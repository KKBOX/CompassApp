package org.ruby_http_parser;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyClass;
import org.jruby.RubyHash;
import org.jruby.RubyModule;
import org.jruby.RubyNumeric;
import org.jruby.RubyObject;
import org.jruby.RubyString;

import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

import org.jruby.anno.JRubyMethod;
import org.jruby.exceptions.RaiseException;

import java.nio.ByteBuffer;
import http_parser.*;
import http_parser.lolevel.ParserSettings;
import http_parser.lolevel.HTTPCallback;
import http_parser.lolevel.HTTPDataCallback;

public class RubyHttpParser extends RubyObject {

  public static ObjectAllocator ALLOCATOR = new ObjectAllocator() {
    public IRubyObject allocate(Ruby runtime, RubyClass klass) {
      return new RubyHttpParser(runtime, klass);
    }
  };

  byte[] fetchBytes (ByteBuffer b, int pos, int len) {
    byte[] by = new byte[len];
    int saved = b.position();
    b.position(pos);
    b.get(by);
    b.position(saved);
    return by;
  }

  public class StopException extends RuntimeException {
  }

  private Ruby runtime;
  private HTTPParser parser;
  private ParserSettings settings;

  private RubyClass eParserError;

  private RubyHash headers;

  private IRubyObject on_message_begin;
  private IRubyObject on_headers_complete;
  private IRubyObject on_body;
  private IRubyObject on_message_complete;

  private IRubyObject requestUrl;
  private IRubyObject requestPath;
  private IRubyObject queryString;
  private IRubyObject fragment;

  private IRubyObject header_value_type;
  private IRubyObject upgradeData;

  private IRubyObject callback_object;

  private String _current_header;
  private String _last_header;

  public RubyHttpParser(final Ruby runtime, RubyClass clazz) {
    super(runtime,clazz);

    this.runtime = runtime;
    this.eParserError = (RubyClass)runtime.getModule("HTTP").getClass("Parser").getConstant("Error");

    this.on_message_begin = null;
    this.on_headers_complete = null;
    this.on_body = null;
    this.on_message_complete = null;

    this.callback_object = null;

    this.header_value_type = runtime.getModule("HTTP").getClass("Parser").getInstanceVariable("@default_header_value_type");

    initSettings();
    init();
  }

  private void initSettings() {
    this.settings = new ParserSettings();

    this.settings.on_url = new HTTPDataCallback() {
      public int cb (http_parser.lolevel.HTTPParser p, ByteBuffer buf, int pos, int len) {
        byte[] data = fetchBytes(buf, pos, len);
        ((RubyString)requestUrl).concat(runtime.newString(new String(data)));
        return 0;
      }
    };
    this.settings.on_path = new HTTPDataCallback() {
      public int cb (http_parser.lolevel.HTTPParser p, ByteBuffer buf, int pos, int len) {
        byte[] data = fetchBytes(buf, pos, len);
        ((RubyString)requestPath).concat(runtime.newString(new String(data)));
        return 0;
      }
    };
    this.settings.on_query_string = new HTTPDataCallback() {
      public int cb (http_parser.lolevel.HTTPParser p, ByteBuffer buf, int pos, int len) {
        byte[] data = fetchBytes(buf, pos, len);
        ((RubyString)queryString).concat(runtime.newString(new String(data)));
        return 0;
      }
    };
    this.settings.on_fragment = new HTTPDataCallback() {
      public int cb (http_parser.lolevel.HTTPParser p, ByteBuffer buf, int pos, int len) {
        byte[] data = fetchBytes(buf, pos, len);
        ((RubyString)fragment).concat(runtime.newString(new String(data)));
        return 0;
      }
    };

    this.settings.on_header_field = new HTTPDataCallback() {
      public int cb (http_parser.lolevel.HTTPParser p, ByteBuffer buf, int pos, int len) {
        byte[] data = fetchBytes(buf, pos, len);

        if (_current_header == null)
          _current_header = new String(data);
        else
          _current_header = _current_header.concat(new String(data));

        return 0;
      }
    };
    this.settings.on_header_value = new HTTPDataCallback() {
      public int cb (http_parser.lolevel.HTTPParser p, ByteBuffer buf, int pos, int len) {
        byte[] data = fetchBytes(buf, pos, len);
        ThreadContext context = headers.getRuntime().getCurrentContext();
        IRubyObject key, val;
        int new_field = 0;

        if (_current_header != null) {
          new_field = 1;
          _last_header = _current_header;
          _current_header = null;
        }

        key = (IRubyObject)runtime.newString(_last_header);
        val = headers.op_aref(context, key);

        if (new_field == 1) {
          if (val.isNil()) {
            if (header_value_type == runtime.newSymbol("arrays")) {
              headers.op_aset(context, key, RubyArray.newArrayLight(runtime, runtime.newString("")));
            } else {
              headers.op_aset(context, key, runtime.newString(""));
            }
          } else {
            if (header_value_type == runtime.newSymbol("mixed")) {
              if (val instanceof RubyString) {
                headers.op_aset(context, key, RubyArray.newArrayLight(runtime, val, runtime.newString("")));
              } else {
                ((RubyArray)val).add(runtime.newString(""));
              }
            } else if (header_value_type == runtime.newSymbol("arrays")) {
              ((RubyArray)val).add(runtime.newString(""));
            } else {
              ((RubyString)val).cat(", ".getBytes());
            }
          }
          val = headers.op_aref(context, key);
        }

        if (val instanceof RubyArray) {
          val = ((RubyArray)val).entry(-1);
        }

        ((RubyString)val).cat(data);

        return 0;
      }
    };

    this.settings.on_message_begin = new HTTPCallback() {
      public int cb (http_parser.lolevel.HTTPParser p) {
        headers = new RubyHash(runtime);

        requestUrl = runtime.newString("");
        requestPath = runtime.newString("");
        queryString = runtime.newString("");
        fragment = runtime.newString("");

        upgradeData = runtime.newString("");

        IRubyObject ret = runtime.getNil();

        if (callback_object != null) {
          if (((RubyObject)callback_object).respond_to_p(runtime.newSymbol("on_message_begin")).toJava(Boolean.class) == Boolean.TRUE) {
            ThreadContext context = callback_object.getRuntime().getCurrentContext();
            ret = callback_object.callMethod(context, "on_message_begin");
          }
        } else if (on_message_begin != null) {
          ThreadContext context = on_message_begin.getRuntime().getCurrentContext();
          ret = on_message_begin.callMethod(context, "call");
        }

        if (ret == runtime.newSymbol("stop")) {
          throw new StopException();
        } else {
          return 0;
        }
      }
    };
    this.settings.on_message_complete = new HTTPCallback() {
      public int cb (http_parser.lolevel.HTTPParser p) {
        IRubyObject ret = runtime.getNil();

        if (callback_object != null) {
          if (((RubyObject)callback_object).respond_to_p(runtime.newSymbol("on_message_complete")).toJava(Boolean.class) == Boolean.TRUE) {
            ThreadContext context = callback_object.getRuntime().getCurrentContext();
            ret = callback_object.callMethod(context, "on_message_complete");
          }
        } else if (on_message_complete != null) {
          ThreadContext context = on_message_complete.getRuntime().getCurrentContext();
          ret = on_message_complete.callMethod(context, "call");
        }

        if (ret == runtime.newSymbol("stop")) {
          throw new StopException();
        } else {
          return 0;
        }
      }
    };
    this.settings.on_headers_complete = new HTTPCallback() {
      public int cb (http_parser.lolevel.HTTPParser p) {
        IRubyObject ret = runtime.getNil();

        if (callback_object != null) {
          if (((RubyObject)callback_object).respond_to_p(runtime.newSymbol("on_headers_complete")).toJava(Boolean.class) == Boolean.TRUE) {
            ThreadContext context = callback_object.getRuntime().getCurrentContext();
            ret = callback_object.callMethod(context, "on_headers_complete", headers);
          }
        } else if (on_headers_complete != null) {
          ThreadContext context = on_headers_complete.getRuntime().getCurrentContext();
          ret = on_headers_complete.callMethod(context, "call", headers);
        }

        if (ret == runtime.newSymbol("stop")) {
          throw new StopException();
        } else {
          return 0;
        }
      }
    };
    this.settings.on_body = new HTTPDataCallback() {
      public int cb (http_parser.lolevel.HTTPParser p, ByteBuffer buf, int pos, int len) {
        IRubyObject ret = runtime.getNil();
        byte[] data = fetchBytes(buf, pos, len);

        if (callback_object != null) {
          if (((RubyObject)callback_object).respond_to_p(runtime.newSymbol("on_body")).toJava(Boolean.class) == Boolean.TRUE) {
            ThreadContext context = callback_object.getRuntime().getCurrentContext();
            ret = callback_object.callMethod(context, "on_body", callback_object.getRuntime().newString(new String(data)));
          }
        } else if (on_body != null) {
          ThreadContext context = on_body.getRuntime().getCurrentContext();
          ret = on_body.callMethod(context, "call", on_body.getRuntime().newString(new String(data)));
        }

        if (ret == runtime.newSymbol("stop")) {
          throw new StopException();
        } else {
          return 0;
        }
      }
    };
  }

  private void init() {
    this.parser = new HTTPParser();
    this.headers = null;

    this.requestUrl = runtime.getNil();
    this.requestPath = runtime.getNil();
    this.queryString = runtime.getNil();
    this.fragment = runtime.getNil();

    this.upgradeData = runtime.getNil();
  }

  @JRubyMethod(name = "initialize")
  public IRubyObject initialize() {
    return this;
  }

  @JRubyMethod(name = "initialize")
  public IRubyObject initialize(IRubyObject arg) {
    callback_object = arg;
    return initialize();
  }

  @JRubyMethod(name = "initialize")
  public IRubyObject initialize(IRubyObject arg, IRubyObject arg2) {
    header_value_type = arg2;
    return initialize(arg);
  }

  @JRubyMethod(name = "on_message_begin=")
  public IRubyObject set_on_message_begin(IRubyObject cb) {
    on_message_begin = cb;
    return cb;
  }

  @JRubyMethod(name = "on_headers_complete=")
  public IRubyObject set_on_headers_complete(IRubyObject cb) {
    on_headers_complete = cb;
    return cb;
  }

  @JRubyMethod(name = "on_body=")
  public IRubyObject set_on_body(IRubyObject cb) {
    on_body = cb;
    return cb;
  }

  @JRubyMethod(name = "on_message_complete=")
  public IRubyObject set_on_message_complete(IRubyObject cb) {
    on_message_complete = cb;
    return cb;
  }

  @JRubyMethod(name = "<<")
  public IRubyObject execute(IRubyObject data) {
    RubyString str = (RubyString)data;
    ByteBuffer buf = ByteBuffer.wrap(str.getBytes());
    boolean stopped = false;

    try {
      this.parser.execute(this.settings, buf);
    } catch (HTTPException e) {
      throw new RaiseException(runtime, eParserError, e.getMessage(), true);
    } catch (StopException e) {
      stopped = true;
    }

    if (parser.getUpgrade()) {
      byte[] upData = fetchBytes(buf, buf.position(), buf.limit() - buf.position());
      ((RubyString)upgradeData).concat(runtime.newString(new String(upData)));

    } else if (buf.hasRemaining()) {
      if (!stopped)
        throw new RaiseException(runtime, eParserError, "Could not parse data entirely", true);
    }

    return RubyNumeric.int2fix(runtime, buf.position());
  }

  @JRubyMethod(name = "keep_alive?")
  public IRubyObject shouldKeepAlive() {
    return parser.shouldKeepAlive() ? runtime.getTrue() : runtime.getFalse();
  }

  @JRubyMethod(name = "upgrade?")
  public IRubyObject shouldUpgrade() {
    return parser.getUpgrade() ? runtime.getTrue() : runtime.getFalse();
  }

  @JRubyMethod(name = "http_major")
  public IRubyObject httpMajor() {
    if (parser.getMajor() == 0 && parser.getMinor() == 0)
      return runtime.getNil();
    else
      return RubyNumeric.int2fix(runtime, parser.getMajor());
  }

  @JRubyMethod(name = "http_minor")
  public IRubyObject httpMinor() {
    if (parser.getMajor() == 0 && parser.getMinor() == 0)
      return runtime.getNil();
    else
      return RubyNumeric.int2fix(runtime, parser.getMinor());
  }

  @JRubyMethod(name = "http_version")
  public IRubyObject httpVersion() {
    if (parser.getMajor() == 0 && parser.getMinor() == 0)
      return runtime.getNil();
    else
      return runtime.newArray(httpMajor(), httpMinor());
  }

  @JRubyMethod(name = "http_method")
  public IRubyObject httpMethod() {
    HTTPMethod method = parser.getHTTPMethod();
    if (method != null)
      return runtime.newString(new String(method.bytes));
    else
      return runtime.getNil();
  }

  @JRubyMethod(name = "status_code")
  public IRubyObject statusCode() {
    int code = parser.getStatusCode();
    if (code != 0)
      return RubyNumeric.int2fix(runtime, code);
    else
      return runtime.getNil();
  }

  @JRubyMethod(name = "headers")
  public IRubyObject getHeaders() {
    return headers == null ? runtime.getNil() : headers;
  }

  @JRubyMethod(name = "request_url")
  public IRubyObject getRequestUrl() {
    return requestUrl == null ? runtime.getNil() : requestUrl;
  }

  @JRubyMethod(name = "request_path")
  public IRubyObject getRequestPath() {
    return requestPath == null ? runtime.getNil() : requestPath;
  }

  @JRubyMethod(name = "query_string")
  public IRubyObject getQueryString() {
    return queryString == null ? runtime.getNil() : queryString;
  }

  @JRubyMethod(name = "fragment")
  public IRubyObject getFragment() {
    return fragment == null ? runtime.getNil() : fragment;
  }

  @JRubyMethod(name = "header_value_type")
  public IRubyObject getHeaderValueType() {
    return header_value_type == null ? runtime.getNil() : header_value_type;
  }

  @JRubyMethod(name = "header_value_type=")
  public IRubyObject set_header_value_type(IRubyObject val) {
    if (val != runtime.newSymbol("mixed") && val != runtime.newSymbol("arrays") && val != runtime.newSymbol("strings")) {
      throw runtime.newArgumentError("Invalid header value type");
    }
    header_value_type = val;
    return val;
  }

  @JRubyMethod(name = "upgrade_data")
  public IRubyObject upgradeData() {
    return upgradeData == null ? runtime.getNil() : upgradeData;
  }

  @JRubyMethod(name = "reset!")
  public IRubyObject reset() {
    init();
    return runtime.getTrue();
  }

}

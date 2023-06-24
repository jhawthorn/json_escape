#include "ruby.h"
#include "ruby/encoding.h"

VALUE rb_mJsonEscape;

/* strlen("\\u2029") == 6 */
#define ESCAPE_JSON_MAX_LEN 6

static inline long
json_escaped_length(VALUE str)
{
    const long len = RSTRING_LEN(str);
    if (len >= LONG_MAX / ESCAPE_JSON_MAX_LEN) {
        ruby_malloc_size_overflow(len, ESCAPE_JSON_MAX_LEN);
    }
    return len * ESCAPE_JSON_MAX_LEN;
}

static VALUE
escape_json(VALUE self, VALUE str)
{
    if (!RB_TYPE_P(str, T_STRING)) {
        str = rb_convert_type(str, T_STRING, "String", "to_s");
    }

    if (!rb_enc_str_asciicompat_p(str)) {
        // FIXME: check for usascii or utf8
        rb_raise(rb_eEncCompatError, "input string must be ASCII-compatible");
    }

    const char *cstr = RSTRING_PTR(str);
    const unsigned long str_len = RSTRING_LEN(str);
    const char *end = cstr + RSTRING_LEN(str);

    size_t initial_match = strcspn(cstr, "&<>\xe2");
    if (initial_match == str_len) {
        return str;
    }

    VALUE vbuf;
    char *buf = ALLOCV_N(char, vbuf, json_escaped_length(str));
    char *dest = buf;

    memcpy(dest, cstr, initial_match);
    cstr += initial_match;
    dest += initial_match;

    while (cstr < end) {
        const char c = *cstr++;

#define JSON_ESCAPE_CONCAT(s) do { \
    memcpy(dest, ("\\u" s), strlen(s) + 2); \
    dest += strlen(s) + 2; \
} while (0)

        if (0) {
        }
        else if (c == '&') {
            JSON_ESCAPE_CONCAT("0026");
        }
        else if (c == '>') {
            JSON_ESCAPE_CONCAT("003e");
        }
        else if (c == '<') {
            JSON_ESCAPE_CONCAT("003c");
        }
        else if (c == '\xe2' && cstr[0] == '\x80' && cstr[1] == '\xa8') {
            JSON_ESCAPE_CONCAT("2028");
            cstr += 2;
        }
        else if (c == '\xe2' && cstr[0] == '\x80' && cstr[1] == '\xa9') {
            JSON_ESCAPE_CONCAT("2029");
            cstr += 2;
        }
        else {
            *dest++ = c;
        }

        initial_match = strcspn(cstr, "&<>\xe2");
        memcpy(dest, cstr, initial_match);
        cstr += initial_match;
        dest += initial_match;

#undef JSON_ESCAPE_CONCAT
    }

    VALUE escaped = str;
    if (RSTRING_LEN(str) < (dest - buf)) {
        escaped = rb_str_new(buf, dest - buf);
        rb_enc_associate(escaped, rb_enc_get(str));
    }
    ALLOCV_END(vbuf);
    return escaped;
}

void
Init_json_escape(void)
{
    rb_mJsonEscape = rb_define_module("JsonEscape");
    rb_define_method(rb_mJsonEscape, "json_escape", escape_json, 1);
}

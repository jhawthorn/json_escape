#include "json_escape.h"

VALUE rb_mJsonEscape;

void
Init_json_escape(void)
{
  rb_mJsonEscape = rb_define_module("JsonEscape");
}

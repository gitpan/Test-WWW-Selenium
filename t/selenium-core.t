#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw/no_plan/;

BEGIN {
    use lib 't/lib';
    use_ok 'LWP::UserAgent';    # mocked
    use_ok 'HTTP::Response';    # mocked
    use lib 'lib';
    use t::WWW::Selenium;
}

my $sel = t::WWW::Selenium->new;
isa_ok $sel, 't::WWW::Selenium';
$sel->open;

$sel->_method_exists("click");
$sel->_method_exists("double_click");
$sel->_method_exists("click_at");
$sel->_method_exists("double_click_at");
$sel->_method_exists("fire_event");
$sel->_method_exists("key_press");
$sel->_method_exists("shift_key_down");
$sel->_method_exists("shift_key_up");
$sel->_method_exists("meta_key_down");
$sel->_method_exists("meta_key_up");
$sel->_method_exists("alt_key_down");
$sel->_method_exists("alt_key_up");
$sel->_method_exists("control_key_down");
$sel->_method_exists("control_key_up");
$sel->_method_exists("key_down");
$sel->_method_exists("key_up");
$sel->_method_exists("mouse_over");
$sel->_method_exists("mouse_out");
$sel->_method_exists("mouse_down");
$sel->_method_exists("mouse_down_at");
$sel->_method_exists("mouse_up");
$sel->_method_exists("mouse_up_at");
$sel->_method_exists("mouse_move");
$sel->_method_exists("mouse_move_at");
$sel->_method_exists("type");
$sel->_method_exists("type_keys");
$sel->_method_exists("set_speed");
$sel->_method_exists("get_speed");
$sel->_method_exists("check");
$sel->_method_exists("uncheck");
$sel->_method_exists("select");
$sel->_method_exists("add_selection");
$sel->_method_exists("remove_selection");
$sel->_method_exists("remove_all_selections");
$sel->_method_exists("submit");
$sel->_method_exists("open");
$sel->_method_exists("open_window");
$sel->_method_exists("select_window");
$sel->_method_exists("select_frame");
$sel->_method_exists("get_log_messages");
$sel->_method_exists("get_whether_this_frame_match_frame_expression");
$sel->_method_exists("get_whether_this_window_match_window_expression");
$sel->_method_exists("wait_for_pop_up");
$sel->_method_exists("choose_cancel_on_next_confirmation");
$sel->_method_exists("answer_on_next_prompt");
$sel->_method_exists("go_back");
$sel->_method_exists("refresh");
$sel->_method_exists("close");
$sel->_method_exists("is_alert_present");
$sel->_method_exists("is_prompt_present");
$sel->_method_exists("is_confirmation_present");
$sel->_method_exists("get_alert");
$sel->_method_exists("get_confirmation");
$sel->_method_exists("get_prompt");
$sel->_method_exists("get_location");
$sel->_method_exists("get_title");
$sel->_method_exists("get_body_text");
$sel->_method_exists("get_value");
$sel->_method_exists("get_text");
$sel->_method_exists("highlight");
$sel->_method_exists("get_eval");
$sel->_method_exists("is_checked");
$sel->_method_exists("get_table");
$sel->_method_exists("get_selected_labels");
$sel->_method_exists("get_selected_label");
$sel->_method_exists("get_selected_values");
$sel->_method_exists("get_selected_value");
$sel->_method_exists("get_selected_indexes");
$sel->_method_exists("get_selected_index");
$sel->_method_exists("get_selected_ids");
$sel->_method_exists("get_selected_id");
$sel->_method_exists("is_something_selected");
$sel->_method_exists("get_select_options");
$sel->_method_exists("get_attribute");
$sel->_method_exists("is_text_present");
$sel->_method_exists("is_element_present");
$sel->_method_exists("is_visible");
$sel->_method_exists("is_editable");
$sel->_method_exists("get_all_buttons");
$sel->_method_exists("get_all_links");
$sel->_method_exists("get_all_fields");
$sel->_method_exists("get_attribute_from_all_windows");
$sel->_method_exists("dragdrop");
$sel->_method_exists("set_mouse_speed");
$sel->_method_exists("get_mouse_speed");
$sel->_method_exists("drag_and_drop");
$sel->_method_exists("drag_and_drop_to_object");
$sel->_method_exists("window_focus");
$sel->_method_exists("window_maximize");
$sel->_method_exists("get_all_window_ids");
$sel->_method_exists("get_all_window_names");
$sel->_method_exists("get_all_window_titles");
$sel->_method_exists("get_html_source");
$sel->_method_exists("set_cursor_position");
$sel->_method_exists("get_element_index");
$sel->_method_exists("is_ordered");
$sel->_method_exists("get_element_position_left");
$sel->_method_exists("get_element_position_top");
$sel->_method_exists("get_element_width");
$sel->_method_exists("get_element_height");
$sel->_method_exists("get_cursor_position");
$sel->_method_exists("set_context");
$sel->_method_exists("get_expression");
$sel->_method_exists("wait_for_condition");
$sel->_method_exists("set_timeout");
$sel->_method_exists("wait_for_page_to_load");
$sel->_method_exists("get_cookie");
$sel->_method_exists("create_cookie");
$sel->_method_exists("delete_cookie");

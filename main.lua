-- TODO: use module will better
-- TODO: use Busted To Unit Testing
-- simple test
dofile("file.lua")


p=File:new("test.txt");
print(p:get_file_name());

p:dump_cache_info("init dump_cache_info")

print("get_text_by_line_count")

p:get_text_by_line_count(5)
p:get_text_by_line_count(20)
p:get_text_by_line_count(21)

print("---------------------------- end")

print("get_line_text_by_key_string")

p:get_line_text_by_key_string("1001")
p:get_line_text_by_key_string("卡20")
p:get_line_text_by_key_string(21)

print("---------------------------- end")

print("insert_txt_before_line_count")

print(p:insert_txt_before_line_count(7, "77777777"));
print(p:insert_txt_before_line_count(6, "66666666"));
print(p:insert_txt_before_line_count(21, "21"));
print(p:dump_cache_info("insert_txt_before_line_count"));
print("---------------------------- end")



print("insert_txt_after_line_count")
print(p:insert_txt_after_line_count(7, "77777777"));
print(p:insert_txt_after_line_count(6, "66666666"));
print(p:insert_txt_after_line_count(30, "30"));
print(p:dump_cache_info("insert_txt_after_line_count"));
print("---------------------------- end")

print("save_all")
p:save_all();
print("---------------------------- end")

print("reolad")
print(p:reload_file("test_copy.txt"));
print(p:dump_cache_info("after reolad"))
print("---------------------------- end")

print("delete_line_by_line_count")
print(p:delete_line_by_line_count(7, "77777777"));
print(p:delete_line_by_line_count(6, "66666666"));
print(p:delete_line_by_line_count(30, "30"));
print("---------------------------- end")

print("delete_line_by_line_count")
print(p:delete_line_by_line_count(7));
print(p:delete_line_by_line_count(6));
print(p:delete_line_by_line_count(30));
print("---------------------------- end");

print("delete_line_by_line_count")
print(p:delete_line_by_key_string("1001"));
print(p:delete_line_by_key_string("卡20"));
print(p:delete_line_by_key_string(21));
print("---------------------------- end");

print("check_line_have_key_string")
print(p:check_line_have_key_string("1002"))
print(p:check_line_have_key_string("卡19"))
print(p:check_line_have_key_string("21"))
print("---------------------------- end");

print("save_all")
p:save_all();
print("---------------------------- end")

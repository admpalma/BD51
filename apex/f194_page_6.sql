set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.3.00.05'
,p_default_workspace_id=>621076755988548703
,p_default_application_id=>194
,p_default_owner=>'BD55697'
);
end;
/
prompt --application/set_environment
 
prompt APPLICATION 194 - BD51-Project
--
-- Application Export:
--   Application:     194
--   Name:            BD51-Project
--   Date and Time:   17:44 Wednesday May 20, 2020
--   Exported By:     U55697
--   Flashback:       0
--   Export Type:     Page Export
--   Version:         5.1.3.00.05
--   Instance ID:     218259688285440
--

prompt --application/pages/delete_00006
begin
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>6);
end;
/
prompt --application/pages/page_00006
begin
wwv_flow_api.create_page(
 p_id=>6
,p_user_interface_id=>wwv_flow_api.id(727871623198193276)
,p_name=>'Add restaurants'
,p_page_mode=>'NORMAL'
,p_step_title=>'Add restaurants'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_last_updated_by=>'U55697'
,p_last_upd_yyyymmddhh24miss=>'20200520173924'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(844231067778772068)
,p_plug_name=>'Add restaurants'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(727838025892193239)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'BODY'
,p_plug_query_row_template=>1
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(844239255666772079)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(727842455610193243)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'N'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(727872970239193279)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(727861377515193265)
,p_plug_query_row_template=>1
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(844231576504772068)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(844231067778772068)
,p_button_name=>'SUBMIT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(727860885903193265)
,p_button_image_alt=>'Submit'
,p_button_position=>'REGION_TEMPLATE_CHANGE'
,p_grid_new_grid=>false
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(844231458936772068)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(844231067778772068)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(727860885903193265)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
,p_grid_new_grid=>false
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(844238770554772079)
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_api.id(844231576504772068)
,p_branch_sequence=>1
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(682536194986341830)
,p_name=>'P6_LON'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Lon'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844232393394772070)
,p_name=>'P6_T'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Lat'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844232768725772071)
,p_name=>'P6_TR_CLOSING_TIME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Closing Time'
,p_format_mask=>'YYYY-MM-DD HH24:MI:SS'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844233113893772071)
,p_name=>'P6_TR_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Attr Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844233575172772071)
,p_name=>'P6_TR_DESCR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Attr Descr'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844233961543772073)
,p_name=>'P6_TR_PHONE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Attr Phone'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844234393609772073)
,p_name=>'P6_TR_WEBSITE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Attr Website'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844234762631772073)
,p_name=>'P6_C_DESCR'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Ic Descr'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844235184094772075)
,p_name=>'P6_C_DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Ic Date'
,p_format_mask=>'YYYY-MM-DD HH24:MI:SS'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844235539636772075)
,p_name=>'P6_C_PHOTOGRAPHER'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Ic Photographer'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844235963951772075)
,p_name=>'P6_DISH'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'R Dish'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844236318174772076)
,p_name=>'P6_FOOD_TYPE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Specialty'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'SPECIALTIES'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select food_type as "Specialty", food_type',
'from food_types',
'order by food_type'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844236779436772076)
,p_name=>'P6_PL_LANG'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Empl Lang'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select language, language from languages;'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844237146059772076)
,p_name=>'P6_TR_START_DATE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Attr Start Date'
,p_format_mask=>'YYYY-MM-DD'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844237530903772078)
,p_name=>'P6_TR_END_DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Attr End Date'
,p_format_mask=>'YYYY-MM-DD'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(844237960684772078)
,p_name=>'P6_TR_OPENING_TIME'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(844231067778772068)
,p_prompt=>'Attr Opening Time'
,p_format_mask=>'YYYY-MM-DD HH24:MI:SS'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(727860310774193264)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(844238341083772078)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Run Stored Procedure'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#OWNER#.INSERT_RESTAURANT(',
'LAT => :P6_T,',
'LON => :P6_LON,',
'ATTR_CLOSING_TIME => to_timestamp(:P6_TR_CLOSING_TIME, ''YYYY-MM-DD HH24:MI:SS''),',
'ATTR_NAME => :P6_TR_NAME,',
'ATTR_DESCR => :P6_TR_DESCR,',
'ATTR_PHONE => :P6_TR_PHONE,',
'ATTR_WEBSITE => :P6_TR_WEBSITE,',
'PIC_DESCR => :P6_C_DESCR,',
'PIC_DATE => to_timestamp(:P6_C_DATE, ''YYYY-MM-DD HH24:MI:SS''),',
'PIC_PHOTOGRAPHER => :P6_C_PHOTOGRAPHER,',
'R_DISH => :P6_DISH,',
'R_FOOD_TYPE => :P6_FOOD_TYPE,',
'EMPL_LANG => :P6_PL_LANG,',
'ATTR_START_DATE => to_date(:P6_TR_START_DATE, ''YYYY-MM-DD''),',
'ATTR_END_DATE => to_date(:P6_TR_END_DATE, ''YYYY-MM-DD''),',
'ATTR_OPENING_TIME => to_timestamp(:P6_TR_OPENING_TIME, ''YYYY-MM-DD HH24:MI:SS''));'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(844231576504772068)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done

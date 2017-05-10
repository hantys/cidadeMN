require 'test_helper'

class CausesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cause = causes(:one)
  end

  test "should get index" do
    get causes_url
    assert_response :success
  end

  test "should get new" do
    get new_cause_url
    assert_response :success
  end

  test "should create cause" do
    assert_difference('Cause.count') do
      post causes_url, params: { cause: { address: @cause.address, category_id: @cause.category_id, end_date: @cause.end_date, latitude: @cause.latitude, longitude: @cause.longitude, start_date: @cause.start_date, status: @cause.status, support: @cause.support, text: @cause.text, user_id: @cause.user_id } }
    end

    assert_redirected_to cause_url(Cause.last)
  end

  test "should show cause" do
    get cause_url(@cause)
    assert_response :success
  end

  test "should get edit" do
    get edit_cause_url(@cause)
    assert_response :success
  end

  test "should update cause" do
    patch cause_url(@cause), params: { cause: { address: @cause.address, category_id: @cause.category_id, end_date: @cause.end_date, latitude: @cause.latitude, longitude: @cause.longitude, start_date: @cause.start_date, status: @cause.status, support: @cause.support, text: @cause.text, user_id: @cause.user_id } }
    assert_redirected_to cause_url(@cause)
  end

  test "should destroy cause" do
    assert_difference('Cause.count', -1) do
      delete cause_url(@cause)
    end

    assert_redirected_to causes_url
  end
end

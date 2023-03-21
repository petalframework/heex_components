defmodule PetalComponents.ATest do
  use ComponentCase
  alias PetalComponents.Link

  test "a link with label" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Link.a link_type="a" to="/" label="Press me" phx-click="click_event" />
      """)

    assert html =~ "Press me"
    assert html =~ "href="
    assert html =~ "phx-click"
  end

  test "live_patch link with label" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Link.a link_type="live_patch" to="/" label="Press me" phx-click="click_event" />
      """)

    assert html =~ "Press me"
    assert html =~ "href="
    assert html =~ "phx-click"
  end

  test "live_redirect link with label" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Link.a link_type="live_redirect" to="/" label="Press me" phx-click="click_event" />
      """)

    assert html =~ "Press me"
    assert html =~ "href="
    assert html =~ "phx-click"
  end

  test "link with inner_block" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Link.a link_type="a" to="/" phx-click="click_event">
        Press me
      </Link.a>
      """)

    assert html =~ "Press me"
    assert html =~ "phx-click"
  end

  test "link with method" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Link.a to="/" method={:put}>
        Press me
      </Link.a>
      """)

    assert html =~ "Press me"
    assert html =~ "data-method"
  end

  test "link contains no extra spaces" do
    assigns = %{}

    assert rendered_to_string(~H"""
           <Link.a to="/" label="Press me" />
           """) =~ ">Press me<"

    assert rendered_to_string(~H"""
           <Link.a to="/" label=" Press me " />
           """) =~ "> Press me <"

    assert rendered_to_string(~H"""
           <Link.a link_type="live_patch" to="/" label="Press me" />
           """) =~ ">Press me<"

    assert rendered_to_string(~H"""
           <Link.a link_type="live_redirect" to="/" label="Press me" />
           """) =~ ">Press me<"

    assert rendered_to_string(~H"""
           <Link.a to="/">Press me</Link.a>
           """) =~ ">Press me<"

    assert rendered_to_string(~H"""
           <Link.a to="/" label="Press me" />, blah
           """) =~ "</a>, blah"
  end

  test "link as a disabled button" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <Link.a link_type="button" disabled phx-click="click-me">
        Press me
      </Link.a>
      """)

    assert html =~ "Press me"
    assert html =~ " disabled"
    refute html =~ " phx-"

    html =
      rendered_to_string(~H"""
      <Link.a link_type="live_redirect" disabled to="/">
        Press me
      </Link.a>
      """)

    assert html =~ "Press me"
    assert html =~ " disabled"
    assert html =~ ~s{href="#"}
    refute html =~ " phx-"

    html =
      rendered_to_string(~H"""
      <Link.a link_type="live_patch" disabled to="/">
        Press me
      </Link.a>
      """)

    assert html =~ "Press me"
    assert html =~ " disabled"
    assert html =~ ~s{href="#"}
    refute html =~ " phx-"

    html =
      rendered_to_string(~H"""
      <Link.a link_type="a" disabled to="/">
        Press me
      </Link.a>
      """)

    assert html =~ "Press me"
    assert html =~ " disabled"
    assert html =~ ~s{href="#"}
  end
end

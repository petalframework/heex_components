defmodule PetalComponents.FormTest do
  use ComponentCase
  import PetalComponents.Form

  test "text_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.text_input form={f} field={:name} placeholder="eg. John" class="!w-max" itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "John"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
    refute html =~ " disabled "
    assert html =~ "pc-text-input"
    assert html =~ "!w-max"
  end

  test "text_input disabled" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.text_input disabled form={f} field={:name} placeholder="eg. John" itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "John"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "pc-text-input"
    assert html =~ " disabled "
  end

  test "textarea" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.textarea form={f} field={:description} itemid="something" placeholder="dummy text" />
      </.form>
      """)

    assert html =~ "<textarea"
    assert html =~ "user[description]"
    assert html =~ "itemid"
    assert html =~ "placeholder"
    assert html =~ "phx-feedback-for"
    assert html =~ "dummy text"
  end

  test "select" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.select form={f} field={:role} options={[Admin: "admin", User: "user"]} itemid="something" />
      </.form>
      """)

    assert html =~ "<select"
    assert html =~ "user[role]"
    assert html =~ "itemid"
    assert html =~ "<option"
    assert html =~ "admin"
    assert html =~ "phx-feedback-for"
    assert html =~ "Admin"
  end

  test "checkbox" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.checkbox form={f} field={:read_terms} itemid="something" />
      </.form>
      """)

    assert html =~ "checkbox"
    assert html =~ "user[read_terms]"
    assert html =~ "phx-feedback-for"
    assert html =~ "itemid"
  end

  test "checkbox_group" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.checkbox_group form={f} field={:roles} options={[{"Read", "read"}, {"Write", "write"}]} />
      </.form>
      """)

    assert html =~ "checkbox"
    assert html =~ "user_roles"
    assert html =~ "user_roles_read"
    assert html =~ "user_roles_write"
    assert html =~ "user[roles][]"
    assert html =~ "Read"
    assert html =~ "phx-feedback-for"
    assert html =~ "Write"
    refute html =~ "checked"

    # Test "checked" attribute
    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.checkbox_group
          checked={["read"]}
          form={f}
          field={:roles}
          options={[{"Read", "read"}, {"Write", "write"}]}
        />
      </.form>
      """)

    assert html =~ "checked"
  end

  test "switch" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.switch form={f} field={:read_terms} itemid="something" />
      </.form>
      """)

    assert html =~ "checkbox"
    assert html =~ "user[read_terms]"
    assert html =~ "phx-feedback-for"
    assert html =~ "itemid"
  end

  test "radio" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.radio form={f} field={:eye_color} value="green" itemid="something" />
      </.form>
      """)

    assert html =~ "radio"
    assert html =~ "user[eye_color]"
    assert html =~ "green"
    assert html =~ "itemid"
    assert html =~ "phx-feedback-for"
  end

  test "form_label" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.form_label form={f} field={:name} class="text-pink-500" />
      </.form>
      """)

    assert html =~ "label"
    assert html =~ "Name"
    assert html =~ "phx-feedback-for"
    assert html =~ "text-pink-500"

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.form_label form={f} field={:name}>
          Something else
        </.form_label>
      </.form>
      """)

    assert html =~ "Something else"

    html =
      rendered_to_string(~H"""
      <.form_label>Simple</.form_label>
      """)

    assert html =~ "Simple"

    html =
      rendered_to_string(~H"""
      <.form_label label="Simpler" />
      """)

    assert html =~ "Simpler"
  end

  test "form_field_error" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form
        :let={f}
        as={:user}
        for={
          %Ecto.Changeset{
            action: :update,
            data: %{name: ""},
            errors: [
              name: {"can't be blank", [validation: :required]},
              name: {"too long", [validation: :required]}
            ]
          }
        }
      >
        <.form_field_error form={f} field={:name} class="mt-1" />
      </.form>
      """)

    assert html =~ "pc-form-field-error"
    assert html =~ "phx-feedback-for"
    assert html =~ "blank"
    assert html =~ "too long"
  end

  test "form_help_text" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form_help_text help_text="Inline" />
      """)

    assert html =~ "Inline"

    html =
      rendered_to_string(~H"""
      <.form_help_text>Utilising slot</.form_help_text>
      """)

    assert html =~ "Utilising slot"

    html =
      rendered_to_string(~H"""
      <.form_help_text class="mt-1" help_text="Test class" />
      """)

    assert html =~ "Test class"
    assert html =~ "mt-1"
  end

  test "form_field wrapper_classes" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form
        :let={f}
        as={:user}
        for={
          %Ecto.Changeset{
            action: :update,
            data: %{name: ""},
            errors: [
              name: {"can't be blank", [validation: :required]},
              name: {"too long", [validation: :required]}
            ]
          }
        }
      >
        <.form_field
          type="text_input"
          form={f}
          field={:name}
          placeholder="eg. John"
          wrapper_classes="wrapper-test"
          help_text="Help!"
        />
      </.form>
      """)

    assert html =~ "label"
    assert html =~ "<input"
    assert html =~ "user[name]"
    assert html =~ "John"
    assert html =~ "too long"
    assert html =~ "blank"
    assert html =~ "<div class=\"wrapper-test\" phx-feedback-for=\"user[name]\">"
    assert html =~ "Help!"
  end

  test "form_field label_class" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} as={:user} for={%Ecto.Changeset{action: :update, data: %{name: ""}}}>
        <.form_field
          type="text_input"
          form={f}
          field={:name}
          placeholder="eg. John"
          label_class="label-class-test"
          help_text="Help!"
        />
      </.form>
      """)

    assert html =~ "label-class-test"
  end

  test "form_field text_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form
        :let={f}
        as={:user}
        for={
          %Ecto.Changeset{
            action: :update,
            data: %{name: ""},
            errors: [
              name: {"can't be blank", [validation: :required]},
              name: {"too long", [validation: :required]}
            ]
          }
        }
      >
        <.form_field type="text_input" form={f} field={:name} class="w-max" placeholder="eg. John" />
      </.form>
      """)

    assert html =~ "label"
    assert html =~ "<input"
    assert html =~ "user[name]"
    assert html =~ "John"
    assert html =~ "too long"
    assert html =~ "blank"
    assert html =~ "pc-form-field-wrapper"
    assert html =~ "pc-text-input"
    assert html =~ "w-max"
  end

  test "form_field checkbox label" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} as={:user} for={%Ecto.Changeset{action: :update, data: %{name: ""}}}>
        <.form_field type="checkbox" form={f} field={:name} />
      </.form>
      """)

    assert html =~ "Name"

    html =
      rendered_to_string(~H"""
      <.form :let={f} as={:user} for={%Ecto.Changeset{action: :update, data: %{name: ""}}}>
        <.form_field type="checkbox" form={f} field={:name} label="Something else" />
      </.form>
      """)

    assert html =~ "Something else"
  end

  test "number_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.number_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "number"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "email_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.email_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "email"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "password_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.password_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "password"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "search_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.search_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "search"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "telephone_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.telephone_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "tel"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "url_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.url_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "url"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "time_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.time_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "time"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "time_select" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.time_select form={f} field={:name} />
      </.form>
      """)

    assert html =~ "select"
    assert html =~ "user[name]"
  end

  test "datetime_local_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.datetime_local_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "datetime-local"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "datetime_select" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.datetime_select form={f} field={:name} />
      </.form>
      """)

    assert html =~ "select"
    assert html =~ "user[name]"
  end

  test "date_select" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.date_select form={f} field={:name} />
      </.form>
      """)

    assert html =~ "select"
    assert html =~ "user[name]"
  end

  test "date_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.date_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "date"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "color_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.color_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "color"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "file_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user} multipart>
        <.file_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "file"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "pc-file-input"
    assert html =~ "phx-feedback-for"
  end

  test "range_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.range_input form={f} field={:name} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "range"
    assert html =~ "user[name]"
    assert html =~ "itemid"
    assert html =~ "something"
    assert html =~ "phx-feedback-for"
  end

  test "hidden_input" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.form :let={f} for={%{}} as={:user}>
        <.hidden_input form={f} field={:token} itemid="something" />
      </.form>
      """)

    assert html =~ "input"
    assert html =~ "hidden"
    assert html =~ "token"
    assert html =~ "user[token]"
    assert html =~ "itemid"
    assert html =~ "something"
  end
end

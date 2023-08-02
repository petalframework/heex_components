defmodule PetalComponents.MenuTest do
  use ComponentCase

  import PetalComponents.Menu

  describe "vertical_menu/1" do
    test "renders correctly" do
      assigns = %{
        main_menu_items: [
          %{
            name: :sign_in,
            label: "Path",
            path: "/path",
            icon: :key
          }
        ],
        current_page: :current_page,
        sidebar_title: "blah"
      }

      html =
        rendered_to_string(~H"""
        <.vertical_menu menu_items={@main_menu_items} current_page={@current_page} title={@sidebar_title} />
        """)

      assert html =~ "<svg"
      assert html =~ "Path"
      assert html =~ "/path"
      assert html =~ "blah"
    end

    test "grouped menu renders correctly" do
      assigns = %{
        main_menu_items: [
          %{
            title: "Menu group 1",
            menu_items: [
              %{
                name: :home,
                label: "Home",
                path: "#",
                icon: :home
              }
            ]
          },
          %{
            title: "Menu group 2",
            menu_items: [
              %{
                name: :school,
                label: "School",
                path: "#",
                icon: :academic_cap
              }
            ]
          }
        ],
        current_page: :current_page,
        sidebar_title: "blah"
      }

      html =
        rendered_to_string(~H"""
        <.vertical_menu menu_items={@main_menu_items} current_page={@current_page} title={@sidebar_title} />
        """)

      assert html =~ "Home"
      assert html =~ "School"
    end
  end
end

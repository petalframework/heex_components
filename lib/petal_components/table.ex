defmodule PetalComponents.Table do
  use Phoenix.Component

  import PetalComponents.Avatar

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
        <:empty_state>No data here yet</:empty_state>
      </.table>
  """
  attr :id, :string
  attr :class, :string, default: "", doc: "CSS class"
  attr :rows, :list, default: [], doc: "the list of rows to render"
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col slot"

  slot :col do
    attr :label, :string
    attr :class, :string
    attr :row_class, :string
  end

  slot :empty_state,
    doc: "A message to show when the table is empty, to be used together with :col" do
    attr :row_class, :string
  end

  attr :rest, :global, include: ~w(colspan rowspan)

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    assigns = assign_new(assigns, :id, fn -> "table_#{Ecto.UUID.generate()}" end)

    ~H"""
    <%= if length(@col) > 0 do %>
      <table class={["pc-table", @class]} {@rest}>
        <thead>
          <.tr>
            <.th :for={col <- @col} class={col[:class]}><%= col[:label] %></.th>
          </.tr>
        </thead>
        <tbody id={@id} phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}>
          <%= if length(@empty_state) > 0 do %>
            <.tr class="hidden only:table-row">
              <.td
                :for={empty_state <- @empty_state}
                colspan={length(@col)}
                class={empty_state[:row_class]}
              >
                <%= render_slot(empty_state) %>
              </.td>
            </.tr>
          <% end %>
          <.tr
            :for={row <- @rows}
            id={@row_id && @row_id.(row)}
            class={"group #{if @row_click, do: "pc-table__tr--row-click", else: ""}"}
          >
            <.td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={"#{if @row_click, do: "pc-table__td--row-click", else: ""} #{if i == 0, do: "pc-table__td--first-col", else: ""} #{if col[:row_class], do: col[:row_class], else: ""}"}
            >
              <%= render_slot(col, @row_item.(row)) %>
            </.td>
          </.tr>
        </tbody>
      </table>
    <% else %>
      <table id={@id} class={["pc-table", @class]} {@rest}>
        <%= render_slot(@inner_block) %>
      </table>
    <% end %>
    """
  end

  attr(:class, :string, default: "", doc: "CSS class")
  attr(:rest, :global, include: ~w(colspan rowspan))
  slot(:inner_block, required: false)

  def th(assigns) do
    ~H"""
    <th class={["pc-table__th", @class]} {@rest}>
      <%= render_slot(@inner_block) %>
    </th>
    """
  end

  attr(:class, :string, default: "", doc: "CSS class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def tr(assigns) do
    ~H"""
    <tr class={["pc-table__tr", @class]} {@rest}>
      <%= render_slot(@inner_block) %>
    </tr>
    """
  end

  attr(:class, :string, default: "", doc: "CSS class")
  attr(:rest, :global, include: ~w(colspan headers rowspan))
  slot(:inner_block, required: false)

  def td(assigns) do
    ~H"""
    <td class={["pc-table__td", @class]} {@rest}>
      <%= render_slot(@inner_block) %>
    </td>
    """
  end

  attr(:class, :any, default: "", doc: "CSS class")
  attr(:label, :string, default: nil, doc: "Adds a label your user, e.g name")
  attr(:sub_label, :string, default: nil, doc: "Adds a sub-label your to your user, e.g title")
  attr(:rest, :global)

  attr(:avatar_assigns, :map,
    default: nil,
    doc: "if using an avatar, this map will be passed to the avatar component as props"
  )

  def user_inner_td(assigns) do
    ~H"""
    <div class={@class} {@rest}>
      <div class="pc-table__user-inner-td">
        <%= if @avatar_assigns do %>
          <.avatar {@avatar_assigns} />
        <% end %>

        <div class="pc-table__user-inner-td__inner">
          <div class="pc-table__user-inner-td__label">
            <%= @label %>
          </div>
          <div class="pc-table__user-inner-td__sub-label">
            <%= @sub_label %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

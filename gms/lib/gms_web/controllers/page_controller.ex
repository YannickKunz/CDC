defmodule GmsWeb.PageController do
  use GmsWeb, :controller
    def index(conn, _params) do
      render(conn, "index.html")
    end

    def start(conn, %{"group_name" => group_name, "number_of_processes" => number_of_processes}) do
      :myP.start(String.to_atom(group_name), String.to_integer(number_of_processes))
      send_resp(conn, 200, "Started")
    end

    def add_process(conn, %{"group_name" => group_name}) do
      :myP.add_process(String.to_atom(group_name))
      send_resp(conn, 200, "Process added")
    end

    def delete_process(conn, %{"group_name" => group_name, "process_pid" => process_pid}) do
      :myP.delete_process(String.to_atom(group_name), String.to_atom(process_pid))
      send_resp(conn, 200, "Process deleted")
    end

    def send_message(conn, %{"group_name" => group_name, "message" => message}) do
      :myP.send_message(String.to_atom(group_name), message)
      send_resp(conn, 200, "Message sent")
    end

    def send_message_to_group(conn, %{"source_group_name" => source_group_name, "target_group_name" => target_group_name, "message" => message}) do
      :myP.send_message_to_group(String.to_atom(source_group_name), String.to_atom(target_group_name), message)
      send_resp(conn, 200, "Message sent to group")
    end

    def delete_group(conn, %{"group_name" => group_name}) do
      :myP.delete_group(String.to_atom(group_name))
      send_resp(conn, 200, "Group deleted")
    end

  end

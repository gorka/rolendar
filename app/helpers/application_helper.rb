module ApplicationHelper
  def flash_messages_class_names(key)
    class_names(
      # alert
      { "border-red-700": key == "alert" },
      { "bg-red-50": key == "alert" },
      { "text-red-700": key == "alert" },
      
      # notice
      { "border-green-700": key == "notice" },
      { "bg-green-50": key == "notice" },
      { "text-green-700": key == "notice" }
    )
  end
end

module ApplicationHelper
  def flash_kind(type)
    base_classes = "font-mplus animate-flash w-fit max-w-[300px] px-3 py-6 rounded-md shadow-lg border border-black/5 pointer-events-auto mb-2"

    case type.to_sym
    when :notice
      "bg-success text-on-success #{base_classes}"
    when :alert
      "bg-error text-on-error #{base_classes}"
    else
      "bg-warning text-on-warning #{base_classes}"
    end
  end
end

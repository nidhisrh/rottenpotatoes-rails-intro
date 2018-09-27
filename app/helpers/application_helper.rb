module ApplicationHelper
    def sortable(column, title = nil)
        direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
        link_to title, {:sort => column, :direction => direction}
    end
    def sort_class(column)
        if(column == sort_column)
           return 'hilite'
        else
           return nil
        end
    end
end

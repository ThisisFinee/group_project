class TicketsService
    VIP_TICKET_COUNT = 50
    FAN_TICKET_COUNT = 150
    COST_INCREASE = 0.1
    SALE_PERCENT = 0.1
    USER_SERVER_URL = 'http://user_server:2000/users?'

    def self.calculate_ticket_cost(free_count, category)
        total_count = FAN_TICKET_COUNT
        cost = ENV['FAN_PRICE'].to_i

        if category == 'vip'
            total_count = VIP_TICKET_COUNT
            cost = ENV['VIP_PRICE'].to_i
        end

        sold_count = total_count - free_count
        sold_persent = sold_count.to_f/total_count

        while sold_persent > SALE_PERCENT do
            cost += cost * COST_INCREASE
            sold_persent -= SALE_PERCENT
        end
        cost.to_i
    end

    def self.check_block_conditions(ticket_number, ticket_status, document_number)
        user_document = get_user_document(ticket_number)
        # p "#{user_document} #{user_document.class} #{document_number} #{document_number.class}"
        return false, 'Номер документа не совпадает' if document_number != user_document
        return false, 'Билет не куплен' if ticket_status != 'purchased'
        return true, 'ok'
    end

    private

    def self.get_user_document(ticket_number)
        url = USER_SERVER_URL + "ticket_number=#{ticket_number}"
        # FOR DEVELOPMENT
        response = { "document_number": "123456" }.to_json
        # END

        # response = Net::HTTP.get(URI(url))
        response = JSON.parse(response) #.body
        response["document_number"]
    end



end

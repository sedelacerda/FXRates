class WelcomeController < ApplicationController

  def index

    Rate.update_rates

  end

  private

    def capitaria_getValue (response, parity)
      aux = response.partition(parity).last
      aux = aux.partition('<td>').last
      value = aux.partition('</td>').first
      return value
    end

    def yahoo_getValue (parity)
      response = open('https://es-us.finanzas.yahoo.com/quote/' << parity << '=X?ltr=1').read
      aux = response.partition(%Q(data-reactid="241">)).last
      value = aux.partition('</span>').first
      return value
    end

    def bloomberg_getValue (parity)
      response = open('https://www.bloomberg.com/quote/' << parity << ':CUR').read
      aux = response.partition('price-container').last
      aux = aux.partition(%Q(class="price">)).last
      value = aux.partition('</div>').first
      return value
    end
end

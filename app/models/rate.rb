class Rate < ApplicationRecord

  def self.update_rates

    require 'open-uri'

    #Capitaria
    capitaria_response = open('https://www.capitaria.com/noticias/precios-en-linea/').read

    @capitaria_USDCLP = Rate.capitaria_getValue(capitaria_response, 'USDCLP').to_f
    @capitaria_EURCLP = Rate.capitaria_getValue(capitaria_response, 'EURCLP').to_f
    capitaria_GBPUSD = Rate.capitaria_getValue(capitaria_response, 'GBPUSD').to_f
    @capitaria_GBPCLP = (capitaria_GBPUSD*@capitaria_USDCLP).round(2)

    last_capitaria_record = Rate.where(provider: 'Capitaria').last

    if last_capitaria_record == nil
      Rate.create(provider: 'Capitaria', usdclp: @capitaria_USDCLP, eurclp:@capitaria_EURCLP, gbpclp:@capitaria_GBPCLP)
    else
      if (last_capitaria_record.usdclp != @capitaria_USDCLP || last_capitaria_record.eurclp != @capitaria_EURCLP || last_capitaria_record.gbpclp != @capitaria_GBPCLP)
        Rate.create(provider: 'Capitaria', usdclp: @capitaria_USDCLP, eurclp:@capitaria_EURCLP, gbpclp:@capitaria_GBPCLP)
      end
    end

    #Yahoo
    @yahoo_USDCLP = Rate.yahoo_getValue('USDCLP').to_f.round(2)
    @yahoo_EURCLP = Rate.yahoo_getValue('EURCLP').to_f.round(2)
    @yahoo_GBPCLP = Rate.yahoo_getValue('GBPCLP').to_f.round(2)

    last_yahoo_record = Rate.where(provider: 'Yahoo').last

    if last_yahoo_record == nil
      Rate.create(provider: 'Yahoo', usdclp: @yahoo_USDCLP, eurclp:@yahoo_EURCLP, gbpclp:@yahoo_GBPCLP)
    else
      if (last_yahoo_record.usdclp != @yahoo_USDCLP || last_yahoo_record.eurclp != @yahoo_EURCLP || last_yahoo_record.gbpclp != @yahoo_GBPCLP)
        Rate.create(provider: 'Yahoo', usdclp: @yahoo_USDCLP, eurclp:@yahoo_EURCLP, gbpclp:@yahoo_GBPCLP)
      end
    end

    #Trading View
    @bloomberg_USDCLP = Rate.bloomberg_getValue('USDCLP').to_f.round(2)
    @bloomberg_EURCLP = Rate.bloomberg_getValue('EURCLP').to_f.round(2)
    bloomberg_GBPUSD = Rate.bloomberg_getValue('GBPUSD')
    @bloomberg_GBPCLP = ((bloomberg_GBPUSD.to_f)*(@bloomberg_USDCLP)).round(2)

    last_bloomberg_record = Rate.where(provider: 'Bloomberg').last

    if last_bloomberg_record == nil
      Rate.create(provider: 'Bloomberg', usdclp: @bloomberg_USDCLP, eurclp:@bloomberg_EURCLP, gbpclp:@bloomberg_GBPCLP)
    else
      if (last_bloomberg_record.usdclp != @bloomberg_USDCLP || last_bloomberg_record.eurclp != @bloomberg_EURCLP || last_bloomberg_record.gbpclp != @bloomberg_GBPCLP)
        Rate.create(provider: 'Bloomberg', usdclp: @bloomberg_USDCLP, eurclp:@bloomberg_EURCLP, gbpclp:@bloomberg_GBPCLP)
      end
    end

  end

  def self.last_usdclp_average(provider)
    last_records = Rate.where(["usdclp > ? and provider = ?", 0.0, provider]).last(10).pluck("usdclp")
    sum = 0.0
    last_records.each do |r|
      sum = sum + r.to_f
    end
    avg = sum/10
    return avg
  end

  def self.create(params)
    super
    if params[:usdclp].to_f <= 0.0 || params[:eurclp].to_f <= 0.0 || params[:gbpclp].to_f <= 0.0
      ErrorMailer.notify_error_email(params[:provider]).deliver
      puts "Email enviado a sebadelacerda@gmail.com"
    end
    return Rate.where(provider: params[:provider]).last
  end

  def self.capitaria_getValue (response, parity)
    aux = response.partition(parity).last
    aux = aux.partition('<td>').last
    aux = aux.partition('<td>').last
    value = aux.partition('</td>').first
    return value
  end

  def self.yahoo_getValue (parity)
    response = open('https://es-us.finanzas.yahoo.com/quote/' << parity << '=X?ltr=1').read
    aux = response.partition(%Q(<div id="quote-market-notice")).first
    aux = aux[aux.rindex(%Q(<div))..-1]
    aux = aux.partition(%Q(</span>)).first
    aux = aux[aux.rindex(%Q(>))..-1]
    value = aux[1..-1]
    return value
  end

  def self.bloomberg_getValue (parity)
    response = open('https://www.bloomberg.com/quote/' << parity << ':CUR').read
    aux = response.partition('price-container').last
    aux = aux.partition(%Q(class="price">)).last
    value = aux.partition('</div>').first
    return value
  end
end

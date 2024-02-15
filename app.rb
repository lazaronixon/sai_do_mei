require_relative "models"

require "roda"

require "tilt"
require "tilt/jbuilder"

class App < Roda
  plugin :default_headers, "content-type" => "application/json"
  plugin :render, engine: "jbuilder"
  plugin :error_handler
  plugin :symbol_status
  plugin :json_parser

  plugin :common_logger, LOGGER, method: :info

  route do |r|
    r.on "clientes", Integer do |cliente_id|
      r.get "extrato" do
        @cliente = Cliente.first!(id: cliente_id)
        render "extratos/show.json"
      end

      r.post "transacoes" do
        DB.transaction do
          @cliente = Cliente.first!(id: cliente_id)
          @cliente.add_transacao(r.params.slice("valor", "tipo", "descricao"))
        end

        render "transacoes/create.json"
      end
    end
  end

  error do |exception|
    case exception
    when Sequel::NoMatchingRow
      response.status = :not_found; nil
    when Sequel::ValidationFailed
      response.status = :unprocessable_entity; nil
    else
      LOGGER.error(exception); nil
    end
  end
end

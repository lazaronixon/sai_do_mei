class Transacao < Sequel::Model
  many_to_one :cliente

  enum :tipo, { credito: "c", debito: "d" }

  def after_create
    update_saldo_cliente
    super
  end

  def validate
    super
    validates_includes %i(credito debito), :tipo
    validates_integer :valor
    validates_length_range 1..10, :descricao
    validates_operator :>, 0, :valor

    client_must_have_available_funds
  end

  private
    def update_saldo_cliente
      cliente.update saldo: saldo_futuro
    end

    def saldo_futuro
      debito? ? (cliente.saldo - valor) : (cliente.saldo + valor)
    end

    def client_must_have_available_funds
      errors.add(:valor, :invalid) if debito? && saldo_futuro_disponivel.negative?
    end

    def saldo_futuro_disponivel
      debito? ? (cliente.saldo_disponivel - valor) : (cliente.saldo_disponivel + valor)
    end
end

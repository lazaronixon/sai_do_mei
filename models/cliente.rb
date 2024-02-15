class Cliente < Sequel::Model
  one_to_many :transacoes, order: Sequel.desc(:id)

  def saldo_disponivel
    saldo + limite
  end
end

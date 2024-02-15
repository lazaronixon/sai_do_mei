Sequel.migration do
  change do
    create_table :transacoes do
      primary_key :id
      Integer :valor,      null: false
      String  :tipo,       null: false, limit: 1
      String  :descricao,  null: false, limit: 10
      Integer :cliente_id, null: false

      DateTime :created_at, null: false
    end
  end
end

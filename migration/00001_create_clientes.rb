Sequel.migration do
  change do
    create_table :clientes do
      primary_key :id
      String  :nome,   null: false
      Integer :limite, null: false
      Integer :saldo,  null: false, default: 0
    end
  end
end

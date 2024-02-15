json.saldo do
  json.total @cliente.saldo
  json.data_extrato Time.now
  json.limite @cliente.limite
end

json.ultimas_transacoes @cliente.transacoes_dataset.limit(10) do |transacao|
  json.valor transacao.valor
  json.tipo transacao[:tipo]
  json.descricao transacao.descricao
  json.realizada_em transacao.created_at
end

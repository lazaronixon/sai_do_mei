clientes = [
  { id: 1, nome: "o barato sai caro", limite: 100000 },
  { id: 2, nome: "zan corp ltda", limite: 80000 },
  { id: 3, nome: "les cruders", limite: 1000000 },
  { id: 4, nome: "padaria joia de cocaia", limite: 10000000 },
  { id: 5, nome: "kid mais", limite: 500000 }
]

clientes.each do |attributes|
  Cliente.insert(attributes)
rescue Sequel::UniqueConstraintViolation => ex
  # cliente already exists
end

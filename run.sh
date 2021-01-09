# Criar arquivo de politicas de segurança (policy.json)

# Criar role de segurança na AWS (IAM)
aws iam create-role \
  --role-name lambda-example-test \
  --assume-role-policy-document file://policy.json \
  | tee logs/role.log

# Criar arquivo com conteudo e zipar
zip function.zip index.js

aws lambda create-function \
  --function-name hello-cli-test \
  --zip-file fileb://function.zip \
  --handler index.handler \
  --runtime nodejs12.x \
  --role arn:aws:iam::244083263703:role/lambda-example-test \
  | tee logs/lambda-create.log

# Invocar a lambda
aws lambda invoke \
  --function-name hello-cli-test \
  --log-type Tail \
  logs/lambda-exec.log

# Atualizar e zipar lambda
zip function.zip index.js

# atualizar lambda na AWS
aws lambda update-function-code \
  --zip-file fileb://function.zip \
  --function-name hello-cli-test \
  --publish \
  | tee logs/lambda-update.log

# Invocar a lambda novamente
aws lambda invoke \
  --function-name hello-cli-test \
  --log-type Tail \
  logs/lambda-exec-update.log

# remover function
aws lambda delete-function \
  --function-name hello-cli-test

# remover role
aws iam delete-role \
  --role-name lambda-example-test
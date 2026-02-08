# ExMon

Jogo de turnos via terminal inspirado em Pokemon, criado para aprendizado da linguagem Elixir.

## Sobre

O jogador cria um personagem com 3 movimentos (ataque aleatório, ataque médio e cura) e enfrenta o computador em turnos alternados. Cada jogador começa com 100 de vida — vence quem zerar a vida do oponente primeiro.

## Como jogar

```bash
# Instalar dependências
mix deps.get

# Iniciar o jogo no terminal interativo
iex -S mix
```

```elixir
# Criar um jogador com nome e 3 movimentos (aleatório, médio, cura)
player = ExMon.create_player("Sam")

# Iniciar o jogo
ExMon.start_game(player)

# Fazer uma jogada (:move_avg, :move_rnd ou :move_heal)
ExMon.make_move(:move_avg)
```

## Testes

```bash
mix test
```

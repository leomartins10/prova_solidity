// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29; 

import "@openzeppelin/contracts/access/Ownable.sol";

contract Jokenpo is Ownable(msg.sender) {

    // Mapping para armazenar todas as carteiras inscritas no contrato
    mapping(address => bool) public carteirasInscritas;

    // Armazenando os fatos do jogo
    struct jokenpo {
        uint id;
        address jogador1;
        string jogada1;
        address jogador2;
        string jogada2;
        string vencedor;
    }
    
    // Array para armazenar os jogos jokenpo
    jokenpo[] public jogosJokenpo;

    // Função para inscrever carteiras
    function adicionarCarteira(address _carteira) public onlyOwner returns(bool) {
        // Garantindo que o endereço não é nulo
        require(_carteira != address(0), "Endereco Invalido");
        carteirasInscritas[_carteira] = true;

        // Retornar `true` para operação bem sucedida
        return true;
    }


    // Função para jogar jokenpo    
    function jogar_jokenpo(
        address _jogador1, string memory _jogada1, 
        address _jogador2, string memory _jogada2
        ) public returns(string memory) {
        
        // Verificando se os jogadores estão inscritos no contrato
        require(
            carteirasInscritas[_jogador1] == true &&
            carteirasInscritas[_jogador2] == true, "Carteira Invalida"
        );

        // Certificando que apenas jogadas válidas possam ocorrer
        require(
            keccak256(abi.encodePacked(_jogada1)) == "Pedra" ||
            keccak256(abi.encodePacked(_jogada1)) == "Papel" ||
            keccak256(abi.encodePacked(_jogada1)) == "Tesoura" 
        );
        
        // Certificando que apenas jogadas válidas possam ocorrer
        require(
            keccak256(abi.encodePacked(_jogada2)) == "Pedra" ||
            keccak256(abi.encodePacked(_jogada2)) == "Papel" ||
            keccak256(abi.encodePacked(_jogada2)) == "Tesoura" 
        );

        // Determina o vencedor com base nas jogadas
        string memory vencedor;

        // Lógica IF/Else para determinar o vencedor da partida
        if (keccak256(abi.encodePacked(_jogada1)) == keccak256(abi.encodePacked(_jogada2))) {
            vencedor = "Empate";
        } else if (
            (keccak256(abi.encodePacked(_jogada1)) == keccak256(abi.encodePacked("Pedra")) && keccak256(abi.encodePacked(_jogada2)) == keccak256(abi.encodePacked("Tesoura"))) ||
            (keccak256(abi.encodePacked(_jogada1)) == keccak256(abi.encodePacked("Tesoura")) && keccak256(abi.encodePacked(_jogada2)) == keccak256(abi.encodePacked("Papel"))) ||
            (keccak256(abi.encodePacked(_jogada1)) == keccak256(abi.encodePacked("Papel")) && keccak256(abi.encodePacked(_jogada2)) == keccak256(abi.encodePacked("Pedra")))
        ) {
            vencedor = "Jogador 1";
        } else {
            vencedor = "Jogador 2";
        }

        // Armazenando jogo no contrato com o resultado
        armazenarJokenpo(_jogador1, _jogada1, _jogador2, _jogada2, vencedor);

        // Retorna o vencedor
        return vencedor;
    }

    // Função para armazenar jogo de jokenpo    
    function armazenarJokenpo(
        address _jogador1, string memory _jogada1, 
        address _jogador2, string memory _jogada2,
        string memory _vencedor
        ) internal returns(bool) { 
        

        // Criando id do jogo jokenpo
        uint _id = jogosJokenpo.length;

        // Criando jogo jokenpo 
        jokenpo memory meuJogoJokenpo = jokenpo({
            id: _id,
            jogador1: _jogador1,
            jogada1: _jogada1,
            jogador2: _jogador2,
            jogada2: _jogada2,
            vencedor: _vencedor
        });
        
        // Armazenando `meuJogoJokenpo` no array `jogosJokenpo`
        jogosJokenpo.push(meuJogoJokenpo);

        // Retornando true caso a operação for bem sucedida
        return true;

        }
}
(async () => {
    try {
        const base = 'http://localhost:3000/api';

        // 1) Login
        const loginResp = await fetch(`${base}/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: 'prof@gmail.com', senha: '1234' }),
        });
        const loginJson = await loginResp.json().catch(() => null);
        console.log('LOGIN HTTP', loginResp.status, JSON.stringify(loginJson));

        const usuario = loginJson?.usuario;
        if (!usuario) {
            console.error('Login falhou ou não retornou usuario.');
            process.exit(2);
        }

        const usuarioId = usuario.id;

        // 2) Criar turma
        const nome = `Turma Teste Automação ${Date.now()}`;
        const createResp = await fetch(`${base}/turmas`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ nome, professorId: usuarioId }),
        });
        const createJson = await createResp.json().catch(() => null);
        console.log('CREATE TURMA HTTP', createResp.status, JSON.stringify(createJson));

        process.exit(0);
    } catch (err) {
        console.error('Erro no script:', err);
        process.exit(1);
    }
})();

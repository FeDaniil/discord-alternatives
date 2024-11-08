<script lang="ts">
    import { Button } from "$lib/components/ui/button";
    import { Input } from "$lib/components/ui/input";
    import { Label } from "$lib/components/ui/label";
    import { Badge } from "$lib/components/ui/badge";
    import GradientBackground from './GradientBackground.svelte';

    type Platform = {
        id: string;
        name: string;
        port: string;
        enabled: boolean;
        comingSoon?: boolean;
    };

    let serverName = '';
    let adminEmail = '';
    let result = '';
    let serverDomain = '';
    let copied = false;
    let selectedPlatform = 'mattermost';

    let errors = {
        serverName: '',
        serverDomain: '',
        adminEmail: ''
    };

    const platforms: Platform[] = [
        { id: 'mattermost', name: 'Mattermost', port: '8065', enabled: true },
        { id: 'rocketchat', name: 'Rocket.Chat', port: '3000', enabled: false, comingSoon: true },
        { id: 'matrix', name: 'Matrix', port: '443', enabled: false, comingSoon: true }
    ];

    function copyToClipboard() {
        navigator.clipboard.writeText(result);
        copied = true;
        setTimeout(() => copied = false, 2000);
    }

    function validateForm() {
        let isValid = true;
        errors = { serverName: '', serverDomain: '', adminEmail: '' };

        if (!serverName) {
            errors.serverName = 'Имя сервера обязательно.';
            isValid = false;
        }

        if (!serverDomain) {
            errors.serverDomain = 'Имя домена обязательно.';
            isValid = false;
        }

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(adminEmail)) {
            errors.adminEmail = 'Некорректный e-mail адрес.';
            isValid = false;
        }

        return isValid;
    }

    function generateScript() {
        if (validateForm()) {
            return `
mkdir -p /tmp/${selectedPlatform} && cd /tmp/${selectedPlatform} && echo "APP=${selectedPlatform}
SERVER_NAME=${serverName}
SERVER_DOMAIN=${serverDomain}
ADMIN_EMAIL=${adminEmail}" > .env
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/FeDaniil/discord-alternatives/HEAD/setup.sh)"
            `;
        }
        return '';
    }

    function handleGenerateScript() {
        result = generateScript();
    }

    function selectPlatform(platform: Platform) {
        if (platform.enabled) {
            selectedPlatform = platform.id;
        }
    }
</script>

<style>
    .container {
        display: flex;
        width: 100%;
        justify-content: center; /* Aligns form-container to the center */
    }

    .form-container {
        width: 90%; /* Adjust as needed */
        padding: 16px;
        max-width: 800px; /* Optional: Add a max width for better control */
    }

    .error {
        color: red;
        font-size: 0.875rem;
    }
</style>

<main class="min-h-screen flex flex-col sm:flex-row justify-center items-center px-4 sm:px-0">
    <GradientBackground />
    <div class="container rounded-lg m-4">
        <div class="form-container rounded-lg border bg-gray-50 bg-opacity-90">
            <div class="mb-8 text-center">
                <h1 class="text-2xl font-semibold">Генератор аналога Discord / Slack</h1>
            </div>

            <div class="flex flex-wrap mb-8 p-2 justify-center gap-2">
                {#each platforms as platform}
                    <Button
                            variant={selectedPlatform === platform.id ? "default" : "outline"}
                            on:click={() => selectPlatform(platform)}
                            disabled={!platform.enabled}
                            class="relative flex-1 min-w-max whitespace-nowrap">
                        {platform.name}
                        {#if platform.comingSoon}
                            <Badge class="absolute top-[-8px] right-[-8px] text-xs px-1 py-0.5 rounded bg-purple-600 text-white whitespace-nowrap">Скоро</Badge>
                        {/if}
                    </Button>
                {/each}
            </div>

            <!-- Форма для ввода данных -->
            <div class="flex flex-col gap-6 mb-8">
                <div class="flex flex-col gap-2">
                    <Label for="name">Имя сервера:</Label>
                    <Input id="name" bind:value={serverName}/>
                    {#if errors.serverName}
                        <span class="error">{errors.serverName}</span>
                    {/if}
                </div>
                <div class="flex flex-col gap-2">
                    <Label for="domain">Имя домена:</Label>
                    <Input id="domain" bind:value={serverDomain}/>
                    {#if errors.serverDomain}
                        <span class="error">{errors.serverDomain}</span>
                    {/if}
                </div>
                <div class="flex flex-col gap-2">
                    <Label for="email">Email адрес:</Label>
                    <Input id="email" bind:value={adminEmail}/>
                    {#if errors.adminEmail}
                        <span class="error">{errors.adminEmail}</span>
                    {/if}
                </div>
                <div class="flex justify-center">
                    <Button variant="default" on:click={handleGenerateScript}>
                        Генерировать сценарий
                    </Button>
                </div>
            </div>

            {#if result}
                <div class="mt-8">
                    <div class="flex justify-between items-center">
                        <h2 class="text-xl">Сгенерированный сценарий</h2>
                        <Button
                                variant="outline"
                                size="sm"
                                on:click={copyToClipboard}
                                class="px-2 py-1 text-sm">
                            {copied ? '✓ Скопировано!' : 'Копировать'}
                        </Button>
                    </div>
                    <div class="p-4 mt-2 rounded-lg border border-gray-300 bg-gray-50">
                        <pre class="text-xs whitespace-pre-wrap">{result}</pre>
                    </div>
                </div>
            {/if}
        </div>
    </div>
</main>
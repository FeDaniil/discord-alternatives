<script lang="ts">
    import { onMount } from 'svelte';
    let gradientContainer: HTMLDivElement | null = null;

    onMount(() => {
        animateGradient();
    });

    function animateGradient() {
        const colors = [
            [0, 0, 0],       // black
            [50, 0, 50],     // dark purple
            [100, 0, 100],   // purple
            [150, 0, 150],   // light purple
            [200, 0, 200],   // lighter purple
            [255, 0, 255]    // purple (with full intensity)
        ];
        let step = 0;
        const colorIndices = [0, 1, 2, 3];
        const gradientSpeed = 0.001; // Slower speed for smoother transitions

        function updateGradient() {
            if (!gradientContainer) return;

            const c0_0 = colors[colorIndices[0]];
            const c0_1 = colors[colorIndices[1]];
            const c1_0 = colors[colorIndices[2]];
            const c1_1 = colors[colorIndices[3]];

            const istep = 1 - step;
            const r1 = Math.round(istep * c0_0[0] + step * c0_1[0]);
            const g1 = Math.round(istep * c0_0[1] + step * c0_1[1]);
            const b1 = Math.round(istep * c0_0[2] + step * c0_1[2]);
            const color1 = `rgb(${r1},${g1},${b1})`;

            const r2 = Math.round(istep * c1_0[0] + step * c1_1[0]);
            const g2 = Math.round(istep * c1_0[1] + step * c1_1[1]);
            const b2 = Math.round(istep * c1_0[2] + step * c1_1[2]);
            const color2 = `rgb(${r2},${g2},${b2})`;

            gradientContainer.style.background = `linear-gradient(to right, ${color1}, ${color2})`;

            step += gradientSpeed;
            if (step >= 1) {
                step %= 1;
                colorIndices[0] = colorIndices[1];
                colorIndices[1] = (colorIndices[1] + 1) % colors.length;
                colorIndices[2] = colorIndices[3];
                colorIndices[3] = (colorIndices[3] + 1) % colors.length;
            }
        }

        setInterval(updateGradient, 10);
    }
</script>

<style>
    .gradient {
        height: 100vh;
        width: 100%;
        background: linear-gradient(to right, #000000, #1c1962); /* Initial gradient for fallback */
        position: fixed;
        top: 0;
        left: 0;
        z-index: -1;
    }
</style>

<div bind:this={gradientContainer} class="gradient"></div>
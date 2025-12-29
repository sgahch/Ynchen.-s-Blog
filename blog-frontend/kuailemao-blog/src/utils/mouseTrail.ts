// mouseTrail.ts
export function initMouseTrail() {
    const CONFIG = {
        trailLength: 50,
        explosionCount: 40,
        friction: 0.96,
        gravity: 0.15
    };

    const canvas = document.getElementById("fx") as HTMLCanvasElement;
    if (!canvas) return;

    const ctx = canvas.getContext("2d", { alpha: true })!;
    let particles: any[] = [];
    let trail: any[] = [];
    let mousePos: { x: number; y: number } | null = null;
    let animationId = 0;

    function resize() {
        const dpr = window.devicePixelRatio || 1;
        canvas.width = window.innerWidth * dpr;
        canvas.height = window.innerHeight * dpr;
        canvas.style.width = `${window.innerWidth}px`;
        canvas.style.height = `${window.innerHeight}px`;

        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.scale(dpr, dpr);
    }
    resize();
    window.addEventListener("resize", resize);

    function createExplosion(x: number, y: number) {
        const hueBase = Math.random() * 360;
        for (let i = 0; i < CONFIG.explosionCount; i++) {
            const angle = Math.random() * Math.PI * 2;
            const speed = 2 + Math.random() * 8;

            particles.push({
                x,
                y,
                vx: Math.cos(angle) * speed,
                vy: Math.sin(angle) * speed,
                life: 1,
                decay: 0.015 + Math.random() * 0.02,
                color: `hsl(${hueBase + Math.random() * 60}, 100%, 60%)`,
                size: 3 + Math.random() * 5
            });
        }
    }

    function render() {
        const w = window.innerWidth;
        const h = window.innerHeight;
        ctx.clearRect(0, 0, w, h);

        if (mousePos) {
            trail.push({ ...mousePos, age: 0 });
            if (trail.length > CONFIG.trailLength) trail.shift();
        }

        trail.forEach(t => (t.age += 0.04));
        trail = trail.filter(t => t.age < 1);

        if (trail.length > 1) {
            ctx.beginPath();
            ctx.lineCap = "round";
            ctx.lineJoin = "round";

            const p0 = trail[0];
            ctx.moveTo(p0.x, p0.y);

            for (let i = 1; i < trail.length - 1; i++) {
                const p1 = trail[i];
                const p2 = trail[i + 1];
                const xc = (p1.x + p2.x) / 2;
                const yc = (p1.y + p2.y) / 2;
                ctx.quadraticCurveTo(p1.x, p1.y, xc, yc);
            }

            const last = trail[trail.length - 1];
            ctx.lineTo(last.x, last.y);

            const gradient = ctx.createLinearGradient(p0.x, p0.y, last.x, last.y);
            gradient.addColorStop(0, "rgba(0,255,255,0)");
            gradient.addColorStop(0.6, "rgba(0,255,255,0.9)");
            gradient.addColorStop(1, "rgba(255,255,255,1)");

            ctx.strokeStyle = gradient;
            ctx.lineWidth = 3.2;
            ctx.shadowBlur = 18;
            ctx.shadowColor = "cyan";
            ctx.stroke();
            ctx.shadowBlur = 0;
        }

        ctx.globalCompositeOperation = "lighter";
        for (let i = particles.length - 1; i >= 0; i--) {
            const p = particles[i];

            p.vx *= CONFIG.friction;
            p.vy *= CONFIG.friction;
            p.vy += CONFIG.gravity;

            p.x += p.vx;
            p.y += p.vy;

            p.life -= p.decay;
            if (p.life <= 0) {
                particles.splice(i, 1);
                continue;
            }

            ctx.globalAlpha = p.life;
            ctx.beginPath();
            ctx.arc(p.x, p.y, p.size * p.life, 0, Math.PI * 2);
            ctx.fillStyle = p.color;
            ctx.fill();
        }
        ctx.globalAlpha = 1;
        ctx.globalCompositeOperation = "source-over";

        animationId = requestAnimationFrame(render);
    }
    render();

    window.addEventListener("mousemove", e => {
        mousePos = { x: e.clientX, y: e.clientY };
    });

    window.addEventListener("click", e => {
        createExplosion(e.clientX, e.clientY);
    });
}

// ⬇⬇⬇ 关键导出（你之前缺这个）⬇⬇⬇
export default initMouseTrail;

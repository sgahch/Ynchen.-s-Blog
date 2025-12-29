// DayNightToggleButton.js
import { useColorMode } from "@vueuse/core";

function initAnimations(shadow) {
    const button = shadow.querySelector(".button");
    const stars = shadow.querySelectorAll(".star");
    const circle1 = shadow.querySelector(".circle1");
    const circle2 = shadow.querySelector(".circle2");
    const circle3 = shadow.querySelector(".circle3");
    const moon1 = shadow.querySelector(".moon1");
    const moon2 = shadow.querySelector(".moon2");
    const moon3 = shadow.querySelector(".moon3");
    const cloud1 = shadow.querySelector(".cloud1");
    const cloud2 = shadow.querySelector(".cloud2");
    const floatingClouds = shadow.querySelectorAll(".float-cloud span");

    let theme = "light";

    const fireChange = () => {
        const detail = theme === "light" ? "dark" : "light";
        theme = detail;
        shadow.host.dispatchEvent(new CustomEvent("change", { detail }));
    };

    button.addEventListener("click", () => {
        button.classList.toggle("day");
        button.classList.toggle("night");

        stars.forEach((star) => star.classList.toggle("active"));
        circle1.classList.toggle("active");
        circle2.classList.toggle("active");
        circle3.classList.toggle("active");

        moon1.classList.toggle("active");
        moon2.classList.toggle("active");
        moon3.classList.toggle("active");

        cloud1.classList.toggle("active");
        cloud2.classList.toggle("active");

        fireChange();
    });

    // 星星闪烁动画
    setInterval(() => {
        stars.forEach((star) => {
            star.style.animation = `twinkle ${1.5 + Math.random()}s infinite`;
        });
    }, 1000);

    // 漂浮云朵随机运动
    floatingClouds.forEach((cloud) => {
        setInterval(() => {
            const randomX = Math.random() * 20 - 10;
            const randomY = Math.random() * 10 - 5;
            cloud.style.transform = `translate(${randomX}px, ${randomY}px)`;
        }, 2000 + Math.random() * 2000);
    });
}

class DayNightToggleButton extends HTMLElement {
    constructor() {
        super();

        const shadow = this.attachShadow({ mode: "open" });

        // 加载 HTML 和 CSS
        shadow.innerHTML = `
      <style>
        :host {
          display: inline-block;
          cursor: pointer;
        }

        .button {
          --size: 40px;
          width: var(--size);
          height: var(--size);
          border-radius: 50%;
          position: relative;
          background: #ffeb3b;
          transition: all 0.5s ease;
          overflow: visible;
        }

        .button.night {
          background: #37474f;
        }

        /* 太阳光晕 */
        .circle1, .circle2, .circle3 {
          position: absolute;
          border-radius: 50%;
          background: rgba(255, 235, 59, 0.4);
          transition: 0.5s;
          opacity: 1;
        }

        .circle1 { width: 60px; height: 60px; top: -10px; left: -10px; }
        .circle2 { width: 80px; height: 80px; top: -20px; left: -20px; }
        .circle3 { width: 100px; height: 100px; top: -30px; left: -30px; }

        .circle1.active, .circle2.active, .circle3.active {
          opacity: 0;
        }

        /* 月亮 */
        .moon1, .moon2, .moon3 {
          position: absolute;
          width: 6px;
          height: 6px;
          background: #fff;
          border-radius: 50%;
          opacity: 0;
          transition: 0.5s;
        }

        .moon1 { top: 5px; left: -10px; }
        .moon2 { top: -5px; left: 2px; }
        .moon3 { top: 10px; left: 10px; }

        .moon1.active, .moon2.active, .moon3.active {
          opacity: 1;
        }

        /* 星星 */
        .star {
          width: 4px;
          height: 4px;
          background: white;
          border-radius: 50%;
          position: absolute;
          top: -20px;
          right: -20px;
          opacity: 0;
        }

        .star.active {
          animation: twinkle 1.5s infinite;
          opacity: 1;
        }

        @keyframes twinkle {
          0%, 100% { opacity: 0.2; transform: scale(1); }
          50% { opacity: 1; transform: scale(1.3); }
        }

        /* 云朵 */
        .cloud1, .cloud2 {
          position: absolute;
          top: 10px;
          width: 40px;
          height: 18px;
          background: #fff;
          border-radius: 20px;
          transition: 0.5s;
        }

        .cloud1 { left: -20px; }
        .cloud2 { left: 25px; top: 12px; }

        .cloud1.active, .cloud2.active {
          opacity: 0;
        }

        /* 浮动云 */
        .float-cloud {
          position: absolute;
          width: 100px;
          height: 100px;
        }

        .float-cloud span {
          position: absolute;
          width: 15px;
          height: 8px;
          background: #fff;
          border-radius: 20px;
          opacity: 0.7;
          transition: 1.5s;
        }
      </style>

      <div class="button day">

        <!-- 太阳光晕 -->
        <div class="circle1"></div>
        <div class="circle2"></div>
        <div class="circle3"></div>

        <!-- 月亮 -->
        <div class="moon1"></div>
        <div class="moon2"></div>
        <div class="moon3"></div>

        <!-- 星星 -->
        <div class="star" style="top:-10px; left:-10px;"></div>
        <div class="star" style="top:-15px; left:20px;"></div>
        <div class="star" style="top:5px; left:25px;"></div>

        <!-- 云朵 -->
        <div class="cloud1"></div>
        <div class="cloud2"></div>

        <!-- 漂浮云 -->
        <div class="float-cloud">
          <span style="top:5px; left:0px;"></span>
          <span style="top:15px; left:20px;"></span>
          <span style="top:25px; left:10px;"></span>
        </div>

      </div>
    `;

        setTimeout(() => initAnimations(shadow), 0);
    }
}

export default DayNightToggleButton;

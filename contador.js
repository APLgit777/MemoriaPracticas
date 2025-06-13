document.addEventListener("DOMContentLoaded", () => {
    const totalUsersEl = document.getElementById('totalUsers');
    const premiumUsersEl = document.getElementById('premiumUsers');
  
    const totalUsers = 7;
    const premiumUsers = 2;
  
    function animateCount(el, target, duration) {
      let start = 0;
      const stepTime = Math.max(1, Math.floor(duration / target));
      const timer = setInterval(() => {
        start += 1;
        el.textContent = start.toLocaleString();
        if (start >= target) clearInterval(timer);
      }, stepTime);
    }
  
    animateCount(totalUsersEl, totalUsers, 1000); // duración en milisegundos (1 segundo)
    animateCount(premiumUsersEl, premiumUsers, 1000);
  });
  
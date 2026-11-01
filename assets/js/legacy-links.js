(() => {
  const destinations = { publications: '/publications/', projects: '/projects/', resume: '/cv/', hobbies: '/yoyo/' };
  const route = () => {
    const destination = destinations[window.location.hash.slice(1)];
    if (destination) window.location.replace(destination);
  };
  route();
  window.addEventListener('hashchange', route);
})();

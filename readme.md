Le fichier compose.yml permet de builder l'image de l'app, de la lancer dans un container, 
et de lancer un autre container pour la base de donnée en parallèle. 
L'app est ensuite accessible à l'adresse localhost:8000

Le fichier compose.swarm.yml nécessite au préalable le lancement d'un 'docker build -t symfony-app .'
Ensuite il faudra lancer un 'docker swarm init' 
Puis pour finir, un 'docker stack deploy -c compose.swarm.yml symfo-app'
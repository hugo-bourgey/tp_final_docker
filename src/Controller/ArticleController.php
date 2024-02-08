<?php

namespace App\Controller;

use App\Entity\Article;
use App\Repository\ArticleRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class ArticleController extends AbstractController
{

    public function __construct(
        private ArticleRepository $repo,
        private EntityManagerInterface $em
    )
    {
    }

    #[Route('/', name: 'app_article')]
    public function index(): Response
    {

        //get all articles and send them to the view
        $articles = $this->repo->findAll();

        return $this->render('article/index.html.twig', [
            'controller_name' => 'ArticleController',
            'articles' => $articles
        ]);
    }
}
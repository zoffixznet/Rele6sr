unit class GoogleComputeEngine::UA;
use HTTP::UserAgent;

has $!ua  = HTTP::UserAgent.new;
has $.api-base;

method post {
}

unit class GoogleComputeEngine::Instance;
use GoogleComputeEngine::UA;

has $.name;
has $.zone;
has $.project;
has $!ua = GoogleComputeEngine::UA.new:
    :api-base('https://www.googleapis.com/compute/v1');

method start {
    $!ua.post: "projects/$!project/zones/$!zone/instances/$!name/start";
}

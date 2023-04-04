post_comment(){
  declare title=$1 body=$2;
  : ${title:? required} ${body:? required};
  echo $title $body;
}
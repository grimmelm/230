$ENV{'TEXINPUTS'}='./texmf//:' . $ENV{'TEXINPUTS'};
$pdf_mode = 1;
$pdflatex = 'pdflatex --shell-escape %O %S'; 
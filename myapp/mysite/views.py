from django.shortcuts import render

# Create your views here.
def index(request):
    context = {'title':'My Wonderful Site'}
    return render(request, 'mysite/index.html', context)
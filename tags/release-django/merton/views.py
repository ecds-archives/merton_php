false = False
true = True

import os
import re
from urllib import urlencode

import datetime

from merton_app.models import *
from merton_app.forms import *
    
from django.conf import settings
from django.http import HttpResponse, Http404
from django.shortcuts import render, render_to_response, redirect
from django.core.paginator import Paginator, InvalidPage, EmptyPage, PageNotAnInteger
from django.template import RequestContext
from django.template.loader import get_template

from eulxml.xmlmap.teimap import Tei, TeiDiv, _TeiBase, TEI_NAMESPACE, xmlmap
from eulcommon.djangoextras.http.decorators import content_negotiation

import eulexistdb
from eulexistdb.query import escape_string
from eulexistdb.exceptions import DoesNotExist, ReturnedMultiple

#Load red_diary.xml as a string from database
db = eulexistdb.db.ExistDB(settings.EXISTDB_SERVER_URL)
path = 'merton/red_diary.xml'
try:
    text_xml = db.getDoc(path).encode('ascii','ignore') #Loads document from server as a string to get around the ascii problem
except:
    print 'Document cannot be accessed'
    raise Http404
#text_xml = os.path.join(settings.BASE_DIR, 'static', 'xml', 'text.xml') # Path to main text document locally
display_xsl = os.path.join('file:///' + settings.BASE_DIR, 'static', 'xsl', 'tei.xsl') #XSL for displaying a page

def index(request):
    context = {}
    return render_to_response('index.html', context, context_instance=RequestContext(request))

def search(request):
    form = SearchForm(request.GET)
    context = {'searchform': form}
    search_opts = {}
    if form.is_valid():
        keyword = ''
        if 'keyword' in form.cleaned_data and form.cleaned_data['keyword']:
            keyword = form.cleaned_data['keyword']
            search_opts['fulltext_terms'] = '%s' % form.cleaned_data['keyword']
            search_opts['highlight'] = True
            
        pags = Search.objects.filter(**search_opts).order_by('-fulltext_score')
            
        pages = pags.all()
        
        context['pages'] = pages
        context['keyword'] = keyword
    else:
        context['keyword'] = 'a vast expanse of nothingness'
    return render_to_response('search.html', context, context_instance=RequestContext(request))

def display_page(request, doc_id):
    url_params = request.GET
    context = {}
    if 'keyword' in url_params and url_params['keyword']:
        context['keywords'] = re.findall(r'\w+', url_params['keyword'])
        context['keyword_url'] = url_params['keyword']
        filter = {'highlight': url_params['keyword']}
    else:
        filter = {}
    if re.search(r'X..\..+', doc_id):
        doc_id = doc_id[:3]#Cleans up unruly doc_ids
    try:
        page = Page.objects.filter(**filter).get(id__exact=doc_id)
    except:
        print 'No page found with doc_id=%s' % doc_id
        raise Http404
    all_pages = xmlmap.load_xmlobject_from_string(text_xml, xmlclass=AllPages)
    format = page.xsl_transform(filename=display_xsl)
    next = ''
    prev = ''
    foundit = False
    for some_page in all_pages.pages:
        next = some_page.id
        if foundit:
            break
        if some_page.id == page.id:
            foundit = True
        if not foundit:
            prev = some_page.id
    context['page'] = page
    context['format'] = format.serialize()
    if next != page.id:
        context['next'] = next
    if prev:
        context['prev'] = prev
    dateline = ''
    if len(page.dateline) > 1 and page.dateline[1].strip() != '':
        dateline = dateline + page.dateline[1].strip() + ', ' + page.dateline[0].strip()
    context['dateline'] = dateline
    return render_to_response('display_page.html', context, context_instance=RequestContext(request))

def contents(request):
    context = {}
    bibliography = xmlmap.load_xmlobject_from_string(text_xml, xmlclass=MertonBibliography)
    context['merton_bib'] = bibliography.citation
    merton = xmlmap.load_xmlobject_from_string(text_xml, xmlclass=AllPages)
    doc_list = []
    for div in merton.pages:
        if div.parent.type != 'div':
            doc_list.append(div)
    context['list'] = doc_list
    return render_to_response('contents.html', context, context_instance=RequestContext(request))

def browse(request, category):
    context = {}
    url_params = request.GET
    if 'filter' in url_params and url_params['filter']:
        context['filter'] = url_params['filter']
    if category:
        context['category'] = category
    else:
        context['category'] = 'author'
    merton = xmlmap.load_xmlobject_from_string(text_xml, xmlclass=AllPages)
    doc_list = []
    for quote in merton.quotes:
        appendage = {
            "author": quote.author,
            "id":quote.quotation.id,
            "text":quote.quotation.text_string,
            "title":quote.quotation.parent.parent.n
        }
        if quote.quotation.lang == 'eng':
            appendage['lang'] = 'English'
        elif quote.quotation.lang == 'fre':
            appendage['lang'] = 'French'
        elif quote.quotation.lang == 'lat':
            appendage['lang'] = 'Latin'
        else:
            appendage['lang'] = 'None'
        doc_list.append(appendage)
    context['quotes'] = doc_list
    return render_to_response('browse.html', context, context_instance=RequestContext(request))

def credits(request):
    return render_to_response('credits.html', {}, context_instance=RequestContext(request))

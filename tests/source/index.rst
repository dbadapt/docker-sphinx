ndd-docker-sphinx-tests
=======================

.. toctree::
   :maxdepth: 2

   markdown



rst2pdf.pdfbuilder
------------------

https://github.com/rst2pdf/rst2pdf



sphinx.ext.graphviz
-------------------

http://sphinx-doc.org/ext/graphviz.html

.. graphviz::

   digraph foo {
      "bar" -> "baz";
   }

.. graph:: foo

   "bar" -- "baz";

.. digraph:: foo

   "bar" -> "baz" -> "quux";



sphinx.ext.ifconfig
-------------------

.. ifconfig:: releaselevel in ('alpha', 'beta', 'rc')

   This stuff is only included in the built docs for unstable versions.

.. ifconfig:: releaselevel in ('1.0.0', '2.0.0')

   This stuff is only included in the built docs for stable versions.



sphinx.ext.mathjax
------------------

https://www.mathjax.org/



sphinx.ext.todo
---------------

.. todo::

   Fix this thing!



sphinxcontrib.actdiag
---------------------

http://blockdiag.com/en/actdiag/sphinxcontrib.html

.. actdiag::

    actdiag admin {
      A -> B -> C;
    }



sphinxcontrib.blockdiag
-----------------------

http://blockdiag.com/en/blockdiag/sphinxcontrib.html

.. blockdiag::

    blockdiag admin {
      top_page -> config -> config_edit -> config_confirm -> top_page;
    }



sphinxcontrib.exceltable
------------------------

https://pythonhosted.org/sphinxcontrib-exceltable/

https://bitbucket.org/birkenfeld/sphinx-contrib/issues/139/sphinxcontrib-exceltable-error-with-sphinx

..
   .. exceltable:: Table caption
      :file: document.xls
      :header: 1
      :selection: A5:B7



sphinxcontrib.gnuplot
---------------------

https://github.com/thewtex/sphinx-contrib/tree/master/gnuplot

Does not work ?!?!



sphinxcontrib.googleanalytics
-----------------------------

https://pypi.python.org/pypi/sphinxcontrib-googleanalytics

Does not work ?!?!



sphinxcontrib.googlechart
-------------------------

https://pythonhosted.org/sphinxcontrib-googlechart/

.. piechart::

   dog: 100
   cat: 80
   rabbit: 40



sphinxcontrib.googlemaps
------------------------

https://pypi.python.org/pypi/sphinxcontrib-googlemaps

.. googlemaps:: Shibuya Station



sphinxcontrib.libreoffice
-------------------------

Need LibreOffice (TODO)



sphinxcontrib.nwdiag
--------------------

http://blockdiag.com/en/nwdiag/sphinxcontrib.html


sphinxcontrib.packetdiag
------------------------

See sphinxcontrib.nwdiag

.. nwdiag::

    nwdiag {
      network dmz {
          web01;
          web02;
      }
    }



sphinxcontrib.plantuml
----------------------

http://fr.plantuml.com/

.. uml::

   @startuml
   user -> (use PlantUML)

   note left of user
      Hello!
   end note
   @enduml

.. uml::

      @startuml

      'style options
      skinparam monochrome true
      skinparam circledCharacterRadius 0
      skinparam circledCharacterFontSize 0
      skinparam classAttributeIconSize 0
      hide empty members

      class Car

      Driver - Car : drives >
      Car *- Wheel : have 4 >
      Car -- Person : < owns

      @enduml

.. uml::

   @startuml
   salt
   {
     Just plain text
     [This is my button]
     ()  Unchecked radio
     (X) Checked radio
     []  Unchecked box
     [X] Checked box
     "Enter text here   "
     ^This is a droplist^
   }
   @enduml



sphinxcontrib.rackdiag
----------------------

See sphinxcontrib.nwdiag



sphinxcontrib.seqdiag
---------------------

http://blockdiag.com/en/seqdiag/sphinxcontrib.html

.. seqdiag::

    seqdiag admin {
      A -> B -> C;
    }

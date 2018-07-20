From: Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 09:30:33 +0200
Message-ID: <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
References: <20180719181556.GA21435@thunk.org>
         <20180719190400.GB4800@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719190400.GB4800@magnolia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Donnerstag, den 19.07.2018, 12:04 -0700 schrieb Darrick J. Wong:
> On Thu, Jul 19, 2018 at 02:15:56PM -0400, Theodore Y. Ts'o wrote:
> > Darrick has sent in patches to convert the ext4 documentation to use
> > rst and to be built as part of the full kernel documentation thanks.
> > In addition to that, he's imported the on-disk documentation from the
> > ext4 wiki into the kernel sources, so hopefully we can keep it more up
> > to date.
> > 
> > When I was experimenting with this, I had to actually build the kernel
> > docs using Sphinx for the first time.  I'm using Debian testing, so at
> > first I blindly followed the instructions by
> > ./scripts/sphinx-pre-install:
> > 
> > Detected OS: Debian GNU/Linux unstable (sid).
> > 	/usr/local/bin/virtualenv sphinx_1.4
> > 	. sphinx_1.4/bin/activate
> > 	pip install -r Documentation/sphinx/requirements.txt
> > 
> > But when I did that, Sphinx had heartburn over the ext4.rst file.
> > 
> >     ./include/linux/spi/spi.h:373: ERROR: Unexpected indentation.
> >     /usr/projects/linux/ext4/Documentation/filesystems/ext4/ext4.rst:139: ERROR: Malformed table.
> >     Column span alignment problem in table line 5.
> 
> Hmmm, apparently it's choking on the table heading borders not matching
> the text:
> 
> ====== ===========
> Foo    Bar
> ====== ===========        <-- need to extend to EOL
> Blah   Blah blah blah blah
> ====== ===========
> 
> Though weirdly while I /can/ get this error to reproduce with the
> virtualenv 1.4.9 release, I can't get it to reproduce with the 1.3.6 or
> 1.6.7 ubuntu packages.  Maybe it's a python3 thing, maybe not?  

Not a py2 or py3 thing. I *guess* it is caused by changes in the underlying
docutils.

> Seems
> pretty fragile to me.

Yes, this is a very confusing and we have to look at reST, docutils, Sphinx-doc,
virtualenv py2 & py3, all these distros and the philosophy of the Linux
community to understand.

Yes, this is a very confusing and we have to look at reST, docutils, Sphinx-doc,
virtualenv py2 & py3, all these distros and the philosophy of the Linux
community to understand.

reST: Is the markup.

docutils (python): Is the reST reference implementation with some changes in
  2017[1].

Sphinx-doc (python): reST application based on the docutils lib
  (docutils>=0.11)[2].  Take in mind, this dependency opens a new array of
  confusion, cause its fulfillment is based on what is installed on your system
  (or in your virtualenv, see below). Side node: the pdf-builder (LaTeX, to be
  correct) is in a continues redesign since the last two years and was horrible
  in older Sphinx-doc versions. E.g. take a look at the current 1.8.0
  development (section deprecated)[4].

python: py2 will retire in 2020 (py3 was released in 2008). All py applications
   we using are py2 and py3 compatible. If we have no bugs, py2 or py3 should
   never be the cause.

distros: Nearly all distros using using py2 as there default python interpreter
   (mostly since there package managers are written/tested with py2).

virtualenv: A virtualenv is build up in the $HOME folder where Sphinx-doc and
   docutils are installed from pypi, the python package manager[3]. Take in
   mind, using another package in parallel to the system package manager manager
   opens another array of confusion.

Normally I would say, lets use (and test against) state of the art. This is
easily done by installing py3 and using virtualenv. But this seems not match the
philosophy of the whole Linux community.

As one told me, the philosophy is to build the Kernel with less installations
from the web by using what the distro ships. IMO this might be right for the
Kernel but not for applications building viewing formats. When it comes to
build PDF you will realize how naive this approach is. IMO there is also no
need to build viewing formats as we can read the documentation in plain text
as we can do it since the beginning ... and this is one reason why we changed
from XML to a plain text markup.

The script named 'sphinx-pre-install' is the crutch that supports this
philosophy.

We have this discussion over and over again an I believe we will have it again
and again, as long as we do not change our POV .. building viewing formats is
an application not a part of the Kernel.
 
Anyway, I hope this helps to clarify, why we have those problems.

[1] http://docutils.sourceforge.net/HISTORY.html 
[2] https://github.com/sphinx-doc/sphinx/blob/master/setup.py#L22
[3] https://pypi.org/
[4] https://github.com/sphinx-doc/sphinx/blob/master/CHANGES

-- Markus --

> 
> Anyway, I'll fix ext4.rst and resubmit that part to get this moving.
> 
> --D
> 
> >     ...
> > 
> > After consulting with Darrick, it appears the problem is that Sphinx8
> > 1.4.9 was the problem.  This is the version that
> > Documentation/sphinx/requirements.txt calls for.  He did his rst
> > conversion work using Ubuntu 18.04's Sphinx 1.6.7.
> > 
> > As it turns out Debian testing/unstable already has Sphinx 1.7.5 in
> > its repository, so if I simply install Sphinx 1.7.5, it works fine.
> > That's what I've done for now.
> > 
> > So that leaves me with some questions:
> > 
> > * Is there a reason why scripts/sphinx-pre-install suggested using a
> >   Python virtual environment and installing Sphinx 1.4.9 instead of
> >   using the distro's pre-packaged Sphinx for Debian unstable/testing?
> > 
> > * Why does Documentation/sphinx/requirements.txt asking for such an
> >   old version of Sphinx?
> >  
> > * Is it a requirement that *.rst files that are checked into the
> >   kernel repo have to work with Sphinx 1.4.9?  Or is it sufficient
> >   that it works with Sphinx 1.6.7 and 1.7.5 (which are the prepackaged
> >   Debian and Ubuntu versions).  And it looks like Fedora 28 has Sphinx
> >   1.7.2 if I'm not mistaken.   How many versions of Sphinx are various
> >   automated build/test systems using?
> > 
> > Thanks,
> > 
> > 						- Ted
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

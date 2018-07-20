From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 09:44:21 -0700
Message-ID: <20180720164421.GG4800@magnolia>
References: <20180719181556.GA21435@thunk.org>
 <20180719190400.GB4800@magnolia>
 <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
 <20180720131206.GM30706@thunk.org>
 <d064f468ab9fc60a02242331e0dddc185d6556ba.camel@darmarit.de>
 <20180720145235.GA27862@thunk.org>
 <cd31ba58ac24851698e06628ceebce4648345ff6.camel@darmarit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Markus Heiser <markus.heiser@darmarit.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cd31ba58ac24851698e06628ceebce4648345ff6.camel@darmarit.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2018 at 06:00:28PM +0200, Markus Heiser wrote:
> Am Freitag, den 20.07.2018, 10:52 -0400 schrieb Theodore Y. Ts'o:
> > On Fri, Jul 20, 2018 at 03:45:37PM +0200, Markus Heiser wrote:
> > > Am Freitag, den 20.07.2018, 09:12 -0400 schrieb Theodore Y. Ts'o:
> > > > I'm not entirely sure what's the best approach.  Right now I just want
> > > > to understand --- do I have to make ext4.rst work against one, or many
> > > > versions of Sphinx?  And which version(s) of Sphinx do I need to
> > > > concern myself with?  If that turns out to be an onerous burden, I'm
> > > > sure I won't be the only person complaining.  :-)
> > > 
> > > In that case ...
> > > 
> > > > But when I did that, Sphinx had heartburn over the ext4.rst file.
> > > > 
> > > >     ./include/linux/spi/spi.h:373: ERROR: Unexpected indentation.
> > > >     /usr/projects/linux/ext4/Documentation/filesystems/ext4/ext4.rst:139: ERROR: Malformed table.
> > > >     Column span alignment problem in table line 5.
> > > 
> > > ... its clear; the table was malformed. A markup error which is not detected
> > > by older versions of docutils (very special case).
> > 
> > ... except that newer verions are A-OK with it.  Apparently 1.3.x was
> > OK with it, and 1.6.x and 1.7.x were ok with it.  ***ONLY*** Sphinx
> > 1.4.9 blew up on the "malformed table".
> 
> Are you sure that it was not due to the docutils version?
> I can't reproduce it but the table parser is a part of docutils.

No idea.  With the virtualenv instructions I get:

$ pip list | egrep -i '(sphinx|docutils)'
docutils         0.12   
Sphinx           1.4.9  
sphinx-rtd-theme 0.4.0  

With Ubuntu 18.04 I get:

$ dpkg -l | egrep -i '(sphinx|docutils)' | awk '{print $2, $3}' | sort -k 2
docutils-common 0.14+dfsg-3
python3-docutils 0.14+dfsg-3
python3-sphinx-rtd-theme 0.2.4-1
sphinx-rtd-theme-common 0.2.4-1
python3-alabaster 0.7.8-1
libjs-sphinxdoc 1.6.7-1ubuntu1
python3-sphinx 1.6.7-1ubuntu1
sphinx-common 1.6.7-1ubuntu1

Ok, newer docutils, maybe that's what it is?

With Ubuntu 16.04 I get:

$ dpkg -l | egrep -i '(sphinx|docutils)' | awk '{print $2, $3}' | sort -k 2
docutils-common 0.12+dfsg-1
python-docutils 0.12+dfsg-1
python-sphinx-rtd-theme 0.1.9-1
sphinx-rtd-theme-common 0.1.9-1
python-alabaster 0.7.7-1
libjs-sphinxdoc 1.3.6-2ubuntu1.1
python-sphinx 1.3.6-2ubuntu1.1
sphinx-common 1.3.6-2ubuntu1.1

and now I'm just confused since 16.04 has the same version of docutils
and an older sphinx and runs fine; but 18.04 has newer docutils and
newer sphinx and runs fine.

> > 
> > So in this case, Darrick has come up with a patch that is makes it OK
> > with 1.4.9 without breaking on 1.7.5 --- and obviously, doing
> > something that makes it broadly portable is the right thing.
> 
> Right, fix it by the markup .. is what I recommend.
> 
> > I'm asking a larger question, which is moving forward, which is more
> > important?  Make it work with Sphinx 1.4.9?  Or making it Sphinx work
> > with Sphinx 1.7.5?
> > 
> > And should we change Documentation/sphinx/requirements.txt to require
> > something newer, such as Sphinx 1.7.5?  And should we require that
> > Ubuntu 18.04 which is using Sphinx 1.6.8 use a virtualenv and use
> > download Sphinx 1.6.8?
> 
> The requirements.txt came from commit fb947f3f47 [1] (inital 24071ac1a6).
> Where Jon and Mauro decided to tag explicit versions ...
> 
> docutils==0.12
> Sphinx==1.4.9
> sphinx_rtd_theme
> 
> Maybe it is time to switch to something like .. ?
> 
> Sphinx>=1.4.9
> sphinx_rtd_theme
> 
> I don't know. Mauro has tested on many distros, he has more experience with
> the wide range of distros then I.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fb947f3f47
> 
> > 
> > My understanding that the Sphinx developers make no guarantees that if
> > we follow some external, version-indepedent spec, that it will work on
> > Sphinx version N, as well as Sphinx version N+1.  (In the ideal world,
> > if there was such an independent spec for .rst format files, and a
> > compliant .rst file doesn't work for Sphinx version N, it's a bug, and
> > we should expect somebody --- perhaps the Distro's --- to backport the
> > fix from Sphinx version N+1 to Sphinx version N.)  E.g., is there an
> > equivalent for ANSI C 1999 standard for .rst files?
> 
> The reST markup is specified here:
> 
>  http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
> 
> but the (last) example of the simple table does not match your "1.4.9"
> experience.

Yes.  This makes writing broadly portable markup difficult -- originally
I did not take the '=' all the way to the right edge of the table
because I saw that last example in the above document and assumed that
it wasn't necessary to extend the '=' all the way to the right edge.
Neither Ubuntu system choked on it, so is this a bug in upstream?  Some
strange patch added by the distro?  Something that ended up in the
python wheel?  Or a bug in the spec?

--D

> -- Markus --
> 
> 
> > 
> > 		       	      	   	    - Ted

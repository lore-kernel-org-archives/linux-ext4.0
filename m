From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 10:52:35 -0400
Message-ID: <20180720145235.GA27862@thunk.org>
References: <20180719181556.GA21435@thunk.org>
 <20180719190400.GB4800@magnolia>
 <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
 <20180720131206.GM30706@thunk.org>
 <d064f468ab9fc60a02242331e0dddc185d6556ba.camel@darmarit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Markus Heiser <markus.heiser@darmarit.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d064f468ab9fc60a02242331e0dddc185d6556ba.camel@darmarit.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2018 at 03:45:37PM +0200, Markus Heiser wrote:
> Am Freitag, den 20.07.2018, 09:12 -0400 schrieb Theodore Y. Ts'o:
> > I'm not entirely sure what's the best approach.  Right now I just want
> > to understand --- do I have to make ext4.rst work against one, or many
> > versions of Sphinx?  And which version(s) of Sphinx do I need to
> > concern myself with?  If that turns out to be an onerous burden, I'm
> > sure I won't be the only person complaining.  :-)
> 
> In that case ...
> 
> > But when I did that, Sphinx had heartburn over the ext4.rst file.
> > 
> >     ./include/linux/spi/spi.h:373: ERROR: Unexpected indentation.
> >     /usr/projects/linux/ext4/Documentation/filesystems/ext4/ext4.rst:139: ERROR: Malformed table.
> >     Column span alignment problem in table line 5.
> 
> ... its clear; the table was malformed. A markup error which is not detected
> by older versions of docutils (very special case).

... except that newer verions are A-OK with it.  Apparently 1.3.x was
OK with it, and 1.6.x and 1.7.x were ok with it.  ***ONLY*** Sphinx
1.4.9 blew up on the "malformed table".

So in this case, Darrick has come up with a patch that is makes it OK
with 1.4.9 without breaking on 1.7.5 --- and obviously, doing
something that makes it broadly portable is the right thing.

I'm asking a larger question, which is moving forward, which is more
important?  Make it work with Sphinx 1.4.9?  Or making it Sphinx work
with Sphinx 1.7.5?

And should we change Documentation/sphinx/requirements.txt to require
something newer, such as Sphinx 1.7.5?  And should we require that
Ubuntu 18.04 which is using Sphinx 1.6.8 use a virtualenv and use
download Sphinx 1.6.8?

My understanding that the Sphinx developers make no guarantees that if
we follow some external, version-indepedent spec, that it will work on
Sphinx version N, as well as Sphinx version N+1.  (In the ideal world,
if there was such an independent spec for .rst format files, and a
compliant .rst file doesn't work for Sphinx version N, it's a bug, and
we should expect somebody --- perhaps the Distro's --- to backport the
fix from Sphinx version N+1 to Sphinx version N.)  E.g., is there an
equivalent for ANSI C 1999 standard for .rst files?

		       	      	   	    - Ted

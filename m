From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 09:12:06 -0400
Message-ID: <20180720131206.GM30706@thunk.org>
References: <20180719181556.GA21435@thunk.org>
 <20180719190400.GB4800@magnolia>
 <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Markus Heiser <markus.heiser@darmarit.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2018 at 09:30:33AM +0200, Markus Heiser wrote:
> Normally I would say, lets use (and test against) state of the art. This is
> easily done by installing py3 and using virtualenv. But this seems not match the
> philosophy of the whole Linux community.
> 
> As one told me, the philosophy is to build the Kernel with less installations
> from the web by using what the distro ships. IMO this might be right for the
> Kernel but not for applications building viewing formats. When it comes to
> build PDF you will realize how naive this approach is. IMO there is also no
> need to build viewing formats as we can read the documentation in plain text
> as we can do it since the beginning ... and this is one reason why we changed
> from XML to a plain text markup.u
> 
> The script named 'sphinx-pre-install' is the crutch that supports this
> philosophy.

It's clear we have an over-constrained problem.  On the one hand, we
want to make sure that the Linux kernel (but maybe not the docs?
unclear?) can build on a wide variety of Linux distros, from those
that are shipping (in some cases) decade-old, antiquated tools in
Enterprise Distrobutions, to bleeding edge Community Distro's.  On the
other, we want to be able to use the latest and greatest features.
And on yet a third hand, we need to deal with the fact that
historically, developers have hated it when they have to download
wierd tools, often ones that are not packaged by the distro, such as
cmake, imake, etc., etc.  (Fortunately with Python virtualenv makes
things relatively painless; unlike in the past.  But I think we
sometimes have biases on past experience.)

My observation though is that at the moment sphinx-pre-install doesn't
really seem to support any one philosophy consistently.  On the one
hand, if you are running Debian unstable, and you don't have the
distro-packaged Sphinx installed, it tells you to use virtualenv, and
force-installs Sphinx 1.4.9.  On the other hand, if you happen to have
the debian-packaged Sphinx installed already it says, "go forth and
build!"  This means that from the perspective of a Kernel developer,
we don't know whether someone will be running Sphinx 1.4.9, or some
other random Distro version.

One approach might be to build the virtualenv setup and download
directly into build sequence.  But the problem with that is it would
break hermetic build systems that some distros use, which (by design)
are not connected to the network for security reasons.

Another solution is to specify that the kernel docs *must* build on
1.4.9, and change sphinx-pre-install to always require this.  This
might require imposing a requirement on distro's to package more than
one version of Sphinx.  (There is precedence, at one point Debian
packaged something like four different versions of autoconf, because
it's needed because autoconf is not necessary backwards *or* forwards
compatible.)

Yet another solution is to impose the burden on kernel developers and
tell them that the kernel docs must be built on a variety of Sphinx
versions, and that over time, changes will break the docs even if
nothing has changed.  So in addition to testing on a large range of
Sphinx versions, over time we will have to continuously update the
kernel docs to deal with backwards incompatible changes in how Sphinx
processes the .rst format.

A forth solution is to force everyone to use something correleted to
what the community distro's are packaging, but roughly every 12-18
months, we leapfrog to a newer version of Sphinx.  This decreases the
continuous upgrade burden, but doesn't make it go away.

I'm not entirely sure what's the best approach.  Right now I just want
to understand --- do I have to make ext4.rst work against one, or many
versions of Sphinx?  And which version(s) of Sphinx do I need to
concern myself with?  If that turns out to be an onerous burden, I'm
sure I won't be the only person complaining.  :-)

							- Ted
							

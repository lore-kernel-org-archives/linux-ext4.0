From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 10:08:35 -0700
Message-ID: <20180720170835.GH4800@magnolia>
References: <20180719181556.GA21435@thunk.org>
 <20180719190400.GB4800@magnolia>
 <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
 <20180720150402.GA32320@infradead.org>
 <1cc801608a1e71b54fe97aae6f5ad2a0024e8e5d.camel@darmarit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Markus Heiser <markus.heiser@darmarit.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1cc801608a1e71b54fe97aae6f5ad2a0024e8e5d.camel@darmarit.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2018 at 06:28:09PM +0200, Markus Heiser wrote:
> Am Freitag, den 20.07.2018, 08:04 -0700 schrieb Christoph Hellwig:
> > On Fri, Jul 20, 2018 at 09:30:33AM +0200, Markus Heiser wrote:
> > > We have this discussion over and over again an I believe we will have it again
> > > and again, as long as we do not change our POV .. building viewing formats is
> > > an application not a part of the Kernel.
> > 
> > Sorry, but this is complete and utter bullshit.
> 
> Maybe .. I'am not a Kernel developer .. I only try to help with the doc tool-

It is (broken, that is, not bulls*).  Building the documentation as part
of the kernel build *is* an application.

The point of documentation is that we record knowledge and then anyone
ought to be able to read it, no matter what platform they choose, right?
So that means that for any given user, if their Linux distro packages
the doc build tools they ought to be able to build the fancy html stuff
and read it.  If they're more accustomed to virtualenv and pip, they
ought to be able to build the fancy html and read it too.

Anyway, this whole thread got started because Ted followed the
instructions, applied my Documentation/ patches, and the build broke.
>From my POV this is just brokenness wrt to the rst spec in the docutils
egg/wheel/whatever python calls it now.

> chain. But if I don't want to install anything from the web, the plain text
> is not as bad.

It will be once we start uploading filesystem format documentation
that's full of juicy tables and diagrams...

> > 
> > If that was the case we could skip all that RST stuff and just stick
> > to text files.  If we want fancy docs it better behave like the rest
> > of the kernel and just works.  python virtual environments are just
> > not going to cut it as they lead to a long-term maintainance nightmare.
> 
> Really a nightmare? This is what I do on my ubuntu/debian box ... I do
> prefer py3 so I installed *virtualenv-py3* once from distro's package
> manager:
> 
> $ sudo apt install python3-virtualenv
> 
> To setup up a environment for building htmldocs:
> 
> $ python3 -m virtualenv py3env
> $ ./py3env/bin/pip install -r ./Documentation/sphinx/requirements.txt

This isn't going to fly in $corporate hermetically sealed kernel build
environment.  It's ok to add things to the list of packages pulled in by
the provisioning system prior to a kernel build, but we cannot support
downloading python wheels for kernel builds.  Therefore the distro
packages have to work.

Which is fine, because the problem here is that whatever pip installs is
less forgiving than the distro packaged versions. :)

--D

> 
> now I have all installed in the in the py3env folder. To build htmldocs
> with:
> 
>  $ SPHINXBUILD=./py3env/bin/sphinx-build make htmldocs
> 
> If the env is no longer needed:
> 
>  $ rm -r py3env
> 
>  -- Markus --
> 
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

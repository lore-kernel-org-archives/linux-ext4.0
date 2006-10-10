From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Tue, 10 Oct 2006 17:07:18 -0400
Message-ID: <20061010210718.GB27591@thunk.org>
References: <20061005205526.7fe744f5.akpm@osdl.org> <20061006122105.GA21816@thunk.org> <1160169015.8658.50.camel@kleikamp.austin.ibm.com> <1160169700.8658.56.camel@kleikamp.austin.ibm.com> <20061006153219.d5b62ee8.akpm@osdl.org> <1160176800.8658.70.camel@kleikamp.austin.ibm.com> <20061007041439.GA5478@thunk.org> <1160236427.14217.14.camel@kleikamp.austin.ibm.com> <20061007172027.GB5478@thunk.org> <1160506098.28923.7.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57730 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1030391AbWJJVHX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 17:07:23 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
Content-Disposition: inline
In-Reply-To: <1160506098.28923.7.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 10, 2006 at 01:48:18PM -0500, Dave Kleikamp wrote:
> On Sat, 2006-10-07 at 13:20 -0400, Theodore Tso wrote:
> > On Sat, Oct 07, 2006 at 10:53:47AM -0500, Dave Kleikamp wrote:
> > > I noticed we are missing Documentation/filesystems/ext4.txt.  Over the
> > > weekend, I'll try to put something together with instructions on getting
> > > the right version of e2fsprogs, etc.
> > 
> > For now just say to grab the latest from:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim
> 
> Ted,
> Do you think it's possible to put a source tarball out there with the
> patches applied?  It's confusing to untar the tarball only to find the
> patchset.  Otherwise, we'll have to beef up the instructions a little
> bit.

I was assuming that someone who knew out how to deal with -mm patchset
would know how to deal with with a patchset. I agree it should be
changed to e2fsprogs-1.39-tyt1-broken-out.tar.gz, though.

We can put a source tarball up, but sometimes the e2fsprogs-interim
patches will be, well, about as stable as the -mm tree.  So people who
assume a completely stable release may end up being a little
disappointed.  Hopefully by the time the ext4 stuff gets merged into
the mainline kernel we'll have a e2fsprogs-WIP release which will
support extents, and then we can tell people to use that....

				-	 - Ted


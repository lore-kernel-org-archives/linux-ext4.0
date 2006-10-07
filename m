From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Sat, 7 Oct 2006 00:14:39 -0400
Message-ID: <20061007041439.GA5478@thunk.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005205526.7fe744f5.akpm@osdl.org> <20061006122105.GA21816@thunk.org> <1160169015.8658.50.camel@kleikamp.austin.ibm.com> <1160169700.8658.56.camel@kleikamp.austin.ibm.com> <20061006153219.d5b62ee8.akpm@osdl.org> <1160176800.8658.70.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:17870 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751673AbWJGEOx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Oct 2006 00:14:53 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
Content-Disposition: inline
In-Reply-To: <1160176800.8658.70.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 06, 2006 at 06:20:00PM -0500, Dave Kleikamp wrote:
> To be honest, I've been lazy and I haven't even tried to get the new
> e2fsprogs.  I just grabbed the latest from the mercurial repository,
> http://e2fsprogs.sourceforge.net/e2fsprogs-hacking.html , and it doesn't
> work for me either.  Ted?
> 
> Hold off on the patch until we figure it out.  :-)

I've been busy cleaning up the userspace extents patches before I'm
willing to accept them into the mainline e2fsprogs tree.  So it's not
yet in Mercurial yet.  It's coming soon; but in the meantime, my
interim patchset which I've been using to hack on the extents patches
plus signed-char-powerpc-dirhash problem can be found at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim

Both a rolled-up patch file plus a broken-out tar.gz file are
available there.  The current version on the above URL is
e2fsprogs-1.39-tyt1.  Note that you will have to take the
f_extents/image.gz from the broken-out tar file and copy it into
tests/f_extents/image.gz or the f_extents regression test will fail.
In addition, the f_lotsbad test regression test is also known to fail
in 1.39-tyt1, and that regression test failure can be safely ignored
for now.

This should be good enough for the extents patches that Shaggy has
been queuing up.

					- Ted

P.S.  Before we add the extents patch, I just thought of one
additional change that might be good to add.  Could we add an u32
field in the superblock which counts the number of files with extents,
and is automatically incremented and decremented as necessary by the
kernel, and which can be checked by e2fsck?  It would be really useful
for making it easy for tune2fs to be able to tell if it can safely
remove the extents feature from the filesystem, or whether it should
refuse such a request.

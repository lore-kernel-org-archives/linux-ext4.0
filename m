From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Sat, 07 Oct 2006 10:53:47 -0500
Message-ID: <1160236427.14217.14.camel@kleikamp.austin.ibm.com>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	 <20061005205526.7fe744f5.akpm@osdl.org> <20061006122105.GA21816@thunk.org>
	 <1160169015.8658.50.camel@kleikamp.austin.ibm.com>
	 <1160169700.8658.56.camel@kleikamp.austin.ibm.com>
	 <20061006153219.d5b62ee8.akpm@osdl.org>
	 <1160176800.8658.70.camel@kleikamp.austin.ibm.com>
	 <20061007041439.GA5478@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:51656 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S932279AbWJGPx4
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Oct 2006 11:53:56 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k97FrqIc007623
	for <linux-ext4@vger.kernel.org>; Sat, 7 Oct 2006 11:53:52 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k97FrqrQ503602
	for <linux-ext4@vger.kernel.org>; Sat, 7 Oct 2006 09:53:52 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k97FrpDE015683
	for <linux-ext4@vger.kernel.org>; Sat, 7 Oct 2006 09:53:52 -0600
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061007041439.GA5478@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2006-10-07 at 00:14 -0400, Theodore Tso wrote:
> On Fri, Oct 06, 2006 at 06:20:00PM -0500, Dave Kleikamp wrote:
> > To be honest, I've been lazy and I haven't even tried to get the new
> > e2fsprogs.  I just grabbed the latest from the mercurial repository,
> > http://e2fsprogs.sourceforge.net/e2fsprogs-hacking.html , and it doesn't
> > work for me either.  Ted?
> > 
> > Hold off on the patch until we figure it out.  :-)
> 
> I've been busy cleaning up the userspace extents patches before I'm
> willing to accept them into the mainline e2fsprogs tree.  So it's not
> yet in Mercurial yet.  It's coming soon; but in the meantime, my
> interim patchset which I've been using to hack on the extents patches
> plus signed-char-powerpc-dirhash problem can be found at:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim
> 
> Both a rolled-up patch file plus a broken-out tar.gz file are
> available there.  The current version on the above URL is
> e2fsprogs-1.39-tyt1.  Note that you will have to take the
> f_extents/image.gz from the broken-out tar file and copy it into
> tests/f_extents/image.gz or the f_extents regression test will fail.
> In addition, the f_lotsbad test regression test is also known to fail
> in 1.39-tyt1, and that regression test failure can be safely ignored
> for now.
> 
> This should be good enough for the extents patches that Shaggy has
> been queuing up.

I noticed we are missing Documentation/filesystems/ext4.txt.  Over the
weekend, I'll try to put something together with instructions on getting
the right version of e2fsprogs, etc.

> P.S.  Before we add the extents patch, I just thought of one
> additional change that might be good to add.  Could we add an u32
> field in the superblock which counts the number of files with extents,
> and is automatically incremented and decremented as necessary by the
> kernel, and which can be checked by e2fsck?  It would be really useful
> for making it easy for tune2fs to be able to tell if it can safely
> remove the extents feature from the filesystem, or whether it should
> refuse such a request.

I guess this would be useful to turn the feature off immediately after
turning it on, but with the removal of the extents mount option, we no
longer have the ability to make old-style files once the feature is
turned on.  So it's unlikely that you'd be able to turn the feature off
once a file system has been used.

Also, do we update the superblock in every transaction that creates or
deletes a file?  Otherwise, how do we guarantee the count is accurate
after replaying the journal?

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center


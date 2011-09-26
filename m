From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add better example about how to compress e2image raw
 image
Date: Mon, 26 Sep 2011 15:23:58 -0400
Message-ID: <20110926192358.GC3282@thunk.org>
References: <1316803672-25550-1-git-send-email-cmaiolino@redhat.com>
 <BAB1C1C4-D0BB-4398-89A5-EC8B1E20801B@dilger.ca>
 <20110923205124.GD26962@andromeda.usersys.redhat.com>
 <20110924163153.GB2779@thunk.org>
 <4E80A73F.2070205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Carlos Maiolino <cmaiolino@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45675 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1IZTYD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Sep 2011 15:24:03 -0400
Content-Disposition: inline
In-Reply-To: <4E80A73F.2070205@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 26, 2011 at 11:24:31AM -0500, Eric Sandeen wrote:
> > 
> >     bunzip2 < hda1.e2i.bz2 | make-sparse hda1.e2i
> > 
> > ... and this creates a sparse file in hda1.e2i.
> 
> or | cp --sparse=always /dev/stdin sparse.img works too.
> 
> But have you ever tried this with a multi-terabyte image?
> 
> It takes -forever- to process all those 0s, with cpus pegged.

Yeah, I didn't realize until I read another message on this thread
that bzip2's CPU problems were causing problems.  Is gzip sufficiently
better, I wonder, or is it still problematic?

> Ted, your concern about space - it doesn't take the full fs size worth
> of space, right, just the metadata space?  So in general it should not
> be THAT much ...

Yes, it's just the metadata space that I was worried about.  So it's
not *that* much, but it still adds up on large systems.  But then
again, on large systems we precisely have the problem of bzip2 taking
forever.

If we decide that we're OK with not compressing qcow2, we could use
qcow2.  But note that the qcow2 format is still very compressible ---
it looks like it could do a better job removing zero blocks.  (I had a
256meg qcow2 e2image file compress down to 9 megs.)  Unfortunately we
can't do stream compression with qcow2.

Long run I think we should make the qcow2 support better (by dropping
all-zero blocks, and adding support for qcow2 to
debugfs/dumpe2fs/e2fsck, and perhaps adding support for native
compression).  Anyone looking for a project?  :-)

						- Ted

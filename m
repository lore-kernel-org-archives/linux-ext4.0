From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH/RFC] - make ext3 more robust in the face of filesystem corruption
Date: Wed, 18 Oct 2006 16:24:49 -0600
Message-ID: <20061018222449.GK3509@schatzie.adilger.int>
References: <45369869.60400@redhat.com> <20061018214022.GJ3509@schatzie.adilger.int> <4536A31F.5050604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:60823 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1423102AbWJRWYw
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 18:24:52 -0400
To: Eric Sandeen <sandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <4536A31F.5050604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 18, 2006  16:56 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > The directory leaf data is kept in
> > the page cache and there is a helper function ext2_check_page() to mark
> > the page "checked".  That means the page only needs to be checked once
> > after being read from disk, instead of each time through readdir.
> 
> ah, sure.  Hm...  well, this might be a bit of a performance hit if it's
> checking cached data... let me think on that.

Well, having something like "ext3_dir_bread()" that verifies the leaf block
once if (!uptodate()) would be almost the same as ext2 with fairly little
effort.  It would help performance in several places, at the slight risk
of not handling in-memory corruption after the block is read...

> > I'm not sure whether this is a win or not.  It means that if there is ever
> > a directory with a bad leaf block any entries beyond that block are not
> > accessible anymore.  
> 
> I'm amazed at how hard ext3 works to cope with bad blocks ;-)

It would fail all of your tests otherwise, right?  That is one virtue of
ext2 having grown up in the days when bad blocks existed.  Those days are
(sadly) coming back again, hence desire for fs-level checksums, etc.

> > The existing !bh case already marks the filesystem in
> > error.  Maybe as a special case we can check in "if (!bh)" if i_size and
> > i_blocks make sense.  Something like:
> > 
> > 		if (!bh) {
> > 			:
> > 			:
> > +			if (filp->f_pos > inode->i_blocks << 9) {
> > +				break;
> > 			filp->f_pos += sb->s_blocksize - offset;
> > 			continue;
> > 		}
> > 
> > This obviously won't help if the whole inode is bogus, but then nothing
> > will catch all errors.
> 
> Yep, I'd thought maybe a size vs. blocks test might make sense; I think
> there can never legitimately be a sparse directory?

Not currently, though there was some desire to allow this during htree
development, to allow shrinking large-but-empty directories.  Since this
already provokes an ext3_error() (which might be a panic()) to hit a hole
we can assume that this needs to be carefully implmemented.

> I guess if the intent is to soldier on in the face of adversity, it
> doesn't matter if it's an umappable offset or an IO error; ext3 wants to
> go ahead & try the next one block anyway.  So the size test probably
> makes sense as a stopping point.

Well, it would also be possible to look into inode->i_blocks to see what
blocks exist past this offset, but that is complicated by the introduction

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

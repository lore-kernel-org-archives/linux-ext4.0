From: Frank Mayhar <fmayhar@google.com>
Subject: Re: fsck infinite loop on corrupt ext4 file system
Date: Tue, 18 Aug 2009 09:31:09 -0700
Message-ID: <1250613069.10195.12.camel@bobble.smo.corp.google.com>
References: <1250294105.6221.24.camel@bobble.smo.corp.google.com>
	 <1250557822.23227.9.camel@bobble.smo.corp.google.com>
	 <20090818160155.GC28560@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:26317 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042AbZHRQbQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2009 12:31:16 -0400
In-Reply-To: <20090818160155.GC28560@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-08-18 at 12:01 -0400, Theodore Tso wrote:
> On Mon, Aug 17, 2009 at 06:10:22PM -0700, Frank Mayhar wrote:
> > It's clear that fsck is neither correcting the block groups nor is it
> > detecting the bad entries properly (a sanity check might be in order
> > here).  It's not even noticing that it's looping, it just keeps failing
> > the allocation and retrying.  While it may be that fsck can't recover
> > the file system in this case, it should at least notice and abort.
> > 
> > My thinking is that the location of the inode tables should be invariant
> > over the life of the file system.  Certainly there's no place in ext4
> > itself that changes those fields (that I can see, anyway).  Why couldn't
> > fsck compute the proper values and compare those against what's there?
> 
> So there are a couple of things going on here.  The first is that the
> code which tries to allocate new inode/block allocation bitmaps or
> inode tables wasn't taught that filesystems with the FLEX_BG feature
> should have the metadata located at the beginning of the
> flex-blockgroup, but if we can't find space for it there (allocating
> the inode table is tricky since it requires possibly up to a few
> hundred contiguous free blocks), we should try to find the space
> anywhere in the filesystem.  If it can't find the space, we should
> indeed abort.  Please find attached a patch which should fix e2fsck to
> handle this case correctly.  Could you test it and let me know if it
> works correctly?

Will do.  I wasn't able to keep a copy of the corrupted image but I
should be able to do _something_ with your patch.  Thanks!

> As far as assuming the inode tables are invariant over the life of the
> filesystem --- this is normally true, but inode tables can be located
> in places other than the default; for example if bad blocks located
> where the inode tables should be, then the inode tables can be pushed
> to non-standard locations.  So this makes calculating where the inode
> table "should" be a little tricky, especially since the contents of
> the bad blocks can change after the filesystem is formatted.

Ah, right.  As far as I understand, though, bad blocks are the only
exception.  (Note that resizing isn't an issue here, nor will it be in
the foreseeable future.)

> In addition, e2fsck tries very hard not to destroy data, and so there
> is the question of what to do if there are data blocks located where
> the inode table "should" be.

I would think that that case would be even more rare than the one we're
dealing with here.  In fact outside of a resize operation I can't think
of how it might happen.

> In any case, with ext4 and the flex_bg feature, the ability to
> allocate the inode table anywhere in the filesystem should make the
> case where the really complex recovery code even more rarely required.

Yeah, agreed.  In fact just noticing that the allocation error is
unrecoverable and failing the fsck would be sufficient for our needs;
our problem was really that fsck was blindly looping until it got
killed.  (I see that your patch does indeed abort the check if the
allocation fails.)

> Please try this patch and see if it fixes things up for you or not.

I'll do so; it might be a bit but I'll let you know how it goes.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.


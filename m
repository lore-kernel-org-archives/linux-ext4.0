From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/31] libext2fs: Fix ext2fs_open2() truncation of the
 superblock parameter
Date: Tue, 8 Oct 2013 10:47:29 -0700
Message-ID: <20131008174729.GJ6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012812.28415.49840.stgit@birch.djwong.org>
 <20131008155859.GG17896@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22974 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3JHRrg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Oct 2013 13:47:36 -0400
Content-Disposition: inline
In-Reply-To: <20131008155859.GG17896@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 08, 2013 at 11:58:59AM -0400, Theodore Ts'o wrote:
> On Mon, Sep 30, 2013 at 06:28:12PM -0700, Darrick J. Wong wrote:
> > Since it's possible for very large filesystems to store backup superblocks at
> > very large (> 2^32) block numbers, we need to be able to handle the case of a
> > caller directing us to read one of these high-numbered backups.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hmm... This is technically true, but I'm wondering how much we should
> care.  In practice, users almost always use the first couple of backup
> superblocks.  I could imagine a situation with a RAID array where the
> first disk(s) were trashed, so we needed to use a backup superblock
> beyond 2**32, but it's a bit unlikely.

True, it seems unlikely now that one would ever need to use the backup sbs
beyond 2^32, but since mke2fs is writing them there, we ought to be able to use
them.

For now, though, it's truncating the top 32 bits of a (usually) user-specified
value, so if we don't extend the API we ought to at least complain and exit.

> If there was some other reason why we needed to add a new ext2fs_open3
> variant, it would certainly be a good thing to fix.  But I'm wondering
> if it's worth adding a new interface just for this.
> 
> Is there perhaps any other extensions to ext2fs_open() that we might
> want to make, either now or in the future?

I don't have any off the top of my head, but I'll think about it.

--D
> 
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

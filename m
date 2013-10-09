From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/31] libext2fs: Badblocks should handle 48-bit block
 numbers correctly
Date: Wed, 9 Oct 2013 14:57:32 -0700
Message-ID: <20131009215732.GL6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012837.28415.1138.stgit@birch.djwong.org>
 <20131008160331.GI17896@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23116 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3JIV5j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Oct 2013 17:57:39 -0400
Content-Disposition: inline
In-Reply-To: <20131008160331.GI17896@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 08, 2013 at 12:03:31PM -0400, Theodore Ts'o wrote:
> On Mon, Sep 30, 2013 at 06:28:37PM -0700, Darrick J. Wong wrote:
> > Currently, the badblocks code assumes 32-bit block numbers.  This leads to
> > unfortunate results, because feeding a badblocks file to mke2fs with 64-bit
> > block numbers causes libext2fs to rip off the upper 32 bits of the block number
> > and then assign a truncated block number to the badblocks file.
> > 
> > This is just as well, since the code that writes to the bb inode doesn't know
> > about extents anyway.  Rather than continuing to open-code block map
> > manipulation, simply use existing library functions to truncate the old bb
> > inode, mark all badblocks in use, and then assign them to the badblocks file.
> > We can even use extents now.
> > 
> > (It's arguable that badblocks is a vestigial organ now, but perhaps someone is
> > using it?  I use it to stress-test disk block allocation, but I might just be
> > nutty.)
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Yeah, I think badblocks is vestigal at this point, and for huge disk
> arrays, almost certainly block replacement will be handed at the LVM,
> storage array, or HDD level.  So it might be better simply to have
> mke2fs throw an error if there is an attempt to hand it a 64-bit block
> number.

Ok.  I'll audit all callers of ext2fs_badblocks_list_add() to make sure they
reject > 2^32 numbers.

--D
> 
> 							- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

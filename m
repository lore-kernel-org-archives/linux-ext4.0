From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/18] libext2/fsck: correctly preserve fs flags when
 modifying ignore-csum-error flag
Date: Mon, 28 Jul 2014 01:06:17 -0700
Message-ID: <20140728080617.GM8628@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003447.28334.51963.stgit@birch.djwong.org>
 <20140727232746.GZ6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21316 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaG1IGW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 04:06:22 -0400
Content-Disposition: inline
In-Reply-To: <20140727232746.GZ6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 27, 2014 at 07:27:46PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 25, 2014 at 05:34:47PM -0700, Darrick J. Wong wrote:
> > nor is it correct
> > to assume that we can unconditionally set (or clear) the "ignore csum
> > error" flag bit.
> 
> For functions inside e2fsck, why is this true?  All of the places
> where we are are EXT2_FLAG_IGNORE_CSUM_ERRORS are places where we set
> it, and then clear it after an ext2 call.  So as near as I can tell it
> shouldn't matter.
> 
> I can understand why we need to be careful for functions inside
> libext2fs, but in that particular case, none of the downstream
> functions of ext2fs_read_inode_full() modify fs->flags.
> 
> So I'm really puzzled what problem this patch actually solves.  Was
> this a theoretical concern, or was there something I missed?

It's mostly a theoretical concern -- rather than having to decide where it's ok
to set the flag and unset it later vs. where we have to set the flag and then
restore it to the previous value, I'd rather just be careful every time, so
that the next time I read through this code I'll know that IGNORE_CSUM_ERRORS
is always put back to its previous value and the other flags are left alone, no
matter how much e2fsck or libext2fs might get refactored.

One of those sites where we modify IGNORE_CSUM_ERRORS actually would
incorrectly clobber the other flag bits that were set inside the library (I
think it's the write_dir_block4 in pass2.c), so I decided to fix all of the
sites.

--D
> 
>        		   	       	   	 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

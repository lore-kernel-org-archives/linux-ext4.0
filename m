From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 6/6] ext4: update EOFBLOCKS flag on fallocate properly
Date: Fri, 28 Oct 2011 15:40:08 -0600
Message-ID: <8E55A8AA-39D7-4FFB-831E-EC5AC25A6112@dilger.ca>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org> <1319144939-28801-7-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:10295 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1J1VkD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 17:40:03 -0400
In-Reply-To: <1319144939-28801-7-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-20, at 3:08 PM, Dmitry Monakhov wrote:
> EOFBLOCK_FL should be updated if called w/o FALLOCATE_FL_KEEP_SIZE
> Currently it happens only if new extent was allocated
> Last fallocate cmd has updated size, but kept EOFBLOCK_FL set. And fsck
> will complain about that.
> 
> Also remove ping pong in ext4_fallocate() in case of new extents, where
> ext4_ext_map_blocks() clear EOFBLOCKS bit, and later
> ext4_falloc_update_inode() restore it again.

Looking into this code, I see some strange behaviour that you added in
an earlier commit (21ca087a3q) to both ext4_ext_convert_to_initialized()
and ext4_split_unwritten_extents(), but I'm trying to figure out if it
is actually needed today.

>    ext4: Do not zero out uninitialized extents beyond i_size
> 
>    The extents code will sometimes zero out blocks and mark them as
>    initialized instead of splitting an extent into several smaller ones.
>    This optimization however, causes problems if the extent is beyond
>    i_size because fsck will complain if there are uninitialized blocks

Should this be "... if there are initialized blocks after i_size"?

>    after i_size as this can not be distinguished from an inode that has
>    an incorrect i_size field.

Shouldn't it be possible to just mark the file with EXT4_EOFBLOCK_FL
so that the whole extent can be zeroed out and avoid the overhead of
splitting the extent and having to zero out the blocks beyond EOF on
the next file IO?

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.






Cheers, Andreas






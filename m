From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: handle flex_bg collision with backup descriptors
Date: Sat, 5 Jul 2014 22:11:24 -0400
Message-ID: <20140706021124.GE19036@thunk.org>
References: <1393618545-29319-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47171 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaGFCL2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 22:11:28 -0400
Content-Disposition: inline
In-Reply-To: <1393618545-29319-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 28, 2014 at 01:15:45PM -0700, Andreas Dilger wrote:
> If a large flex_bg factor is specified and the block allocator was
> laying out block or inode bitmaps or inode tables, and collides with
> previously allocated metadata (for example the backup superblock or
> group descriptors) it would reset the allocator back to the beginning
> of the flex_bg instead of continuing past the obstruction.
> 
> For example, with "-G 131072" the inode table will hit the backup
> descriptors in groups 1, 3, 5, 7, 9 and start interleaving with the
> block and inode bitmaps.  That results in poorly allocated bitmaps
> and inode tables that are interleaved and not contiguous as was
> intended for flex_bg:
> 
>  Group 0: (Blocks 0-32767)
>    Primary superblock at 0, Group descriptors at 1-2048
>    Block bitmap 2049 (+2049), Inode bitmap at 133121 (bg #4+2049)
>    Inode table 264193-264200 (bg #8+2049)
>    :
>    :
>  Group 3838: (Blocks 125763584-125796351) [INODE_UNINIT, BLOCK_UNINIT]
>    Block bitmap 5887 (bg #0+5887), Inode bitmap 136959 (bg #4+5887)
>    Inode table 294897-294904 (bg #8 + 32753)
>  Group 3839: (Blocks 125796352-125829119) [INODE_UNINIT, BLOCK_UNINIT]
>    Block bitmap 5888 (bg #0+5888), Inode bitmap 136960 (bg #4+5888)
>    Inode table 5889-5896 (bg #0 + 5889)
>  Group 3840: (Blocks 125829120-125861887) [INODE_UNINIT, BLOCK_UNINIT]
>    Block bitmap 5897 (bg #0+5897), Inode bitmap 136961 (bg #4+5889)
>    Inode table 5898-5905 (bg #0 + 5898)
>    :
>    :
> 
> Instead, skip the intervening blocks if there aren't too many of them.
> That mostly keeps the flex_bg allocations from colliding, though still
> not perfect because there is still some overlap with the backups.
> This patch addresses the majority of the problem, allowing about 124k
> groups to be layed out perfectly, instead of less than 4k groups with
> the previous code.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted

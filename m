From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext3: set i_extra_isize of 11th inode
Date: Fri, 20 Aug 2010 01:42:25 -0600
Message-ID: <0347DFC8-03A9-45DF-9B9F-ED4005720C49@dilger.ca>
References: <20100820112011.E6FA.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4 development <linux-ext4@vger.kernel.org>
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:29097 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0HTHoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Aug 2010 03:44:32 -0400
In-Reply-To: <20100820112011.E6FA.61FB500B@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-19, at 20:20, Masayoshi MIZUMA wrote:
> In ext3 filesystem, if following conditions 1., 2., 3. and 4. is satisfied,
> getfattr can't search the extended attribute (EA) after remount.
> 
> This happens because of following logic:
>    i_extra_isize is set to over 0 by ext3_new_inode() when we create
>    a file whose inode number is 11 after removing "lost+found". 
>    Therefore setfattr creates the EA in-inode.
>    After remount, i_extra_isize of 11th inode is set to 0 by ext3_iget()
>    when we lookup the file, so getfattr tries to search the EA out-inode.
>    However, the EA locates in-inode, so getfattr can't search the EA.

This was a workaround for a bug in mke2fs a couple of years ago, and is probably no longer needed.

> @@ -2881,8 +2881,7 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
> 		atomic_set(&ei->i_datasync_tid, tid);
> 	}
> 
> -	if (inode->i_ino >= EXT3_FIRST_INO(inode->i_sb) + 1 &&
> -	    EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
> +	if (EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
> 		/*
> 		 * When mke2fs creates big inodes it does not zero out
> 		 * the unused bytes above EXT3_GOOD_OLD_INODE_SIZE,

This should also remove the above comment, which is no longer relevant.


Cheers, Andreas






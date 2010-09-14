From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/2] ext3: Fix lost extented attributes for inode with ino == 11
Date: Tue, 14 Sep 2010 15:36:17 -0600
Message-ID: <DCCF1B41-24F6-484E-AA16-1E866C26D67C@dilger.ca>
References: <1284467566-12661-1-git-send-email-jack@suse.cz> <1284467566-12661-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:10666 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab0INVgT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Sep 2010 17:36:19 -0400
In-Reply-To: <1284467566-12661-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-09-14, at 06:32, Jan Kara wrote:
> If a filesystem has inode size > 128 and someone deletes lost+found and
> reuses inode 11 for some other file, extented attributes set for this
> inode before umount will get lost after remounting the filesystem. This
> is because extended attributes will get stored in an inode but ext3_iget
> will ignore them due to workaround of a bug in an old mkfs.
> 
> Fix the problem by initializing i_extra_isize to 0 for freshly allocated
> inodes where mkfs workaround in ext3_iget applies. This way these inodes
> will always store extended attributes in a special block and no problems
> occur.
> 
> The bug was spotted and a reproduction test provided by:
>  Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
> 
> CC: Andreas Dilger <adilger.kernel@dilger.ca>

Both patches now look good to me.  You can add a:

Reviewed-by: Andreas Dilger <adilger.kernel@dilger.ca>

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> fs/ext3/ialloc.c |   11 ++++++++---
> 1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> index 4ab72db..9724aef 100644
> --- a/fs/ext3/ialloc.c
> +++ b/fs/ext3/ialloc.c
> @@ -570,9 +570,14 @@ got:
> 	ei->i_state_flags = 0;
> 	ext3_set_inode_state(inode, EXT3_STATE_NEW);
> 
> -	ei->i_extra_isize =
> -		(EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) ?
> -		sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE : 0;
> +	/* See comment in ext3_iget for explanation */
> +	if (ino >= EXT3_FIRST_INO(sb) + 1 &&
> +	    EXT3_INODE_SIZE(sb) > EXT3_GOOD_OLD_INODE_SIZE) {
> +		ei->i_extra_isize =
> +			sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE;
> +	} else {
> +		ei->i_extra_isize = 0;
> +	}
> 
> 	ret = inode;
> 	dquot_initialize(inode);
> -- 
> 1.6.4.2
> 


From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH][TRIVIAL] ext2: fix a typo in ext2.h
Date: Tue, 31 Mar 2009 15:14:25 +0200
Message-ID: <20090331131424.GG20127@atrey.karlin.mff.cuni.cz>
References: <20090330121927.GA2237@lilem.mirepesht>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ali Gholami Rudi <ali@rudi.ir>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37476 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZCaNO1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Mar 2009 09:14:27 -0400
Content-Disposition: inline
In-Reply-To: <20090330121927.GA2237@lilem.mirepesht>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  JFYI: Bounced the email to trivial@kernel.org. Please also CC this alias
when submitting such trivial patches. Thanks.

									Honza

> 
> Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
> ---
>  fs/ext2/ext2.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 3203042..6888b2d 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -27,7 +27,7 @@ struct ext2_inode_info {
>  	/*
>  	 * i_block_group is the number of the block group which contains
>  	 * this file's inode.  Constant across the lifetime of the inode,
> -	 * it is ued for making block allocation decisions - we try to
> +	 * it is used for making block allocation decisions - we try to
>  	 * place a file's data blocks near its inode block, and new inodes
>  	 * near to their parent directory's inode.
>  	 */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

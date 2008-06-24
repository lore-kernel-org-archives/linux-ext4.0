From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: handle deleting corrupted indirect blocks
Date: Tue, 24 Jun 2008 08:57:58 -0500
Message-ID: <4860FD66.60003@redhat.com>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org> <1214315240-22950-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	Sami Liedes <sliedes@cc.hut.fi>
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbYFXN6t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2008 09:58:49 -0400
In-Reply-To: <1214315240-22950-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Duane Griffin wrote:
> While freeing indirect blocks we attach a journal head to the parent buffer
> head, free the blocks, then journal the parent. If the indirect block list
> is corrupted and points to the parent the journal head will be detached
> when the block is cleared, causing an OOPS.
> 
> Check for that explicitly and handle it gracefully.
> 
> This patch fixes the third case (image hdb.20000057.nullderef.gz)
> reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 6ae4ecf..8019bf2 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -2127,7 +2127,20 @@ static void ext3_free_data(handle_t *handle, struct inode *inode,
>  
>  	if (this_bh) {
>  		BUFFER_TRACE(this_bh, "call ext3_journal_dirty_metadata");
> -		ext3_journal_dirty_metadata(handle, this_bh);
> +
> +		/*
> +		 * The buffer head should have an attached journal head at this
> +		 * point. However, if the data is corrupted and an indirect
> +		 * block pointed to itself, it would have been detached when
> +		 * the block was cleared. Check for this instead of OOPSing.
> +		 */
> +		if (bh2jh(this_bh))

Should it also (or only) be checking for buffer_jbd rather than testing
bh2jh which is just shorthand for "is b_private non-null?"

Also maybe I should know this intuitively by now, but what is the path
where b_private / BH_JBD got cleared on this corrupted image?

Thanks,
-Eric

> +			ext3_journal_dirty_metadata(handle, this_bh);
> +		else
> +			ext3_error(inode->i_sb, "ext3_free_data",
> +				   "circular indirect block detected, "
> +				   "inode=%lu, block="E3FSBLK,
> +				   inode->i_ino, this_bh->b_blocknr);
>  	}
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


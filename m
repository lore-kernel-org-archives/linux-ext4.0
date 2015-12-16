From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: make sure to revoke all the freeable blocks in
 ext4_free_blocks
Date: Wed, 16 Dec 2015 10:44:15 +0100
Message-ID: <20151216094415.GC8968@quack.suse.cz>
References: <1450225243-9085-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbbLPJoS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Dec 2015 04:44:18 -0500
Content-Disposition: inline
In-Reply-To: <1450225243-9085-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 16-12-15 09:20:43, Daeho Jeong wrote:
> Now, ext4_free_blocks() doesn't revoke data blocks of per-file data
> journalled inode and it can cause file data inconsistency problems.
> Even though data blocks of per-file data journalled inode are already
> forgotten by jbd2_journal_invalidatepage() in advance of invoking
> ext4_free_blocks(), we still need to revoke the data blocks here.
> Moreover some of the metadata blocks, which are not found by
> sb_find_get_block(), are still needed to be revoked, but this is also
> missing here.

Thanks for looking into the issue! Just one small nit below.

> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> ---
>  fs/ext4/mballoc.c |   29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
...

> +	/*
> +	 * We need to make sure we don't reuse the freed block until
> +	 * after the transaction is committed, which we can do by
> +	 * treating the block as metadata, below.  We make an
> +	 * exception if the inode is to be written in writeback mode
> +	 * since writeback mode has weak data consistency guarantees.
> +	 */
> +	if (!ext4_should_writeback_data(inode))
> +		flags |= EXT4_FREE_BLOCKS_METADATA;
> +

I think it would be clearer what's going on if your just modified the
condition checking whether EFD entry needs to be created. Like:

-	if ((flags & EXT4_FREE_BLOCKS_METADATA) && ext4_handle_valid(handle)) {
+	/*
+	 * We need to make sure we don't reuse the freed block until after the
+	 * transaction is committed. We make an exception if the inode is to be
+	 * written in writeback mode since writeback mode has weak data
+	 * consistency guarantees.
+	 */
+	if (ext4_handle_valid(handle) &&
+	    ((flags & EXT4_FREE_BLOCKS_METADATA) ||
+	     !ext4_should_writeback_data(inode))) {
		struct ext4_free_data *new_entry;
		/*
-		 * blocks being freed are metadata. these blocks shouldn't
-		 * be used until this transaction is committed
-		 *
		 * We use __GFP_NOFAIL because ext4_free_blocks() is not
		 * allowed
		 * to fail.

Otherwise the patch looks fine so after changing this feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH 1/2] ext4: Fix assertion in ext4_add_complete_io()
Date: Tue, 15 Oct 2013 11:37:54 -0400
Message-ID: <20131015153754.GA28968@wallace>
References: <1381843949-31805-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:55196 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab3JOPiA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Oct 2013 11:38:00 -0400
Received: by mail-qc0-f175.google.com with SMTP id v2so6069813qcr.6
        for <linux-ext4@vger.kernel.org>; Tue, 15 Oct 2013 08:37:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1381843949-31805-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Jan Kara <jack@suse.cz>:
> It doesn't make sense to require io_end->handle when we are in nojournal
> mode. So update the assertion accordingly to avoid false warnings from
> ext4_add_complete_io().
> 
> Reported-by: Eric Whitney <enwlinux@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/page-io.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index d7d0c7b46ed4..d488f80ee32d 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -197,14 +197,15 @@ static void dump_completed_IO(struct inode *inode, struct list_head *head)
>  static void ext4_add_complete_io(ext4_io_end_t *io_end)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(io_end->inode);
> +	struct ext4_sb_info *sbi = EXT4_SB(io_end->inode->i_sb);
>  	struct workqueue_struct *wq;
>  	unsigned long flags;
>  
>  	/* Only reserved conversions from writeback should enter here */
>  	WARN_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
> -	WARN_ON(!io_end->handle);
> +	WARN_ON(!io_end->handle && sbi->s_journal);
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> -	wq = EXT4_SB(io_end->inode->i_sb)->rsv_conversion_wq;
> +	wq = sbi->rsv_conversion_wq;
>  	if (list_empty(&ei->i_rsv_conversion_list))
>  		queue_work(wq, &ei->i_rsv_conversion_work);
>  	list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
> -- 
> 1.8.1.4
> 
> --

I've successfully tested this patch against 3.12-rc5 - it silences the 
warning triggered by ext4/271 in xfstests-bld's dioread_nolock test config.

Thanks very much!
Eric


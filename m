From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 08/29] jbd2: Remove outdated comment
Date: Fri, 3 May 2013 22:20:07 +0800
Message-ID: <20130503142007.GB9564@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-9-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42295 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762472Ab3ECOCd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 May 2013 10:02:33 -0400
Received: by mail-pd0-f170.google.com with SMTP id 10so930544pdi.1
        for <linux-ext4@vger.kernel.org>; Fri, 03 May 2013 07:02:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-9-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:13PM +0200, Jan Kara wrote:
> The comment about credit estimates isn't true anymore. We do what the
> comment describes now.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/jbd2/transaction.c |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 81df09c..74cfbd3 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -283,16 +283,6 @@ repeat:
>  	 * reduce the free space arbitrarily.  Be careful to account for
>  	 * those buffers when checkpointing.
>  	 */
> -
> -	/*
> -	 * @@@ AKPM: This seems rather over-defensive.  We're giving commit
> -	 * a _lot_ of headroom: 1/4 of the journal plus the size of
> -	 * the committing transaction.  Really, we only need to give it
> -	 * committing_transaction->t_outstanding_credits plus "enough" for
> -	 * the log control blocks.
> -	 * Also, this test is inconsistent with the matching one in
> -	 * jbd2_journal_extend().
> -	 */
>  	if (__jbd2_log_space_left(journal) < jbd_space_needed(journal)) {
>  		jbd_debug(2, "Handle %p waiting for checkpoint...\n", handle);
>  		atomic_sub(nblocks, &transaction->t_outstanding_credits);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

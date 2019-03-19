Return-Path: <SRS0=iy/Z=RW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28842C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 08:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0283920828
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 08:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfCSIdo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Mar 2019 04:33:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:33112 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727452AbfCSIdo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Mar 2019 04:33:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EA194AFDF;
        Tue, 19 Mar 2019 08:33:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 8B6BB1E428E; Tue, 19 Mar 2019 09:33:42 +0100 (CET)
Date:   Tue, 19 Mar 2019 09:33:42 +0100
From:   Jan Kara <jack@suse.cz>
To:     Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Updated locking documentation for transaction_t
Message-ID: <20190319083342.GC17334@quack2.suse.cz>
References: <20190318184237.20677-1-alexander.lochmann@tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318184237.20677-1-alexander.lochmann@tu-dortmund.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 18-03-19 19:42:37, Alexander Lochmann wrote:
> We used LockDoc to derive locking rules for each member
> of struct transaction_t.
> Based on those results, we extended the existing documentation
> by more members of struct inode, and updated the existing
> documentation.
> 
> Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
> Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>

Thanks! You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/jbd2.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 0f919d5fe84f..72f689746340 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -534,6 +534,7 @@ struct transaction_chp_stats_s {
>   * The transaction keeps track of all of the buffers modified by a
>   * running transaction, and all of the buffers committed but not yet
>   * flushed to home for finished transactions.
> + * (Locking Documentation improved by LockDoc)
>   */
>  
>  /*
> @@ -585,7 +586,8 @@ struct transaction_s
>  	}			t_state;
>  
>  	/*
> -	 * Where in the log does this transaction's commit start? [no locking]
> +	 * Where in the log does this transaction's commit start?
> +	 * [journal_t.j_state_lock]
>  	 */
>  	unsigned long		t_log_start;
>  
> @@ -647,17 +649,17 @@ struct transaction_s
>  	unsigned long		t_max_wait;
>  
>  	/*
> -	 * When transaction started
> +	 * When transaction started [journal_t.j_state_lock]
>  	 */
>  	unsigned long		t_start;
>  
>  	/*
> -	 * When commit was requested
> +	 * When commit was requested [journal_t.j_state_lock]
>  	 */
>  	unsigned long		t_requested;
>  
>  	/*
> -	 * Checkpointing stats [j_checkpoint_sem]
> +	 * Checkpointing stats [journal_t.j_list_lock]
>  	 */
>  	struct transaction_chp_stats_s t_chp_stats;
>  
> -- 
> 2.20.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

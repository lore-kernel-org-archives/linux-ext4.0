Return-Path: <SRS0=9ApQ=RO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49A2C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Mar 2019 16:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 824C02084F
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Mar 2019 16:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfCKQP2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Mar 2019 12:15:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:50690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726625AbfCKQP2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Mar 2019 12:15:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2F065AE03;
        Mon, 11 Mar 2019 16:15:27 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id C93871E426A; Mon, 11 Mar 2019 17:15:25 +0100 (CET)
Date:   Mon, 11 Mar 2019 17:15:25 +0100
From:   Jan Kara <jack@suse.cz>
To:     Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc:     tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
Subject: Re: [PATCH 1/1] Updated locking documentation for struct journal_t
Message-ID: <20190311161525.GN11553@quack2.suse.cz>
References: <20190308150605.98405-1-alexander.lochmann@tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308150605.98405-1-alexander.lochmann@tu-dortmund.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 08-03-19 16:06:05, Alexander Lochmann wrote:
> We used LockDoc to derive locking rules for each member
> of struct journal_t. Based on those results, we extended
> the existing documentation by more members
> of struct inode, and updated the existing documentation.
> 
> Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
> Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
> ---
>  include/linux/jbd2.h | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)

Thanks for the patch! Some comments below.

> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 0f919d5fe84f..c1ba44ca515a 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -585,7 +585,8 @@ struct transaction_s
>  	}			t_state;
>  
>  	/*
> -	 * Where in the log does this transaction's commit start? [no locking]
> +	 * Where in the log does this transaction's commit start?
> +	 * [journal_t->j_state_lock]
>  	 */
>  	unsigned long		t_log_start;
>  
> @@ -647,17 +648,17 @@ struct transaction_s
>  	unsigned long		t_max_wait;
>  
>  	/*
> -	 * When transaction started
> +	 * When transaction started [j_state_lock]
>  	 */
>  	unsigned long		t_start;
>  
>  	/*
> -	 * When commit was requested
> +	 * When commit was requested [j_state_lock]
>  	 */
>  	unsigned long		t_requested;
>  
>  	/*
> -	 * Checkpointing stats [j_checkpoint_sem]
> +	 * Checkpointing stats [j_list_lock]
>  	 */
>  	struct transaction_chp_stats_s t_chp_stats;
>  

These look correct to me.

> @@ -762,6 +764,7 @@ struct journal_s
>  
>  	/**
>  	 * @j_sb_buffer: The first part of the superblock buffer.
> +	 * [j_checkpoint_mutex]
>  	 */
>  	struct buffer_head	*j_sb_buffer;

This isn't true. j_sb_buffer is just initialized in journal_init_common()
and never changed. So there's no lock protecting it.


> @@ -1015,6 +1018,7 @@ struct journal_s
>  	 * @j_commit_interval:
>  	 *
>  	 * What is the maximum transaction lifetime before we begin a commit?
> +	 * [super_block->s_umount]
>  	 */
>  	unsigned long		j_commit_interval;

Ditto here.

> @@ -1032,7 +1036,7 @@ struct journal_s
>  	 * @j_revoke:
>  	 *
>  	 * The revoke table - maintains the list of revoked blocks in the
> -	 * current transaction.
> +	 * current transaction. [j_state_lock]
>  	 */
>  	struct jbd2_revoke_table_s *j_revoke;
>  

This is also not true. The contents of the revoke table itself is protected
by j_revoke_lock. The pointer to current revoke table (i.e. j_revoke
itself) is changed only when the currently running transation is in
T_SWITCH state - a special state where no updates can be happening anymore
and new transaction cannot be running yet either.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

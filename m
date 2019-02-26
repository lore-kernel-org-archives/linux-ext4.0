Return-Path: <SRS0=4ybF=RB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AFCC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 16:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F36A2184D
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Feb 2019 16:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfBZQfG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Feb 2019 11:35:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:34060 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727108AbfBZQfG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 26 Feb 2019 11:35:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0DB3AAAE;
        Tue, 26 Feb 2019 16:35:04 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1F5771E4255; Tue, 26 Feb 2019 17:35:04 +0100 (CET)
Date:   Tue, 26 Feb 2019 17:35:04 +0100
From:   Jan Kara <jack@suse.cz>
To:     Liu Song <fishland@aliyun.com>
Cc:     tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, liu.song11@zte.com.cn
Subject: Re: [PATCH] jbd2: jbd2_get_transaction does not need to return a
 value
Message-ID: <20190226163504.GA24711@quack2.suse.cz>
References: <20190226160728.38587-1-fishland@aliyun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226160728.38587-1-fishland@aliyun.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 27-02-19 00:07:27, Liu Song wrote:
> In jbd2_get_transaction, a new transaction is initialized,
> and set to the j_running_transaction. No need for a return
> value, so remove it.
> Also, adjust some comments to match the actual operation
> of this function.
> 
> Signed-off-by: Liu Song <liu.song11@zte.com.cn>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/transaction.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index cc35537232f2..79a028a7a579 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -63,7 +63,7 @@ void jbd2_journal_free_transaction(transaction_t *transaction)
>  /*
>   * jbd2_get_transaction: obtain a new transaction_t object.
>   *
> - * Simply allocate and initialise a new transaction.  Create it in
> + * Simply initialise a new transaction. Initialize it in
>   * RUNNING state and add it to the current journal (which should not
>   * have an existing running transaction: we only make a new transaction
>   * once we have started to commit the old one).
> @@ -75,8 +75,8 @@ void jbd2_journal_free_transaction(transaction_t *transaction)
>   *
>   */
>  
> -static transaction_t *
> -jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
> +static void jbd2_get_transaction(journal_t *journal,
> +				transaction_t *transaction)
>  {
>  	transaction->t_journal = journal;
>  	transaction->t_state = T_RUNNING;
> @@ -100,8 +100,6 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
>  	transaction->t_max_wait = 0;
>  	transaction->t_start = jiffies;
>  	transaction->t_requested = 0;
> -
> -	return transaction;
>  }
>  
>  /*
> -- 
> 2.19.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

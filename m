Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B16CC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 19 Mar 2021 10:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D85264F6C
	for <linux-ext4@archiver.kernel.org>; Fri, 19 Mar 2021 10:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCSK30 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 19 Mar 2021 06:29:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:59192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhCSK25 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 Mar 2021 06:28:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BCE90AE05;
        Fri, 19 Mar 2021 10:28:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4BE8F1F2B5B; Fri, 19 Mar 2021 11:28:55 +0100 (CET)
Date:   Fri, 19 Mar 2021 11:28:55 +0100
From:   Jan Kara <jack@suse.cz>
To:     menglong8.dong@gmail.com
Cc:     jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu xuzhi <liu.xuzhi@zte.com.cn>
Subject: Re: [PATCH] fs/ext2/: fix misspellings using codespell tool
Message-ID: <20210319102855.GB4910@quack2.suse.cz>
References: <20210319003131.484738-1-liu.xuzhi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319003131.484738-1-liu.xuzhi@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 18-03-21 17:31:31, menglong8.dong@gmail.com wrote:
> From: Liu xuzhi <liu.xuzhi@zte.com.cn>
> 
> A typo is found out by codespell tool in 1107th lines of super.c:
> 
> $ codespell ./fs/ext2/
> ./super.c:1107: fileystem  ==> filesystem
> 
> Fix a typo found by codespell.
> 
> Signed-off-by: Liu xuzhi <liu.xuzhi@zte.com.cn>

Thanks. I've merged the patch to my tree.

								Honza

> ---
>  fs/ext2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 6c4753277916..d2fd9707e953 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1104,7 +1104,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
>  	spin_lock_init(&sbi->s_next_gen_lock);
>  
> -	/* per fileystem reservation list head & lock */
> +	/* per filesystem reservation list head & lock */
>  	spin_lock_init(&sbi->s_rsv_window_lock);
>  	sbi->s_rsv_window_root = RB_ROOT;
>  	/*
> -- 
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

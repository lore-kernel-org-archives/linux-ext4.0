Return-Path: <SRS0=Z8NG=R6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6833FC4360F
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 16:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F47520651
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 16:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfC0QZk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:25:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:48356 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726803AbfC0QZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 27 Mar 2019 12:25:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8368CADBD;
        Wed, 27 Mar 2019 16:25:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3085A1E1589; Wed, 27 Mar 2019 17:25:35 +0100 (CET)
Date:   Wed, 27 Mar 2019 17:25:35 +0100
From:   Jan Kara <jack@suse.cz>
To:     Liu Song <fishland@aliyun.com>
Cc:     tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, liu.song11@zte.com.cn
Subject: Re: [PATCH] jbd2: remove repeated assignments in
 __jbd2_log_wait_for_space
Message-ID: <20190327162535.GA6742@quack2.suse.cz>
References: <20190327143135.2784-1-fishland@aliyun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327143135.2784-1-fishland@aliyun.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 27-03-19 22:31:35, Liu Song wrote:
> From: Liu Song <liu.song11@zte.com.cn>
> 
> At the beginning, nblocks has been assigned. There is no need
> to repeat the assignment in the while loop, and remove it.
> 
> Signed-off-by: Liu Song <liu.song11@zte.com.cn>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/checkpoint.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 26f8d7e46462..23053de5e999 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -132,7 +132,6 @@ void __jbd2_log_wait_for_space(journal_t *journal)
>  			return;
>  		}
>  		spin_lock(&journal->j_list_lock);
> -		nblocks = jbd2_space_needed(journal);
>  		space_left = jbd2_log_space_left(journal);
>  		if (space_left < nblocks) {
>  			int chkpt = journal->j_checkpoint_transactions != NULL;
> -- 
> 2.19.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

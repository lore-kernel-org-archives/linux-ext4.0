Return-Path: <SRS0=1XWU=Z2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B97C43603
	for <linux-ext4@archiver.kernel.org>; Wed,  4 Dec 2019 17:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B228E205ED
	for <linux-ext4@archiver.kernel.org>; Wed,  4 Dec 2019 17:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfLDRFc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:05:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:37564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728784AbfLDRFc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 4 Dec 2019 12:05:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BEB85B1F7;
        Wed,  4 Dec 2019 17:05:30 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 012471E0B99; Wed,  4 Dec 2019 18:05:28 +0100 (CET)
Date:   Wed, 4 Dec 2019 18:05:28 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, liangyun2@huawei.com,
        luoshijie1@huawei.com
Subject: Re: [PATCH v3 3/4] jbd2: make sure ESHUTDOWN to be recorded in the
 journal superblock
Message-ID: <20191204170528.GH8206@quack2.suse.cz>
References: <20191204124614.45424-1-yi.zhang@huawei.com>
 <20191204124614.45424-4-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204124614.45424-4-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 04-12-19 20:46:13, zhangyi (F) wrote:
> Commit fb7c02445c49 ("ext4: pass -ESHUTDOWN code to jbd2 layer") want
> to allow jbd2 layer to distinguish shutdown journal abort from other
> error cases. So the ESHUTDOWN should be taken precedence over any other
> errno which has already been recoded after EXT4_FLAGS_SHUTDOWN is set,
> but it only update errno in the journal suoerblock now if the old errno
> is 0.
> 
> Fixes: fb7c02445c49 ("ext4: pass -ESHUTDOWN code to jbd2 layer")
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Yeah, I think this is correct if I understand the logic correctly but I'd
like Ted to have a look at this. Anyway, feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/journal.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index b2d6e7666d0f..93be6e0311da 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2109,8 +2109,7 @@ static void __journal_abort_soft (journal_t *journal, int errno)
>  
>  	if (journal->j_flags & JBD2_ABORT) {
>  		write_unlock(&journal->j_state_lock);
> -		if (!old_errno && old_errno != -ESHUTDOWN &&
> -		    errno == -ESHUTDOWN)
> +		if (old_errno != -ESHUTDOWN && errno == -ESHUTDOWN)
>  			jbd2_journal_update_sb_errno(journal);
>  		return;
>  	}
> -- 
> 2.17.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

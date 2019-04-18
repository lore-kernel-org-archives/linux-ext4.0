Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F84C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 11:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F05842183E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 11:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388756AbfDRLxa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:53:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:46218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727807AbfDRLxa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 07:53:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 65D40AEBC;
        Thu, 18 Apr 2019 11:53:29 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B2B091E15AE; Thu, 18 Apr 2019 13:53:26 +0200 (CEST)
Date:   Thu, 18 Apr 2019 13:53:26 +0200
From:   Jan Kara <jack@suse.cz>
To:     Khazhismel Kumykov <khazhy@google.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: add cond_resched() to ext4_mb_init_backend()
Message-ID: <20190418115326.GE28541@quack2.suse.cz>
References: <20190416025934.115252-1-khazhy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416025934.115252-1-khazhy@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 15-04-19 19:59:34, Khazhismel Kumykov wrote:
> on non-preempt kernels for filesystems with large number of groups we
> may take a long time (>50 ticks) initializing all the groups.
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>

Thanks for the patch. I'm not opposed to this but I'm just wondering: Has
this caused any real issues to you? Or how have you come across this
particular loop? Because I'd think we have more similar loops in ext4
codebase...

								Honza

> ---
>  fs/ext4/mballoc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8ef5f12bbee2..c89f497ccf50 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2490,6 +2490,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
>  	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
>  	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
>  	for (i = 0; i < ngroups; i++) {
> +		cond_resched();
>  		desc = ext4_get_group_desc(sb, i, NULL);
>  		if (desc == NULL) {
>  			ext4_msg(sb, KERN_ERR, "can't read descriptor %u", i);
> -- 
> 2.21.0.392.gf8f6787159e-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

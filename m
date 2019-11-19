Return-Path: <SRS0=YMbR=ZL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E880C432C3
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Nov 2019 16:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BBBF22360
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Nov 2019 16:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfKSQFE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Nov 2019 11:05:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:47304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727509AbfKSQFE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Nov 2019 11:05:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5DEF0BAAE;
        Tue, 19 Nov 2019 16:05:02 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D19E11E47E5; Tue, 19 Nov 2019 17:05:01 +0100 (CET)
Date:   Tue, 19 Nov 2019 17:05:01 +0100
From:   Jan Kara <jack@suse.cz>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: code cleanup for descriptor_loc()
Message-ID: <20191119160501.GB2440@quack2.suse.cz>
References: <20191115224900.2613-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115224900.2613-1-cgxu519@mykernel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat 16-11-19 06:49:00, Chengguang Xu wrote:
> Code cleanup by removing unnecessary variable
> in descriptor_loc().
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

Thanks! I've added the patch to my tree.

								Honza

> ---
>  fs/ext2/super.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 30c630d73f0f..bef607d5db28 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -806,7 +806,6 @@ static unsigned long descriptor_loc(struct super_block *sb,
>  {
>  	struct ext2_sb_info *sbi = EXT2_SB(sb);
>  	unsigned long bg, first_meta_bg;
> -	int has_super = 0;
>  	
>  	first_meta_bg = le32_to_cpu(sbi->s_es->s_first_meta_bg);
>  
> @@ -814,10 +813,8 @@ static unsigned long descriptor_loc(struct super_block *sb,
>  	    nr < first_meta_bg)
>  		return (logic_sb_block + nr + 1);
>  	bg = sbi->s_desc_per_block * nr;
> -	if (ext2_bg_has_super(sb, bg))
> -		has_super = 1;
>  
> -	return ext2_group_first_block_no(sb, bg) + has_super;
> +	return ext2_group_first_block_no(sb, bg) + ext2_bg_has_super(sb, bg);
>  }
>  
>  static int ext2_fill_super(struct super_block *sb, void *data, int silent)
> -- 
> 2.21.0
> 
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

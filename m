Return-Path: <SRS0=F8b5=2I=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876D0C43603
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Dec 2019 08:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 629AB21D7D
	for <linux-ext4@archiver.kernel.org>; Wed, 18 Dec 2019 08:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfLRIiv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 18 Dec 2019 03:38:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:37882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbfLRIiv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 18 Dec 2019 03:38:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7038CAC52;
        Wed, 18 Dec 2019 08:38:49 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 066621E0B2D; Wed, 18 Dec 2019 09:38:39 +0100 (CET)
Date:   Wed, 18 Dec 2019 09:38:39 +0100
From:   Jan Kara <jack@suse.cz>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2] ext2: Adjust indentation in ext2_fill_super
Message-ID: <20191218083838.GB4083@quack2.suse.cz>
References: <20191218031519.15450-1-natechancellor@gmail.com>
 <20191218031930.31393-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218031930.31393-1-natechancellor@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 17-12-19 20:19:31, Nathan Chancellor wrote:
> Clang warns:
> 
> ../fs/ext2/super.c:1076:3: warning: misleading indentation; statement is
> not part of the previous 'if' [-Wmisleading-indentation]
>         sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
>         ^
> ../fs/ext2/super.c:1074:2: note: previous statement is here
>         if (EXT2_BLOCKS_PER_GROUP(sb) == 0)
>         ^
> 1 warning generated.
> 
> This warning occurs because there is a space before the tab on this
> line. Remove it so that the indentation is consistent with the Linux
> kernel coding style and clang no longer warns.
> 
> Fixes: 41f04d852e35 ("[PATCH] ext2: fix mounts at 16T")
> Link: https://github.com/ClangBuiltLinux/linux/issues/827
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Thanks! I've added the patch to my tree.

								Honza

> ---
> 
> v1 -> v2:
> 
> * Adjust link to point to the right issue.
> 
>  fs/ext2/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 8643f98e9578..4a4ab683250d 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1073,9 +1073,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	if (EXT2_BLOCKS_PER_GROUP(sb) == 0)
>  		goto cantfind_ext2;
> - 	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
> - 				le32_to_cpu(es->s_first_data_block) - 1)
> - 					/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;
> +	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
> +				le32_to_cpu(es->s_first_data_block) - 1)
> +					/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;
>  	db_count = (sbi->s_groups_count + EXT2_DESC_PER_BLOCK(sb) - 1) /
>  		   EXT2_DESC_PER_BLOCK(sb);
>  	sbi->s_group_desc = kmalloc_array (db_count,
> -- 
> 2.24.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C526C282C8
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 14:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76E2720844
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 14:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfA1Ov3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:51:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:57436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726682AbfA1Ov3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 09:51:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 582BDAEF3;
        Mon, 28 Jan 2019 14:51:28 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 287791E3FEF; Mon, 28 Jan 2019 15:51:28 +0100 (CET)
Date:   Mon, 28 Jan 2019 15:51:28 +0100
From:   Jan Kara <jack@suse.cz>
To:     Liu Xiang <liu.xiang6@zte.com.cn>
Cc:     jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuxiang_1999@126.com
Subject: Re: [PATCH] ext2: Remove redundant check for finding no group
Message-ID: <20190128145128.GB5858@quack2.suse.cz>
References: <1548424896-4692-1-git-send-email-liu.xiang6@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548424896-4692-1-git-send-email-liu.xiang6@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 25-01-19 22:01:36, Liu Xiang wrote:
> When best_desc keeps NULL, best_group keeps -1, too. So we can
> return best_group directly.
> 
> Signed-off-by: Liu Xiang <liu.xiang6@zte.com.cn>

Thanks for the patch! I've added it to my tree.

								Honza

> ---
>  fs/ext2/ialloc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
> index 5c3d7b7..a0c5ea9 100644
> --- a/fs/ext2/ialloc.c
> +++ b/fs/ext2/ialloc.c
> @@ -222,8 +222,6 @@ static int find_group_dir(struct super_block *sb, struct inode *parent)
>  			best_desc = desc;
>  		}
>  	}
> -	if (!best_desc)
> -		return -1;
>  
>  	return best_group;
>  }
> -- 
> 1.9.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

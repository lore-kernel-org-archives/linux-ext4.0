Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3585CC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 11:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FF3B2084F
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 11:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbfCRLIY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 07:08:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:46170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfCRLIY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Mar 2019 07:08:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6D59DAE25;
        Mon, 18 Mar 2019 11:08:23 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id C203F1E425D; Mon, 18 Mar 2019 12:08:22 +0100 (CET)
Date:   Mon, 18 Mar 2019 12:08:22 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH v2 1/2] ext4: brelse all indirect buffer in
 ext4_ind_remove_space()
Message-ID: <20190318110822.GE9415@quack2.suse.cz>
References: <1552633813-42832-1-git-send-email-yi.zhang@huawei.com>
 <1552633813-42832-2-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552633813-42832-2-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 15-03-19 15:10:12, zhangyi (F) wrote:
> All indirect buffers get by ext4_find_shared() should be released no
> mater the branch should be freed or not. But now, we forget to release
> the lower depth indirect buffers when removing space from the same
> higher depth indirect block. It will lead to buffer leak and futher
> more, it may lead to quota information corruption when using old quota,
> consider the following case.
> 
>  - Create and mount an empty ext4 filesystem without extent and quota
>    features,
>  - quotacheck and enable the user & group quota,
>  - Create some files and write some data to them, and then punch hole
>    to some files of them, it may trigger the buffer leak problem
>    mentioned above.
>  - Disable quota and run quotacheck again, it will create two new
>    aquota files and write the checked quota information to them, which
>    probably may reuse the freed indirect block(the buffer and page
>    cache was not freed) as data block.
>  - Enable quota again, it will invoke
>    vfs_load_quota_inode()->invalidate_bdev() to try to clean unused
>    buffers and pagecache. Unfortunately, because of the buffer of quota
>    data block is still referenced, quota code cannot read the up to date
>    quota info from the device and lead to quota information corruption.
> 
> This problem can be reproduced by xfstests generic/231 on ext3 file
> system or ext4 file system without extent and quota features.
> 
> This patch fix this problem by brelse the missing indirect buffers, in
> ext4_ind_remove_space().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: <stable@vger.kernel.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/indirect.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index bf7fa15..9e96a0b 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -1387,10 +1387,14 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
>  					   partial->p + 1,
>  					   partial2->p,
>  					   (chain+n-1) - partial);
> -			BUFFER_TRACE(partial->bh, "call brelse");
> -			brelse(partial->bh);
> -			BUFFER_TRACE(partial2->bh, "call brelse");
> -			brelse(partial2->bh);
> +			while (partial > chain) {
> +				BUFFER_TRACE(partial->bh, "call brelse");
> +				brelse(partial->bh);
> +			}
> +			while (partial2 > chain2) {
> +				BUFFER_TRACE(partial2->bh, "call brelse");
> +				brelse(partial2->bh);
> +			}
>  			return 0;
>  		}
>  
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

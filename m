Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA96CC169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 15:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C222720882
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 15:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfA2PoT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 10:44:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:48004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbfA2PoT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Jan 2019 10:44:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06DADAD47;
        Tue, 29 Jan 2019 15:44:17 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B34B01E3FFD; Tue, 29 Jan 2019 16:44:15 +0100 (CET)
Date:   Tue, 29 Jan 2019 16:44:15 +0100
From:   Jan Kara <jack@suse.cz>
To:     Liu Xiang <liu.xiang6@zte.com.cn>
Cc:     jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuxiang_1999@126.com
Subject: Re: [PATCH] ext2: Fix a typo in comment
Message-ID: <20190129154415.GE29981@quack2.suse.cz>
References: <1548765589-2920-1-git-send-email-liu.xiang6@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548765589-2920-1-git-send-email-liu.xiang6@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 29-01-19 20:39:49, Liu Xiang wrote:
> Fix a typo in ext2_get_blocks comment.
> 
> Signed-off-by: Liu Xiang <liu.xiang6@zte.com.cn>

Thanks for the patch! Applied to my tree.

								Honza

> ---
>  fs/ext2/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index e4bb938..11da3fb 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -717,7 +717,7 @@ static int ext2_get_blocks(struct inode *inode,
>  	/* the number of blocks need to allocate for [d,t]indirect blocks */
>  	indirect_blks = (chain + depth) - partial - 1;
>  	/*
> -	 * Next look up the indirect map to count the totoal number of
> +	 * Next look up the indirect map to count the total number of
>  	 * direct blocks to allocate for this branch.
>  	 */
>  	count = ext2_blks_to_allocate(partial, indirect_blks,
> -- 
> 1.9.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

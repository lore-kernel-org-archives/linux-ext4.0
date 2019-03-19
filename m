Return-Path: <SRS0=iy/Z=RW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666A8C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 10:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 304FE20989
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 10:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfCSKsx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:48:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:39746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726464AbfCSKsx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Mar 2019 06:48:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A2B65AD36;
        Tue, 19 Mar 2019 10:48:52 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 448AE1E429B; Tue, 19 Mar 2019 11:48:52 +0100 (CET)
Date:   Tue, 19 Mar 2019 11:48:52 +0100
From:   Jan Kara <jack@suse.cz>
To:     Shuning Zhang <sunny.s.zhang@oracle.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: Adjust the comment of function ext2_alloc_branch
Message-ID: <20190319104852.GB20138@quack2.suse.cz>
References: <1551836855-10316-1-git-send-email-sunny.s.zhang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551836855-10316-1-git-send-email-sunny.s.zhang@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 06-03-19 09:47:35, Shuning Zhang wrote:
> The name of argument is error in the header comment.
> @num should be @indirect_blks.
> At the same time, there was a lack of description of the two parameters
> @blks and @goal.
> This commit therefore fixes this header comment.
> 
> Signed-off-by: Shuning Zhang <sunny.s.zhang@oracle.com>

Thanks. I've added the patch to my tree.

								Honza

> ---
>  fs/ext2/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index e4bb938..3f404c3 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -451,7 +451,9 @@ static int ext2_alloc_blocks(struct inode *inode,
>  /**
>   *	ext2_alloc_branch - allocate and set up a chain of blocks.
>   *	@inode: owner
> - *	@num: depth of the chain (number of blocks to allocate)
> + *	@indirect_blks: depth of the chain (number of blocks to allocate)
> + *	@blks: number of allocated direct blocks
> + *	@goal: preferred place for allocation
>   *	@offsets: offsets (in the blocks) to store the pointers to next.
>   *	@branch: place to store the chain in.
>   *
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

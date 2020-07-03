Return-Path: <SRS0=fc1z=AO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47259C433E0
	for <linux-ext4@archiver.kernel.org>; Fri,  3 Jul 2020 10:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AFBF206BE
	for <linux-ext4@archiver.kernel.org>; Fri,  3 Jul 2020 10:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgGCKU1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 3 Jul 2020 06:20:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:58210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgGCKUY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 3 Jul 2020 06:20:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A68EAB8D2;
        Fri,  3 Jul 2020 10:20:21 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 085591E12EB; Fri,  3 Jul 2020 12:20:19 +0200 (CEST)
Date:   Fri, 3 Jul 2020 12:20:19 +0200
From:   Jan Kara <jack@suse.cz>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     jack@suse.cz, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: delete incorrect comment for
 ext2_blks_to_allocate()
Message-ID: <20200703102019.GC4355@quack2.suse.cz>
References: <20200702095636.29246-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702095636.29246-1-cgxu519@mykernel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 02-07-20 17:56:36, Chengguang Xu wrote:
> ext2_blks_to_allocate() only counts direct blocks need to be allocated,
> return value does not include indirect blocks.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/ext2/inode.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index c8b371c82b4f..4df849e694dd 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -355,9 +355,6 @@ static inline ext2_fsblk_t ext2_find_goal(struct inode *inode, long block,
>   *	@k: number of blocks need for indirect blocks
>   *	@blks: number of data blocks to be mapped.
>   *	@blocks_to_boundary:  the offset in the indirect block
> - *
> - *	return the total number of blocks to be allocate, including the
> - *	direct and indirect blocks.

You're right the comment is wrong but instead of deleting it, I'd rather
fix it like: "Return the number of direct blocks to allocate."

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

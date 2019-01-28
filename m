Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15020C282C8
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 14:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D951A20844
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 14:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfA1OvH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:51:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:57378 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726647AbfA1OvG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 09:51:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8B3DFAEF3;
        Mon, 28 Jan 2019 14:51:05 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3FA621E3FEF; Mon, 28 Jan 2019 15:51:05 +0100 (CET)
Date:   Mon, 28 Jan 2019 15:51:05 +0100
From:   Jan Kara <jack@suse.cz>
To:     Mathieu Malaterre <malat@debian.org>
Cc:     Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: Annotate implicit fall through in
 __ext2_truncate_blocks
Message-ID: <20190128145105.GA5858@quack2.suse.cz>
References: <20190124180504.19912-1-malat@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124180504.19912-1-malat@debian.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 24-01-19 19:05:04, Mathieu Malaterre wrote:
> There is a plan to build the kernel with -Wimplicit-fallthrough and
> these places in the code produced warnings (W=1).
> 
> This commit removes the following warnings:
> 
>   fs/ext2/inode.c:1237:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
>   fs/ext2/inode.c:1244:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
> 
> Signed-off-by: Mathieu Malaterre <malat@debian.org>

Thanks for the patch! I've added it to my tree.

								Honza

> ---
>  fs/ext2/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index e4bb9386c045..e64029b1bd50 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1239,6 +1239,7 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
>  				mark_inode_dirty(inode);
>  				ext2_free_branches(inode, &nr, &nr+1, 1);
>  			}
> +			/* fall through */
>  		case EXT2_IND_BLOCK:
>  			nr = i_data[EXT2_DIND_BLOCK];
>  			if (nr) {
> @@ -1246,6 +1247,7 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
>  				mark_inode_dirty(inode);
>  				ext2_free_branches(inode, &nr, &nr+1, 2);
>  			}
> +			/* fall through */
>  		case EXT2_DIND_BLOCK:
>  			nr = i_data[EXT2_TIND_BLOCK];
>  			if (nr) {
> -- 
> 2.19.2
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

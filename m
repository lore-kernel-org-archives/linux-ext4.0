Return-Path: <SRS0=Pl0f=DB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FAAC4363D
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Sep 2020 14:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F65D20B1F
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Sep 2020 14:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgIXOAk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Sep 2020 10:00:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:45888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgIXOAk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Sep 2020 10:00:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 77003B12A;
        Thu, 24 Sep 2020 14:00:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 32A6A1E12ED; Thu, 24 Sep 2020 10:06:13 +0200 (CEST)
Date:   Thu, 24 Sep 2020 10:06:13 +0200
From:   Jan Kara <jack@suse.cz>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     yi.zhang@huawei.com, tytso@mit.edu, jack@suse.cz,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH] ext4: Fix bdev write error check failed when mount fs
 with ro
Message-ID: <20200924080613.GC27019@quack2.suse.cz>
References: <20200924011149.1624846-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924011149.1624846-1-zhangxiaoxu5@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 23-09-20 21:11:49, Zhang Xiaoxu wrote:
> If some errors has occurred on the device, and the orphan list not empty,
> then mount the device with 'ro', the bdev write error check will failed:
>   ext4_check_bdev_write_error:193: comm mount: Error while async write back metadata
> 
> Since the sbi->s_bdev_wb_err wouldn't be initialized when mount file system
> with 'ro', when clean up the orphan list and access the iloc buffer, bdev
> write error check will failed.
> 
> So we should always initialize the sbi->s_bdev_wb_err even if mount the
> file system with 'ro'.
> 
> Fixes: bc71726c7257 ("ext4: abort the filesystem if failed to async write metadata buffer")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

Thanks for the patch! Good catch! I just think you should now remove the
errseq_check_and_advance() call in ext4_remount() because it isn't needed
anymore.

								Honza


> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ea425b49b345..086439889869 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4814,9 +4814,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	 * used to detect the metadata async write error.
>  	 */
>  	spin_lock_init(&sbi->s_bdev_wb_lock);
> -	if (!sb_rdonly(sb))
> -		errseq_check_and_advance(&sb->s_bdev->bd_inode->i_mapping->wb_err,
> -					 &sbi->s_bdev_wb_err);
> +	errseq_check_and_advance(&sb->s_bdev->bd_inode->i_mapping->wb_err,
> +				 &sbi->s_bdev_wb_err);
>  	sb->s_bdev->bd_super = sb;
>  	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
>  	ext4_orphan_cleanup(sb, es);
> -- 
> 2.25.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

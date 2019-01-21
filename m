Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E5CC2F421
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 15:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9225420823
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 15:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfAUP4W (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 10:56:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:37850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728761AbfAUP4W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Jan 2019 10:56:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CFFE3AC3B;
        Mon, 21 Jan 2019 15:56:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E4E1F1E1584; Mon, 21 Jan 2019 16:56:19 +0100 (CET)
Date:   Mon, 21 Jan 2019 16:56:19 +0100
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH v2 1/2] ext4: use i_size_read() when converting
 initialized extent
Message-ID: <20190121155619.GC21694@quack2.suse.cz>
References: <1545141822-3082-1-git-send-email-yi.zhang@huawei.com>
 <1545141822-3082-2-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545141822-3082-2-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 18-12-18 22:03:41, zhangyi (F) wrote:
> Use i_size_read() in ext4_ext_convert_to_initialized() and
> ext4_split_convert_extents() because we haven't taken inode->i_rwsem
> in these two functions.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 240b6de..0307fc6 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3483,7 +3483,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>  		(unsigned long long)map->m_lblk, map_len);
>  
>  	sbi = EXT4_SB(inode->i_sb);
> -	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
> +	eof_block = (i_size_read(inode) + inode->i_sb->s_blocksize - 1) >>
>  		inode->i_sb->s_blocksize_bits;
>  	if (eof_block < map->m_lblk + map_len)
>  		eof_block = map->m_lblk + map_len;
> @@ -3739,7 +3739,7 @@ static int ext4_split_convert_extents(handle_t *handle,
>  		  __func__, inode->i_ino,
>  		  (unsigned long long)map->m_lblk, map->m_len);
>  
> -	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
> +	eof_block = (i_size_read(inode) + inode->i_sb->s_blocksize - 1) >>
>  		inode->i_sb->s_blocksize_bits;
>  	if (eof_block < map->m_lblk + map->m_len)
>  		eof_block = map->m_lblk + map->m_len;
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

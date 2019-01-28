Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7740FC282CD
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 14:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 518AF2082E
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 14:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfA1Osv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:48:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:57096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726266AbfA1Osu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 28 Jan 2019 09:48:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9D61AAE5D;
        Mon, 28 Jan 2019 14:48:49 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 71D281E3FEF; Mon, 28 Jan 2019 15:48:47 +0100 (CET)
Date:   Mon, 28 Jan 2019 15:48:47 +0100
From:   Jan Kara <jack@suse.cz>
To:     Liu Xiang <liu.xiang6@zte.com.cn>
Cc:     jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, liuxiang_1999@126.com
Subject: Re: [PATCH] ext2: Remove useless reset code
Message-ID: <20190128144847.GG27972@quack2.suse.cz>
References: <1548424864-4647-1-git-send-email-liu.xiang6@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548424864-4647-1-git-send-email-liu.xiang6@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 25-01-19 22:01:04, Liu Xiang wrote:
> If ((char *)de == dir_end) is true, the name_len will not be used
> in the subsequent routine. So the reset code can be removed.
> 
> Signed-off-by: Liu Xiang <liu.xiang6@zte.com.cn>

Thanks for the patch. I agree with your analysis but I prefer to keep the
code as is - it prevents warnings about uninitialized variable being used
for compilers than cannot infer that and also for humans reading the code
is easier this way.

								Honza

> ---
>  fs/ext2/dir.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index 3b8114d..5ec497f 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -517,7 +517,6 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
>  		while ((char *)de <= kaddr) {
>  			if ((char *)de == dir_end) {
>  				/* We hit i_size */
> -				name_len = 0;
>  				rec_len = chunk_size;
>  				de->rec_len = ext2_rec_len_to_disk(chunk_size);
>  				de->inode = 0;
> -- 
> 1.9.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

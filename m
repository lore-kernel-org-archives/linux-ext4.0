Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78866C2F3D5
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 14:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 532AA20861
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 14:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbfAUORi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 09:17:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:45412 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729377AbfAUORi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Jan 2019 09:17:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 98D9BAE06;
        Mon, 21 Jan 2019 14:17:36 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B54B21E1584; Mon, 21 Jan 2019 15:17:35 +0100 (CET)
Date:   Mon, 21 Jan 2019 15:17:35 +0100
From:   Jan Kara <jack@suse.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix some error pointer dereferences
Message-ID: <20190121141735.GA21694@quack2.suse.cz>
References: <20190103113811.GA13543@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103113811.GA13543@kadam>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 03-01-19 14:38:11, Dan Carpenter wrote:
> We can't pass error pointers to brelse().
> 
> Fixes: fb265c9cb49e ("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks for catching this. The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/xattr.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 7fddd519adae..6ddbbe21fdd8 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -829,6 +829,7 @@ int ext4_get_inode_usage(struct inode *inode, qsize_t *usage)
>  		bh = ext4_sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl, REQ_PRIO);
>  		if (IS_ERR(bh)) {
>  			ret = PTR_ERR(bh);
> +			bh = NULL;
>  			goto out;
>  		}
>  
> @@ -2903,6 +2904,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>  			if (error == -EIO)
>  				EXT4_ERROR_INODE(inode, "block %llu read error",
>  						 EXT4_I(inode)->i_file_acl);
> +			bh = NULL;
>  			goto cleanup;
>  		}
>  		error = ext4_xattr_check_block(inode, bh);
> @@ -3059,6 +3061,7 @@ ext4_xattr_block_cache_find(struct inode *inode,
>  		if (IS_ERR(bh)) {
>  			if (PTR_ERR(bh) == -ENOMEM)
>  				return NULL;
> +			bh = NULL;
>  			EXT4_ERROR_INODE(inode, "block %lu read error",
>  					 (unsigned long)ce->e_value);
>  		} else if (ext4_xattr_cmp(header, BHDR(bh)) == 0) {
> -- 
> 2.17.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

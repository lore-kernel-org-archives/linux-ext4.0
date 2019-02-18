Return-Path: <SRS0=geXL=QZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2027AC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 14:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF51E2177E
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 14:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392014AbfBROQM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:16:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:53950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391798AbfBROQH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Feb 2019 09:16:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36AADB024;
        Mon, 18 Feb 2019 14:16:05 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B7A431E088D; Mon, 18 Feb 2019 15:16:04 +0100 (CET)
Date:   Mon, 18 Feb 2019 15:16:04 +0100
From:   Jan Kara <jack@suse.cz>
To:     yangerkun <yangerkun@huawei.com>
Cc:     jack@suse.com, yi.zhang@huawei.com, houtao1@huawei.com,
        miaoxie@huawei.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: support statx syscall
Message-ID: <20190218141604.GD20919@quack2.suse.cz>
References: <20190218010702.101058-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218010702.101058-1-yangerkun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 18-02-19 09:07:02, yangerkun wrote:
> Since statx, every filesystem should fill the attributes/attributes_mask
> in routine getattr. But the generic_fillattr has not fill that, so add
> ext2_getattr to do this. This can fix generic/424 while testing ext2.
> 
> Reviewed-by: zhangyi (F) <yi.zhang@huawei.com>
> Signed-off-by: yangerkun <yangerkun@huawei.com>

Thanks for the patch. I have added it to my tree.

								Honza

> ---
>  fs/ext2/ext2.h    |  1 +
>  fs/ext2/file.c    |  1 +
>  fs/ext2/inode.c   | 26 ++++++++++++++++++++++++++
>  fs/ext2/namei.c   |  2 ++
>  fs/ext2/symlink.c |  2 ++
>  5 files changed, 32 insertions(+)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index e770cd1..ae0cd9e 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -774,6 +774,7 @@ extern int ext2_write_inode (struct inode *, struct writeback_control *);
>  extern void ext2_evict_inode(struct inode *);
>  extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
>  extern int ext2_setattr (struct dentry *, struct iattr *);
> +extern int ext2_getattr (const struct path *, struct kstat *, u32, unsigned int);
>  extern void ext2_set_inode_flags(struct inode *inode);
>  extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		       u64 start, u64 len);
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index 28b2609..39c4772 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -199,6 +199,7 @@ const struct inode_operations ext2_file_inode_operations = {
>  #ifdef CONFIG_EXT2_FS_XATTR
>  	.listxattr	= ext2_listxattr,
>  #endif
> +	.getattr	= ext2_getattr,
>  	.setattr	= ext2_setattr,
>  	.get_acl	= ext2_get_acl,
>  	.set_acl	= ext2_set_acl,
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index e4bb938..8e6f3ca 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1635,6 +1635,32 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
>  	return __ext2_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
>  }
>  
> +int ext2_getattr(const struct path *path, struct kstat *stat,
> +		u32 request_mask, unsigned int query_falgs)
> +{
> +	struct inode *inode = d_inode(path->dentry);
> +	struct ext2_inode_info *ei = EXT2_I(inode);
> +	unsigned int flags;
> +
> +	flags = ei->i_flags & EXT2_FL_USER_VISIBLE;
> +	if (flags & EXT2_APPEND_FL)
> +		stat->attributes |= STATX_ATTR_APPEND;
> +	if (flags & EXT2_COMPR_FL)
> +		stat->attributes |= STATX_ATTR_COMPRESSED;
> +	if (flags & EXT2_IMMUTABLE_FL)
> +		stat->attributes |= STATX_ATTR_IMMUTABLE;
> +	if (flags & EXT2_NODUMP_FL)
> +		stat->attributes |= STATX_ATTR_NODUMP;
> +	stat->attributes_mask |= (STATX_ATTR_APPEND |
> +			STATX_ATTR_COMPRESSED |
> +			STATX_ATTR_ENCRYPTED |
> +			STATX_ATTR_IMMUTABLE |
> +			STATX_ATTR_NODUMP);
> +
> +	generic_fillattr(inode, stat);
> +	return 0;
> +}
> +
>  int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index 0c26dcc..ccfbbf5 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -416,6 +416,7 @@ const struct inode_operations ext2_dir_inode_operations = {
>  #ifdef CONFIG_EXT2_FS_XATTR
>  	.listxattr	= ext2_listxattr,
>  #endif
> +	.getattr	= ext2_getattr,
>  	.setattr	= ext2_setattr,
>  	.get_acl	= ext2_get_acl,
>  	.set_acl	= ext2_set_acl,
> @@ -426,6 +427,7 @@ const struct inode_operations ext2_special_inode_operations = {
>  #ifdef CONFIG_EXT2_FS_XATTR
>  	.listxattr	= ext2_listxattr,
>  #endif
> +	.getattr	= ext2_getattr,
>  	.setattr	= ext2_setattr,
>  	.get_acl	= ext2_get_acl,
>  	.set_acl	= ext2_set_acl,
> diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
> index d5589dd..00cdb86 100644
> --- a/fs/ext2/symlink.c
> +++ b/fs/ext2/symlink.c
> @@ -23,6 +23,7 @@
>  
>  const struct inode_operations ext2_symlink_inode_operations = {
>  	.get_link	= page_get_link,
> +	.getattr	= ext2_getattr,
>  	.setattr	= ext2_setattr,
>  #ifdef CONFIG_EXT2_FS_XATTR
>  	.listxattr	= ext2_listxattr,
> @@ -31,6 +32,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
>   
>  const struct inode_operations ext2_fast_symlink_inode_operations = {
>  	.get_link	= simple_get_link,
> +	.getattr	= ext2_getattr,
>  	.setattr	= ext2_setattr,
>  #ifdef CONFIG_EXT2_FS_XATTR
>  	.listxattr	= ext2_listxattr,
> -- 
> 2.9.5
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

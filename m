Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16AAC43334
	for <linux-ext4@archiver.kernel.org>; Tue, 28 Jun 2022 08:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiF1IkS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 28 Jun 2022 04:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343896AbiF1IkQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2022 04:40:16 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89442715C
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jun 2022 01:40:14 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LXJ0Z0tSyzkWsR;
        Tue, 28 Jun 2022 16:38:54 +0800 (CST)
Received: from [10.174.178.134] (10.174.178.134) by
 canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 16:40:12 +0800
Subject: Re: [PATCH] ext4: Read inlined symlink targets using
 ext4_readpage_inline.
To:     Torge Matthies <openglfreak@googlemail.com>,
        <linux-ext4@vger.kernel.org>
References: <20220628033446.285207-1-openglfreak@googlemail.com>
From:   Zhang Yi <yi.zhang@huawei.com>
CC:     <tytso@mit.edu>, <jack@suse.cz>
Message-ID: <9b675cca-7ace-4f5f-a57b-ebddb091bf75@huawei.com>
Date:   Tue, 28 Jun 2022 16:40:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20220628033446.285207-1-openglfreak@googlemail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.134]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi, Torge.

On 2022/6/28 11:34, Torge Matthies wrote:
> Instead of using ext4_bread/ext4_getblk.
> 
> When I was trying out Linux 5.19-rc3 some symlinks became inaccessible to
> me, with the error "Structure needs cleaning" and the following printed in
> the kernel message log:
> 
> EXT4-fs error (device nvme0n1p1): ext4_map_blocks:599: inode #7351350:
> block 774843950: comm readlink: lblock 0 mapped to illegal pblock
> 774843950 (length 1)
> 
> It looks like the ext4_get_link function introduced in commit 6493792d3299
> ("ext4: convert symlink external data block mapping to bdev") does not
> handle links with inline data correctly. I added explicit handling for this
> case using ext4_readpage_inline. This fixes the bug and the affected
> symlinks become accessible again.
> 
> Fixes: 6493792d3299 ("ext4: convert symlink external data block mapping to bdev")
> Signed-off-by: Torge Matthies <openglfreak@googlemail.com>

Thanks for the fix patch! I missed the inline_data case for the symlink inode
in commit 6493792d3299.

> ---
>  fs/ext4/symlink.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index d281f5bcc526..ec4fc2d23efc 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -19,7 +19,10 @@
>   */
>  
>  #include <linux/fs.h>
> +#include <linux/gfp.h>
> +#include <linux/mm.h>
>  #include <linux/namei.h>
> +#include <linux/pagemap.h>
>  #include "ext4.h"
>  #include "xattr.h"
>  
> @@ -65,6 +68,37 @@ static int ext4_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
>  	return fscrypt_symlink_getattr(path, stat);
>  }
>  
> +static void ext4_free_link_inline(void *folio)
> +{
> +	folio_unlock(folio);
> +	folio_put(folio);
> +}
> +
> +static const char *ext4_get_link_inline(struct inode *inode,
> +					struct delayed_call *callback)
> +{
> +	struct folio *folio;
> +	char *ret;
> +	int err;
> +
> +	folio = folio_alloc(GFP_NOFS, 0)> +	if (!folio)
> +		return ERR_PTR(-ENOMEM);
> +	folio_lock(folio);
> +	folio->index = 0;
> +
> +	err = ext4_readpage_inline(inode, &folio->page);
> +	if (err) {
> +		folio_put(folio);
> +		return ERR_PTR(err);
> +	}
> +

We need to handle the case of RCU walk in pick_link(), almost all above
functions could sleep. The inline_data is a left over case, we cannot create
new inline symlink now, maybe we can just disable the RCU walk for simple?
or else we have to introduce some other no sleep helpers to get raw inode's
cached buffer_head.

BTW, why not just open code by calling ext4_read_inline_data()? The folio
conversion seems unnecessary.

Thanks,
Yi.

> +	set_delayed_call(callback, ext4_free_link_inline, folio);
> +	ret = folio_address(folio);
> +	nd_terminate_link(ret, inode->i_size, inode->i_sb->s_blocksize - 1);
> +	return ret;
> +}
> +
>  static void ext4_free_link(void *bh)
>  {
>  	brelse(bh);
> @@ -75,6 +109,9 @@ static const char *ext4_get_link(struct dentry *dentry, struct inode *inode,
>  {
>  	struct buffer_head *bh;
>  
> +	if (ext4_has_inline_data(inode))
> +		return ext4_get_link_inline(inode, callback);
> +
>  	if (!dentry) {
>  		bh = ext4_getblk(NULL, inode, 0, EXT4_GET_BLOCKS_CACHED_NOWAIT);
>  		if (IS_ERR(bh))
> 

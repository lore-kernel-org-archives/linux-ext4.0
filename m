From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
Date: Tue, 28 Aug 2012 18:04:00 +0530
Message-ID: <CAOiN93=m6VccvSJPO-Obu-vyd1Ov+qHu4_P9Lx6ng+gU=1H2yw@mail.gmail.com>
References: <CAPgLHd8oRK5qre9FEa6gGv68CWa8iUKnwROLMBJZ+hA-=kvvNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55340 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2H1MeC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Aug 2012 08:34:02 -0400
Received: by vcbfk26 with SMTP id fk26so5717089vcb.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Aug 2012 05:34:00 -0700 (PDT)
In-Reply-To: <CAPgLHd8oRK5qre9FEa6gGv68CWa8iUKnwROLMBJZ+hA-=kvvNw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

you can add 1 more.
In function ext4_mb_new_blocks(), change:
ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
to
ac = kmem_cache_zalloc(ext4_ac_cachep, GFP_NOFS); and remove
memset(ac, 0, sizeof(struct ext4_allocation_context)); from
ext4_mb_initialize_context().

On Mon, Aug 27, 2012 at 10:10 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().
>
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  fs/ext4/mballoc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8eae947..6bc21a2 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2195,12 +2195,11 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
>                 sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)];
>         i = group & (EXT4_DESC_PER_BLOCK(sb) - 1);
>
> -       meta_group_info[i] = kmem_cache_alloc(cachep, GFP_KERNEL);
> +       meta_group_info[i] = kmem_cache_zalloc(cachep, GFP_KERNEL);
>         if (meta_group_info[i] == NULL) {
>                 ext4_msg(sb, KERN_ERR, "can't allocate buddy mem");
>                 goto exit_group_info;
>         }
> -       memset(meta_group_info[i], 0, kmem_cache_size(cachep));
>         set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
>                 &(meta_group_info[i]->bb_state));
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

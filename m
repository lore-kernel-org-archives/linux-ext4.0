From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] ext4: no need to remove extent if len is 0 in ext4_es_remove_extent()
Date: Sat, 23 Feb 2013 11:40:13 +0800
Message-ID: <CA+dCu89+h00LRts_wk2GTDmi7qR9nqZfGKvabFoAvee-FCUG7A@mail.gmail.com>
References: <1361511243-2458-1-git-send-email-guaneryu@gmail.com>
 <20130222062509.GA2735@gmail.com> <20130222175557.GA21264@thunk.org>
Reply-To: guaneryu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ye0-f176.google.com ([209.85.213.176]:41059 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3BWDrf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2013 22:47:35 -0500
Received: by mail-ye0-f176.google.com with SMTP id m1so256449yen.35
        for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2013 19:47:34 -0800 (PST)
In-Reply-To: <20130222175557.GA21264@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 23, 2013 at 1:55 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> This patch didn't apply since it was apparently against an older
> version of the extents status patches.  Here is the version after I
> fixed it up so it would apply into the current ext4 tree.  Zheng, can

Thanks Ted! I was making the patch on top of Linus' tree.
Linus' tree vs ext4 tree which one is preferred for submitting patch?

Thanks,
Eryu
> you do a quick sanity check to make sure I didn't screw up anything?
> Thanks!
>
> Eryu, thanks for testing and submitting a bug fix!!
>
>                                                 - Ted
>
> From 7d46e5051453b2c4dfac4e31ae1afb30064cc404 Mon Sep 17 00:00:00 2001
> From: Eryu Guan <guaneryu@gmail.com>
> Date: Fri, 22 Feb 2013 12:54:36 -0500
> Subject: [PATCH] ext4: no need to remove extent if len is 0 in
>  ext4_es_remove_extent()
>
> len is 0 means no extent needs to be removed, so return immediately.
> Otherwise it could trigger the following BUG_ON() in
> ext4_es_remove_extent()
>
>         end = lblk + len - 1;
>         BUG_ON(end < lblk);
>
> This could be reproduced by a simple truncate(1) command by an
> unprivileged user
>
>         truncate -s $(($((2**32 - 1)) * 4096)) /mnt/ext4/testfile
>
> The same is true for __es_insert_extent().
>
> Patched kernel passed xfstests regression test.
>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/extents_status.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 9f1380e..2be245b 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -392,6 +392,9 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes)
>         struct rb_node *parent = NULL;
>         struct extent_status *es;
>
> +       if (!len)
> +               return 0;
> +
>         while (*p) {
>                 parent = *p;
>                 es = rb_entry(parent, struct extent_status, rb_node);
> @@ -456,6 +459,9 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>         es_debug("add [%u/%u) %llu %llx to extent status tree of inode %lu\n",
>                  lblk, len, pblk, status, inode->i_ino);
>
> +       if (!len)
> +               return 0;
> +
>         BUG_ON(end < lblk);
>
>         newes.es_lblk = lblk;
> @@ -649,6 +655,9 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>         es_debug("remove [%u/%u) from extent status tree of inode %lu\n",
>                  lblk, len, inode->i_ino);
>
> +       if (!len)
> +               return err;
> +
>         end = lblk + len - 1;
>         BUG_ON(end < lblk);
>
> --
> 1.7.12.rc0.22.gcdd159b
>

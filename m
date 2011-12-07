From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: check flags's EXT4_GET_BLOCKS_DELALLOC_RESERVE
 before call ext4_find_delalloc_cluster()
Date: Wed, 7 Dec 2011 19:02:15 +0800
Message-ID: <CAGBYx2ZRo_XSnU0XAvmD1+ivARyOTdM1L76LNsve7CrtHrqVug@mail.gmail.com>
References: <1323237879-31800-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48605 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1LGLCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2011 06:02:17 -0500
Received: by ggnr5 with SMTP id r5so503849ggn.19
        for <linux-ext4@vger.kernel.org>; Wed, 07 Dec 2011 03:02:16 -0800 (PST)
In-Reply-To: <1323237879-31800-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Robin,

If a file system is mounted with delalloc and it changes to nodelalloc
mode thereafter, does the patch work?

Yongqiang.

On Wed, Dec 7, 2011 at 2:04 PM, Robin Dong <hao.bigrat@gmail.com> wrote=
:
> From: Robin Dong <sanbai@taobao.com>
>
> We found performance regression when using bigalloc with "nodelalloc"=
 =A0(1MB cluster size):
>
> 1. mke2fs -C 1048576 -O ^has_journal,bigalloc /dev/sda
> 2. mount -o nodelalloc /dev/sda /test/
> 3. time dd if=3D/dev/zero of=3D/test/io bs=3D1048576 count=3D1024
>
> The "dd" will cost about 2 seconds to finish, but if we mke2fs withou=
t "bigalloc",
> "dd" will only cost lesss than 1 second.
>
> The reason is: =A0when using ext4 with "nodelalloc", it will call ext=
4_find_delalloc_cluster() nearly
> everytime it call ext4_ext_map_blocks(), and ext4_find_delalloc_clust=
er() will also scan all pages
> in cluster because no buffer is "delayed".
> A cluster has 256 pages (1MB cluster), so it will scan 256 * 256k pag=
s when creating a 1G file. That
> severely hurts the performance.
>
> Therefore, we don't call ext4_find_delalloc_cluster() when use "nodel=
alloc".
>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
> =A0fs/ext4/extents.c | =A0 =A06 ++++--
> =A01 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 61fa9e1..e15d32b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3724,7 +3724,8 @@ int ext4_ext_map_blocks(handle_t *handle, struc=
t inode *inode,
> =A0 =A0 =A0 =A0if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_in_cache(inode, map->m_lblk, =
&newex)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!newex.ee_start_lo && !newex.ee_st=
art_hi) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((sbi->s_cluster_rat=
io > 1) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((flags & EXT4_GET_B=
LOCKS_DELALLOC_RESERVE) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (sbi->s_cluster=
_ratio > 1) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_find_dela=
lloc_cluster(inode, map->m_lblk, 0))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map->m=
_flags |=3D EXT4_MAP_FROM_CLUSTER;
>
> @@ -3900,7 +3901,8 @@ int ext4_ext_map_blocks(handle_t *handle, struc=
t inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if ((sbi->s_cluster_ratio > 1) &&
> + =A0 =A0 =A0 if ((flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
> + =A0 =A0 =A0 =A0 =A0 (sbi->s_cluster_ratio > 1) &&
> =A0 =A0 =A0 =A0 =A0 =A0ext4_find_delalloc_cluster(inode, map->m_lblk,=
 0))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map->m_flags |=3D EXT4_MAP_FROM_CLUSTE=
R;
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

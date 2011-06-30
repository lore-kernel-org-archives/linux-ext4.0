From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] ext4: avoid finding next leaf if newext->ee_block
 smaller than fex->ee_block
Date: Thu, 30 Jun 2011 16:42:31 +0800
Message-ID: <BANLkTikeMA72P2-6eSv=2cqOtvEaHRbsZA@mail.gmail.com>
References: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
	<1309421014-6148-2-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52326 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab1F3Imc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jun 2011 04:42:32 -0400
Received: by pzk9 with SMTP id 9so1524654pzk.19
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 01:42:31 -0700 (PDT)
In-Reply-To: <1309421014-6148-2-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 30, 2011 at 4:03 PM, Robin Dong <hao.bigrat@gmail.com> wrot=
e:
> If newext->ee_block is smaller than (or equal to) fex->ee_block, the =
call of
> ext4_ext_next_leaf_block will be useless. We need to call it only aft=
er
> newext->ee_block is greater than fex->ee_block.
>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
> =A0fs/ext4/extents.c | =A0 37 ++++++++++++++++++++-----------------
> =A01 files changed, 20 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index dc5ef91..0ee475a 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1765,24 +1765,27 @@ int ext4_ext_insert_extent(handle_t *handle, =
struct inode *inode,
>
> =A0 =A0 =A0 =A0/* probably next leaf has space for us? */
> =A0 =A0 =A0 =A0fex =3D EXT_LAST_EXTENT(eh);
> - =A0 =A0 =A0 next =3D ext4_ext_next_leaf_block(inode, path);
> - =A0 =A0 =A0 if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee=
_block)
> - =A0 =A0 =A0 =A0 =A0 && next !=3D EXT_MAX_BLOCKS) {
How about:
           next =3D EXT_MAX_BLOCKS;
           if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_bloc=
k)
                   next =3D ext4_ext_next_leaf_block(inode, path);
           if (next !=3D EXT_MAX_BLOCKS) {
Code above can reduce an indent.

Yongqiang.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("next leaf block - %d\n", nex=
t);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(npath !=3D NULL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 npath =3D ext4_ext_find_extent(inode, n=
ext, NULL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(npath))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(npath);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(npath->p_depth !=3D path->p_dept=
h);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 eh =3D npath[depth].p_hdr;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (le16_to_cpu(eh->eh_entries) < le16_=
to_cpu(eh->eh_max)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("next leaf is=
n't full(%d)\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le1=
6_to_cpu(eh->eh_entries));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =3D npath;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto has_space;
> + =A0 =A0 =A0 if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee=
_block)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 next =3D ext4_ext_next_leaf_block(inode=
, path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (next !=3D EXT_MAX_BLOCKS) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("next leaf bl=
ock - %d\n", next);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(npath !=3D NULL)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 npath =3D ext4_ext_find=
_extent(inode, next, NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(npath))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
PTR_ERR(npath);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(npath->p_depth !=
=3D path->p_depth);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 eh =3D npath[depth].p_h=
dr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (le16_to_cpu(eh->eh_=
entries) <
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le16_to_cpu(eh->eh_max)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_deb=
ug("next leaf isn't full(%d)\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 le16_to_cpu(eh->eh_entries));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =3D=
 npath;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ha=
s_space;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("next leaf ha=
s no free space(%d,%d)\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to=
_cpu(eh->eh_entries),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to=
_cpu(eh->eh_max));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("next leaf has no free space(=
%d,%d)\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(eh->eh_=
entries), le16_to_cpu(eh->eh_max));
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/*
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

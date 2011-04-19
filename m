From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [Ext4 punch hole 5/6 v5] Ext4 Punch Hole Support: Map blocks
 punch hole flag
Date: Tue, 19 Apr 2011 16:35:48 +0800
Message-ID: <BANLkTinaFDetbwu-Y6afPgiRAzwarvtGJg@mail.gmail.com>
References: <4DAD3D05.8000103@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63778 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1DSImu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2011 04:42:50 -0400
Received: by pzk12 with SMTP id 12so3875178pzk.11
        for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 01:42:50 -0700 (PDT)
In-Reply-To: <4DAD3D05.8000103@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 19, 2011 at 3:43 PM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> This patch adds a new flag to map blocks that specifies
> the given range of blocks should be punched out. =A0Extents
> are first converted to uninitialized extents before they are
> punched out. Because punching a hole may require that the
> extent be split, it is possible that the splitting may need
> more blocks than are available. =A0To deal with this, reserved
> blocks are temporarily borrowed to allow the split to proceed.
> The borrowed blocks are then returned after the hole punch has
> released more blocks.
>
> The routine then returns the number of blocks successfully
> punched out.
>
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> :100644 100644 e3a721a... d97bc87... M =A0fs/ext4/extents.c
> =A0fs/ext4/extents.c | =A0 99 +++++++++++++++++++++++++++++++++++++++=
++++++++------
> =A01 files changed, 88 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e3a721a..d97bc87 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3456,15 +3456,19 @@ int ext4_ext_map_blocks(handle_t *handle, str=
uct inode *inode,
> =A0 =A0 =A0 =A0ext4_fsblk_t newblock =3D 0;
> =A0 =A0 =A0 =A0int err =3D 0, depth, ret;
> =A0 =A0 =A0 =A0unsigned int allocated =3D 0;
> + =A0 =A0 =A0 unsigned int punched_out =3D 0;
> + =A0 =A0 =A0 unsigned int result =3D 0;
> =A0 =A0 =A0 =A0struct ext4_allocation_request ar;
> =A0 =A0 =A0 =A0ext4_io_end_t *io =3D EXT4_I(inode)->cur_aio_dio;
> + =A0 =A0 =A0 struct ext4_map_blocks punch_map;
>
> =A0 =A0 =A0 =A0ext_debug("blocks %u/%u requested for inode %lu\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map->m_lblk, map->m_len, inode->i_=
ino);
> =A0 =A0 =A0 =A0trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, ma=
p->m_len, flags);
>
> =A0 =A0 =A0 =A0/* check in cache */
> - =A0 =A0 =A0 if (ext4_ext_in_cache(inode, map->m_lblk, &newex)) {
> + =A0 =A0 =A0 if (ext4_ext_in_cache(inode, map->m_lblk, &newex) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT=
) =3D=3D 0)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!newex.ee_start_lo && !newex.ee_st=
art_hi) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((flags & EXT4_GET_=
BLOCKS_CREATE) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> @@ -3529,16 +3533,85 @@ int ext4_ext_map_blocks(handle_t *handle, str=
uct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext_debug("%u fit into=
 %u:%d -> %llu\n", map->m_lblk,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ee=
_block, ee_len, newblock);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Do not put uninitial=
ized extent in the cache */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ext4_ext_is_uninit=
ialized(ex)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_put_in_cache(inode, ee_block,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_len, ee_start);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((flags & EXT4_GET_B=
LOCKS_PUNCH_OUT_EXT) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Do=
 not put uninitialized extent
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* in=
 the cache
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ex=
t4_ext_is_uninitialized(ex)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ext4_ext_put_in_cache(inode, ee_block,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ee_len, ee_start);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 ext4_ext_handle_uninitialized_extents(
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 handle, inode, map, path, flags,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 allocated, newblock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
ret;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_ext_handle=
_uninitialized_extents(handle,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 inode, map, path, flags, allocated,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 newblock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Punch out the map =
length, but only to the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* end of the extent
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 punched_out =3D allocat=
ed < map->m_len ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 allocat=
ed : map->m_len;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Sense extents need=
 to be converted to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* uninitialized, the=
y must fit in an
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* uninitialized exte=
nt
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (punched_out > EXT_U=
NINIT_MAX_LEN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 punched=
_out =3D EXT_UNINIT_MAX_LEN;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 punch_map.m_lblk =3D ma=
p->m_lblk;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 punch_map.m_pblk =3D ne=
wblock;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 punch_map.m_len =3D pun=
ched_out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 punch_map.m_flags =3D 0=
;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Check to see if the =
extent needs to be split */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (punch_map.m_len !=3D=
 ee_len ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 punch_m=
ap.m_lblk !=3D ee_block) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 ext4_ext_split_extents(handle, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &punch_=
map, path,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_GE=
T_BLOCKS_PRE_IO |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_HA=
S_FREE_BLKS_USE_ROOTBLKS,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret=
 < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 err =3D ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto out2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* fi=
nd extent for the block at
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* th=
e start of the hole
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_drop_refs(path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(p=
ath);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =3D=
 ext4_ext_find_extent(inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map->m_=
lblk, NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_=
ERR(path)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 err =3D PTR_ERR(path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 path =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto out2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 depth =3D=
 ext_depth(inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex =3D =
path[depth].p_ext;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_len =
=3D ext4_ext_get_actual_len(ex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_bloc=
k =3D le32_to_cpu(ex->ee_block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ee_star=
t =3D ext4_ext_pblock(ex);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitial=
ized(ex);
Is this change journaled?

> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_remove=
_space(inode, map->m_lblk,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map->m_=
lblk + punched_out);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out2;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> @@ -3683,7 +3756,11 @@ out2:
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0trace_ext4_ext_map_blocks_exit(inode, map->m_lblk,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0newblock, map->m_len, err ? err : allo=
cated);
> - =A0 =A0 =A0 return err ? err : allocated;
> +
> + =A0 =A0 =A0 result =3D (flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 punched_out : allocated=
;
> +
> + =A0 =A0 =A0 return err ? err : result;
> =A0}
>
> =A0void ext4_ext_truncate(struct inode *inode)
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

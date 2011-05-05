From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [Ext4 punch hole 3/5 v6] Ext4 Punch Hole Support: Punch out extents
Date: Thu, 5 May 2011 15:41:45 +0800
Message-ID: <BANLkTi=yXiv0emuC7h9eUGs1AiJNv1aWNw@mail.gmail.com>
References: <4DC031BE.8070807@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51943 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1EEHlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 03:41:47 -0400
Received: by vxi39 with SMTP id 39so2007734vxi.19
        for <linux-ext4@vger.kernel.org>; Thu, 05 May 2011 00:41:46 -0700 (PDT)
In-Reply-To: <4DC031BE.8070807@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 4, 2011 at 12:47 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> This patch modifies the truncate routines to support hole punching
> Below is a brief summary of the patches changes:
>
> - Added end param to ext_ext4_rm_leaf
> =A0 =A0 =A0 =A0This function has been modified to accept an end param=
eter
> =A0 =A0 =A0 =A0which enables it to punch holes in leafs instead of ju=
st
> =A0 =A0 =A0 =A0truncating them.
>
> - Implemented the "remove head" case in the ext_remove_blocks routine
> =A0 =A0 =A0 =A0This routine is used by ext_ext4_rm_leaf to remove the=
 tail
> =A0 =A0 =A0 =A0of an extent during a truncate. =A0The new ext_ext4_rm=
_leaf
> =A0 =A0 =A0 =A0routine will now also use it to remove the head of an =
extent in the
> =A0 =A0 =A0 =A0case that the hole covers a region of blocks at the be=
ginning
> =A0 =A0 =A0 =A0of an extent.
>
> - Added "end" param to ext4_ext_remove_space routine
> =A0 =A0 =A0 =A0This function has been modified to accept a stop param=
eter, which
> =A0 =A0 =A0 =A0is passed through to ext4_ext_rm_leaf.
>
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> :100644 100644 7398a59... 0afb746... M =A0fs/ext4/extents.c
> =A0fs/ext4/extents.c | =A0160 +++++++++++++++++++++++++++++++++++++++=
+++++++------
> =A01 files changed, 141 insertions(+), 19 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7398a59..0afb746 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -46,6 +46,13 @@
>
> =A0#include <trace/events/ext4.h>
>
> +static int ext4_split_extent(handle_t *handle,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
inode *inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
ext4_ext_path *path,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
ext4_map_blocks *map,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int spl=
it_flag,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int fla=
gs);
> +
> =A0static int ext4_ext_truncate_extend_restart(handle_t *handle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0int needed)
> @@ -2198,8 +2205,16 @@ static int ext4_remove_blocks(handle_t *handle=
, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_free_blocks(handle, inode, NULL, =
start, num, flags);
> =A0 =A0 =A0 =A0} else if (from =3D=3D le32_to_cpu(ex->ee_block)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && to <=3D le32_to_cpu(ex->ee_blo=
ck) + ee_len - 1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO "strange request: remo=
val %u-%u from %u:%u\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from, to, le32_to_cpu(e=
x->ee_block), ee_len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* head removal */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lblk_t num;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t start;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D to - from;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 start =3D ext4_ext_pblock(ex);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("free first %u blocks startin=
g %llu\n", num, start);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blocks(handle, inode, 0, star=
t, num, flags);
> +
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_INFO "strange request: rem=
oval(2) "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"%u-%u=
 from %u:%u\n",
> @@ -2208,9 +2223,22 @@ static int ext4_remove_blocks(handle_t *handle=
, struct inode *inode,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +
> +/*
> + * ext4_ext_rm_leaf() Removes the extents associated with the
> + * blocks appearing between "start" and "end", and splits the extent=
s
> + * if "start" and "end" appear in the same extent
> + *
> + * @handle: The journal handle
> + * @inode: =A0The files inode
> + * @path: =A0 The path to the leaf
> + * @start: =A0The first block to remove
> + * @end: =A0 The last block to remove
> + */
> =A0static int
> =A0ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_ext_path *path, ext4_lblk_t=
 start)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_ext_path *path, ext4_lblk_t=
 start,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lblk_t end)
> =A0{
> =A0 =A0 =A0 =A0int err =3D 0, correct_index =3D 0;
> =A0 =A0 =A0 =A0int depth =3D ext_depth(inode), credits;
> @@ -2221,6 +2249,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode=
 *inode,
> =A0 =A0 =A0 =A0unsigned short ex_ee_len;
> =A0 =A0 =A0 =A0unsigned uninitialized =3D 0;
> =A0 =A0 =A0 =A0struct ext4_extent *ex;
> + =A0 =A0 =A0 struct ext4_map_blocks map;
>
> =A0 =A0 =A0 =A0/* the header must be checked already in ext4_ext_remo=
ve_space() */
> =A0 =A0 =A0 =A0ext_debug("truncate since %u in leaf\n", start);
> @@ -2250,31 +2279,95 @@ ext4_ext_rm_leaf(handle_t *handle, struct ino=
de *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path[depth].p_ext =3D ex;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a =3D ex_ee_block > start ? ex_ee_bloc=
k : start;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 b =3D ex_ee_block + ex_ee_len - 1 < EXT=
_MAX_BLOCK ?
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex_ee_block + ex_ee_len=
 - 1 : EXT_MAX_BLOCK;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 b =3D ex_ee_block+ex_ee_len - 1 < end ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex_ee_block+ex_ee_len -=
 1 : end;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext_debug(" =A0border %u:%u\n", a, b);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (a !=3D ex_ee_block && b !=3D ex_ee_=
block + ex_ee_len - 1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If this extent is beyond the end of =
the hole, skip it */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (end <=3D ex_ee_block) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex_ee_block =3D le32_to=
_cpu(ex->ee_block);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex_ee_len =3D ext4_ext_=
get_actual_len(ex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (a !=3D ex_ee_block &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 b !=3D ex_ee_block + ex=
_ee_len - 1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If this is a trunc=
ate, then this condition should
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* never happen becau=
se at least one of the end points
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* needs to be on the=
 edge of the extent.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (end =3D=3D EXT_MAX_=
BLOCK) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_deb=
ug(" =A0bad truncate %u:%u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 start, end);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D=
 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D=
 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D=
 -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* else this is a hol=
e punch, so the extent needs to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* be split since nei=
ther edge of the hole is on the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* extent edge
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_p=
blk =3D ext4_ext_pblock(ex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_l=
blk =3D ex_ee_block;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_l=
en =3D b - ex_ee_block;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D=
 ext4_split_extent(handle,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 inode, path, &map, 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 EXT4_GET_BLOCKS_PUNCH_OUT_EXT |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 EXT4_GET_BLOCKS_PRE_IO);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err=
 < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex_ee_l=
en =3D ext4_ext_get_actual_len(ex);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 b =3D e=
x_ee_block+ex_ee_len - 1 < end ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ex_ee_block+ex_ee_len - 1 : end;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Then=
 remove tail of this extent */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D=
 ex_ee_block;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D=
 a - block;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (a !=3D ex_ee_block) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* remove tail of the =
extent */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block =3D ex_ee_block;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num =3D a - block;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (b !=3D ex_ee_block + ex_ee_=
len - 1) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* remove head of the =
extent */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D a;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D b - a;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* there is no "make a =
hole" API yet */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D b;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D =A0ex_ee_block =
+ ex_ee_len - b;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If this is a trunc=
ate, this condition
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* should never happe=
n
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (end =3D=3D EXT_MAX_=
BLOCK) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_deb=
ug(" =A0bad truncate %u:%u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 start, end);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D=
 -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* remove whole extent=
: excellent! */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block =3D ex_ee_block;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(a !=3D ex_ee_blo=
ck);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(b !=3D ex_ee_blo=
ck + ex_ee_len - 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (a !=3D ex_ee_block)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_deb=
ug(" =A0bad truncate %u:%u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 start, end);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D=
 -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (b !=3D ex_ee_block =
+ ex_ee_len - 1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_deb=
ug(" =A0bad truncate %u:%u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 start, end);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D=
 -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> @@ -2305,7 +2398,13 @@ ext4_ext_rm_leaf(handle_t *handle, struct inod=
e *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (num =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* this extent is remo=
ved; mark slot entirely unused */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_store_pblock(=
ex, 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_add_cpu(&eh->eh_en=
tries, -1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (block !=3D ex_ee_block) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If this was a head=
 removal, then we need to update
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the physical block=
 since it is now at a different
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* location
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_store_pblock(e=
x, ext4_ext_pblock(ex) + (b-a));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ex->ee_block =3D cpu_to_le32(block);
> @@ -2321,6 +2420,27 @@ ext4_ext_rm_leaf(handle_t *handle, struct inod=
e *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If the extent was completely relea=
sed,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we need to remove it from the leaf
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (end !=3D EXT_MAX_BL=
OCK) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Fo=
r hole punching, we need to scoot all the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ex=
tents up when an extent is removed so that
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we=
 dont have blank extents in the middle
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memmove=
(ex, ex+1, (EXT_LAST_EXTENT(eh) - ex) *
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct ext4_extent));
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Now =
get rid of the one at the end */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(=
EXT_LAST_EXTENT(eh), 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct ext4_extent));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_add_cpu(&eh->eh_en=
tries, -1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext_debug("new extent: %u:%u:%llu\n", =
block, num,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_e=
xt_pblock(ex));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ex--;
> @@ -2361,7 +2481,8 @@ ext4_ext_more_to_rm(struct ext4_ext_path *path)
> =A0 =A0 =A0 =A0return 1;
> =A0}
>
> -static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t st=
art)
> +static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t st=
art,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lb=
lk_t end)
> =A0{
> =A0 =A0 =A0 =A0struct super_block *sb =3D inode->i_sb;
> =A0 =A0 =A0 =A0int depth =3D ext_depth(inode);
> @@ -2400,7 +2521,8 @@ again:
> =A0 =A0 =A0 =A0while (i >=3D 0 && err =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (i =3D=3D depth) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* this is leaf block =
*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_rm_lea=
f(handle, inode, path, start);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_ext_rm_lea=
f(handle, inode, path,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 start, end);
Hi there,

Sorry for so late voice.

ext4_ext_remove_space() are supposed to be used by truncate, so it
remove blocks from EOF to start as indicated by while-loop.   Now it
has an end, so I think we'd better limit the while loop from the end
to the start, but not from EOF to the start.

we can achieve this by assigning path right before while-loop.

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* root level has p_bh=
 =3D=3D NULL, brelse() eats this */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brelse(path[i].p_bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path[i].p_bh =3D NULL;
> @@ -3443,7 +3565,7 @@ void ext4_ext_truncate(struct inode *inode)
>
> =A0 =A0 =A0 =A0last_block =3D (inode->i_size + sb->s_blocksize - 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0>> EXT4_BLOCK_SIZE_BIT=
S(sb);
> - =A0 =A0 =A0 err =3D ext4_ext_remove_space(inode, last_block);
> + =A0 =A0 =A0 err =3D ext4_ext_remove_space(inode, last_block, EXT_MA=
X_BLOCK);
>
> =A0 =A0 =A0 =A0/* In a multi-transaction truncate, we only make the f=
inal
> =A0 =A0 =A0 =A0 * transaction synchronous.
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

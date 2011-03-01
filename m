From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [Ext4 punch hole 4/5] Ext4 Punch Hole Support: Enable Punch Hole
Date: Tue, 1 Mar 2011 10:20:26 +0200
Message-ID: <AANLkTi=Y1m=oH6zms-vsZE9iHwYd2q7Seuo+KcHCFQv-@mail.gmail.com>
References: <4D6C634C.8050308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55535 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1CAIU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 03:20:27 -0500
Received: by qyg14 with SMTP id 14so4114773qyg.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Mar 2011 00:20:26 -0800 (PST)
In-Reply-To: <4D6C634C.8050308@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 1, 2011 at 5:09 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> This patch adds the =A0new "ext4_punch_hole" "ext4_ext_punch_hole" ro=
utines.
>
> fallocate has been modified to call ext4_punch_hole when the punch ho=
le
> flag is passed. =A0At the moment, we only support punching holes in
> extents, so this routine is pretty much a wrapper for the ext4_ext_pu=
nch_hole
> routine.
>
> The ext4_ext_punch_hole routine zeros out the pages that are
> covered by the hole. =A0The blocks to be punched out
> are then identified as mapped, delayed, or already punched out.
> The blocks that mapped are the converted to into uninitialized
> extents. =A0The blocks are then punched out using the
> "ext4_ext_release_blocks" routine.
>
> Some minor utility functions have also been added.
> A new ext4_ext_lookup_hole routine is used by
> ext4_ext_punch_hole to check if a range of blocks
> have already been punched out.
>
> A new ext4_ext_test_block_flag has also been
> added to identify the state of a block (ie mapped,
> delayed, ect)
>
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> :100644 100644 43a5772... aeb86d6... M =A0fs/ext4/ext4.h
> :100644 100644 efbc3ef... 5713258... M =A0fs/ext4/extents.c
> :100644 100644 28c9137... 493c908... M =A0fs/ext4/inode.c
> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A02 +
> =A0fs/ext4/extents.c | =A0321 +++++++++++++++++++++++++++++++++++++++=
+++++++++++++-
> =A0fs/ext4/inode.c =A0 | =A0 26 +++++
> =A03 files changed, 345 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 43a5772..aeb86d6 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1729,6 +1729,7 @@ extern int ext4_change_inode_journal_flag(struc=
t inode *, int);
> =A0extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
> =A0extern int ext4_can_truncate(struct inode *inode);
> =A0extern void ext4_truncate(struct inode *);
> +extern long =A0ext4_punch_hole(struct inode *inode,loff_t offset, lo=
ff_t length);
> =A0extern int ext4_truncate_restart_trans(handle_t *, struct inode *,=
 int nblocks);
> =A0extern void ext4_set_inode_flags(struct inode *);
> =A0extern void ext4_get_inode_flags(struct ext4_inode_info *);
> @@ -2066,6 +2067,7 @@ extern int ext4_ext_index_trans_blocks(struct i=
node *inode, int nrblocks,
> =A0extern int ext4_ext_map_blocks(handle_t *handle, struct inode *ino=
de,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ex=
t4_map_blocks *map, int flags);
> =A0extern void ext4_ext_truncate(struct inode *);
> +extern void ext4_ext_punch_hole(struct inode *inode, loff_t offset, =
loff_t length);
> =A0extern void ext4_ext_init(struct super_block *);
> =A0extern void ext4_ext_release(struct super_block *);
> =A0extern long ext4_fallocate(struct file *file, int mode, loff_t off=
set,
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index efbc3ef..5713258 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2776,6 +2776,154 @@ out:
> =A0}
>
> =A0/*
> + * lookup_hole()
> + * Returns the numbers of consecutive blocks starting at "start"
> + * that are not contained within an extent
> + */
> +static int ext4_ext_lookup_hole(struct inode *inode, ext4_lblk_t sta=
rt){
> + =A0 =A0struct super_block *sb =3D inode->i_sb;
> + =A0 =A0 =A0 int depth =3D ext_depth(inode);
> + =A0 =A0 =A0 struct ext4_ext_path *path;
> + =A0 =A0 =A0 struct ext4_extent_header *eh;
> + =A0 =A0 =A0 struct ext4_extent *ex;
> + =A0 =A0 =A0 struct buffer_head *bh;
> + =A0 =A0 =A0 ext4_lblk_t last_block;
> + =A0 =A0 =A0 handle_t *handle;
> + =A0 =A0 =A0 int i, err;
> +
> + =A0 =A0 =A0 ext_debug("lookup hole since %u\n", start);
> +
> + =A0 =A0 =A0 /* Make sure start is valid */
> + =A0 =A0 =A0 last_block =3D inode->i_size >> EXT4_BLOCK_SIZE_BITS(sb=
);
> + =A0 =A0 =A0 if(start >=3D last_block)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> +
> + =A0 =A0 =A0 handle =3D ext4_journal_start(inode, depth + 1);
> + =A0 =A0 =A0 if (IS_ERR(handle))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);

This is strange. The name of the functions implies it is a readonly ope=
ration,
so why is a transaction needed?
You should probably document the reason for that and specify the change=
s
which this function may apply.

> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* We start scanning from right side, looking for
> + =A0 =A0 =A0 =A0* the left most block contained in the leaf, and
> + =A0 =A0 =A0 =A0* stopping when "start" is crossed.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 depth =3D ext_depth(inode);
> + =A0 =A0 =A0 path =3D kzalloc(sizeof(struct ext4_ext_path) * (depth =
+ 1), GFP_NOFS);
> + =A0 =A0 =A0 if (path =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_stop(handl=
e);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 path[0].p_depth =3D depth;
> + =A0 =A0 =A0 path[0].p_hdr =3D ext_inode_hdr(inode);
> + =A0 =A0 =A0 if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 i =3D err =3D 0;
> +
> + =A0 =A0 =A0 while (i >=3D 0 && err =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i =3D=3D depth) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* this is leaf block *=
/
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 eh =3D path[i].p_hdr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (eh !=3D NULL){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (eh-=
>eh_entries =3D=3D 0){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 err =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex =3D =
EXT_LAST_EXTENT(eh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (=
ex !=3D NULL && ex >=3D EXT_FIRST_EXTENT(eh)){
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0* If the entire extent apears before start
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0* then we have passed the hole.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if(ex->ee_block + ex->ee_len <=3D start)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0* If the start of the extent appears after
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0* or on start, then mark this as the edge
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0* of the hole
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if(ex->ee_block >=3D start)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 last_block =3D ex->ee_block;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0* If the extent contains start, then there
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0* is no hole.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 else if(ex->ee_block + ex->ee_len > start){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 last_block =3D start;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ex--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* root level has p_bh =
=3D=3D NULL, brelse() eats this */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(path[i].p_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[i].p_bh =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* this is index block */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!path[i].p_hdr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[i].p_hdr =3D ext_b=
lock_hdr(path[i].p_bh);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!path[i].p_idx) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* this level hasn't be=
en touched yet */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[i].p_idx =3D EXT_L=
AST_INDEX(path[i].p_hdr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[i].p_block =3D le1=
6_to_cpu(path[i].p_hdr->eh_entries)+1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("init index p=
tr: hdr 0x%p, num %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[i].p_hdr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(path[i].p_h=
dr->eh_entries));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we were already here=
, see at next index */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[i].p_idx--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("level %d - index, first 0x%p=
, cur 0x%p\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i, EXT_FIRST_INDEX(path[i].p_hdr),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[i].p_idx);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* go to the next level */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_debug("move to level %d (block %llu=
)\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i + 1, =
ext4_idx_pblock(path[i].p_idx));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(path + i + 1, 0, sizeof(*path));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D sb_bread(sb, ext4_idx_pblock(pat=
h[i].p_idx));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bh) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (WARN_ON(i + 1 > depth)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext4_ext_check(inode, ext_block_hdr=
(bh), depth - i - 1)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 path[i + 1].p_bh =3D bh;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
> +
> + =A0 =A0 =A0 }
> +out:
> + =A0 =A0 =A0 ext4_ext_drop_refs(path);
> + =A0 =A0 =A0 kfree(path);
> + =A0 =A0 =A0 ext4_journal_stop(handle);
> +
> + =A0 =A0 =A0 return err ? err : last_block - start;
> +
> +}
> +
> +/*
> =A0* called at mount time
> =A0*/
> =A0void ext4_ext_init(struct super_block *sb)
> @@ -4029,6 +4177,172 @@ next:
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> +/*
> + * ext4_ext_test_block_flag
> + * Tests the buffer head associated with the given block
> + * to see if the state contains flag
> + *
> + * @inode: =A0The inode of the given file
> + * @block: =A0The block to test
> + * @flag: =A0 The flag to check for
> + *
> + * Returns 0 on sucess or negative on err
> + */
> +static int ext4_ext_test_block_flag(struct inode *inode, ext4_lblk_t=
 block, enum bh_state_bits flag){

(style) open { in new line.

> + =A0 =A0 =A0 struct buffer_head *bh;
> + =A0 =A0 =A0 struct page *page;
> + =A0 =A0 =A0 struct address_space *mapping =3D inode->i_mapping;
> + =A0 =A0 =A0 loff_t block_offset;
> + =A0 =A0 =A0 int i, ret;
> + =A0 =A0 =A0 unsigned long flag_mask =3D 1 << flag;
> +
> + =A0 =A0 =A0 block_offset =3D block << EXT4_BLOCK_SIZE_BITS(inode->i=
_sb);
> + =A0 =A0 =A0 page =3D find_or_create_page(mapping, block_offset >> P=
AGE_CACHE_SHIFT,
> + =A0 =A0 =A0 mapping_gfp_mask(mapping) & ~__GFP_FS);
> +
> + =A0 =A0 =A0 if (!page)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> +
> + =A0 =A0 =A0 if (!page_has_buffers(page))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_empty_buffers(page, EXT4_BLOCK_S=
IZE(inode->i_sb), 0);
> +
> + =A0 =A0 =A0 /* advance to the buffer that has the block offset =A0*=
/
> + =A0 =A0 =A0 bh =3D page_buffers(page);
> + =A0 =A0 =A0 for (i =3D 0; i < block_offset; i+=3DEXT4_BLOCK_SIZE(in=
ode->i_sb)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D bh->b_this_page;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if(bh->b_state & flag_mask)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -1;
> +
> + =A0 =A0 =A0 unlock_page(page);
> + =A0 =A0 =A0 page_cache_release(page);
> +
> + =A0 =A0 =A0 return ret;
> +
> +}
> +
> +/*
> + * ext4_ext_punch_hole
> + *
> + * Punches a hole of "length" bytes in a file starting
> + * at byte "offset"
> + *
> + * @inode: =A0The inode of the file to punch a hole in
> + * @offset: The starting byte offset of the hole
> + * @length: The length of the hole
> + *
> + */
> +void ext4_ext_punch_hole(struct inode *inode, loff_t offset, loff_t =
length)
> +{
> + =A0 =A0 =A0 struct super_block *sb =3D inode->i_sb;
> + =A0 =A0 =A0 ext4_lblk_t first_block, last_block, num_blocks, iblock=
 =3D 0;
> + =A0 =A0 =A0 struct address_space *mapping =3D inode->i_mapping;
> + =A0 =A0 =A0 struct ext4_map_blocks map;
> + =A0 =A0 =A0 handle_t *handle;
> + =A0 =A0 =A0 loff_t first_block_offset, last_block_offset, block_len=
;
> + =A0 =A0 =A0 int get_blocks_flags, err, ret =3D 0;
> +
> + =A0 =A0 =A0 first_block =3D (offset + sb->s_blocksize - 1)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 >> EXT4_BLOCK_SIZE_BITS=
(sb);
> + =A0 =A0 =A0 last_block =3D (offset+length) =A0>> EXT4_BLOCK_SIZE_BI=
TS(sb);
> +
> + =A0 =A0 =A0 first_block_offset =3D first_block << EXT4_BLOCK_SIZE_B=
ITS(sb);
> + =A0 =A0 =A0 last_block_offset =3D last_block << EXT4_BLOCK_SIZE_BIT=
S(sb);
> +
> + =A0 =A0 =A0 err =3D ext4_writepage_trans_blocks(inode);

1. (style) err is not an appropriate name (even though is it
convenient to reuse it)
2. did you check if ext4_writepage_trans_blocks(inode) covers the credi=
ts
    needed for splitting 1 extent into 3? I suppose it does if it also
being used
    when converting a middle part of an uninitialized extent, but I
didn't check.

> + =A0 =A0 =A0 handle =3D ext4_journal_start(inode, err);
> + =A0 =A0 =A0 if (IS_ERR(handle))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Now we need to zero out the un block aligned data.
> + =A0 =A0 =A0 =A0* If the file is smaller than a block, just
> + =A0 =A0 =A0 =A0* zero out the middle and return
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if(first_block > last_block)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_block_zero_page_range(handle, mapp=
ing, offset, length);
> + =A0 =A0 =A0 else{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zero out the head of the hole before=
 the first block */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_len =A0=3D first_block_offset - o=
ffset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(block_len > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_block_zero_page_ra=
nge(handle, mapping, offset, block_len);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* zero out the tail of the hole after =
the last block */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_len =3D offset + length - last_bl=
ock_offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(block_len > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_block_zero_page_ra=
nge(handle, mapping,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 last_block_offset, block_len);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* If there are no blocks to remove, return now */
> + =A0 =A0 =A0 if(first_block >=3D last_block){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_stop(handle);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Clear pages associated with the hole */
> + =A0 =A0 =A0 if (mapping->nrpages)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_inode_pages2_range(mapping, =
offset >> PAGE_CACHE_SHIFT,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 (offset+length) >> PAGE_CACHE_SHIFT );
> +
> +
> + =A0 =A0 =A0 /* Loop over all the blocks and identify blocks that ne=
ed to be punched out */
> + =A0 =A0 =A0 iblock =3D first_block;
> + =A0 =A0 =A0 while(iblock < last_block){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_lblk =3D iblock;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_len =3D last_block - iblock;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_map_blocks(handle, inode, =
&map, 0);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If the blocks are mapped, release th=
em */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ret > 0){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blocks =3D ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_convert_blocks=
_uninit(inode, handle, iblock, num_blocks);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_release_blocks=
(inode, iblock, iblock+num_blocks);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto next;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If they are not mapped
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* check to see if they are punched o=
ut
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_ext_lookup_hole(inode, ibl=
ock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ret > 0){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blocks =3D ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto next;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If the block could not be mapped, =
and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* its not already punched out,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* check to see if the block is delay=
ed
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ext4_ext_test_block_flag(inode, iblo=
ck, BH_Delay) =3D=3D 0){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_blocks_flags =3D EX=
T4_GET_BLOCKS_CREATE | EXT4_GET_BLOCKS_DELALLOC_RESERVE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_map_blocks=
(handle, inode, &map, get_blocks_flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If the blocks are fo=
und, release them */
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if(ret > 0){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blo=
cks =3D ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_release_blocks(inode, iblock, iblock+num_blocks);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ne=
xt;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If the block cannot be identified, j=
ust skip it */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_blocks =3D 1;
> +
> +next:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iblock+=3Dnum_blocks;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 ext4_mark_inode_dirty(handle, inode);
> +
> + =A0 =A0 =A0 ext4_journal_stop(handle);
> +
> +}
> +
>
> =A0static void ext4_falloc_update_inode(struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int mo=
de, loff_t new_size, int update_ctime)
> @@ -4079,10 +4393,6 @@ long ext4_fallocate(struct file *file, int mod=
e, loff_t offset, loff_t len)
> =A0 =A0 =A0 =A0struct ext4_map_blocks map;
> =A0 =A0 =A0 =A0unsigned int credits, blkbits =3D inode->i_blkbits;
>
> - =A0 =A0 =A0 /* We only support the FALLOC_FL_KEEP_SIZE mode */
> - =A0 =A0 =A0 if (mode & ~FALLOC_FL_KEEP_SIZE)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
> -
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * currently supporting (pre)allocate mode for extent-=
based
> =A0 =A0 =A0 =A0 * files _only_
> @@ -4090,6 +4400,9 @@ long ext4_fallocate(struct file *file, int mode=
, loff_t offset, loff_t len)
> =A0 =A0 =A0 =A0if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EOPNOTSUPP;
>
> + =A0 =A0 =A0 if (mode & FALLOC_FL_PUNCH_HOLE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ext4_punch_hole(inode, offset, l=
en);
> +
> =A0 =A0 =A0 =A0map.m_lblk =3D offset >> blkbits;
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * We can't just convert len to max_blocks because
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 28c9137..493c908 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4487,6 +4487,32 @@ int ext4_can_truncate(struct inode *inode)
> =A0}
>
> =A0/*
> + * ext4_punch_hole: punches a hole in a file by releaseing the block=
s
> + * associated with the given offset and length
> + *
> + * @inode: =A0File inode
> + * @offset: The offset where the hole will begin
> + * @len: =A0 =A0The length of the hole
> + *
> + * Returns: 0 on sucess or negative on failure
> + */
> +
> +long =A0ext4_punch_hole(struct inode *inode, loff_t offset, loff_t l=
ength)
> +{
> +
> + =A0 =A0 =A0 if (!S_ISREG(inode->i_mode)=3D=3D1)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOTSUPP;

(style) please drop the =3D=3D 1. I am not even sure that !(0) is
guarantied to return 1...

> +
> + =A0 =A0 =A0 if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 //TODO: Add support for non extent hole=
 punching
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOTSUPP;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ext4_ext_punch_hole(inode, offset, length);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/*
> =A0* ext4_truncate()
> =A0*
> =A0* We block out ext4_get_block() block instantiations across the en=
tire
> --
> 1.7.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

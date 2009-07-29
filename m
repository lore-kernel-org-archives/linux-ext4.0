From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Wed, 29 Jul 2009 09:10:45 -0700
Message-ID: <6601abe90907290910x7cf1122cwac689d1f106326d3@mail.gmail.com>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:10019 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbZG2QKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jul 2009 12:10:48 -0400
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id n6TGAmD2005776
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 09:10:48 -0700
Received: from pzk2 (pzk2.prod.google.com [10.243.19.130])
	by zps19.corp.google.com with ESMTP id n6TGAj2W025684
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 09:10:46 -0700
Received: by pzk2 with SMTP id 2so44035pzk.30
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2009 09:10:45 -0700 (PDT)
In-Reply-To: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Although replying to self is somewhat bad etiquette...

I've found at least one issue with this patch:  Although the semantics
seem correct, since the late-converted-to-init extents are not merged
with neighbors, you can easily end up with thousands of extents :-( .
Each write to fallocate'd space results in its own initialized extent.

I'm not sure how expensive it would be to merge the extents when they
are converted to initialized after the DIO write goes through.

Curt


On Tue, Jul 28, 2009 at 5:28 PM, Curt Wohlgemuth<curtw@google.com> wrot=
e:
> This insures that direct IO writes to fallocate'd file space do not u=
se the
> page cache.
>
>
> =A0 =A0 =A0Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>
> ---
>
> I implemented Aneesh's ideas for this solution, but have some questio=
ns.
>
> I've verified that the page cache isn't =A0used, regardless of whethe=
r
> FALLOC_FL_KEEP_SIZE is used in the fallocate() call or not.
>
> The changes:
> =A0 - New inode state flag to indicate that a DIO write is ongoing
>
> =A0 - ext4_ext_convert_to_initialized() will mark any new extent it c=
reates
> =A0 =A0 as uninitialized, if this new EXT4_STATE_DIO_WRITE flag is se=
t.
>
> =A0 - ext4_direct_IO() will set this flag for any write.
>
> =A0 =A0 It now calls blockdev_direct_IO_own_locking() to do the I/O.
>
> =A0 =A0 After return from blockdev_direct_IO_own_locking() it clears =
the flag
> =A0 =A0 and calls a new routine to mark all extents containing the re=
turned
> =A0 =A0 blocks as initialized.
>
> I'm a bit uncertain about the use of DIO_OWN_LOCKING; I looked at the=
 XFS
> code to see if it acquired any other locks while using this flag, but=
 didn't
> see any. =A0Suggestions/corrections welcome.
>
>
> diff -Naur orig/fs/ext4/ext4.h new/fs/ext4/ext4.h
> --- orig/fs/ext4/ext4.h 2009-07-28 17:02:25.000000000 -0700
> +++ new/fs/ext4/ext4.h =A02009-07-28 17:02:19.000000000 -0700
> @@ -272,6 +272,7 @@
> =A0#define EXT4_STATE_XATTR =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x00000004 /*=
 has in-inode xattrs */
> =A0#define EXT4_STATE_NO_EXPAND =A0 =A0 =A0 =A0 =A0 0x00000008 /* No =
space for expansion */
> =A0#define EXT4_STATE_DA_ALLOC_CLOSE =A0 =A0 =A00x00000010 /* Alloc D=
A blks on close */
> +#define EXT4_STATE_DIO_WRITE =A0 =A0 =A0 =A0 =A0 0x00000020 /* This =
is a DIO write */
>
> =A0/* Used to pass group descriptor data when online resize is done *=
/
> =A0struct ext4_new_group_input {
> diff -Naur orig/fs/ext4/ext4_extents.h new/fs/ext4/ext4_extents.h
> --- orig/fs/ext4/ext4_extents.h 2009-07-28 17:02:40.000000000 -0700
> +++ new/fs/ext4/ext4_extents.h =A02009-07-28 17:02:34.000000000 -0700
> @@ -242,5 +242,7 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0ext4_lblk_t *, ext4_fsblk_t *);
> =A0extern void ext4_ext_drop_refs(struct ext4_ext_path *);
> =A0extern int ext4_ext_check_inode(struct inode *inode);
> +extern int ext4_ext_mark_extents_init(struct inode *inode, loff_t of=
fset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int nr_bytes);
> =A0#endif /* _EXT4_EXTENTS */
>
> diff -Naur orig/fs/ext4/extents.c new/fs/ext4/extents.c
> --- orig/fs/ext4/extents.c =A0 =A0 =A02009-07-28 17:02:54.000000000 -=
0700
> +++ new/fs/ext4/extents.c =A0 =A0 =A0 2009-07-28 17:02:49.000000000 -=
0700
> @@ -2563,6 +2563,13 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ex3->ee_block =3D cpu_=
to_le32(iblock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_store_pblock(=
ex3, newblock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ex3->ee_len =3D cpu_to=
_le16(allocated);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For direct I/O, we m=
ark this as uninitialized, and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* set it as initiali=
zed when we finish the direct
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* IO. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (EXT4_I(inode)->i_st=
ate & EXT4_STATE_DIO_WRITE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ex=
t_mark_uninitialized(ex3);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_ext_inser=
t_extent(handle, inode, path, ex3);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err =3D=3D -ENOSPC=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D=
 =A0ext4_ext_zeroout(inode, &orig_ex);
> @@ -2698,6 +2705,13 @@
> =A0 =A0 =A0 =A0ex2->ee_block =3D cpu_to_le32(iblock);
> =A0 =A0 =A0 =A0ext4_ext_store_pblock(ex2, newblock);
> =A0 =A0 =A0 =A0ex2->ee_len =3D cpu_to_le16(allocated);
> +
> + =A0 =A0 =A0 /* For direct I/O, we mark this as uninitialized, and
> + =A0 =A0 =A0 =A0* set it as initialized when we finish the direct
> + =A0 =A0 =A0 =A0* IO. */
> + =A0 =A0 =A0 if (EXT4_I(inode)->i_state & EXT4_STATE_DIO_WRITE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_mark_uninitialized(ex2);
> +
> =A0 =A0 =A0 =A0if (ex2 !=3D ex)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto insert;
> =A0 =A0 =A0 =A0/*
> @@ -2763,6 +2777,109 @@
> =A0 =A0 =A0 =A0return err;
> =A0}
>
> +
> +static int handle_uninit_extent(struct ext4_ext_path *path,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
inode *inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
ext4_extent *ex)
> +{
> + =A0 =A0 =A0 handle_t *handle;
> + =A0 =A0 =A0 int credits;
> + =A0 =A0 =A0 int started;
> + =A0 =A0 =A0 int depth =3D ext_depth(inode);
> + =A0 =A0 =A0 int ret =3D 0;
> +
> + =A0 =A0 =A0 if (ext4_ext_is_uninitialized(ex)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal_current_handle(=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 started =3D 0;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!handle) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 credits =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_chunk_t=
rans_blocks(inode, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle =3D ext4_journal=
_start(inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 credits);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 PTR_ERR(handle);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 started =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Mark as initialized */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex->ee_len =3D cpu_to_le16(ext4_ext_get=
_actual_len(ex));
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_ext_dirty(handle, inode, p=
ath + depth);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (started)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_stop(handl=
e);
> + =A0 =A0 =A0 }
> +out:
> + =A0 =A0 =A0 return ret;
> +}
> +
> +/* Called after direct I/O writes, to make sure that all extents are=
 marked
> + * as initialized. */
> +int ext4_ext_mark_extents_init(struct inode *inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t =
offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int nr_=
bytes)
> +{
> + =A0 =A0 =A0 struct ext4_ext_path *path =3D NULL;
> + =A0 =A0 =A0 struct ext4_extent *ex;
> + =A0 =A0 =A0 int depth;
> + =A0 =A0 =A0 int nr_blocks =3D nr_bytes >> inode->i_blkbits;
> + =A0 =A0 =A0 ext4_lblk_t first_block =3D offset >> inode->i_blkbits;
> + =A0 =A0 =A0 ext4_lblk_t block;
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 /* Handle the extent for the first block */
> + =A0 =A0 =A0 path =A0=3D ext4_ext_find_extent(inode, first_block, NU=
LL);
> + =A0 =A0 =A0 if (IS_ERR(path)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PTR_ERR(path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 depth =3D ext_depth(inode);
> + =A0 =A0 =A0 ex =A0 =A0=3D path[depth].p_ext;
> +
> + =A0 =A0 =A0 ret =3D handle_uninit_extent(path, inode, ex);
> + =A0 =A0 =A0 if (ret !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Check the rest of the blocks; if they're in differen=
t
> + =A0 =A0 =A0 =A0* extents, handle those as well. */
> + =A0 =A0 =A0 for (block =3D first_block + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0block < first_block + nr_blocks;
> + =A0 =A0 =A0 =A0 =A0 =A0block++) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Only look for new extents now */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (block >=3D ex->ee_block &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block <=
 (ex->ee_block + ex->ee_len))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_drop_refs(path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =A0=3D ext4_ext_find_extent(inode,=
 first_block, path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(path)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D PTR_ERR(path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 path =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 depth =3D ext_depth(inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ex =A0 =A0=3D path[depth].p_ext;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D handle_uninit_extent(path, inod=
e, ex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +out:
> + =A0 =A0 =A0 if (path) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_ext_drop_refs(path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(path);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return ret;
> +}
> +
> +
> =A0/*
> =A0* Block allocation/map/preallocation routine for extents based fil=
es
> =A0*
> diff -Naur orig/fs/ext4/inode.c new/fs/ext4/inode.c
> --- orig/fs/ext4/inode.c =A0 =A0 =A0 =A02009-07-28 17:02:04.000000000=
 -0700
> +++ new/fs/ext4/inode.c 2009-07-28 17:23:59.000000000 -0700
> @@ -3318,11 +3318,33 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ei->i_disksize =3D ino=
de->i_size;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_journal_stop(hand=
le);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This prevents initializing extents t=
oo early */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ei->i_flags & EXT4_EXTENTS_FL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ei->i_state |=3D EXT4_S=
TATE_DIO_WRITE;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ret =3D blockdev_direct_IO_own_locking(rw, iocb, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_sb->s_bdev, iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 offset, nr_segs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ext4_get_block, NULL);
> +
> + =A0 =A0 =A0 /* We now need to look at all extents for the blocks th=
at were
> + =A0 =A0 =A0 =A0* written out, and mark them as initialized. =A0Note=
 that they've
> + =A0 =A0 =A0 =A0* already been converted, simply not yet marked as i=
nit. */
> + =A0 =A0 =A0 if (rw =3D=3D WRITE && ei->i_flags & EXT4_EXTENTS_FL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON((ei->i_state & EXT4_STATE_DIO_WR=
ITE) =3D=3D 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ei->i_state |=3D ~EXT4_STATE_DIO_WRITE;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret2;
>
> - =A0 =A0 =A0 ret =3D blockdev_direct_IO(rw, iocb, inode, inode->i_sb=
->s_bdev, iov,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offs=
et, nr_segs,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4=
_get_block, NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret2 =3D ext4_ext_mark_=
extents_init(inode, offset, ret);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret2 !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 ret2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (orphan) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int err;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

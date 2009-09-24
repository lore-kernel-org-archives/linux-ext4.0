From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Wed, 23 Sep 2009 22:27:17 -0700
Message-ID: <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>
References: <1248389165.17459.3.camel@bobble.smo.corp.google.com>
	 <5df78e1d0908281444x556a7c2ey763dc6233820abc6@mail.gmail.com>
	 <20090828221432.GS4197@webber.adilger.int>
	 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
	 <20090830025250.GA25768@mit.edu>
	 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
	 <20090831215612.GG4197@webber.adilger.int>
	 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
	 <20090902084134.GO4197@webber.adilger.int>
	 <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Frank Mayhar <fmayhar@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:1452 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZIXF1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Sep 2009 01:27:17 -0400
Received: from wpaz1.hot.corp.google.com (wpaz1.hot.corp.google.com [172.24.198.65])
	by smtp-out.google.com with ESMTP id n8O5RKdh029482
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 22:27:20 -0700
Received: from pxi13 (pxi13.prod.google.com [10.243.27.13])
	by wpaz1.hot.corp.google.com with ESMTP id n8O5QDcL027784
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 22:27:17 -0700
Received: by pxi13 with SMTP id 13so1297750pxi.6
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 22:27:17 -0700 (PDT)
In-Reply-To: <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for taking so long to finish this. Here is the new patch based on
Andreas's suggestions. Now the patch clears the EXT4_EOFBLOCKS_FL
flag when we allocate beyond the maximum allocated block. I also
made the EOFBLOCKS flag user visible and added the handling
in ext4_ioctl as Andrea suggested.

Index: linux-2.6.30.5/fs/ext4/inode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.30.5.orig/fs/ext4/inode.c=A0=A0=A0 2009-08-31 12:08:10.00=
0000000 -0700
+++ linux-2.6.30.5/fs/ext4/inode.c=A0=A0=A0 2009-09-23 21:42:33.0000000=
00 -0700
@@ -3973,6 +3973,8 @@ void ext4_truncate(struct inode *inode)
=A0=A0=A0=A0 if (!ext4_can_truncate(inode))
=A0=A0=A0=A0 =A0=A0=A0 return;

+=A0=A0=A0 inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
+
=A0=A0=A0=A0 if (inode->i_size =3D=3D 0 && !test_opt(inode->i_sb, NO_AU=
TO_DA_ALLOC))
=A0=A0=A0=A0 =A0=A0=A0 ei->i_state |=3D EXT4_STATE_DA_ALLOC_CLOSE;

@@ -4285,8 +4287,8 @@ void ext4_get_inode_flags(struct ext4_in
=A0{
=A0=A0=A0=A0 unsigned int flags =3D ei->vfs_inode.i_flags;

-=A0=A0=A0 ei->i_flags &=3D ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
-=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_D=
IRSYNC_FL);
+=A0=A0=A0 ei->i_flags &=3D ~(EXT4_SYNC_FL|EXT4_APPEND_FL|EXT4_IMMUTABL=
E_FL|
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 EXT4_NOATIME_FL|EXT4_DIRSYNC_FL|EXT4_EOF=
BLOCKS_FL);
=A0=A0=A0=A0 if (flags & S_SYNC)
=A0=A0=A0=A0 =A0=A0=A0 ei->i_flags |=3D EXT4_SYNC_FL;
=A0=A0=A0=A0 if (flags & S_APPEND)
@@ -4297,6 +4299,8 @@ void ext4_get_inode_flags(struct ext4_in
=A0=A0=A0=A0 =A0=A0=A0 ei->i_flags |=3D EXT4_NOATIME_FL;
=A0=A0=A0=A0 if (flags & S_DIRSYNC)
=A0=A0=A0=A0 =A0=A0=A0 ei->i_flags |=3D EXT4_DIRSYNC_FL;
+=A0=A0=A0 if (flags & FS_EOFBLOCKS_FL)
+=A0=A0=A0 =A0=A0=A0 ei->i_flags |=3D EXT4_EOFBLOCKS_FL;
=A0}
=A0static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 struct ext4_inode_=
info *ei)
@@ -4807,7 +4811,9 @@ int ext4_setattr(struct dentry *dentry,
=A0=A0=A0=A0 }

=A0=A0=A0=A0 if (S_ISREG(inode->i_mode) &&
-=A0=A0=A0 =A0=A0=A0 attr->ia_valid & ATTR_SIZE && attr->ia_size < inod=
e->i_size) {
+=A0=A0=A0 =A0=A0=A0 attr->ia_valid & ATTR_SIZE &&
+=A0=A0=A0 =A0=A0=A0 (attr->ia_size < inode->i_size ||
+=A0=A0=A0 =A0=A0=A0=A0 (inode->i_flags & EXT4_EOFBLOCKS_FL))) {
=A0=A0=A0=A0 =A0=A0=A0 handle_t *handle;

=A0=A0=A0=A0 =A0=A0=A0 handle =3D ext4_journal_start(inode, 3);
@@ -4838,6 +4844,11 @@ int ext4_setattr(struct dentry *dentry,
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto err_out;
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
=A0=A0=A0=A0 =A0=A0=A0 }
+=A0=A0=A0 =A0=A0=A0 if ((inode->i_flags & EXT4_EOFBLOCKS_FL)) {
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 rc =3D vmtruncate(inode, attr->ia_size);
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (rc)
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto err_out;
+=A0=A0=A0 =A0=A0=A0 }
=A0=A0=A0=A0 }

=A0=A0=A0=A0 rc =3D inode_setattr(inode, attr);
Index: linux-2.6.30.5/include/linux/fs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.30.5.orig/include/linux/fs.h=A0=A0=A0 2009-08-31
12:08:10.000000000 -0700
+++ linux-2.6.30.5/include/linux/fs.h=A0=A0=A0 2009-09-10 21:27:30.0000=
00000 -0700
@@ -343,9 +343,10 @@ struct inodes_stat_t {
=A0#define FS_TOPDIR_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x00020000 /* Top =
of directory hierarchies*/
=A0#define FS_EXTENT_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x00080000 /* Exte=
nts */
=A0#define FS_DIRECTIO_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x00100000 /* Us=
e direct i/o */
+#define FS_EOFBLOCKS_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x00200000 /* Blo=
cks allocated beyond EOF */
=A0#define FS_RESERVED_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x80000000 /* re=
served for ext2 lib */

-#define FS_FL_USER_VISIBLE=A0=A0=A0 =A0=A0=A0 0x0003DFFF /* User visib=
le flags */
+#define FS_FL_USER_VISIBLE=A0=A0=A0 =A0=A0=A0 0x0023DFFF /* User visib=
le flags */
=A0#define FS_FL_USER_MODIFIABLE=A0=A0=A0 =A0=A0=A0 0x000380FF /* User =
modifiable flags */


Index: linux-2.6.30.5/fs/ext4/ext4.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.30.5.orig/fs/ext4/ext4.h=A0=A0=A0 2009-08-31 12:08:10.000=
000000 -0700
+++ linux-2.6.30.5/fs/ext4/ext4.h=A0=A0=A0 2009-09-10 21:28:14.00000000=
0 -0700
@@ -235,9 +235,10 @@ struct flex_groups {
=A0#define EXT4_HUGE_FILE_FL=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
0x00040000 /* Set to each huge file */
=A0#define EXT4_EXTENTS_FL=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 0x00080000 /* I=
node uses extents */
=A0#define EXT4_EXT_MIGRATE=A0=A0=A0 =A0=A0=A0 0x00100000 /* Inode is m=
igrating */
+#define EXT4_EOFBLOCKS_FL=A0=A0=A0 =A0=A0=A0 0x00200000 /* Blocks allo=
cated
beyond EOF (bit reserved in fs.h) */
=A0#define EXT4_RESERVED_FL=A0=A0=A0 =A0=A0=A0 0x80000000 /* reserved f=
or ext4 lib */

-#define EXT4_FL_USER_VISIBLE=A0=A0=A0 =A0=A0=A0 0x000BDFFF /* User vis=
ible flags */
+#define EXT4_FL_USER_VISIBLE=A0=A0=A0 =A0=A0=A0 0x002BDFFF /* User vis=
ible flags */
=A0#define EXT4_FL_USER_MODIFIABLE=A0=A0=A0 =A0=A0=A0 0x000B80FF /* Use=
r modifiable flags */

=A0/* Flags that should be inherited by new inodes from their parent. *=
/
Index: linux-2.6.30.5/fs/ext4/extents.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.30.5.orig/fs/ext4/extents.c=A0=A0=A0 2009-09-01 18:14:58.=
000000000 -0700
+++ linux-2.6.30.5/fs/ext4/extents.c=A0=A0=A0 2009-09-23 22:12:22.00000=
0000 -0700
@@ -2788,7 +2788,7 @@ int ext4_ext_get_blocks(handle_t *handle
=A0{
=A0=A0=A0=A0 struct ext4_ext_path *path =3D NULL;
=A0=A0=A0=A0 struct ext4_extent_header *eh;
-=A0=A0=A0 struct ext4_extent newex, *ex;
+=A0=A0=A0 struct ext4_extent newex, *ex, *last_ex;
=A0=A0=A0=A0 ext4_fsblk_t newblock;
=A0=A0=A0=A0 int err =3D 0, depth, ret, cache_type;
=A0=A0=A0=A0 unsigned int allocated =3D 0;
@@ -2968,6 +2968,14 @@ int ext4_ext_get_blocks(handle_t *handle
=A0=A0=A0=A0 newex.ee_len =3D cpu_to_le16(ar.len);
=A0=A0=A0=A0 if (create =3D=3D EXT4_CREATE_UNINITIALIZED_EXT)=A0 /* Mar=
k uninitialized */
=A0=A0=A0=A0 =A0=A0=A0 ext4_ext_mark_uninitialized(&newex);
+
+=A0=A0=A0 if (unlikely(inode->i_flags & EXT4_EOFBLOCKS_FL)) {
+=A0=A0=A0 =A0=A0=A0 BUG_ON(!eh->eh_entries);
+=A0=A0=A0 =A0=A0=A0 last_ex =3D EXT_LAST_EXTENT(eh);
+=A0=A0=A0 =A0=A0=A0 if (iblock + ar.len > le32_to_cpu(last_ex->ee_bloc=
k)
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 + ext4_ext_get_actua=
l_len(last_ex))
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
+=A0=A0=A0 }
=A0=A0=A0=A0 err =3D ext4_ext_insert_extent(handle, inode, path, &newex=
);
=A0=A0=A0=A0 if (err) {
=A0=A0=A0=A0 =A0=A0=A0 /* free data blocks we just allocated */
@@ -3095,6 +3103,13 @@ static void ext4_falloc_update_inode(str
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 i_size_write(inode, new_size);
=A0=A0=A0=A0 =A0=A0=A0 if (new_size > EXT4_I(inode)->i_disksize)
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ext4_update_i_disksize(inode, new_size=
);
+=A0=A0=A0 } else {
+=A0=A0=A0 =A0=A0=A0 /*
+=A0=A0=A0 =A0=A0=A0 =A0* Mark that we allocate beyond EOF so the subse=
quent truncate
+=A0=A0=A0 =A0=A0=A0 =A0* can proceed even if the new size is the same =
as i_size.
+=A0=A0=A0 =A0=A0=A0 =A0*/
+=A0=A0=A0 =A0=A0=A0 if (new_size > i_size_read(inode))
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 inode->i_flags |=3D EXT4_EOFBLOCKS_FL;
=A0=A0=A0=A0 }
=A0}

Index: linux-2.6.30.5/fs/ext4/ioctl.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.30.5.orig/fs/ext4/ioctl.c=A0=A0=A0 2009-08-16 14:19:38.00=
0000000 -0700
+++ linux-2.6.30.5/fs/ext4/ioctl.c=A0=A0=A0 2009-09-23 22:04:47.0000000=
00 -0700
@@ -92,6 +92,16 @@ long ext4_ioctl(struct file *filp, unsig
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 flags &=3D ~EXT4_EXTENTS_FL;
=A0=A0=A0=A0 =A0=A0=A0 }

+=A0=A0=A0 =A0=A0=A0 if (flags & EXT4_EOFBLOCKS_FL) {
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* we don't support adding EOFBLOCKS fla=
g */
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D -EOPNOTSUPP;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 goto flags_out;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 }
+=A0=A0=A0 =A0=A0=A0 } else if (oldflags & EXT4_EOFBLOCKS_FL)
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 /* free the space reserved with fallocat=
e KEEPSIZE */
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 vmtruncate(inode, inode->i_size);
+
=A0=A0=A0=A0 =A0=A0=A0 handle =3D ext4_journal_start(inode, 1);
=A0=A0=A0=A0 =A0=A0=A0 if (IS_ERR(handle)) {
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 err =3D PTR_ERR(handle);


Jiaying

On Wed, Sep 2, 2009 at 10:20 PM, Jiaying Zhang <jiayingz@google.com> wr=
ote:
>
> On Wed, Sep 2, 2009 at 1:41 AM, Andreas Dilger<adilger@sun.com> wrote=
:
> > On Aug 31, 2009 =A016:33 -0700, Jiaying Zhang wrote:
> >> > EXT4_KEEPSIZE_FL should only be cleared if there were writes to
> >> > the end of the fallocated space. =A0In that regard, I think the =
name
> >> > of this flag should be changed to something like "EXT4_EOFBLOCKS=
_FL"
> >> > to indicate that blocks are allocated beyond the end of file (i_=
size).
> >>
> >> Thanks for catching this! I changed the patch to only clear the fl=
ag
> >> when the new_size is larger than i_size and changed the flag name
> >> as you suggested. It would be nice if we only clear the flag when =
we
> >> write beyond the fallocated space, but this seems hard to detect
> >> because we no longer have the allocated size once that keepsize
> >> fallocate call returns.
> >
> > The problem is that if e2fsck depends on the EXT4_EOFBLOCKS_FL set
> > for fallocate-beyond-EOF then it is worse to clear it than to leave
> > it set. =A0At worst, leaving the flag set results in too many trunc=
ates
> > on the file. =A0Clearing the flag when not correct may result in us=
er
> > visible data corruption if the file size is extended...
> >
> >> Here is the new patch:
> >>
> >> --- .pc/fallocate_keepsizse.patch/fs/ext4/extents.c =A0 2009-08-31
> >> 12:08:10.000000000 -0700
> >> +++ fs/ext4/extents.c 2009-08-31 15:51:13.000000000 -0700
> >> @@ -3091,11 +3091,19 @@ static void ext4_falloc_update_inode(str
> >> =A0 =A0 =A0 =A0* the file size.
> >> =A0 =A0 =A0 =A0*/
> >> =A0 =A0 =A0 if (!(mode & FALLOC_FL_KEEP_SIZE)) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (new_size > i_size_read(inode)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(inode, ne=
w_size);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_flags &=3D ~EXT=
4_EOFBLOCKS_FL;
> >
> > This again isn't quite correct, since the EOFBLOCKS_FL shouldn't
> > be cleared unless new_size is beyond the allocated size. =A0The
> > allocation code itself might be a better place to clear this,
> > since it knows whether there were new blocks being added beyond
> > the current max allocated block.
>
> We were thinking to clear this flag when we need to allocate new
> blocks, but I was not sure how to get the current max allocated
> block -- that is mostly because I just started working on the ext4
> code. After digging into the ext4 allocation code today, I think we
> can put the check&clear in ext4_ext_get_blocks:
>
> @@ -2968,6 +2968,14 @@ int ext4_ext_get_blocks(handle_t *handle
> =A0 =A0 =A0 =A0newex.ee_len =3D cpu_to_le16(ar.len);
> =A0 =A0 =A0 =A0if (create =3D=3D EXT4_CREATE_UNINITIALIZED_EXT) =A0/*=
 Mark uninitialized */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_mark_uninitialized(&newex);
> +
> + =A0 =A0 =A0 if (unlikely(inode->i_flags & EXT4_EOFBLOCKS_FL)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(!eh->eh_entries);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 last_ex =3D EXT_LAST_EXTENT(eh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iblock + max_blocks > le32_to_cpu(l=
ast_ex->ee_block)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 + ext4_ext_get_actual_len(last_ex))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_flags &=3D ~EX=
T4_EOFBLOCKS_FL;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0err =3D ext4_ext_insert_extent(handle, inode, path, &n=
ewex);
> =A0 =A0 =A0 =A0if (err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* free data blocks we just allocated =
*/
>
> Again, I just started looking at this part of code, so please let me =
know
> if I am in the right direction.
>
> Another thing I am not sure is whether we can allocate a non-data blo=
ck,
> like extended attributes, beyond the current max block without changi=
ng
> the i_size. In that case, clearing the EOFBLOCKS flag will be wrong.
>
> >> =A0#define FS_FL_USER_VISIBLE =A0 =A0 =A0 =A0 =A0 0x0003DFFF /* Us=
er visible flags */
> >
> > It probably isn't a bad idea to make this flag user-visible, since =
it
> > would allow scanning for files that have excess space reserved (e.g=
=2E
> > if the filesystem is getting full). =A0Making it user-settable (i.e=
=2E
> > clearable) would essentially mean truncating the file to i_size wit=
hout
> > updating the timestamps so that the reserved space is discarded. =A0=
I
> > don't think there is any value in allowing a user to turn this flag=
 on
> > for a file.
>
> So to make it user-settable, we need to add the handling in ext4_ioct=
l
> that calls vmtruncate when the flag to be cleared. But how can we get
> the right size to truncate in that case? Can we just set that to the
> max initialized block shift with block size? But that may also trunca=
te
> the blocks reserved without the KEEP_SIZE flag.
>
> Jiaying
>
> >
> > Cheers, Andreas
> > --
> > Andreas Dilger
> > Sr. Staff Engineer, Lustre Group
> > Sun Microsystems of Canada, Inc.
> >
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Tue, 29 Sep 2009 12:38:29 -0700
Message-ID: <5df78e1d0909291238q44bbf9e8q98205ffa9b6b2518@mail.gmail.com>
References: <1248389165.17459.3.camel@bobble.smo.corp.google.com>
	 <5df78e1d0908281740w7bc0f283x5004ca5b231b3af5@mail.gmail.com>
	 <20090830025250.GA25768@mit.edu>
	 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
	 <20090831215612.GG4197@webber.adilger.int>
	 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
	 <20090902084134.GO4197@webber.adilger.int>
	 <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com>
	 <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>
	 <4AC25CCB.8050805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@mit.edu>,
	Frank Mayhar <fmayhar@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:32011 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbZI2Ti2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Sep 2009 15:38:28 -0400
Received: from zps18.corp.google.com (zps18.corp.google.com [172.25.146.18])
	by smtp-out.google.com with ESMTP id n8TJcW57002758
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2009 12:38:32 -0700
Received: from pzk30 (pzk30.prod.google.com [10.243.19.158])
	by zps18.corp.google.com with ESMTP id n8TJaqh0026946
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2009 12:38:30 -0700
Received: by pzk30 with SMTP id 30so3448164pzk.24
        for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2009 12:38:29 -0700 (PDT)
In-Reply-To: <4AC25CCB.8050805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 29, 2009 at 12:15 PM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> Jiaying Zhang wrote:
>> Sorry for taking so long to finish this. Here is the new patch based=
 on
>> Andreas's suggestions. Now the patch clears the EXT4_EOFBLOCKS_FL
>> flag when we allocate beyond the maximum allocated block. I also
>> made the EOFBLOCKS flag user visible and added the handling
>> in ext4_ioctl as Andrea suggested.
>
> I was testing this a bit in xfstests, with test 083 (recently I sent =
a
> patch to the xfs list to let that test run on generic filesystems) wh=
ich
> runs fsstress on a small-ish 100M fs, and that fsstress does space
> preallocation (on newer kernels, where the older xfs ioctls are hooke=
d
> up to do_fallocate in a generic fashion).

Does the fsstress use fallocate with KEEP_SIZE?

>
> I'm actually seeing more corruption w/ this patch than without it,
> though I don't yet see why. =A0I'll double check that it applied prop=
erly,
> since this was against 2.6.30.5....

Do you want me to port my changes to the latest ext4 git tree?
I should have done so at the beginning.

>
> Also it strikes me as a little odd to allow clearing of the EOF Flag
> from userspace, and the subsequent discarding of the blocks past EOF.
>
> Doesn't truncating to i_size do exactly the same thing, in a more
> portable way? =A0Why make a new interface unique to ext4?

As Andreas suggested, I think the main purpose is to allow users
to scan for any files with EOF flag with the getflag ioctl. We may
not allow users to clear it with the setflag ioctl but just rely on
the truncate interface, but supporting the setflag ioctl interface
doesn't seem to do any harm.

Jiaying

>
> -Eric
>
>> Index: linux-2.6.30.5/fs/ext4/inode.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-2.6.30.5.orig/fs/ext4/inode.c =A0 =A02009-08-31 12:08:10.0=
00000000 -0700
>> +++ linux-2.6.30.5/fs/ext4/inode.c =A0 =A02009-09-23 21:42:33.000000=
000 -0700
>> @@ -3973,6 +3973,8 @@ void ext4_truncate(struct inode *inode)
>> =A0 =A0 =A0if (!ext4_can_truncate(inode))
>> =A0 =A0 =A0 =A0 =A0return;
>>
>> + =A0 =A0inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
>> +
>> =A0 =A0 =A0if (inode->i_size =3D=3D 0 && !test_opt(inode->i_sb, NO_A=
UTO_DA_ALLOC))
>> =A0 =A0 =A0 =A0 =A0ei->i_state |=3D EXT4_STATE_DA_ALLOC_CLOSE;
>>
>> @@ -4285,8 +4287,8 @@ void ext4_get_inode_flags(struct ext4_in
>> =A0{
>> =A0 =A0 =A0unsigned int flags =3D ei->vfs_inode.i_flags;
>>
>> - =A0 =A0ei->i_flags &=3D ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
>> - =A0 =A0 =A0 =A0 =A0 =A0EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRS=
YNC_FL);
>> + =A0 =A0ei->i_flags &=3D ~(EXT4_SYNC_FL|EXT4_APPEND_FL|EXT4_IMMUTAB=
LE_FL|
>> + =A0 =A0 =A0 =A0 =A0 =A0EXT4_NOATIME_FL|EXT4_DIRSYNC_FL|EXT4_EOFBLO=
CKS_FL);
>> =A0 =A0 =A0if (flags & S_SYNC)
>> =A0 =A0 =A0 =A0 =A0ei->i_flags |=3D EXT4_SYNC_FL;
>> =A0 =A0 =A0if (flags & S_APPEND)
>> @@ -4297,6 +4299,8 @@ void ext4_get_inode_flags(struct ext4_in
>> =A0 =A0 =A0 =A0 =A0ei->i_flags |=3D EXT4_NOATIME_FL;
>> =A0 =A0 =A0if (flags & S_DIRSYNC)
>> =A0 =A0 =A0 =A0 =A0ei->i_flags |=3D EXT4_DIRSYNC_FL;
>> + =A0 =A0if (flags & FS_EOFBLOCKS_FL)
>> + =A0 =A0 =A0 =A0ei->i_flags |=3D EXT4_EOFBLOCKS_FL;
>> =A0}
>> =A0static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ext4_inode_info *e=
i)
>> @@ -4807,7 +4811,9 @@ int ext4_setattr(struct dentry *dentry,
>> =A0 =A0 =A0}
>>
>> =A0 =A0 =A0if (S_ISREG(inode->i_mode) &&
>> - =A0 =A0 =A0 =A0attr->ia_valid & ATTR_SIZE && attr->ia_size < inode=
->i_size) {
>> + =A0 =A0 =A0 =A0attr->ia_valid & ATTR_SIZE &&
>> + =A0 =A0 =A0 =A0(attr->ia_size < inode->i_size ||
>> + =A0 =A0 =A0 =A0 (inode->i_flags & EXT4_EOFBLOCKS_FL))) {
>> =A0 =A0 =A0 =A0 =A0handle_t *handle;
>>
>> =A0 =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, 3);
>> @@ -4838,6 +4844,11 @@ int ext4_setattr(struct dentry *dentry,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_out;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0 =A0}
>> + =A0 =A0 =A0 =A0if ((inode->i_flags & EXT4_EOFBLOCKS_FL)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0rc =3D vmtruncate(inode, attr->ia_size);
>> + =A0 =A0 =A0 =A0 =A0 =A0if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_out;
>> + =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0}
>>
>> =A0 =A0 =A0rc =3D inode_setattr(inode, attr);
>> Index: linux-2.6.30.5/include/linux/fs.h
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-2.6.30.5.orig/include/linux/fs.h =A0 =A02009-08-31
>> 12:08:10.000000000 -0700
>> +++ linux-2.6.30.5/include/linux/fs.h =A0 =A02009-09-10 21:27:30.000=
000000 -0700
>> @@ -343,9 +343,10 @@ struct inodes_stat_t {
>> =A0#define FS_TOPDIR_FL =A0 =A0 =A0 =A0 =A0 =A00x00020000 /* Top of =
directory hierarchies*/
>> =A0#define FS_EXTENT_FL =A0 =A0 =A0 =A0 =A0 =A00x00080000 /* Extents=
 */
>> =A0#define FS_DIRECTIO_FL =A0 =A0 =A0 =A0 =A0 =A00x00100000 /* Use d=
irect i/o */
>> +#define FS_EOFBLOCKS_FL =A0 =A0 =A0 =A0 =A0 =A00x00200000 /* Blocks=
 allocated beyond EOF */
>> =A0#define FS_RESERVED_FL =A0 =A0 =A0 =A0 =A0 =A00x80000000 /* reser=
ved for ext2 lib */
>>
>> -#define FS_FL_USER_VISIBLE =A0 =A0 =A0 =A00x0003DFFF /* User visibl=
e flags */
>> +#define FS_FL_USER_VISIBLE =A0 =A0 =A0 =A00x0023DFFF /* User visibl=
e flags */
>> =A0#define FS_FL_USER_MODIFIABLE =A0 =A0 =A0 =A00x000380FF /* User m=
odifiable flags */
>>
>>
>> Index: linux-2.6.30.5/fs/ext4/ext4.h
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-2.6.30.5.orig/fs/ext4/ext4.h =A0 =A02009-08-31 12:08:10.00=
0000000 -0700
>> +++ linux-2.6.30.5/fs/ext4/ext4.h =A0 =A02009-09-10 21:28:14.0000000=
00 -0700
>> @@ -235,9 +235,10 @@ struct flex_groups {
>> =A0#define EXT4_HUGE_FILE_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x00040000 =
/* Set to each huge file */
>> =A0#define EXT4_EXTENTS_FL =A0 =A0 =A0 =A0 =A0 =A00x00080000 /* Inod=
e uses extents */
>> =A0#define EXT4_EXT_MIGRATE =A0 =A0 =A0 =A00x00100000 /* Inode is mi=
grating */
>> +#define EXT4_EOFBLOCKS_FL =A0 =A0 =A0 =A00x00200000 /* Blocks alloc=
ated
>> beyond EOF (bit reserved in fs.h) */
>> =A0#define EXT4_RESERVED_FL =A0 =A0 =A0 =A00x80000000 /* reserved fo=
r ext4 lib */
>>
>> -#define EXT4_FL_USER_VISIBLE =A0 =A0 =A0 =A00x000BDFFF /* User visi=
ble flags */
>> +#define EXT4_FL_USER_VISIBLE =A0 =A0 =A0 =A00x002BDFFF /* User visi=
ble flags */
>> =A0#define EXT4_FL_USER_MODIFIABLE =A0 =A0 =A0 =A00x000B80FF /* User=
 modifiable flags */
>>
>> =A0/* Flags that should be inherited by new inodes from their parent=
=2E */
>> Index: linux-2.6.30.5/fs/ext4/extents.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-2.6.30.5.orig/fs/ext4/extents.c =A0 =A02009-09-01 18:14:58=
=2E000000000 -0700
>> +++ linux-2.6.30.5/fs/ext4/extents.c =A0 =A02009-09-23 22:12:22.0000=
00000 -0700
>> @@ -2788,7 +2788,7 @@ int ext4_ext_get_blocks(handle_t *handle
>> =A0{
>> =A0 =A0 =A0struct ext4_ext_path *path =3D NULL;
>> =A0 =A0 =A0struct ext4_extent_header *eh;
>> - =A0 =A0struct ext4_extent newex, *ex;
>> + =A0 =A0struct ext4_extent newex, *ex, *last_ex;
>> =A0 =A0 =A0ext4_fsblk_t newblock;
>> =A0 =A0 =A0int err =3D 0, depth, ret, cache_type;
>> =A0 =A0 =A0unsigned int allocated =3D 0;
>> @@ -2968,6 +2968,14 @@ int ext4_ext_get_blocks(handle_t *handle
>> =A0 =A0 =A0newex.ee_len =3D cpu_to_le16(ar.len);
>> =A0 =A0 =A0if (create =3D=3D EXT4_CREATE_UNINITIALIZED_EXT) =A0/* Ma=
rk uninitialized */
>> =A0 =A0 =A0 =A0 =A0ext4_ext_mark_uninitialized(&newex);
>> +
>> + =A0 =A0if (unlikely(inode->i_flags & EXT4_EOFBLOCKS_FL)) {
>> + =A0 =A0 =A0 =A0BUG_ON(!eh->eh_entries);
>> + =A0 =A0 =A0 =A0last_ex =3D EXT_LAST_EXTENT(eh);
>> + =A0 =A0 =A0 =A0if (iblock + ar.len > le32_to_cpu(last_ex->ee_block=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+ ext4_ext_get_actual_len(l=
ast_ex))
>> + =A0 =A0 =A0 =A0 =A0 =A0inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
>> + =A0 =A0}
>> =A0 =A0 =A0err =3D ext4_ext_insert_extent(handle, inode, path, &newe=
x);
>> =A0 =A0 =A0if (err) {
>> =A0 =A0 =A0 =A0 =A0/* free data blocks we just allocated */
>> @@ -3095,6 +3103,13 @@ static void ext4_falloc_update_inode(str
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0i_size_write(inode, new_size);
>> =A0 =A0 =A0 =A0 =A0if (new_size > EXT4_I(inode)->i_disksize)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_update_i_disksize(inode, new_size);
>> + =A0 =A0} else {
>> + =A0 =A0 =A0 =A0/*
>> + =A0 =A0 =A0 =A0 * Mark that we allocate beyond EOF so the subseque=
nt truncate
>> + =A0 =A0 =A0 =A0 * can proceed even if the new size is the same as =
i_size.
>> + =A0 =A0 =A0 =A0 */
>> + =A0 =A0 =A0 =A0if (new_size > i_size_read(inode))
>> + =A0 =A0 =A0 =A0 =A0 =A0inode->i_flags |=3D EXT4_EOFBLOCKS_FL;
>> =A0 =A0 =A0}
>> =A0}
>>
>> Index: linux-2.6.30.5/fs/ext4/ioctl.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-2.6.30.5.orig/fs/ext4/ioctl.c =A0 =A02009-08-16 14:19:38.0=
00000000 -0700
>> +++ linux-2.6.30.5/fs/ext4/ioctl.c =A0 =A02009-09-23 22:04:47.000000=
000 -0700
>> @@ -92,6 +92,16 @@ long ext4_ioctl(struct file *filp, unsig
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0flags &=3D ~EXT4_EXTENTS_FL;
>> =A0 =A0 =A0 =A0 =A0}
>>
>> + =A0 =A0 =A0 =A0if (flags & EXT4_EOFBLOCKS_FL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0/* we don't support adding EOFBLOCKS flag *=
/
>> + =A0 =A0 =A0 =A0 =A0 =A0if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D -EOPNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto flags_out;
>> + =A0 =A0 =A0 =A0 =A0 =A0}
>> + =A0 =A0 =A0 =A0} else if (oldflags & EXT4_EOFBLOCKS_FL)
>> + =A0 =A0 =A0 =A0 =A0 =A0/* free the space reserved with fallocate K=
EEPSIZE */
>> + =A0 =A0 =A0 =A0 =A0 =A0vmtruncate(inode, inode->i_size);
>> +
>> =A0 =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, 1);
>> =A0 =A0 =A0 =A0 =A0if (IS_ERR(handle)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D PTR_ERR(handle);
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

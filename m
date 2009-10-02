From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Fri, 2 Oct 2009 15:10:43 -0700
Message-ID: <5df78e1d0910021510g3f32485bva30e08cf00c8682a@mail.gmail.com>
References: <1248389165.17459.3.camel@bobble.smo.corp.google.com>
	 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
	 <20090831215612.GG4197@webber.adilger.int>
	 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
	 <20090902084134.GO4197@webber.adilger.int>
	 <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com>
	 <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>
	 <4AC25CCB.8050805@redhat.com>
	 <5df78e1d0909291238q44bbf9e8q98205ffa9b6b2518@mail.gmail.com>
	 <4AC26630.6030509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@mit.edu>,
	Frank Mayhar <fmayhar@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:2962 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbZJBWKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Oct 2009 18:10:44 -0400
Received: from wpaz5.hot.corp.google.com (wpaz5.hot.corp.google.com [172.24.198.69])
	by smtp-out.google.com with ESMTP id n92MAkMY022908
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 23:10:47 +0100
Received: from pxi13 (pxi13.prod.google.com [10.243.27.13])
	by wpaz5.hot.corp.google.com with ESMTP id n92MAhuG018476
	for <linux-ext4@vger.kernel.org>; Fri, 2 Oct 2009 15:10:44 -0700
Received: by pxi13 with SMTP id 13so1549706pxi.6
        for <linux-ext4@vger.kernel.org>; Fri, 02 Oct 2009 15:10:43 -0700 (PDT)
In-Reply-To: <4AC26630.6030509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46YI, here is my patch synced with the latest ext4-git tree:

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9a99672..2a3d043 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -284,10 +284,11 @@ struct flex_groups {
 #define EXT4_TOPDIR_FL                 0x00020000 /* Top of directory
hierarchies*/
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge=
 file */
 #define EXT4_EXTENTS_FL                        0x00080000 /* Inode
uses extents */
+#define EXT4_EOFBLOCKS_FL              0x00400000 /* Blocks allocated
beyond EOF (bit reserved in fs.h) */
 #define EXT4_RESERVED_FL               0x80000000 /* reserved for ext4=
 lib */

-#define EXT4_FL_USER_VISIBLE           0x000BDFFF /* User visible flag=
s */
-#define EXT4_FL_USER_MODIFIABLE                0x000B80FF /* User
modifiable flags */
+#define EXT4_FL_USER_VISIBLE           0x004BDFFF /* User visible flag=
s */
+#define EXT4_FL_USER_MODIFIABLE                0x004B80FF /* User
modifiable flags */

 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_F=
L |\
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10539e3..3972f88 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3131,7 +3131,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct
inode *inode,
 {
        struct ext4_ext_path *path =3D NULL;
        struct ext4_extent_header *eh;
-       struct ext4_extent newex, *ex;
+       struct ext4_extent newex, *ex, *last_ex;
        ext4_fsblk_t newblock;
        int err =3D 0, depth, ret, cache_type;
        unsigned int allocated =3D 0;
@@ -3300,6 +3300,14 @@ int ext4_ext_get_blocks(handle_t *handle,
struct inode *inode,
                if (io && flags =3D=3D EXT4_GET_BLOCKS_DIO_CREATE_EXT)
                        io->flag =3D DIO_AIO_UNWRITTEN;
        }
+
+       if (unlikely(inode->i_flags & EXT4_EOFBLOCKS_FL)) {
+               BUG_ON(!eh->eh_entries);
+               last_ex =3D EXT_LAST_EXTENT(eh);
+               if (iblock + ar.len > le32_to_cpu(last_ex->ee_block)
+                                       + ext4_ext_get_actual_len(last_=
ex))
+                       inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
+       }
        err =3D ext4_ext_insert_extent(handle, inode, path, &newex, fla=
gs);
        if (err) {
                /* free data blocks we just allocated */
@@ -3418,6 +3426,13 @@ static void ext4_falloc_update_inode(struct inod=
e *inode,
                        i_size_write(inode, new_size);
                if (new_size > EXT4_I(inode)->i_disksize)
                        ext4_update_i_disksize(inode, new_size);
+       } else {
+               /*
+                * Mark that we allocate beyond EOF so the subsequent t=
runcate
+                * can proceed even if the new size is the same as i_si=
ze.
+                */
+               if (new_size > i_size_read(inode))
+                       inode->i_flags |=3D EXT4_EOFBLOCKS_FL;
        }

 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f246b43..1d1857d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4620,6 +4620,8 @@ void ext4_truncate(struct inode *inode)
        if (!ext4_can_truncate(inode))
                return;

+       inode->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
+
        if (inode->i_size =3D=3D 0 && !test_opt(inode->i_sb, NO_AUTO_DA=
_ALLOC))
                ei->i_state |=3D EXT4_STATE_DA_ALLOC_CLOSE;

@@ -4932,8 +4934,8 @@ void ext4_get_inode_flags(struct ext4_inode_info =
*ei)
 {
        unsigned int flags =3D ei->vfs_inode.i_flags;

-       ei->i_flags &=3D ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
-                       EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_=
=46L);
+       ei->i_flags &=3D ~(EXT4_SYNC_FL|EXT4_APPEND_FL|EXT4_IMMUTABLE_F=
L|
+                       EXT4_NOATIME_FL|EXT4_DIRSYNC_FL|EXT4_EOFBLOCKS_=
=46L);
        if (flags & S_SYNC)
                ei->i_flags |=3D EXT4_SYNC_FL;
        if (flags & S_APPEND)
@@ -4944,6 +4946,8 @@ void ext4_get_inode_flags(struct ext4_inode_info =
*ei)
                ei->i_flags |=3D EXT4_NOATIME_FL;
        if (flags & S_DIRSYNC)
                ei->i_flags |=3D EXT4_DIRSYNC_FL;
+       if (flags & FS_EOFBLOCKS_FL)
+               ei->i_flags |=3D EXT4_EOFBLOCKS_FL;
 }

 static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
@@ -5453,7 +5457,9 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
        }

        if (S_ISREG(inode->i_mode) &&
-           attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size=
) {
+           attr->ia_valid & ATTR_SIZE &&
+           (attr->ia_size < inode->i_size ||
+            (inode->i_flags & EXT4_EOFBLOCKS_FL))) {
                handle_t *handle;

                handle =3D ext4_journal_start(inode, 3);
@@ -5484,6 +5490,11 @@ int ext4_setattr(struct dentry *dentry, struct
iattr *attr)
                                goto err_out;
                        }
                }
+               if ((inode->i_flags & EXT4_EOFBLOCKS_FL)) {
+                       rc =3D vmtruncate(inode, attr->ia_size);
+                       if (rc)
+                               goto err_out;
+               }
        }

        rc =3D inode_setattr(inode, attr);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d1fe495..e7c543d 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -104,6 +104,16 @@ long ext4_ioctl(struct file *filp, unsigned int
cmd, unsigned long arg)
                        flags &=3D ~EXT4_EXTENTS_FL;
                }

+               if (flags & EXT4_EOFBLOCKS_FL) {
+                       /* we don't support adding EOFBLOCKS flag */
+                       if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
+                               err =3D -EOPNOTSUPP;
+                               goto flags_out;
+                       }
+               } else if (oldflags & EXT4_EOFBLOCKS_FL)
+                       /* free the space reserved with fallocate KEEPS=
IZE */
+                       vmtruncate(inode, inode->i_size);
+
                handle =3D ext4_journal_start(inode, 1);
                if (IS_ERR(handle)) {
                        err =3D PTR_ERR(handle);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2adaa25..7b3f0df 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -343,10 +343,11 @@ struct inodes_stat_t {
 #define FS_TOPDIR_FL                   0x00020000 /* Top of directory
hierarchies*/
 #define FS_EXTENT_FL                   0x00080000 /* Extents */
 #define FS_DIRECTIO_FL                 0x00100000 /* Use direct i/o */
+#define FS_EOFBLOCKS_FL                        0x00400000 /* Blocks
allocated beyond EOF */
 #define FS_RESERVED_FL                 0x80000000 /* reserved for ext2=
 lib */

-#define FS_FL_USER_VISIBLE             0x0003DFFF /* User visible flag=
s */
-#define FS_FL_USER_MODIFIABLE          0x000380FF /* User modifiable f=
lags */
+#define FS_FL_USER_VISIBLE             0x0043DFFF /* User visible flag=
s */
+#define FS_FL_USER_MODIFIABLE          0x004380FF /* User modifiable f=
lags */


 #define SYNC_FILE_RANGE_WAIT_BEFORE    1

Jiaying

On Tue, Sep 29, 2009 at 12:55 PM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> Jiaying Zhang wrote:
>> On Tue, Sep 29, 2009 at 12:15 PM, Eric Sandeen <sandeen@redhat.com> =
wrote:
>>> Jiaying Zhang wrote:
>>>> Sorry for taking so long to finish this. Here is the new patch bas=
ed on
>>>> Andreas's suggestions. Now the patch clears the EXT4_EOFBLOCKS_FL
>>>> flag when we allocate beyond the maximum allocated block. I also
>>>> made the EOFBLOCKS flag user visible and added the handling
>>>> in ext4_ioctl as Andrea suggested.
>>> I was testing this a bit in xfstests, with test 083 (recently I sen=
t a
>>> patch to the xfs list to let that test run on generic filesystems) =
which
>>> runs fsstress on a small-ish 100M fs, and that fsstress does space
>>> preallocation (on newer kernels, where the older xfs ioctls are hoo=
ked
>>> up to do_fallocate in a generic fashion).
>>
>> Does the fsstress use fallocate with KEEP_SIZE?
>
> Effectively, yes. =A0 It uses the compatible xfs ioctls, which calls
> do_fallocate with KEEP_SIZE.
>
>>> I'm actually seeing more corruption w/ this patch than without it,
>>> though I don't yet see why. =A0I'll double check that it applied pr=
operly,
>>> since this was against 2.6.30.5....
>>
>> Do you want me to port my changes to the latest ext4 git tree?
>> I should have done so at the beginning.
>
> Sure :)
>
>>> Also it strikes me as a little odd to allow clearing of the EOF Fla=
g
>>> from userspace, and the subsequent discarding of the blocks past EO=
=46.
>>>
>>> Doesn't truncating to i_size do exactly the same thing, in a more
>>> portable way? =A0Why make a new interface unique to ext4?
>>
>> As Andreas suggested, I think the main purpose is to allow users
>> to scan for any files with EOF flag with the getflag ioctl. We may
>> not allow users to clear it with the setflag ioctl but just rely on
>> the truncate interface, but supporting the setflag ioctl interface
>> doesn't seem to do any harm.
>
> I like the idea of being able to find them, but adding the clearing
> interface seems redundant to me. =A0All filesystems would need to
> implement this, and I don't see that we gain anything.
>
> Thanks,
> -Eric
>
>> Jiaying
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] libext2fs: reserve exclude bitmap fields in group descriptor
Date: Thu, 15 Sep 2011 09:50:20 +0300
Message-ID: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47522 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab1IOGuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 02:50:21 -0400
Received: by wwf22 with SMTP id 22so3251477wwf.1
        for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 23:50:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 1:14 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Sep 14, 2011 at 01:59:06PM -0600, Andreas Dilger wrote:
>>
>> There is the field that you told Amir he could use for the exception
>> bitmap for snapshots, which is using one of the two reserved fields =
in
>> ext2_group_desc, and also one of the 3 reserved fields in ext4_group=
_desc
>> for 64-bit block numbers. =A0That leaves one __u32 in ext2_group_des=
c, and
>> two __u32 in ext4_group_desc for checksums.
>
> Right, that's what I was forgetting. =A0Thanks for reminding me!
>

Thanks Andreas for reminding!
Here is a patch to reserve the exclude bitmap field, so we won't
forget them again...
The full patch series for adding exclude bitmap can be found here:
https://github.com/amir73il/e2fsprogs-snapshots-patch-queue

---
=46rom: Amir Goldstein <amir73il@users.sf.net>
Date: Thu, 15 Sep 2011 09:42:38 +0300

Ext4 snapshots require the compatible feature 'exclude_bitmap', meaning=
 that
the exclude bitmap was allocated.
The allocated exclude bitmap blocks are stored in the block group descr=
iptors.

To allow easy migration of existing Next3 installations, I took the lib=
erty
of 'burning' the old 'exclude_inode' compatible flag and using a new
'exclude_bitmap' comaptible flag, to state the exclude bitmap blocks ar=
e stored
in the group descriptors.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 lib/ext2fs/ext2_fs.h |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 54cb3d4..f1f0e19 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -142,7 +142,8 @@ struct ext2_group_desc
        __u16   bg_free_inodes_count;   /* Free inodes count */
        __u16   bg_used_dirs_count;     /* Directories count */
        __u16   bg_flags;
-       __u32   bg_reserved[2];
+       __u32   bg_exclude_bitmap;      /* Exclude bitmap block */
+       __u32   bg_reserved[1];
        __u16   bg_itable_unused;       /* Unused inodes count */
        __u16   bg_checksum;            /* crc16(s_uuid+grouo_num+group=
_desc)*/
 };
@@ -159,7 +160,8 @@ struct ext4_group_desc
        __u16   bg_free_inodes_count;   /* Free inodes count */
        __u16   bg_used_dirs_count;     /* Directories count */
        __u16   bg_flags;               /* EXT4_BG_flags (INODE_UNINIT,=
 etc) */
-       __u32   bg_reserved[2];         /* Likely block/inode bitmap ch=
ecksum */
+       __u32   bg_exclude_bitmap;      /* Exclude bitmap block */
+       __u32   bg_reserved[1];         /* Likely block/inode bitmap ch=
ecksum */
        __u16   bg_itable_unused;       /* Unused inodes count */
        __u16   bg_checksum;            /* crc16(sb_uuid+group+desc) */
        __u32   bg_block_bitmap_hi;     /* Blocks bitmap block MSB */

@@ -169,12 +171,14 @@ struct ext4_group_desc
        __u16   bg_free_inodes_count_hi;/* Free inodes count MSB */
        __u16   bg_used_dirs_count_hi;  /* Directories count MSB */
        __u16   bg_itable_unused_hi;    /* Unused inodes count MSB */
-       __u32   bg_reserved2[3];
+       __u32   bg_exclude_bitmap_hi;   /* Exclude bitmap block MSB */
+       __u32   bg_reserved2[2];
 };

 #define EXT2_BG_INODE_UNINIT   0x0001 /* Inode table/bitmap not initia=
lized */
 #define EXT2_BG_BLOCK_UNINIT   0x0002 /* Block bitmap not initialized =
*/
 #define EXT2_BG_INODE_ZEROED   0x0004 /* On-disk itable initialized to=
 zero */
+#define EXT2_BG_EXCLUDE_UNINIT 0x0008 /* Exclude bitmap not initialize=
d */

 /*
  * Data structures used by the directory indexing feature
@@ -670,7 +674,8 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_RESIZE_INODE       0x0010
 #define EXT2_FEATURE_COMPAT_DIR_INDEX          0x0020
 #define EXT2_FEATURE_COMPAT_LAZY_BG            0x0040
-#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE      0x0080
+/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE   0x0080 not used */
+#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP     0x0100

 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER    0x0001
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE      0x0002
--
1.7.0.4
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

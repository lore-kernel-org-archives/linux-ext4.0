From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] A request to reserve a "tree id" field on ext[34] inodes
Date: Wed, 18 Nov 2009 20:43:13 +0300
Message-ID: <87skcb20ge.fsf@openvz.org>
References: <4B02AD8B.2030202@openvz.org>
 <0D1BE31B-34F9-40A1-8C7F-6A9FFF18DA8E@sun.com> <87lji4svcg.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Pavel Emelyanov <xemul@openvz.org>, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:49132 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758053AbZKRRnL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Nov 2009 12:43:11 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KTB00JUWG3HAS10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Wed, 18 Nov 2009 20:47:44 +0300 (MSK)
In-reply-to: <87lji4svcg.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> Andreas Dilger <adilger@sun.com> writes:
>
>> On 2009-11-17, at 06:04, Pavel Emelyanov wrote:
>>> We have a proposal to implement a 2-level disk quota on ext3 and ext4.
>>>
>>> In two words - the aim is to have directories on ext3/4 partitions
>>> which are limited by its disk usage and the number of inodes. Further
>>> the plan is to allow configuring uid and gid quotas within them.
>>>
>>> The main usage of this is containers. When two or more of them are
>>> located on one disk their roots will be marked with a unique tree id
>>> and thus the disk consumption of each container will be limited. While
>>> achieving this goal having an id of what tree an inode belongs to is
>>> a key requirement.
>>
>> How do you handle files with multiple links, if they are located in
>> different trees?  The inode would need to have multiple tree ids.
> A short answer is "NO", inode can not belongs to multiple trees.
> Containers has some non obvious specific. 
> Each container isolated from another as much as possible. 
> Container has its own root tree. This tree is exported inside
> CT by numerous possible ways (name-space, virtual-stack-fs, chroot)
>
> So container's root are independent tree or several trees.
> usually they organized like follows /ct_root/CT_${ID}/${tree_content}
> There are many reasons to keep this trees separate one from another
>    - inode attr: 
>      If inode has links in A n B trees. And A-user call chown() for
>      this inode, then B's owner will be surprised.
>      The only way to overcome this is to virtualize inode atributes
>      (for each tree) which is madness IMHO.
>    - checkpoint/restore/online-backup:
>      This is like suspend resume for VM, but in this case only
>      container's process are stopped(freezed) for some time. After CT's
>      process are stopped we may create backup CT's tree without freezing
>      FS as a whole.
> As I already say there are many way to accomplish this task. But everyone
> has strong disadvantages:
> Virtual block devices(qemu-like): problems with consistency and performance
> ext3/4 + stack-fs(unionfs/vzfs): Bad failure resistance. It is
>         impossible to support jorunalling quota file on stack-fs level.
> XFS with proj quota : Lack of quota file journalling. XFS itself
>         (please dont balme me, but i'm really not huge XFS fan)
>
> So the only way to implement journalled quota for containers is to
> implement it on native fs level.
>
> "Containers directory tree-id" assumptions:
> (1) Tree id is embedded inside inode
> (2) Tree id is inherent from parent dir
> (3) Inode can not belongs to different directory trees
>
> Default directory tree (with id == 0) has special meaning.
> directory which belongs to default tree may contains roots of
> other trees. Default tree is used for subtree manipulation.
>
> ->rename restriction:
>   if (S_ISDIR(old_inode->i_mode)) {
>       if ((new_dir->i_tree_id == 0) || /* move to default tree */
>                (new_dir->i_tree_id == old_inode->i_tree_id)) /*same tree */
>              goto good;
>       return -EXDEV;
>   } else {
>       /* If entry have more than one link then it is bad idea to allow
>          rename it to different (even if it's default tree) tree,
>          because this result in rule (3) violation.
>       if (old_inode->i_nlink > 1) && 
>                     (new_dir->i_tree_id != old_inode->i_tree_id)
>             return -EXDEV;
>  }
> ->link restriction: /* Links may  belongs to only one tree */
>    if(new_dir->i_tree_id != old_inode->i_tree_id)
>             return -EXDEV;
>
>>
>> You can instead just store this data in an xattr (which will normally
>> be stored in the inode, so no performance impact), and then you are
>> free to store multiple values per inode.
> Yes xattr is possible, but struct ext4_xattr_entry is so big plus 
> space for attr_name ...., But we only want 4 bytes.
In other point of view it may be too expensive reserve the last 4
bytes in EXT4_GOOD_OLD_INODE. At the same time store tree_id as xattr.
result in space wasting. But in fact new inode has room for space
reservation. We may store it like it is done for i_version_hi field
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -494,6 +494,7 @@ struct ext4_inode {
 	__le32  i_crtime;       /* File Creation time */
 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
 	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
+	__le32	i_disk_tree_id; /* directory tree quota id */
 };
 
 struct move_extent {
@@ -1112,6 +1113,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP               0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+#define EXT4_FEATURE_INCOMPAT_TREE_ID		0x0400 /* directory tree id */
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1119,7 +1121,8 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
 					 EXT4_FEATURE_INCOMPAT_64BIT| \
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
+					 EXT4_FEATURE_INCOMPAT_TREE_ID)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1534,6 +1534,15 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt, I_VERSION);
 			sb->s_flags |= MS_I_VERSION;
 			break;
+		case Opt_tree_id:
+			if (!(EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_TREE_ID) &&
+				EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
+					EXT4_FITS_IN_INODE(raw_inode, ei, i_disk_tree_id))) {
+				ext4_msg(sb, KERN_ERR, "tree_id is not supported");
+				return 0;
+			}
+			set_opt(sbi->s_mount_opt, TREE_ID);
+			break;
 		case Opt_nodelalloc:
 			clear_opt(sbi->s_mount_opt, DELALLOC);
 			break;
-=-=-=-
>>
>> Cheers, Andreas
>> --
>> Andreas Dilger
>> Sr. Staff Engineer, Lustre Group
>> Sun Microsystems of Canada, Inc.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

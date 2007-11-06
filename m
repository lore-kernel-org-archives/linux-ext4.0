From: Jan Kara <jack@suse.cz>
Subject: [RFC] [PATCH 2/3] Recursive mtime for ext3
Date: Tue, 6 Nov 2007 18:19:17 +0100
Message-ID: <20071106171917.GF23689@duck.suse.cz>
References: <20071106171537.GD23689@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42601 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753578AbXKFRTT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2007 12:19:19 -0500
Content-Disposition: inline
In-Reply-To: <20071106171537.GD23689@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Make space reserved for fragments as unused as they were never implemented.
Remove also related initializations. We later use the space for recursive
mtime.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/fs/ext3/ialloc.c linux-2.6.23-2-make_flags_unused/fs/ext3/ialloc.c
--- linux-2.6.23-1-i_flags_atomicity/fs/ext3/ialloc.c	2007-11-05 14:14:50.000000000 +0100
+++ linux-2.6.23-2-make_flags_unused/fs/ext3/ialloc.c	2007-11-05 14:37:33.000000000 +0100
@@ -576,11 +576,6 @@ got:
 	/* dirsync only applies to directories */
 	if (!S_ISDIR(mode))
 		ei->i_flags &= ~EXT3_DIRSYNC_FL;
-#ifdef EXT3_FRAGMENTS
-	ei->i_faddr = 0;
-	ei->i_frag_no = 0;
-	ei->i_frag_size = 0;
-#endif
 	ei->i_file_acl = 0;
 	ei->i_dir_acl = 0;
 	ei->i_dtime = 0;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/fs/ext3/inode.c linux-2.6.23-2-make_flags_unused/fs/ext3/inode.c
--- linux-2.6.23-1-i_flags_atomicity/fs/ext3/inode.c	2007-11-05 14:24:39.000000000 +0100
+++ linux-2.6.23-2-make_flags_unused/fs/ext3/inode.c	2007-11-05 14:38:05.000000000 +0100
@@ -2651,11 +2651,6 @@ void ext3_read_inode(struct inode * inod
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
-#ifdef EXT3_FRAGMENTS
-	ei->i_faddr = le32_to_cpu(raw_inode->i_faddr);
-	ei->i_frag_no = raw_inode->i_frag;
-	ei->i_frag_size = raw_inode->i_fsize;
-#endif
 	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
 	if (!S_ISREG(inode->i_mode)) {
 		ei->i_dir_acl = le32_to_cpu(raw_inode->i_dir_acl);
@@ -2790,11 +2785,6 @@ static int ext3_do_update_inode(handle_t
 	spin_lock(&inode->i_lock);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
 	spin_unlock(&inode->i_lock);
-#ifdef EXT3_FRAGMENTS
-	raw_inode->i_faddr = cpu_to_le32(ei->i_faddr);
-	raw_inode->i_frag = ei->i_frag_no;
-	raw_inode->i_fsize = ei->i_frag_size;
-#endif
 	raw_inode->i_file_acl = cpu_to_le32(ei->i_file_acl);
 	if (!S_ISREG(inode->i_mode)) {
 		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/fs/ext3/super.c linux-2.6.23-2-make_flags_unused/fs/ext3/super.c
--- linux-2.6.23-1-i_flags_atomicity/fs/ext3/super.c	2007-11-05 15:04:19.000000000 +0100
+++ linux-2.6.23-2-make_flags_unused/fs/ext3/super.c	2007-11-05 15:01:37.000000000 +0100
@@ -1584,17 +1584,7 @@ static int ext3_fill_super (struct super
 			goto failed_mount;
 		}
 	}
-	sbi->s_frag_size = EXT3_MIN_FRAG_SIZE <<
-				   le32_to_cpu(es->s_log_frag_size);
-	if (blocksize != sbi->s_frag_size) {
-		printk(KERN_ERR
-		       "EXT3-fs: fragsize %lu != blocksize %u (unsupported)\n",
-		       sbi->s_frag_size, blocksize);
-		goto failed_mount;
-	}
-	sbi->s_frags_per_block = 1;
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
-	sbi->s_frags_per_group = le32_to_cpu(es->s_frags_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
 	if (EXT3_INODE_SIZE(sb) == 0)
 		goto cantfind_ext3;
@@ -1618,12 +1608,6 @@ static int ext3_fill_super (struct super
 			sbi->s_blocks_per_group);
 		goto failed_mount;
 	}
-	if (sbi->s_frags_per_group > blocksize * 8) {
-		printk (KERN_ERR
-			"EXT3-fs: #fragments per group too big: %lu\n",
-			sbi->s_frags_per_group);
-		goto failed_mount;
-	}
 	if (sbi->s_inodes_per_group > blocksize * 8) {
 		printk (KERN_ERR
 			"EXT3-fs: #inodes per group too big: %lu\n",
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs.h linux-2.6.23-2-make_flags_unused/include/linux/ext3_fs.h
--- linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs.h	2007-11-05 14:31:44.000000000 +0100
+++ linux-2.6.23-2-make_flags_unused/include/linux/ext3_fs.h	2007-11-05 14:37:33.000000000 +0100
@@ -291,27 +291,24 @@ struct ext3_inode {
 	__le32	i_generation;	/* File version (for NFS) */
 	__le32	i_file_acl;	/* File ACL */
 	__le32	i_dir_acl;	/* Directory ACL */
-	__le32	i_faddr;	/* Fragment address */
+	__le32	i_obsolete_faddr;	/* Unused */
 	union {
 		struct {
-			__u8	l_i_frag;	/* Fragment number */
-			__u8	l_i_fsize;	/* Fragment size */
+			__u16	l_i_obsolete_frag;	/* Unused */
 			__u16	i_pad1;
 			__le16	l_i_uid_high;	/* these 2 fields    */
 			__le16	l_i_gid_high;	/* were reserved2[0] */
 			__u32	l_i_reserved2;
 		} linux2;
 		struct {
-			__u8	h_i_frag;	/* Fragment number */
-			__u8	h_i_fsize;	/* Fragment size */
+			__u16	h_i_obsolete_frag;	/* Unused */
 			__u16	h_i_mode_high;
 			__u16	h_i_uid_high;
 			__u16	h_i_gid_high;
 			__u32	h_i_author;
 		} hurd2;
 		struct {
-			__u8	m_i_frag;	/* Fragment number */
-			__u8	m_i_fsize;	/* Fragment size */
+			__u16	m_i_obsolete_frag;	/* Unused */
 			__u16	m_pad1;
 			__u32	m_i_reserved2[2];
 		} masix2;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs_sb.h linux-2.6.23-2-make_flags_unused/include/linux/ext3_fs_sb.h
--- linux-2.6.23-1-i_flags_atomicity/include/linux/ext3_fs_sb.h	2007-10-11 12:01:28.000000000 +0200
+++ linux-2.6.23-2-make_flags_unused/include/linux/ext3_fs_sb.h	2007-11-05 14:50:55.000000000 +0100
@@ -28,10 +28,7 @@
  * third extended-fs super-block data in memory
  */
 struct ext3_sb_info {
-	unsigned long s_frag_size;	/* Size of a fragment in bytes */
-	unsigned long s_frags_per_block;/* Number of fragments per block */
 	unsigned long s_inodes_per_block;/* Number of inodes per block */
-	unsigned long s_frags_per_group;/* Number of fragments in a group */
 	unsigned long s_blocks_per_group;/* Number of blocks in a group */
 	unsigned long s_inodes_per_group;/* Number of inodes in a group */
 	unsigned long s_itb_per_group;	/* Number of inode table blocks per group */

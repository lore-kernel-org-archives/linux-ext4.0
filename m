From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 6/6] debugfs: update to handle newer inode fields
Date: Sat,  5 Mar 2016 17:38:36 -0700
Message-ID: <1457224716-72388-6-git-send-email-adilger@dilger.ca>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:33816 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbcCFAqc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 19:46:32 -0500
In-Reply-To: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove the printing of fragment fields that are HURD only, and
instead print the i_checksum_lo and i_checksum_hi fields.

Allow setting newer fields in extra inode space with modify_inode.

Add inode_includes() macro to simplify checking for fields in the
large inode, rather than hard-coding field offsets in the code.

Fix corresponding tests for newly added Checksum field.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debugfs.c            | 197 +++++++++++++++++++++++++++----------------
 lib/ext2fs/ext2_fs.h         |  22 ++---
 tests/d_special_files/expect |  10 +--
 tests/f_badcluster/expect    |  14 +--
 4 files changed, 140 insertions(+), 103 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 260698c..332fd5a 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -527,6 +527,10 @@ static void dump_xattr_string(FILE *out, const char *str, int len)
 			fprintf(out, "%02x ", (unsigned char)str[i]);
 }
 
+#define inode_includes(size, field)					\
+	(size >= (sizeof(((struct ext2_inode_large *)0)->field) +	\
+		  offsetof(struct ext2_inode_large, field)))
+
 static void internal_dump_inode_extra(FILE *out,
 				      const char *prefix EXT2FS_ATTR((unused)),
 				      ext2_ino_t inode_num EXT2FS_ATTR((unused)),
@@ -725,15 +729,12 @@ void internal_dump_inode(FILE *out, const char *prefix,
 			 int do_dump_blocks)
 {
 	const char *i_type;
-	char frag, fsize;
 	int os = current_fs->super->s_creator_os;
-	struct ext2_inode_large *large_inode;
-	int is_large_inode = 0;
+	struct ext2_inode_large *large_inode = (struct ext2_inode_large *)inode;
+	unsigned inode_size = EXT2_GOOD_OLD_INODE_SIZE;
 
 	if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
-		is_large_inode = 1;
-	large_inode = (struct ext2_inode_large *) inode;
-
+		inode_size += large_inode->i_extra_isize;
 	if (LINUX_S_ISDIR(inode->i_mode)) i_type = "directory";
 	else if (LINUX_S_ISREG(inode->i_mode)) i_type = "regular";
 	else if (LINUX_S_ISLNK(inode->i_mode)) i_type = "symlink";
@@ -745,14 +746,14 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	fprintf(out, "%sInode: %u   Type: %s    ", prefix, inode_num, i_type);
 	fprintf(out, "%sMode:  %04o   Flags: 0x%x\n",
 		prefix, inode->i_mode & 0777, inode->i_flags);
-	if (is_large_inode && large_inode->i_extra_isize >= 24) {
+
+	if (inode_includes(inode_size, i_version_hi))
 		fprintf(out, "%sGeneration: %u    Version: 0x%08x:%08x\n",
 			prefix, inode->i_generation, large_inode->i_version_hi,
 			inode->osd1.linux1.l_i_version);
-	} else {
+	else
 		fprintf(out, "%sGeneration: %u    Version: 0x%08x\n", prefix,
 			inode->i_generation, inode->osd1.linux1.l_i_version);
-	}
 	fprintf(out, "%sUser: %5d   Group: %5d   Size: ",
 		prefix, inode_uid(*inode), inode_gid(*inode));
 	if (LINUX_S_ISREG(inode->i_mode))
@@ -763,7 +764,8 @@ void internal_dump_inode(FILE *out, const char *prefix,
 		fprintf(out,
 			"%sFile ACL: %d    Directory ACL: %d Translator: %d\n",
 			prefix,
-			inode->i_file_acl, LINUX_S_ISDIR(inode->i_mode) ? inode->i_dir_acl : 0,
+			inode->i_file_acl, LINUX_S_ISDIR(inode->i_mode) ?
+							inode->i_dir_acl : 0,
 			inode->osd1.hurd1.h_i_translator);
 	else
 		fprintf(out, "%sFile ACL: %llu    Directory ACL: %d\n",
@@ -780,46 +782,53 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	else
 		fprintf(out, "%sLinks: %d   Blockcount: %u\n",
 			prefix, inode->i_links_count, inode->i_blocks);
-	switch (os) {
-	    case EXT2_OS_HURD:
-		frag = inode->osd2.hurd2.h_i_frag;
-		fsize = inode->osd2.hurd2.h_i_fsize;
-		break;
-	    default:
-		frag = fsize = 0;
-	}
-	fprintf(out, "%sFragment:  Address: %d    Number: %d    Size: %d\n",
-		prefix, inode->i_faddr, frag, fsize);
-	if (is_large_inode && large_inode->i_extra_isize >= 24) {
-		fprintf(out, "%s ctime: 0x%08x:%08x -- %s", prefix,
+	if (os == EXT2_OS_HURD)
+		fprintf(out,
+			"%sFragment:  Address: %d    Number: %d    Size: %d\n",
+			prefix, inode->i_faddr, inode->osd2.hurd2.h_i_frag,
+			inode->osd2.hurd2.h_i_fsize);
+	else
+		fprintf(out,
+			"%sFragment Address: %d    Checksum: 0x%04x%04x\n",
+			prefix, inode->i_faddr,
+			inode_includes(inode_size, i_checksum_hi) ?
+				large_inode->i_checksum_hi : 0,
+			inode->osd2.linux2.l_i_checksum_lo);
+	if (inode_includes(inode_size, i_ctime_extra))
+		fprintf(out, "%sctime: 0x%08x:%08x -- %s", prefix,
 			inode->i_ctime, large_inode->i_ctime_extra,
 			time_to_string(inode->i_ctime));
-		fprintf(out, "%s atime: 0x%08x:%08x -- %s", prefix,
+	else
+		fprintf(out, "%sctime: 0x%08x -- %s", prefix, inode->i_ctime,
+			time_to_string(inode->i_ctime));
+	if (inode_includes(inode_size, i_atime_extra))
+		fprintf(out, "%satime: 0x%08x:%08x -- %s", prefix,
 			inode->i_atime, large_inode->i_atime_extra,
 			time_to_string(inode->i_atime));
-		fprintf(out, "%s mtime: 0x%08x:%08x -- %s", prefix,
+	else
+		fprintf(out, "%satime: 0x%08x -- %s", prefix, inode->i_atime,
+			time_to_string(inode->i_atime));
+	if (inode_includes(inode_size, i_mtime_extra))
+		fprintf(out, "%smtime: 0x%08x:%08x -- %s", prefix,
 			inode->i_mtime, large_inode->i_mtime_extra,
 			time_to_string(inode->i_mtime));
+	else
+		fprintf(out, "%smtime: 0x%08x -- %s", prefix, inode->i_mtime,
+			time_to_string(inode->i_mtime));
+	if (inode_includes(inode_size, i_crtime_extra))
 		fprintf(out, "%scrtime: 0x%08x:%08x -- %s", prefix,
 			large_inode->i_crtime, large_inode->i_crtime_extra,
 			time_to_string(large_inode->i_crtime));
-	} else {
-		fprintf(out, "%sctime: 0x%08x -- %s", prefix, inode->i_ctime,
-			time_to_string(inode->i_ctime));
-		fprintf(out, "%satime: 0x%08x -- %s", prefix, inode->i_atime,
-			time_to_string(inode->i_atime));
-		fprintf(out, "%smtime: 0x%08x -- %s", prefix, inode->i_mtime,
-			time_to_string(inode->i_mtime));
-	}
 	if (inode->i_dtime)
-	  fprintf(out, "%sdtime: 0x%08x -- %s", prefix, inode->i_dtime,
-		  time_to_string(inode->i_dtime));
-	if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
+		fprintf(out, "%sdtime: 0x%08x -- %s", prefix, inode->i_dtime,
+			time_to_string(inode->i_dtime));
+	if (inode_size > EXT2_GOOD_OLD_INODE_SIZE)
 		internal_dump_inode_extra(out, prefix, inode_num,
-					  (struct ext2_inode_large *) inode);
-	if (LINUX_S_ISLNK(inode->i_mode) && ext2fs_inode_data_blocks(current_fs,inode) == 0)
+					  (struct ext2_inode_large *)inode);
+	if (LINUX_S_ISLNK(inode->i_mode) &&
+	    ext2fs_inode_data_blocks(current_fs, inode) == 0)
 		fprintf(out, "%sFast_link_dest: %.*s\n", prefix,
-			(int) inode->i_size, (char *)inode->i_block);
+			(int)inode->i_size, (char *)inode->i_block);
 	else if (LINUX_S_ISBLK(inode->i_mode) || LINUX_S_ISCHR(inode->i_mode)) {
 		int major, minor;
 		const char *devnote;
@@ -1202,15 +1211,15 @@ static void modify_u32(char *com, const char *prompt,
 		*val = v;
 }
 
-
 void do_modify_inode(int argc, char *argv[])
 {
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
+	struct ext2_inode *inodep;
 	ext2_ino_t	inode_num;
-	int 		i;
-	unsigned char	*frag, *fsize;
+	int		i;
+	int		inode_size;
 	char		buf[80];
-	int 		os;
+	int		os;
 	const char	*hex_format = "0x%x";
 	const char	*octal_format = "0%o";
 	const char	*decimal_format = "%d";
@@ -1220,53 +1229,61 @@ void do_modify_inode(int argc, char *argv[])
 		return;
 
 	os = current_fs->super->s_creator_os;
+	inode_size = EXT2_INODE_SIZE(current_fs->super);
 
-	if (debugfs_read_inode(inode_num, &inode, argv[1]))
+	inodep = (struct ext2_inode *)&inode;
+	if (debugfs_read_inode_full(inode_num, inodep, argv[1], inode_size))
 		return;
 
 	modify_u16(argv[0], "Mode", octal_format, &inode.i_mode);
 	modify_u16(argv[0], "User ID", decimal_format, &inode.i_uid);
 	modify_u16(argv[0], "Group ID", decimal_format, &inode.i_gid);
 	modify_u32(argv[0], "Size", unsignedlong_format, &inode.i_size);
-	modify_u32(argv[0], "Creation time", decimal_format, &inode.i_ctime);
-	modify_u32(argv[0], "Modification time", decimal_format, &inode.i_mtime);
+	modify_u32(argv[0], "High 32bits of size", decimal_format,
+		   &inode.i_size_high);
+	modify_u32(argv[0], "Change time", decimal_format, &inode.i_ctime);
+	modify_u32(argv[0], "Modification time",decimal_format, &inode.i_mtime);
 	modify_u32(argv[0], "Access time", decimal_format, &inode.i_atime);
 	modify_u32(argv[0], "Deletion time", decimal_format, &inode.i_dtime);
 	modify_u16(argv[0], "Link count", decimal_format, &inode.i_links_count);
+	modify_u32(argv[0], "Block count",unsignedlong_format, &inode.i_blocks);
 	if (os == EXT2_OS_LINUX)
-		modify_u16(argv[0], "Block count high", unsignedlong_format,
+		modify_u16(argv[0], "High 16bits of lock count",
+			   unsignedlong_format,
 			   &inode.osd2.linux2.l_i_blocks_hi);
-	modify_u32(argv[0], "Block count", unsignedlong_format, &inode.i_blocks);
 	modify_u32(argv[0], "File flags", hex_format, &inode.i_flags);
 	modify_u32(argv[0], "Generation", hex_format, &inode.i_generation);
-#if 0
-	modify_u32(argv[0], "Reserved1", decimal_format, &inode.i_reserved1);
-#endif
-	modify_u32(argv[0], "File acl", decimal_format, &inode.i_file_acl);
-	if (LINUX_S_ISDIR(inode.i_mode))
-		modify_u32(argv[0], "Directory acl", decimal_format, &inode.i_dir_acl);
-	else
-		modify_u32(argv[0], "High 32bits of size", decimal_format, &inode.i_size_high);
+	modify_u32(argv[0], "File ACL", decimal_format, &inode.i_file_acl);
 
-	if (os == EXT2_OS_HURD)
+	if (os == EXT2_OS_HURD) {
 		modify_u32(argv[0], "Translator Block",
 			    decimal_format, &inode.osd1.hurd1.h_i_translator);
-
-	modify_u32(argv[0], "Fragment address", decimal_format, &inode.i_faddr);
-	switch (os) {
-	    case EXT2_OS_HURD:
-		frag = &inode.osd2.hurd2.h_i_frag;
-		fsize = &inode.osd2.hurd2.h_i_fsize;
-		break;
-	    default:
-		frag = fsize = 0;
-	}
-	if (frag)
-		modify_u8(argv[0], "Fragment number", decimal_format, frag);
-	if (fsize)
-		modify_u8(argv[0], "Fragment size", decimal_format, fsize);
-
-	for (i=0;  i < EXT2_NDIR_BLOCKS; i++) {
+		modify_u32(argv[0], "Fragment address", decimal_format,
+			   &inode.i_faddr);
+		modify_u8(argv[0], "Fragment number", decimal_format,
+			  &inode.osd2.hurd2.h_i_frag);
+		modify_u8(argv[0], "Fragment size", decimal_format,
+			  &inode.osd2.hurd2.h_i_fsize);
+	} else {
+		modify_u32(argv[0], "Fragment address", decimal_format,
+			   &inode.i_faddr);
+		modify_u32(argv[0], "Change Version", decimal_format,
+			   &inode.osd1.linux1.l_i_version);
+		modify_u16(argv[0], "High 16bits of file ACL",
+			   unsignedlong_format,
+			   &inode.osd2.linux2.l_i_file_acl_high);
+		modify_u16(argv[0], "High 16bits of user ID",
+			   unsignedlong_format,
+			   &inode.osd2.linux2.l_i_uid_high);
+		modify_u16(argv[0], "High 16bits of group ID",
+			   unsignedlong_format,
+			   &inode.osd2.linux2.l_i_gid_high);
+		modify_u16(argv[0], "Low 16bits of checksum",
+			   unsignedlong_format,
+			   &inode.osd2.linux2.l_i_checksum_lo);
+	}
+
+	for (i = 0; i < EXT2_NDIR_BLOCKS; i++) {
 		sprintf(buf, "Direct Block #%d", i);
 		modify_u32(argv[0], buf, decimal_format, &inode.i_block[i]);
 	}
@@ -1276,7 +1293,39 @@ void do_modify_inode(int argc, char *argv[])
 		    &inode.i_block[EXT2_DIND_BLOCK]);
 	modify_u32(argv[0], "Triple Indirect Block", decimal_format,
 		    &inode.i_block[EXT2_TIND_BLOCK]);
-	if (debugfs_write_inode(inode_num, &inode, argv[1]))
+
+	if (inode_includes(inode_size, i_extra_isize)) {
+		modify_u16(argv[0], "Extra inode size", decimal_format,
+			   &inode.i_extra_isize);
+		i = inode.i_extra_isize;
+	} else {
+		i = 0;
+	}
+
+	if (inode_includes(inode_size, i_checksum_hi))
+		modify_u16(argv[0], "High 16bits of checksum", decimal_format,
+			   &inode.i_checksum_hi);
+	if (inode_includes(inode_size, i_ctime_extra))
+		modify_u32(argv[0], "Extra change time",
+			   decimal_format, &inode.i_ctime_extra);
+	if (inode_includes(inode_size, i_mtime_extra))
+		modify_u32(argv[0], "Extra modification time",
+			   decimal_format, &inode.i_mtime_extra);
+	if (inode_includes(inode_size, i_atime_extra))
+		modify_u32(argv[0], "Extra access time",
+			   decimal_format, &inode.i_atime_extra);
+	if (inode_includes(inode_size, i_crtime))
+		modify_u32(argv[0], "Creation time",
+			   decimal_format, &inode.i_crtime);
+	if (inode_includes(inode_size, i_crtime_extra))
+		modify_u32(argv[0], "Extra creation time",
+			   decimal_format, &inode.i_crtime_extra);
+	if (inode_includes(inode_size, i_version_hi))
+		modify_u32(argv[0], "High 32bits change version",
+			   decimal_format, &inode.i_version_hi);
+
+	if (debugfs_write_inode_full(inode_num, inodep, argv[1],
+				     EXT2_INODE_SIZE(current_fs->super)))
 		return;
 }
 #endif /* READ_ONLY */
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 6c3620c..42024fa 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -461,26 +461,14 @@ struct ext2_inode_large {
 
 #define i_dir_acl	i_size_high
 
-#if defined(__KERNEL__) || defined(__linux__)
-#define i_reserved1	osd1.linux1.l_i_reserved1
-#define i_frag		osd2.linux2.l_i_frag
-#define i_fsize		osd2.linux2.l_i_fsize
-#define i_uid_low	i_uid
-#define i_gid_low	i_gid
-#define i_uid_high	osd2.linux2.l_i_uid_high
-#define i_gid_high	osd2.linux2.l_i_gid_high
-#else
 #if defined(__GNU__)
-
-#define i_translator	osd1.hurd1.h_i_translator
-#define i_frag		osd2.hurd2.h_i_frag;
-#define i_fsize		osd2.hurd2.h_i_fsize;
 #define i_uid_high	osd2.hurd2.h_i_uid_high
 #define i_gid_high	osd2.hurd2.h_i_gid_high
-#define i_author	osd2.hurd2.h_i_author
-
-#endif  /* __GNU__ */
-#endif	/* defined(__KERNEL__) || defined(__linux__) */
+#else
+#define i_uid_high	osd2.linux2.l_i_uid_high
+#define i_gid_high	osd2.linux2.l_i_gid_high
+#define i_checksum_lo	osd2.linux2.l_i_checksum_lo
+#endif	/* __GNU__ */
 
 #define inode_uid(inode)	((inode).i_uid | (inode).osd2.linux2.l_i_uid_high << 16)
 #define inode_gid(inode)	((inode).i_gid | (inode).osd2.linux2.l_i_gid_high << 16)
diff --git a/tests/d_special_files/expect b/tests/d_special_files/expect
index 2b2dbfa..cfdc505 100644
--- a/tests/d_special_files/expect
+++ b/tests/d_special_files/expect
@@ -7,7 +7,7 @@ Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 3
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 0
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
@@ -19,7 +19,7 @@ Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 80
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 2
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
@@ -44,7 +44,7 @@ Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 0
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 0
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
@@ -57,7 +57,7 @@ Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 0
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 0
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
@@ -69,7 +69,7 @@ Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 0
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 0
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
 mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
diff --git a/tests/f_badcluster/expect b/tests/f_badcluster/expect
index 6cfffb7..c10a0c7 100644
--- a/tests/f_badcluster/expect
+++ b/tests/f_badcluster/expect
@@ -115,7 +115,7 @@ Generation: 1117152157    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 32
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -127,7 +127,7 @@ Generation: 1117152158    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 32
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -139,7 +139,7 @@ Generation: 1117152159    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 32
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -151,7 +151,7 @@ Generation: 1117152160    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 32
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -165,7 +165,7 @@ Generation: 1117152161    Version: 0x00000001
 User:     0   Group:     0   Size: 6144
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 32
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -177,7 +177,7 @@ Generation: 1117152162    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 32
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -189,7 +189,7 @@ Generation: 1117152163    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 32
-Fragment:  Address: 0    Number: 0    Size: 0
+Fragment Address: 0    Checksum: 0x00000000
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
-- 
1.8.0


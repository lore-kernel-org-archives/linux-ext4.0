From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] Accomodate 32-bit uid/guid values in e2fsprogs
Date: Mon, 07 May 2007 12:10:37 -0500
Message-ID: <463F5D8D.7080201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965536AbXEGRMu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 13:12:50 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l47HCnfv023584
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 13:12:49 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l47HCnBU005222
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 13:12:49 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l47HCm55023754
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 13:12:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

e2fsprogs doesn't handle large (> 16 bit) UID/GID...

Create an fs by user with large UID:

bash-3.1$ id
uid=501666(newuser) gid=501666(newuser) groups=501666(newuser)
bash-3.1$ /sbin/mke2fs -q fsfile
fsfile is not a block special device.
Proceed anyway? (y,n) y

Now mount it:

[root@neon tmp]# mount -o loop fsfile /mnt/tmp/
[root@neon tmp]# ls -la /mnt/tmp/
total 13
drwxr-xr-x 3 42914 42914  1024 May  7 11:55 .
drwxr-xr-x 4 root  root     28 Jan 23 10:34 ..
drwx------ 2 root  root  12288 May  7 11:55 lost+found

uid/gid is wrong (only bottom 16 bits)!  (it's wrong on disk...)

And even if I get it right on disk:

[root@neon tmp]# ls -lan /mnt/tmp/
total 13
drwxr-xr-x 3 501666 501666  1024 May  7 11:57 .
drwxr-xr-x 4      0      0    28 Jan 23 10:34 ..
drwx------ 2      0      0 12288 May  7 11:57 lost+found

debugfs has further problems:

[root@neon tmp]# /sbin/debugfs /tmp/fsfile 
debugfs 1.39 (29-May-2006)
debugfs:  stat .
Inode: 2   Type: directory    Mode:  0755   Flags: 0x0   Generation: 0
User: 42914   Group: 42914   Size: 1024
File ACL: 0    Directory ACL: 0
Links: 3   Blockcount: 2
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x463f5a8a -- Mon May  7 11:57:46 2007
atime: 0x463f5a90 -- Mon May  7 11:57:52 2007
mtime: 0x463f5a8a -- Mon May  7 11:57:46 2007
BLOCKS:
(0):508
TOTAL: 1

debugfs:  ls -l
      2   40755 (2)  42914  42914    1024  7-May-2007 11:57 .
      2   40755 (2)  42914  42914    1024  7-May-2007 11:57 ..
     11   40700 (2)      0      0   12288  7-May-2007 11:57 lost+found

The attached patch creates inode_uid() and inode_gid() macros to accommodate
the high bits when reading uid/gid, on platforms that support it.

It also accommodates large UID/GID at mkfs time.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-hg/debugfs/debugfs.c
===================================================================
--- e2fsprogs-hg.orig/debugfs/debugfs.c
+++ e2fsprogs-hg/debugfs/debugfs.c
@@ -534,7 +534,7 @@ void internal_dump_inode(FILE *out, cons
 		prefix, 
 		inode->i_mode & 0777, inode->i_flags, inode->i_generation);
 	fprintf(out, "%sUser: %5d   Group: %5d   Size: ",
-		prefix, inode->i_uid, inode->i_gid);
+		prefix, inode_uid(*inode), inode_gid(*inode));
 	if (LINUX_S_ISREG(inode->i_mode)) {
 		__u64 i_size = (inode->i_size |
 				((unsigned long long)inode->i_size_high << 32));
Index: e2fsprogs-hg/debugfs/ls.c
===================================================================
--- e2fsprogs-hg.orig/debugfs/ls.c
+++ e2fsprogs-hg/debugfs/ls.c
@@ -88,7 +88,7 @@ static int list_dir_proc(ext2_ino_t dir 
 		}
 		fprintf(ls->f, "%c%6u%c %6o (%d)  %5d  %5d   ", lbr, ino, rbr,
 			inode.i_mode, dirent->name_len >> 8,
-			inode.i_uid, inode.i_gid);
+			inode_uid(inode), inode_gid(inode));
 		if (LINUX_S_ISDIR(inode.i_mode))
 			fprintf(ls->f, "%5d", inode.i_size);
 		else
Index: e2fsprogs-hg/debugfs/lsdel.c
===================================================================
--- e2fsprogs-hg.orig/debugfs/lsdel.c
+++ e2fsprogs-hg/debugfs/lsdel.c
@@ -23,7 +23,7 @@
 struct deleted_info {
 	ext2_ino_t	ino;
 	unsigned short	mode;
-	unsigned short	uid;
+	__u32		uid;
 	__u64		size;
 	time_t		dtime;
 	int		num_blocks;
@@ -160,7 +160,7 @@ void do_lsdel(int argc, char **argv)
 				
 			delarray[num_delarray].ino = ino;
 			delarray[num_delarray].mode = inode.i_mode;
-			delarray[num_delarray].uid = inode.i_uid;
+			delarray[num_delarray].uid = inode_uid(inode);
 			delarray[num_delarray].size = inode.i_size;
 			if (!LINUX_S_ISDIR(inode.i_mode))
 				delarray[num_delarray].size |= 
Index: e2fsprogs-hg/e2fsck/message.c
===================================================================
--- e2fsprogs-hg.orig/e2fsck/message.c
+++ e2fsprogs-hg/e2fsck/message.c
@@ -304,12 +304,10 @@ static _INLINE_ void expand_inode_expres
 			      inode->i_dir_acl : 0));
 		break;
 	case 'u':
-		printf("%d", (inode->i_uid |
-			      (inode->osd2.linux2.l_i_uid_high << 16)));
+		printf("%d", inode_uid(*inode));
 		break;
 	case 'g':
-		printf("%d", (inode->i_gid |
-			      (inode->osd2.linux2.l_i_gid_high << 16)));
+		printf("%d", inode_gid(*inode));
 		break;
 	case 't':
 		if (LINUX_S_ISREG(inode->i_mode)) 
Index: e2fsprogs-hg/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-hg.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-hg/lib/ext2fs/ext2_fs.h
@@ -423,7 +423,8 @@ struct ext2_inode_large {
 #define i_uid_high	osd2.linux2.l_i_uid_high
 #define i_gid_high	osd2.linux2.l_i_gid_high
 #define i_reserved2	osd2.linux2.l_i_reserved2
-
+#define inode_uid(inode)	((inode).i_uid | (inode).i_uid_high << 16)
+#define inode_gid(inode)	((inode).i_gid | (inode).i_gid_high << 16)
 #else
 #if defined(__GNU__)
 
@@ -433,6 +434,8 @@ struct ext2_inode_large {
 #define i_uid_high	osd2.hurd2.h_i_uid_high
 #define i_gid_high	osd2.hurd2.h_i_gid_high
 #define i_author	osd2.hurd2.h_i_author
+#define inode_uid(inode)	((inode).i_uid | (inode).i_uid_high << 16)
+#define inode_gid(inode)	((inode).i_gid | (inode).i_gid_high << 16)
 
 #else
 #if defined(__masix__)
@@ -441,6 +444,8 @@ struct ext2_inode_large {
 #define i_frag		osd2.masix2.m_i_frag
 #define i_fsize		osd2.masix2.m_i_fsize
 #define i_reserved2	osd2.masix2.m_i_reserved2
+#define inode_uid(inode)	((inode).i_uid)
+#define inode_gid(inode)	((inode).i_gid)
 
 #endif  /* __masix__ */
 #endif  /* __GNU__ */
Index: e2fsprogs-hg/misc/mke2fs.c
===================================================================
--- e2fsprogs-hg.orig/misc/mke2fs.c
+++ e2fsprogs-hg/misc/mke2fs.c
@@ -479,6 +479,8 @@ static void create_root_dir(ext2_filsys 
 {
 	errcode_t	retval;
 	struct ext2_inode	inode;
+	__u32		uid;
+	__u32		gid;
 
 	retval = ext2fs_mkdir(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, 0);
 	if (retval) {
@@ -492,9 +494,14 @@ static void create_root_dir(ext2_filsys 
 				_("while reading root inode"));
 			exit(1);
 		}
-		inode.i_uid = getuid();
-		if (inode.i_uid)
-			inode.i_gid = getgid();
+		uid = getuid();
+		inode.i_uid = uid;
+		inode.i_uid_high = uid >> 16;
+		if (inode.i_uid) {
+			gid = getgid();
+			inode.i_gid = gid;
+			inode.i_gid_high = gid >> 16;
+		}
 		retval = ext2fs_write_new_inode(fs, EXT2_ROOT_INO, &inode);
 		if (retval) {
 			com_err("ext2fs_write_inode", retval,

From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Correction to check_filetype()
Date: Sat, 31 Mar 2007 10:39:26 -0400
Message-ID: <20070331143926.GG25539@thunk.org>
References: <1172049359.4727.15.camel@garfield> <20070331004417.GJ3198@thunk.org> <20070331081624.GF5967@schatzie.adilger.int> <20070331123509.GA25539@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Lustre-discuss <Lustre-discuss@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37312 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXCaOjb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Mar 2007 10:39:31 -0400
Content-Disposition: inline
In-Reply-To: <20070331123509.GA25539@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Mar 31, 2007 at 08:35:09AM -0400, Theodore Tso wrote:
> And we can't really check the case where a directory gets turned into
> a regular file without destroying e2fsck's performance, since that
> would require reading the first block of every single file, and this
> also significantly increases the chance of false positives.  So it's a
> lot of complexity for what seems to have always been an artificial
> test case.

OK, this is what I have done so far.  Not checked in yet, but it looks
right to me.  Note that this makes your testcase have a very booring
result.  :-)

I'm going to let this one soak for a bit to make sure we don't pick up
any fase positives or negatives in the hueristics.

						- Ted

diff -r 11d3e029aa83 e2fsck/message.c
--- a/e2fsck/message.c	Thu Mar 29 00:32:23 2007 -0400
+++ b/e2fsck/message.c	Sat Mar 31 10:36:55 2007 -0400
@@ -35,6 +35,7 @@
  * 	%Id	<inode> -> i_dir_acl
  * 	%Iu	<inode> -> i_uid
  * 	%Ig	<inode> -> i_gid
+ *	%It	<inode type>
  * 	%j	<ino2>			inode number
  * 	%m	<com_err error message>
  * 	%N	<num>
@@ -310,6 +311,25 @@ static _INLINE_ void expand_inode_expres
 		printf("%d", (inode->i_gid |
 			      (inode->osd2.linux2.l_i_gid_high << 16)));
 		break;
+	case 't':
+		if (LINUX_S_ISREG(inode->i_mode)) 
+			printf(_("regular file"));
+		else if (LINUX_S_ISDIR(inode->i_mode)) 
+			printf(_("directory"));
+		else if (LINUX_S_ISCHR(inode->i_mode)) 
+			printf(_("character device"));
+		else if (LINUX_S_ISBLK(inode->i_mode)) 
+			printf(_("block device"));
+		else if (LINUX_S_ISFIFO(inode->i_mode)) 
+			printf(_("named pipe"));
+		else if (LINUX_S_ISLNK(inode->i_mode)) 
+			printf(_("symbolic link"));
+		else if (LINUX_S_ISSOCK(inode->i_mode))
+			printf(_("socket"));
+		else
+			printf(_("unknown file type with mode 0%o"),
+			       inode->i_mode);
+		break;
 	default:
 	no_inode:
 		printf("%%I%c", ch);
diff -r 11d3e029aa83 e2fsck/pass1.c
--- a/e2fsck/pass1.c	Thu Mar 29 00:32:23 2007 -0400
+++ b/e2fsck/pass1.c	Sat Mar 31 10:36:55 2007 -0400
@@ -133,11 +133,10 @@ int e2fsck_pass1_check_device_inode(ext2
 	int	i;
 
 	/*
-	 * If i_blocks is non-zero, or the index flag is set, then
-	 * this is a bogus device/fifo/socket
+	 * If the index flag is set, then this is a bogus
+	 * device/fifo/socket
 	 */
-	if ((ext2fs_inode_data_blocks(fs, inode) != 0) ||
-	    (inode->i_flags & EXT2_INDEX_FL))
+	if (inode->i_flags & EXT2_INDEX_FL)
 		return 0;
 
 	/*
@@ -370,6 +369,73 @@ static void check_inode_extra_space(e2fs
 	if (*eamagic == EXT2_EXT_ATTR_MAGIC) {
 		/* it seems inode has an extended attribute(s) in body */
 		check_ea_in_inode(ctx, pctx);
+	}
+}
+
+/* 
+ * Check to see if the inode might really be a directory, despite i_mode
+ *
+ * This is a lot of complexity for something for which I'm not really
+ * convinced happens frequently in the wild.  If for any reason this
+ * causes any problems, take this code out.
+ * [tytso:20070331.0827EDT]
+ */
+static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
+				char *buf)
+{
+	struct ext2_inode *inode = pctx->inode;
+	int i, not_device = 0;
+	blk_t blk;
+	struct ext2_dir_entry 	*dirent;
+
+	if (LINUX_S_ISDIR(inode->i_mode) || LINUX_S_ISREG(inode->i_mode))
+		return;
+
+	for (i=0; i < EXT2_N_BLOCKS; i++) {
+		blk = inode->i_block[i];
+		if (!blk)
+			continue;
+		if (i >= 4)
+			not_device++;
+
+		if (blk < ctx->fs->super->s_first_data_block ||
+		    blk >= ctx->fs->super->s_blocks_count ||
+		    ext2fs_fast_test_block_bitmap(ctx->block_found_map, blk))
+			return;	/* Invalid block, can't be dir */
+	}
+
+	if ((LINUX_S_ISCHR(inode->i_mode) || LINUX_S_ISBLK(inode->i_mode)) && 
+	    (inode->i_links_count == 1) && !not_device)
+		return;
+
+	if (LINUX_S_ISLNK(inode->i_mode) && inode->i_links_count == 1)
+		return;
+
+	if (ext2fs_read_dir_block(ctx->fs, inode->i_block[0], buf))
+		return;
+
+	dirent = (struct ext2_dir_entry *) buf;
+	if (((dirent->name_len & 0xFF) != 1) ||
+	    (dirent->name[0] != '.') ||
+	    (dirent->inode != pctx->ino) ||
+	    (dirent->rec_len < 12) ||
+	    (dirent->rec_len % 4) ||
+	    (dirent->rec_len >= ctx->fs->blocksize - 12))
+		return;
+
+	dirent = (struct ext2_dir_entry *) (buf + dirent->rec_len);
+	if (((dirent->name_len & 0xFF) != 2) ||
+	    (dirent->name[0] != '.') ||
+	    (dirent->name[1] != '.') ||
+	    (dirent->rec_len < 12) ||
+	    (dirent->rec_len % 4))
+		return;
+
+	if (fix_problem(ctx, PR_1_TREAT_AS_DIRECTORY, pctx)) {
+		inode->i_mode = (inode->i_mode & 07777) | LINUX_S_IFDIR;
+		e2fsck_write_inode_full(ctx, pctx->ino, inode, 
+					EXT2_INODE_SIZE(ctx->fs->super), 
+					"check_is_really_dir");
 	}
 }
 
@@ -770,6 +836,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		}
 
 		check_inode_extra_space(ctx, &pctx);
+		check_is_really_dir(ctx, &pctx, block_buf);
 
 		if (LINUX_S_ISDIR(inode->i_mode)) {
 			ext2fs_mark_inode_bitmap(ctx->inode_dir_map, ino);
diff -r 11d3e029aa83 e2fsck/pass3.c
--- a/e2fsck/pass3.c	Thu Mar 29 00:32:23 2007 -0400
+++ b/e2fsck/pass3.c	Sat Mar 31 10:36:55 2007 -0400
@@ -645,6 +645,7 @@ static int fix_dotdot_proc(struct ext2_d
 		fix_problem(fp->ctx, PR_3_ADJUST_INODE, &pctx);
 	}
 	dirent->inode = fp->parent;
+	dirent->name_len = (dirent->name_len & 0xFF) | EXT2_FT_DIR << 8;
 
 	fp->done++;
 	return DIRENT_ABORT | DIRENT_CHANGED;
diff -r 11d3e029aa83 e2fsck/problem.c
--- a/e2fsck/problem.c	Thu Mar 29 00:32:23 2007 -0400
+++ b/e2fsck/problem.c	Sat Mar 31 10:36:55 2007 -0400
@@ -778,6 +778,11 @@ static struct e2fsck_problem problem_tab
 	{ PR_1_ATTR_HASH,
 	  N_("@a in @i %i has a hash (%N) which is @n (must be 0)\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* inode appears to be a directory */
+	{ PR_1_TREAT_AS_DIRECTORY,
+	  N_("@i %i is a %It but it looks like it is really a directory\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
 
 	/* Pass 1b errors */
 
diff -r 11d3e029aa83 e2fsck/problem.h
--- a/e2fsck/problem.h	Thu Mar 29 00:32:23 2007 -0400
+++ b/e2fsck/problem.h	Sat Mar 31 10:36:55 2007 -0400
@@ -452,6 +452,9 @@ struct problem_context {
 /* wrong EA hash value */
 #define PR_1_ATTR_HASH			0x010054
 
+/* inode appears to be a directory */
+#define PR_1_TREAT_AS_DIRECTORY		0x010055
+
 /*
  * Pass 1b errors
  */

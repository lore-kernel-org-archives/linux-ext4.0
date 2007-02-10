From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-30.diff>
Date: Fri, 9 Feb 2007 18:11:27 -0800
Message-ID: <200702100211.l1A2BRpR007277@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:43687 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbXBJCOb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lawrence Livermore National Labs recently ran the source code
analysis tool Coverity over the e2fsprogs-1.39 source to see 
if it would identify any significant bugs.  The analysis
turned up 38 mostly minor issues which are enumerated here
with patches.  We went through and resolved these issues
but would love to see these mostly minor changes reviewed
and commited upstream.

Thanks,
Brian Behlendorf <behlendorf1@llnl.gov>, and
Herb Wartens <wartens2@llnl.gov>

-----------------------------------------------------------------------------
Coverity ID: 30: Resource Leak

Need to close file if we return early if out_file != stdout.
Also looks like there is a bug here:
if (!out_file < 0)
This will always be false. Changed to:
if (!out_file)
since if the file is not opened properly out_file will be NULL
and errno will be set.

Index: e2fsprogs+chaos/debugfs/logdump.c
===================================================================
--- e2fsprogs+chaos.orig/debugfs/logdump.c
+++ e2fsprogs+chaos/debugfs/logdump.c
@@ -170,7 +170,7 @@ void do_logdump(int argc, char **argv)
 	} else {
 		out_fn = argv[optind];
 		out_file = fopen(out_fn, "w");
-		if (!out_file < 0) {
+		if (!out_file) {
 			com_err(argv[0], errno, "while opening %s for logdump",
 				out_fn);
 			return;
@@ -193,6 +193,8 @@ void do_logdump(int argc, char **argv)
 		if (journal_fd < 0) {
 			com_err(argv[0], errno, "while opening %s for logdump",
 				journal_fn);
+			if (out_file != stdout)
+				fclose(out_file);
 			return;
 		}
 		
@@ -203,6 +205,8 @@ void do_logdump(int argc, char **argv)
 			if (es->s_jnl_backup_type != EXT3_JNL_BACKUP_BLOCKS) {
 				com_err(argv[0], 0,
 					"no journal backup in super block\n");
+				if (out_file != stdout)
+					fclose(out_file);
 				return;
 			}
 			memset(&journal_inode, 0, sizeof(struct ext2_inode));
@@ -213,14 +217,19 @@ void do_logdump(int argc, char **argv)
 			journal_inode.i_mode = LINUX_S_IFREG | 0600;
 		} else {
 			if (debugfs_read_inode(journal_inum, &journal_inode, 
-					       argv[0]))
+					       argv[0])) {
+				if (out_file != stdout)
+					fclose(out_file);
 				return;
+			}
 		}
 		
 		retval = ext2fs_file_open2(current_fs, journal_inum,
 					   &journal_inode, 0, &journal_file);
 		if (retval) {
 			com_err(argv[0], retval, "while opening ext2 file");
+			if (out_file != stdout)
+				fclose(out_file);
 			return;
 		}
 		journal_source.where = JOURNAL_IS_INTERNAL;
@@ -234,6 +243,8 @@ void do_logdump(int argc, char **argv)
 				journal_fn = blkid_devno_to_devname(es->s_journal_dev);
 		if (!journal_fn) {
 			com_err(argv[0], 0, "filesystem has no journal");
+			if (out_file != stdout)
+				fclose(out_file);
 			return;
 		}
 		journal_fd = open(journal_fn, O_RDONLY, 0);
@@ -241,6 +252,8 @@ void do_logdump(int argc, char **argv)
 			com_err(argv[0], errno, "while opening %s for logdump",
 				journal_fn);
 			free(journal_fn);
+			if (out_file != stdout)
+				fclose(out_file);
 			return;
 		}
 		fprintf(out_file, "Using external journal found at %s\n",

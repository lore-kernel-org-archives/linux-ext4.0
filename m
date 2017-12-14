From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 3/5] Add missing information to debugfs man pages and usage texts.
Date: Wed, 13 Dec 2017 23:13:11 -0800
Message-ID: <dbdaf88970cb0d465913b7e82d43925592202865.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Cc: linux-ext4@vger.kernel.org,
        Tyson Nottingham <tgnottingham@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:47048 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbdLNHOi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Dec 2017 02:14:38 -0500
Received: by mail-pg0-f48.google.com with SMTP id b11so2858978pgu.13
        for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2017 23:14:38 -0800 (PST)
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add descriptions for dump_unused, get_quota, list_quota,
set_current_time, show_debugfs_params, and supported_features
commands to debugfs man page. Add various missing command
arguments and correct a few typos in man page and usage texts.

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---
 debugfs/debugfs.8.in | 49 ++++++++++++++++++++++++++++++++++++++++---------
 debugfs/debugfs.c    | 10 +++++-----
 debugfs/do_journal.c |  2 +-
 debugfs/logdump.c    |  2 +-
 debugfs/ls.c         |  2 +-
 debugfs/set_fields.c |  4 ++--
 debugfs/xattrs.c     |  2 +-
 7 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 55abd71..4b5f472 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -143,7 +143,7 @@ Before overwriting a file system block, write the old contents of the block to
 an undo file.  This undo file can be used with e2undo(8) to restore the old
 contents of the file system should something go wrong.  If the empty string is
 passed as the undo_file argument, the undo file will be written to a file named
-resize2fs-\fIdevice\fR.e2undo in the directory specified via the
+debugfs-\fIdevice\fR.e2undo in the directory specified via the
 \fIE2FSPROGS_UNDO_DIR\fR environment variable.
 
 WARNING: The undo file cannot be used to recover from a power or system crash.
@@ -237,8 +237,11 @@ Search the directory
 for
 .IR filename .
 .TP
-.B dirty
+.BI dirty " [-clean]"
 Mark the filesystem as dirty, so that the superblocks will be written on exit.
+Additionally, clear the superblock's valid flag, or set it if
+.I -clean
+is specified.
 .TP
 .BI dump " [-p] filespec out_file"
 Dump the contents of the inode
@@ -290,7 +293,10 @@ not stored in filesystem data structures.   Hence, the values displayed
 may not necessarily by accurate and does not indicate a problem or
 corruption in the file system.)
 .TP
-.BI ea_get " [-f outfile] filespec attr_name"
+.B dump_unused
+Dump unused blocks which contain non-null bytes.
+.TP
+.BI ea_get " [-f outfile]|[-xVC] [-r] filespec attr_name"
 Retrieve the value of the extended attribute
 .I attr_name
 in the file
@@ -302,7 +308,7 @@ List the extended attributes associated with the file
 .I filespec
 to standard output.
 .TP
-.BI ea_set " [-f infile] filespec attr_name attr_value
+.BI ea_set " [-f infile] [-r] filespec attr_name attr_value
 Set the value of the extended attribute
 .I attr_name
 in the file
@@ -402,6 +408,9 @@ If
 .I num
 is specified, also clear num-1 inodes after the specified inode.
 .TP
+.BI get_quota " quota_type id"
+Display quota information for given quota type (user, group, or project) and ID.
+.TP
 .B help
 Print a list of commands understood by
 .BR debugfs .
@@ -437,7 +446,7 @@ the superblock and block descriptors.
 .BI journal_close
 Close the open journal.
 .TP
-.BI journal_open " [-c] [-v ver] [-j ext_jnl]
+.BI journal_open " [-c] [-v ver] [-f ext_jnl]
 Opens the journal for reading and writing.  Journal checksumming can
 be enabled by supplying \fI-c\fR; checksum formats 2 and 3 can be
 selected with the \fI-v\fR option.  An external journal can be loaded
@@ -469,6 +478,9 @@ process to
 .I directory
 on the native filesystem.
 .TP
+.BI list_quota " quota_type"
+Display quota information for given quota type (user, group, or project).
+.TP
 .BI ln " filespec dest_file"
 Create a link named
 .I dest_file
@@ -476,7 +488,7 @@ which is a hard link to
 .IR filespec .
 Note this does not adjust the inode reference counts.
 .TP
-.BI logdump " [-acsO] [-b block] [-i filespec] [-f journal_file] [output_file]"
+.BI logdump " [-acsOS] [-b block] [-i filespec] [-f journal_file] [output_file]"
 Dump the contents of the ext3 journal.  By default, dump the journal inode as
 specified in the superblock.  However, this can be overridden with the
 .I \-i
@@ -490,6 +502,12 @@ option utilizes the backup information in the superblock to locate the
 journal.
 .IP
 The
+.I \-S
+option causes
+.B logdump
+to print the contents of the journal superblock.
+.IP
+The
 .I \-a
 option causes the
 .B logdump
@@ -498,7 +516,7 @@ The
 .I \-b
 option causes
 .B logdump
-to print all journal records that are refer to the specified block.
+to print all journal records that refer to the specified block.
 The
 .I \-c
 option will print out the contents of all of the data blocks selected by
@@ -570,7 +588,7 @@ to those inodes.  The
 flag will enable checking the file type information in the directory
 entry to make sure it matches the inode's type.
 .TP
-.BI open " [-weficD] [-b blocksize] [-s superblock] [-z undo_file] device"
+.BI open " [-weficD] [-b blocksize] [-d image_filename] [-s superblock] [-z undo_file] device"
 Open a filesystem for editing.  The
 .I -f
 flag forces the filesystem to be opened even if there are some unknown
@@ -578,7 +596,7 @@ or incompatible filesystem features which would normally
 prevent the filesystem from being opened.  The
 .I -e
 flag causes the filesystem to be opened in exclusive mode.  The
-.IR -b ", " -c ", " -i ", " -s ", " -w ", and " -D
+.IR -b ", " -c ", " -d ", " -i ", " -s ", " -w ", and " -D
 options behave the same as the command-line options to
 .BR debugfs .
 .TP
@@ -649,6 +667,10 @@ has value
 Also available as
 .BR set_bg .
 .TP
+.BI set_current_time " time"
+Set current time in seconds since Unix epoch to use when setting filesystem
+fields.
+.TP
 .BI seti " filespec [num]"
 Mark inode
 .I filespec
@@ -691,6 +713,11 @@ can be displayed by using the command:
 Also available as
 .BR ssv .
 .TP
+.B show_debugfs_params
+Display
+.B debugfs
+parameters such as information about currently opened filesystem.
+.TP
 .BI show_super_stats " [-h]"
 List the contents of the super block and the block group descriptors.  If the
 .I -h
@@ -701,6 +728,10 @@ flag is given, only print out the superblock contents. Also available as
 Display the contents of the inode structure of the inode
 .IR filespec .
 .TP
+.B supported_features
+Display filesystem features supported by this version of
+.BR debugfs .
+.TP
 .BI testb " block [count]"
 Test if the block number
 .I block
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 4a533b5..341e742 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -292,7 +292,7 @@ void do_open_filesys(int argc, char **argv)
 
 print_usage:
 	fprintf(stderr, "%s: Usage: open [-s superblock] [-b blocksize] "
-		"[-d image_filename] [-c] [-i] [-f] [-e] [-D] "
+		"[-d image_filename] [-z undo_file] [-c] [-i] [-f] [-e] [-D] "
 #ifndef READ_ONLY
 		"[-w] "
 #endif
@@ -514,7 +514,7 @@ void do_show_super_stats(int argc, char *argv[])
 	close_pager(out);
 	return;
 print_usage:
-	fprintf(stderr, "%s: Usage: show_super [-h]\n", argv[0]);
+	fprintf(stderr, "%s: Usage: show_super_stats [-h]\n", argv[0]);
 }
 
 #ifndef READ_ONLY
@@ -1684,7 +1684,7 @@ void do_find_free_inode(int argc, char *argv[])
 	char		*tmp;
 
 	if (argc > 3 || (argc>1 && *argv[1] == '?')) {
-		com_err(argv[0], 0, "Usage: find_free_inode [dir] [mode]");
+		com_err(argv[0], 0, "Usage: find_free_inode [dir [mode]]");
 		return;
 	}
 	if (check_fs_open(argv[0]))
@@ -2416,11 +2416,11 @@ int main(int argc, char **argv)
 	int		retval;
 	const char	*usage = 
 		"Usage: %s [-b blocksize] [-s superblock] [-f cmd_file] "
-		"[-R request] [-V] ["
+		"[-R request] [-d data_source_device] [-i] [-n] [-D] [-V] ["
 #ifndef READ_ONLY
 		"[-w] [-z undo_file] "
 #endif
-		"[-c] device]";
+		"[-c]] [device]";
 	int		c;
 	int		open_flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
 	char		*request = 0;
diff --git a/debugfs/do_journal.c b/debugfs/do_journal.c
index 40c473c..d7ab916 100644
--- a/debugfs/do_journal.c
+++ b/debugfs/do_journal.c
@@ -899,7 +899,7 @@ void do_journal_open(int argc, char *argv[])
 			printf("%s: [-c] [-v ver] [-f ext_jnl]\n", argv[0]);
 			printf("-c: Enable journal checksumming.\n");
 			printf("-v: Use this version checksum format.\n");
-			printf("-j: Load this external journal.\n");
+			printf("-f: Load this external journal.\n");
 		}
 	}
 
diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 864f234..03edb44 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -275,7 +275,7 @@ errout:
 	return;
 
 print_usage:
-	fprintf(stderr, "%s: Usage: logdump [-acsO] [-b<block>] [-i<filespec>]\n\t"
+	fprintf(stderr, "%s: Usage: logdump [-acsOS] [-b<block>] [-i<filespec>]\n\t"
 		"[-f<journal_file>] [output_file]\n", argv[0]);
 }
 
diff --git a/debugfs/ls.c b/debugfs/ls.c
index 61b6319..bfc28cb 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -228,7 +228,7 @@ void do_list_dir(int argc, char *argv[])
 
 	if (argc > optind+1) {
 	print_usage:
-		com_err(0, 0, "Usage: ls [-l] [-d] [-p] file");
+		com_err(0, 0, "Usage: ls [-c] [-d] [-l] [-p] [-r] file");
 		return;
 	}
 
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 8dfbba9..117cfb8 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -787,7 +787,7 @@ void do_set_inode(int argc, char *argv[])
 void do_set_block_group_descriptor(int argc, char *argv[])
 {
 	const char *usage = "<bg number> <field> <value>\n"
-		"\t\"set_block_group_descriptor -l\" will list the names of "
+		"\t\"set_block_group -l\" will list the names of "
 		"the fields in a block group descriptor\n\twhich can be set.";
 	struct field_set_info	*table;
 	struct field_set_info	*ss;
@@ -818,7 +818,7 @@ void do_set_block_group_descriptor(int argc, char *argv[])
 		return;
 	}
 
-	if (common_args_process(argc, argv, 4, 4, "set_block_group_descriptor",
+	if (common_args_process(argc, argv, 4, 4, "set_block_group",
 				usage, CHECK_FS_RW))
 		return;
 
diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
index fdb76e4..390165c 100644
--- a/debugfs/xattrs.c
+++ b/debugfs/xattrs.c
@@ -267,7 +267,7 @@ void do_set_xattr(int argc, char **argv)
 
 	if (!(fp && optind == argc - 2) && !(!fp && optind == argc - 3)) {
 	print_usage:
-		printf("Usage:\t%s <file> <attr> <value>\n", argv[0]);
+		printf("Usage:\t%s [-r] <file> <attr> <value>\n", argv[0]);
 		printf("\t%s -f <value_file> [-r] <file> <attr>\n", argv[0]);
 		goto out2;
 	}
-- 
2.7.4

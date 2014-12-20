From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/31] debugfs: document new commands
Date: Sat, 20 Dec 2014 13:16:53 -0800
Message-ID: <20141220211653.25563.55147.stgit@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40369 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaLTVQ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2014 16:16:58 -0500
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Document the new journal and xattr commands in the debugfs manpage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.8.in |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 debugfs/do_journal.c |    3 ++-
 2 files changed, 48 insertions(+), 2 deletions(-)


diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 8f44ced..04c280d 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -262,6 +262,32 @@ not stored in filesystem data structures.   Hence, the values displayed
 may not necessarily by accurate and does not indicate a problem or
 corruption in the file system.)
 .TP
+.BI ea_get " [-f outfile] filespec attr_name"
+Retrieve the value of the extended attribute
+.I attr_name
+in the file
+.I filespec
+and write it either to stdout or to \fIoutfile\fR.
+.TP
+.BI ea_list " filespec
+List the extended attributes associated with the file
+.I filespec
+to standard output.
+.TP
+.BI ea_set " [-f infile] filespec attr_name attr_value
+Set the value of the extended attribute
+.I attr_name
+in the file
+.I filespec
+to the string value
+.I attr_value
+or read it from \fIinfile\fR.
+.TP
+.BI ea_rm " filespec attr_names...
+Remove the extended attribute
+.I attr_name
+from the file \fIfilespec\fR.
+.TP
 .BI expand_dir " filespec"
 Expand the directory
 .IR filespec .
@@ -373,6 +399,26 @@ to do this, use the
 program.  This is just a call to the low-level library, which sets up
 the superblock and block descriptors.
 .TP
+.BI journal_close
+Close the open journal.
+.TP
+.BI journal_open " [-c] [-v ver] [-j ext_jnl]
+Opens the journal for reading and writing.  Journal checksumming can
+be enabled by supplying \fI-c\fR; checksum formats 2 and 3 can be
+selected with the \fI-v\fR option.  An external journal can be loaded
+from \fIext_jnl\fR.
+.TP
+.BI journal_run
+Replay all transactions in the open journal.
+.TP
+.BI journal_write " [-b blocks] [-r revoke] [-c] file
+Write a transaction to the open journal.  The list of blocks to write
+should be supplied as a comma-separated list in \fIblocks\fR; the
+blocks themselves should be readable from \fIfile\fR.  A list of
+blocks to revoke can be supplied as a comma-separated list in
+\fIrevoke\fR.  By default, a commit record is written at the end; the
+\fI-c\fR switch writes an uncommitted transaction.
+.TP
 .BI kill_file " filespec"
 Deallocate the inode
 .I filespec
@@ -667,7 +713,6 @@ into a newly-created file in the filesystem named
 .IR out_file .
 .TP
 .BI zap_block " [-f filespec] [-o offset] [-l length] [-p pattern] block_num"
-.TP
 Overwrite the block specified by
 .I block_num
 with zero (NUL) bytes, or if
diff --git a/debugfs/do_journal.c b/debugfs/do_journal.c
index a17af6e..46d1793 100644
--- a/debugfs/do_journal.c
+++ b/debugfs/do_journal.c
@@ -925,9 +925,10 @@ void do_journal_open(int argc, char *argv[])
 			}
 			break;
 		default:
-			printf("%s: [-c] [-v ver]\n", argv[0]);
+			printf("%s: [-c] [-v ver] [-f ext_jnl]\n", argv[0]);
 			printf("-c: Enable journal checksumming.\n");
 			printf("-v: Use this version checksum format.\n");
+			printf("-j: Load this external journal.\n");
 		}
 	}
 


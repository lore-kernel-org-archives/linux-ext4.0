From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/37] debugfs: force logdump to display (old) journal
 contents
Date: Sun, 11 May 2014 23:31:08 -0400
Message-ID: <20140512033108.GJ5480@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231302.31890.45397.stgit@birch.djwong.org>
 <alpine.LFD.2.00.1405021346570.2154@localhost.localdomain>
 <20140506002453.GN8434@birch.djwong.org>
 <20140512014119.GI5480@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33819 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaELDbO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 23:31:14 -0400
Content-Disposition: inline
In-Reply-To: <20140512014119.GI5480@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It is useful to be able to display only selected contents of the
already checkpointed transactions.  So instead of using -a twice, it's
better to define a new option, -O, to print the old journal entries.
This allows for commands such as "logdump -O -b 680".

     	    		      	 	  - Ted

commit 46272d5aa21fe879ca90a157485a2a3507e0a9b4
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Thu May 1 16:13:02 2014 -0700

    debugfs: force logdump to display (old) journal contents
    
    If the user passes the -O option to logdump, try to dump old log
    contents.  This can be used to try to track down journal problems even
    after the journal has been replayed.
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 7cda819..aacb223 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -389,7 +389,7 @@ which is a hard link to
 .IR filespec .
 Note this does not adjust the inode reference counts.
 .TP
-.BI logdump " [-acs] [-b block] [-i filespec] [-f journal_file] [output_file]"
+.BI logdump " [-acsO] [-b block] [-i filespec] [-f journal_file] [output_file]"
 Dump the contents of the ext3 journal.  By default, dump the journal inode as
 specified in the superblock.  However, this can be overridden with the
 .I \-i
@@ -420,6 +420,12 @@ the
 and
 .I \-b
 options.
+.IP
+The
+.I \-O
+option causes logdump to display old (checkpointed) journal entries.
+This can be used to try to track down journal problems even after the
+journal has been replayed.
 .TP
 .BI ls " [-l] [-c] [-d] [-p] filespec"
 Print a listing of the files in the directory
diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 211e11a..9f9594f 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -39,7 +39,7 @@ enum journal_location {JOURNAL_IS_INTERNAL, JOURNAL_IS_EXTERNAL};
 
 #define ANY_BLOCK ((blk64_t) -1)
 
-static int		dump_all, dump_contents, dump_descriptors;
+static int		dump_all, dump_old, dump_contents, dump_descriptors;
 static blk64_t		block_to_dump, bitmap_to_dump, inode_block_to_dump;
 static unsigned int	group_to_dump, inode_offset_to_dump;
 static ext2_ino_t	inode_to_dump;
@@ -94,6 +94,7 @@ void do_logdump(int argc, char **argv)
 	journal_source.fd = 0;
 	journal_source.file = 0;
 	dump_all = 0;
+	dump_old = 0;
 	dump_contents = 0;
 	dump_descriptors = 1;
 	block_to_dump = ANY_BLOCK;
@@ -102,7 +103,7 @@ void do_logdump(int argc, char **argv)
 	inode_to_dump = -1;
 
 	reset_getopt();
-	while ((c = getopt (argc, argv, "ab:ci:f:s")) != EOF) {
+	while ((c = getopt (argc, argv, "ab:ci:f:Os")) != EOF) {
 		switch (c) {
 		case 'a':
 			dump_all++;
@@ -126,6 +127,9 @@ void do_logdump(int argc, char **argv)
 			inode_spec = optarg;
 			dump_descriptors = 0;
 			break;
+		case 'O':
+			dump_old++;
+			break;
 		case 's':
 			use_sb++;
 			break;
@@ -267,7 +271,7 @@ errout:
 	return;
 
 print_usage:
-	fprintf(stderr, "%s: Usage: logdump [-acs] [-b<block>] [-i<filespec>]\n\t"
+	fprintf(stderr, "%s: Usage: logdump [-acsO] [-b<block>] [-i<filespec>]\n\t"
 		"[-f<journal_file>] [output_file]\n", argv[0]);
 }
 
@@ -393,9 +397,13 @@ static void dump_journal(char *cmdname, FILE *out_file,
 	fprintf(out_file, "Journal starts at block %u, transaction %u\n",
 		blocknr, transaction);
 
-	if (!blocknr)
+	if (!blocknr) {
 		/* Empty journal, nothing to do. */
-		return;
+		if (!dump_old)
+			return;
+		else
+			blocknr = 1;
+	}
 
 	while (1) {
 		retval = read_journal_block(cmdname, source,
@@ -420,7 +428,8 @@ static void dump_journal(char *cmdname, FILE *out_file,
 			fprintf (out_file, "Found sequence %u (not %u) at "
 				 "block %u: end of journal.\n",
 				 sequence, transaction, blocknr);
-			return;
+			if (!dump_old)
+				return;
 		}
 
 		if (dump_descriptors) {

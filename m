From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/24] debugfs: create idump command to dump an inode in
 hex
Date: Tue, 22 Jul 2014 13:47:36 -0400
Message-ID: <20140722174736.GG25291@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225236.31374.97509.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50618 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbaGVUfG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:35:06 -0400
Content-Disposition: inline
In-Reply-To: <20140718225236.31374.97509.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:52:36PM -0700, Darrick J. Wong wrote:
> Create a command that will dump an entire inode's space in hex.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied with the following addition which (a) adds a formal longer
command name ("inode_dump") to be analogous with the "block_dump"
command, and (b) adds an entry to the debugfs man page.

	     	      	       	  - Ted

diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index ef4c5c4..ed3728f 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -188,7 +188,7 @@ request do_zap_block, "Zap block: fill with 0, pattern, flip bits etc.",
 	zap_block, zap;
 
 request do_block_dump, "Dump contents of a block",
-	block_dump, bd;
+	block_dump, bdump, bd;
 
 request do_list_quota, "List quota",
 	list_quota, lq;
@@ -196,8 +196,8 @@ request do_list_quota, "List quota",
 request do_get_quota, "Get quota",
 	get_quota, gq;
 
-request do_idump, "Dump inode",
-	idump;
+request do_idump, "Dump the inode structure in hex",
+	inode_dump, idump, id;
 
 
 end;
diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 73254d3..9a125f6 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -346,6 +346,9 @@ showing its tree structure.
 Print a listing of the inodes which use the one or more blocks specified
 on the command line.
 .TP
+.BI inode_dump " filespec"
+Print the contents of the inode data structure in hex and ASCII format.
+.TP
 .BI imap " filespec"
 Print the location of the inode data structure (in the inode table)
 of the inode

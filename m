From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-47.diff>
Date: Fri, 9 Feb 2007 18:11:40 -0800
Message-ID: <200702100211.l1A2Be0V007486@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:20101 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbXBJCO5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:57 -0500
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
Coverity ID: 47: Used before assigned

long_opt must be initialized to 0 to ensure the 'l' option has the
desired effect.

Index: e2fsprogs+chaos/debugfs/htree.c
===================================================================
--- e2fsprogs+chaos.orig/debugfs/htree.c
+++ e2fsprogs+chaos/debugfs/htree.c
@@ -181,7 +181,7 @@ void do_htree_dump(int argc, char *argv[
 	ext2_ino_t	ino;
 	struct ext2_inode inode;
 	int		c;
-	int		long_opt;
+	int		long_opt = 0;
 	char		*buf = NULL;
 	struct 		ext2_dx_root_info  *rootnode;
 	struct 		ext2_dx_entry *ent;

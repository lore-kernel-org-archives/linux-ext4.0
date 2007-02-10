From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-11.diff>
Date: Fri, 9 Feb 2007 18:11:09 -0800
Message-ID: <200702100211.l1A2B9wF007009@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:7210 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbXBJCOU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:20 -0500
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
Coverity ID: 11: Overrun Static

Add an extra byte to EXT2_NAME_LEN in the static allocation for the
required trailing null.  This allows filenames up to the maximum
length of EXT2_NAME_LEN withover an overrun.

Index: e2fsprogs+chaos/debugfs/ls.c
===================================================================
--- e2fsprogs+chaos.orig/debugfs/ls.c
+++ e2fsprogs+chaos/debugfs/ls.c
@@ -52,14 +52,14 @@ static int list_dir_proc(ext2_ino_t dir 
 	ext2_ino_t		ino;
 	struct tm		*tm_p;
 	time_t			modtime;
-	char			name[EXT2_NAME_LEN];
+	char			name[EXT2_NAME_LEN + 1];
 	char			tmp[EXT2_NAME_LEN + 16];
 	char			datestr[80];
 	char			lbr, rbr;
 	int			thislen;
 	struct list_dir_struct *ls = (struct list_dir_struct *) private;
 
-	thislen = ((dirent->name_len & 0xFF) < EXT2_NAME_LEN) ?
+	thislen = ((dirent->name_len & 0xFF) <= EXT2_NAME_LEN) ?
 		(dirent->name_len & 0xFF) : EXT2_NAME_LEN;
 	strncpy(name, dirent->name, thislen);
 	name[thislen] = '\0';

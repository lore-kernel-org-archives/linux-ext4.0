From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-4.diff>
Date: Fri, 9 Feb 2007 18:11:35 -0800
Message-ID: <200702100211.l1A2BZvu007411@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:40380 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbXBJCOp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:45 -0500
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
Coverity ID: 4: Deadcode

This check is unnecessary since fs_type is guaranteed to be set earlier in the
function.

Index: e2fsprogs+chaos/misc/mke2fs.c
===================================================================
--- e2fsprogs+chaos.orig/misc/mke2fs.c
+++ e2fsprogs+chaos/misc/mke2fs.c
@@ -1310,8 +1310,6 @@ static void PRS(int argc, char *argv[])
 
 	if (fs_param.s_feature_incompat & 
 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
-		if (!fs_type)
-			fs_type = "journal";
 		reserved_ratio = 0;
 		fs_param.s_feature_incompat = EXT3_FEATURE_INCOMPAT_JOURNAL_DEV;
 		fs_param.s_feature_compat = 0;

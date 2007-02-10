From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-5.diff>
Date: Fri, 9 Feb 2007 18:11:41 -0800
Message-ID: <200702100211.l1A2Bfjd007495@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:20101 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbXBJCOz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:55 -0500
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
Coverity ID: 5: Forward NULL

array is initially set to NULL, so it is possible that readdir() will return
NULL and leave array set to NULL. Thus we do need to check if array is NULL or
check if num != 0.

There is definitely space allocated to array in the normal case. It calls
realloc which since array is NULL the first time through will behave like
malloc. The other times we will resize the array to be 11 larger.

It should be safe to run qsort on array since num should be set to 0 so nothing
will be sorted.  It should also be safe to set *ret_array = array. The array
passed in should just be NULL at this point.

Index: e2fsprogs+chaos/e2fsck/profile.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/profile.c
+++ e2fsprogs+chaos/e2fsck/profile.c
@@ -280,7 +280,8 @@ static errcode_t get_dirlist(const char 
 		array[num++] = fn;
 	}
 	qsort(array, num, sizeof(char *), compstr);
-	array[num++] = 0;
+	if(array)
+		array[num++] = 0;
 	*ret_array = array;
 	closedir(dir);
 	return 0;

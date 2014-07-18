From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/24] misc: fix problems with strncat
Date: Fri, 18 Jul 2014 15:54:07 -0700
Message-ID: <20140718225407.31374.16212.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35669 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946059AbaGRWyN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:54:13 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The third argument to strncat is the maximum number of characters to
copy out of the second argument; it is not the maximum length of the
first argument.

Therefore, code in a check just in case we ever find a /sys/block/X
path long enough to hit the end of the buffer.  FWIW the longest path
I could find on my machine was 133 bytes.

Fixes-Coverity-Bug: 1252003
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mk_hugefiles.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index ea42b6c..7a565ca 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -188,7 +188,9 @@ static blk64_t get_partition_start(const char *device_name)
 	cp = search_sysfs_block(st.st_rdev, path);
 	if (!cp)
 		return 0;
-	strncat(path, "/start", SYSFS_PATH_LEN);
+	if (strlen(path) > SYSFS_PATH_LEN - strlen("/start") - 1)
+		return 0;
+	strcat(path, "/start");
 	f = fopen(path, "r");
 	if (!f)
 		return 0;


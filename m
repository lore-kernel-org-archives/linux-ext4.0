From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/19] e2fuzz: fix fs handle cleanup when closing fails
Date: Fri, 01 Aug 2014 11:11:46 -0700
Message-ID: <20140801181146.12496.33396.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35913 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHASLw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:11:52 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the handling of 'fs' when closing the FS fails so that we don't
dereference a NULL pointer.  Adapt to use ext2fs_close_free while
we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Fixes-Coverity-Bug: 1229241
---
 misc/e2fuzz.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/misc/e2fuzz.c b/misc/e2fuzz.c
index 644c9c5..8c989dd 100644
--- a/misc/e2fuzz.c
+++ b/misc/e2fuzz.c
@@ -279,23 +279,20 @@ int process_fs(const char *fsname)
 	close(fd);
 
 	/* Clean up */
-	ret = ext2fs_close(fs);
+	ret = ext2fs_close_free(&fs);
 	if (ret) {
-		fs = NULL;
 		fprintf(stderr, "%s: error while closing filesystem\n",
 			fsname);
-		goto fail2;
+		return 1;
 	}
 
 	return 0;
 fail3:
 	close(fd);
-fail2:
 	if (corrupt_map != fs->block_map)
 		ext2fs_free_block_bitmap(corrupt_map);
 fail:
-	if (fs)
-		ext2fs_close(fs);
+	ext2fs_close_free(&fs);
 	return 1;
 }
 


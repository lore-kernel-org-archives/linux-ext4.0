From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] libext2fs: fix tst_badblocks buffer overrun
Date: Tue, 24 Nov 2015 14:50:10 -0700
Message-ID: <1448401810-90675-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:59509 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbbKXV6V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Nov 2015 16:58:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The test2[] array is not 0-terminated and the create_test_list() for
loop does not terminate properly at the end of this array, but
continues until it hits the 0 at the end of test3[].

Reported-by: Hanno Boeck <hanno@hboeck.de>
Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=104311
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/tst_badblocks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/tst_badblocks.c b/lib/ext2fs/tst_badblocks.c
index 3b39ef1..c685f33 100644
--- a/lib/ext2fs/tst_badblocks.c
+++ b/lib/ext2fs/tst_badblocks.c
@@ -30,11 +30,11 @@
 #define DEL_BLK	0x0002
 
 blk_t test1[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0 };
-blk_t test2[] = { 11, 10, 9, 8, 7, 6, 5, 4, 3, 3, 2, 1 };
+blk_t test2[] = { 11, 10, 9, 8, 7, 6, 5, 4, 3, 3, 2, 1, 0 };
 blk_t test3[] = { 3, 1, 4, 5, 9, 2, 7, 10, 5, 6, 10, 8, 0 };
 blk_t test4[] = { 20, 50, 12, 17, 13, 2, 66, 23, 56, 0 };
 blk_t test4a[] = {
- 	20, 1,
+	20, 1,
 	50, 1,
 	3, 0,
 	17, 1,
-- 
1.8.0


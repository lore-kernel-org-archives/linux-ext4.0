From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 10/10] libext2fs: fix printf conversion spec in tst_iscan.c
Date: Tue,  3 Dec 2013 00:10:18 -0500
Message-ID: <1386047418-32431-11-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>,
	Eric Whitney <enwlinux@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35860 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3LCFK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:27 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Whitney <enwlinux@gmail.com>

A recent patch to fix blk_t to blk64_t assignment mismatches in
e2fsprogs (commit 4dbfd79d1458ce1259b951377e341aeb6197f8c1) created
a printf conversion spec / argument type mismatch in tst_iscan.c.
Fix this to avoid truncation of the printed value and to silence
a compiler warning seen when "make check" is run.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/tst_iscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index a95296c..70bfbec 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -182,7 +182,7 @@ static void check_map(void)
 
 	for (i=0; test_vec[i]; i++) {
 		if (ext2fs_test_block_bitmap2(touched_map, test_vec[i])) {
-			printf("Bad block was touched --- %u\n", test_vec[i]);
+			printf("Bad block was touched --- %llu\n", test_vec[i]);
 			failed++;
 			first_no_comma = 1;
 		}
-- 
1.8.5.rc3.362.gdf10213


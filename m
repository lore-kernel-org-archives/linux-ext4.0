From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] libext2fs: fix printf conversion spec in tst_iscan.c
Date: Mon, 11 Nov 2013 14:32:13 -0500
Message-ID: <20131111193213.GB6379@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:64798 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3KKTcS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Nov 2013 14:32:18 -0500
Received: by mail-qa0-f45.google.com with SMTP id hu16so2242288qab.11
        for <linux-ext4@vger.kernel.org>; Mon, 11 Nov 2013 11:32:17 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A recent patch to fix blk_t to blk64_t assignment mismatches in
e2fsprogs (commit 4dbfd79d1458ce1259b951377e341aeb6197f8c1) created
a printf conversion spec / argument type mismatch in tst_iscan.c.
Fix this to avoid truncation of the printed value and to silence
a compiler warning seen when "make check" is run.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
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
1.8.3.2


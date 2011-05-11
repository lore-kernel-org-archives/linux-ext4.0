From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] ext4: Fix max file size of extent format file
Date: Wed, 11 May 2011 17:08:38 +0900
Message-ID: <4DCA4406.4030601@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:59910 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1EKR03 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 May 2011 13:26:29 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id p4B8FT0g003723
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 17:15:29 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We hit BUG_ON in ext4_ext_put_gap_in_cache() while creating a file
whose size is the max file size of extent format. Because the extent cache
length is 0 when we allocate two blocks to the file offset 2^32-2, and then
the offset 2^32-1. To fix it, we decrease the max file size to
(2^32-2)*blocksize. In this way, we would be able to allocate a block up to
the offset 2^32-2. I think there is no data loss because we can read all files
created before applying this patch.

How to reproduce:
I'm running 2.6.39-rc6. Note that i386 architecture and 4KB blocksize cannot
reproduce this problem.

# dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-2))
# sync
# dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-1))

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8553dfb..fce0249 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2248,8 +2248,8 @@ static loff_t ext4_max_size(int blkbits, int has_huge_files)
 
 	/* 32-bit extent-start container, ee_block */
 	res = 1LL << 32;
-	res <<= blkbits;
 	res -= 1;
+	res <<= blkbits;
 
 	/* Sanity check against vm- & vfs- imposed limits */
 	if (res > upper_limit)


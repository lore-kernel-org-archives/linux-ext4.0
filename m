From: akpm@linux-foundation.org
Subject: [patch 1/1] fs/ext4/super.c: fix printk warning
Date: Mon, 21 Dec 2009 16:25:42 -0800
Message-ID: <200912220025.nBM0Phi7005152@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbZLVA0I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Dec 2009 19:26:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

sparc64 allmodconfig:

fs/ext4/super.c: In function `lifetime_write_kbytes_show':
fs/ext4/super.c:2174: warning: long long unsigned int format, long unsigned int arg (arg 4)
fs/ext4/super.c:2174: warning: long long unsigned int format, long unsigned int arg (arg 4)

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext4/super.c~fs-ext4-superc-fix-printk-warning fs/ext4/super.c
--- a/fs/ext4/super.c~fs-ext4-superc-fix-printk-warning
+++ a/fs/ext4/super.c
@@ -2174,9 +2174,9 @@ static ssize_t lifetime_write_kbytes_sho
 	struct super_block *sb = sbi->s_buddy_cache->i_sb;
 
 	return snprintf(buf, PAGE_SIZE, "%llu\n",
-			sbi->s_kbytes_written + 
+			(unsigned long long)(sbi->s_kbytes_written +
 			((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -
-			  EXT4_SB(sb)->s_sectors_written_start) >> 1));
+			  EXT4_SB(sb)->s_sectors_written_start) >> 1)));
 }
 
 static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
_

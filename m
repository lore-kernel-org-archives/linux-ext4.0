From: akpm@linux-foundation.org
Subject: - ext2-improve-ext2_readdir-return-value.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:16 -0700
Message-ID: <200804282200.m3SM0Gqw018679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: improve ext2_readdir() return value
has been removed from the -mm tree.  Its filename was
     ext2-improve-ext2_readdir-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: improve ext2_readdir() return value
From: Akinobu Mita <akinobu.mita@gmail.com>

Improve ext2_readdir() return value for ext2_get_page() failure by using the
actual result of ext2_get_page().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext2/dir.c~ext2-improve-ext2_readdir-return-value fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-improve-ext2_readdir-return-value
+++ a/fs/ext2/dir.c
@@ -299,7 +299,7 @@ ext2_readdir (struct file * filp, void *
 				   "bad page in #%lu",
 				   inode->i_ino);
 			filp->f_pos += PAGE_CACHE_SIZE - offset;
-			return -EIO;
+			return PTR_ERR(page);
 		}
 		kaddr = page_address(page);
 		if (unlikely(need_revalidate)) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
idr-create-idr_layer_cache-at-boot-time.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch


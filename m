From: akpm@linux-foundation.org
Subject: + ext4-use-simple_prepare_write-to-zero-page-data.patch added to -mm tree
Date: Mon, 09 Apr 2007 23:18:08 -0700
Message-ID: <200704100618.l3A6I8cc000545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Cc: nate.diller@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: use simple_prepare_write to zero page data
has been added to the -mm tree.  Its filename is
     ext4-use-simple_prepare_write-to-zero-page-data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4: use simple_prepare_write to zero page data
From: Nate Diller <nate.diller@gmail.com>

It's common for file systems to need to zero data on either side of a
write, if a page is not Uptodate during prepare_write.  It just so happens
that simple_prepare_write() in libfs.c does exactly that, so we can avoid
duplication and just call that function to zero page data.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/extent_file_ops.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN fs/reiser4/plugin/item/extent_file_ops.c~ext4-use-simple_prepare_write-to-zero-page-data fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~ext4-use-simple_prepare_write-to-zero-page-data
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1040,16 +1040,9 @@ ssize_t reiser4_write_extent(struct file
 		BUG_ON(get_current_context()->trans->atom != NULL);
 
 		lock_page(page);
-		if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE) {
-			void *kaddr;
-
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, page_off);
-			memset(kaddr + page_off + to_page, 0,
-			       PAGE_CACHE_SIZE - (page_off + to_page));
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
+		if (!PageUptodate(page) && to_page != PAGE_CACHE_SIZE)
+			simple_prepare_write(file, page, page_off,
+					     page_off + to_page);
 
 		written = filemap_copy_from_user(page, page_off, buf, to_page);
 		flush_dcache_page(page);
_

Patches currently in -mm which might be from nate.diller@gmail.com are

cifs-use-simple_prepare_write-to-zero-page-data.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch

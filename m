From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH] Remove two unneeded exports and make two symbols static in fs/mpage.c
Date: Tue, 31 Mar 2009 00:41:20 +0300
Message-ID: <1238449280-10318-1-git-send-email-dmitri.vorobiev@movial.com>
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org,
	alex@clusterfs.com, aneesh.kumar@linux.vnet.ibm.com,
	Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762169AbZC3Vmo@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit 29a814d2ee0e43c2980f33f91c1311ec06c0aa35 (vfs: add hooks for
ext4's delayed allocation support) exported the following functions

mpage_bio_submit()
__mpage_writepage()

for the benefit of ext4's delayed allocation support. Since commit
a1d6cc563bfdf1bf2829d3e6ce4d8b774251796b (ext4: Rework the
ext4_da_writepages() function), these functions are not used by the
ext4 driver anymore. However, the now unnecessary exports still
remain, and this patch removes those. Moreover, these two functions
can become static again.

The issue was spotted by namespacecheck.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
---
 fs/mpage.c            |   13 +++++++++----
 include/linux/mpage.h |   10 ----------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index 16c3ef3..680ba60 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -82,7 +82,7 @@ static void mpage_end_io_write(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-struct bio *mpage_bio_submit(int rw, struct bio *bio)
+static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
 	bio->bi_end_io = mpage_end_io_read;
 	if (rw == WRITE)
@@ -90,7 +90,6 @@ struct bio *mpage_bio_submit(int rw, struct bio *bio)
 	submit_bio(rw, bio);
 	return NULL;
 }
-EXPORT_SYMBOL(mpage_bio_submit);
 
 static struct bio *
 mpage_alloc(struct block_device *bdev,
@@ -439,7 +438,14 @@ EXPORT_SYMBOL(mpage_readpage);
  * just allocate full-size (16-page) BIOs.
  */
 
-int __mpage_writepage(struct page *page, struct writeback_control *wbc,
+struct mpage_data {
+	struct bio *bio;
+	sector_t last_block_in_bio;
+	get_block_t *get_block;
+	unsigned use_writepage;
+};
+
+static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 		      void *data)
 {
 	struct mpage_data *mpd = data;
@@ -648,7 +654,6 @@ out:
 	mpd->bio = bio;
 	return ret;
 }
-EXPORT_SYMBOL(__mpage_writepage);
 
 /**
  * mpage_writepages - walk the list of dirty pages of the given address space & writepage() all of them
diff --git a/include/linux/mpage.h b/include/linux/mpage.h
index 5c42821..068a0c9 100644
--- a/include/linux/mpage.h
+++ b/include/linux/mpage.h
@@ -11,21 +11,11 @@
  */
 #ifdef CONFIG_BLOCK
 
-struct mpage_data {
-	struct bio *bio;
-	sector_t last_block_in_bio;
-	get_block_t *get_block;
-	unsigned use_writepage;
-};
-
 struct writeback_control;
 
-struct bio *mpage_bio_submit(int rw, struct bio *bio);
 int mpage_readpages(struct address_space *mapping, struct list_head *pages,
 				unsigned nr_pages, get_block_t get_block);
 int mpage_readpage(struct page *page, get_block_t get_block);
-int __mpage_writepage(struct page *page, struct writeback_control *wbc,
-		      void *data);
 int mpage_writepages(struct address_space *mapping,
 		struct writeback_control *wbc, get_block_t get_block);
 int mpage_writepage(struct page *page, get_block_t *get_block,
-- 
1.5.6.3

From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 41/54] ext4: convert to bio_for_each_segment_all_sp()
Date: Wed, 28 Dec 2016 00:04:50 +0800
Message-ID: <1482854706-14128-10-git-send-email-tom.leiming@gmail.com>
References: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ming Lei <tom.leiming@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org (open list:EXT4 FILE SYSTEM)
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 fs/ext4/page-io.c  | 3 ++-
 fs/ext4/readpage.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index d83b0f3c5fe9..34d24d8d63d9 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -63,8 +63,9 @@ static void ext4_finish_bio(struct bio *bio)
 {
 	int i;
 	struct bio_vec *bvec;
+	struct bvec_iter_all bia;
 
-	bio_for_each_segment_all(bvec, bio, i) {
+	bio_for_each_segment_all_sp(bvec, bio, i, bia) {
 		struct page *page = bvec->bv_page;
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 		struct page *data_page = NULL;
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index a81b829d56de..6d50b2ca532a 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -71,6 +71,7 @@ static void mpage_end_io(struct bio *bio)
 {
 	struct bio_vec *bv;
 	int i;
+	struct bvec_iter_all bia;
 
 	if (ext4_bio_encrypted(bio)) {
 		if (bio->bi_error) {
@@ -80,7 +81,7 @@ static void mpage_end_io(struct bio *bio)
 			return;
 		}
 	}
-	bio_for_each_segment_all(bv, bio, i) {
+	bio_for_each_segment_all_sp(bv, bio, i, bia) {
 		struct page *page = bv->bv_page;
 
 		if (!bio->bi_error) {
-- 
2.7.4


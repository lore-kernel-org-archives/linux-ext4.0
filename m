From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 42/51] ext4: convert to bio_for_each_segment_all_sp()
Date: Mon, 26 Jun 2017 20:10:25 +0800
Message-ID: <20170626121034.3051-43-ming.lei@redhat.com>
References: <20170626121034.3051-1-ming.lei@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ming Lei <ming.lei@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@infradead.org>,
	Huang Ying <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170626121034.3051-1-ming.lei@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/ext4/page-io.c  | 3 ++-
 fs/ext4/readpage.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 930ca0fc9a0f..0e59404fc530 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -62,8 +62,9 @@ static void ext4_finish_bio(struct bio *bio)
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
index 40a5497b0f60..6bd33c4c1f7f 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -71,6 +71,7 @@ static void mpage_end_io(struct bio *bio)
 {
 	struct bio_vec *bv;
 	int i;
+	struct bvec_iter_all bia;
 
 	if (ext4_bio_encrypted(bio)) {
 		if (bio->bi_status) {
@@ -80,7 +81,7 @@ static void mpage_end_io(struct bio *bio)
 			return;
 		}
 	}
-	bio_for_each_segment_all(bv, bio, i) {
+	bio_for_each_segment_all_sp(bv, bio, i, bia) {
 		struct page *page = bv->bv_page;
 
 		if (!bio->bi_status) {
-- 
2.9.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

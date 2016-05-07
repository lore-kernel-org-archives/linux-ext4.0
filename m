From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v2 1/2] direct-io: cleanup get_more_blocks()
Date: Sun,  8 May 2016 02:31:49 +0800
Message-ID: <1462645910-23290-1-git-send-email-guaneryu@gmail.com>
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com,
	Eryu Guan <guaneryu@gmail.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Save one level of indention by returning error early.

Introduce some local variables to make the code easier to read a bit,
and do preparation for next patch.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

v2: split the cleanup code into a seperate patch to make the review easier

 fs/direct-io.c | 69 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 4720377..9d5aff9 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -607,52 +607,55 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 	int ret;
 	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
 	sector_t fs_endblk;	/* Into file, in filesystem-sized blocks */
+	sector_t block_in_file = sdio->block_in_file;
 	unsigned long fs_count;	/* Number of filesystem-sized blocks */
 	int create;
-	unsigned int i_blkbits = sdio->blkbits + sdio->blkfactor;
+	unsigned int blkbits = sdio->blkbits;
+	unsigned int blkfactor = sdio->blkfactor;
+	unsigned int i_blkbits = blkbits + blkfactor;
+	struct inode *inode = dio->inode;
 
 	/*
 	 * If there was a memory error and we've overwritten all the
 	 * mapped blocks then we can now return that memory error
 	 */
 	ret = dio->page_errors;
-	if (ret == 0) {
-		BUG_ON(sdio->block_in_file >= sdio->final_block_in_request);
-		fs_startblk = sdio->block_in_file >> sdio->blkfactor;
-		fs_endblk = (sdio->final_block_in_request - 1) >>
-					sdio->blkfactor;
-		fs_count = fs_endblk - fs_startblk + 1;
+	if (ret)
+		return ret;
 
-		map_bh->b_state = 0;
-		map_bh->b_size = fs_count << i_blkbits;
+	BUG_ON(block_in_file >= sdio->final_block_in_request);
+	fs_startblk = block_in_file >> blkfactor;
+	fs_endblk = (sdio->final_block_in_request - 1) >> blkfactor;
+	fs_count = fs_endblk - fs_startblk + 1;
 
-		/*
-		 * For writes inside i_size on a DIO_SKIP_HOLES filesystem we
-		 * forbid block creations: only overwrites are permitted.
-		 * We will return early to the caller once we see an
-		 * unmapped buffer head returned, and the caller will fall
-		 * back to buffered I/O.
-		 *
-		 * Otherwise the decision is left to the get_blocks method,
-		 * which may decide to handle it or also return an unmapped
-		 * buffer head.
-		 */
-		create = dio->rw & WRITE;
-		if (dio->flags & DIO_SKIP_HOLES) {
-			if (sdio->block_in_file < (i_size_read(dio->inode) >>
-							sdio->blkbits))
-				create = 0;
-		}
+	map_bh->b_state = 0;
+	map_bh->b_size = fs_count << i_blkbits;
+
+	/*
+	 * For writes inside i_size on a DIO_SKIP_HOLES filesystem we
+	 * forbid block creations: only overwrites are permitted.
+	 * We will return early to the caller once we see an
+	 * unmapped buffer head returned, and the caller will fall
+	 * back to buffered I/O.
+	 *
+	 * Otherwise the decision is left to the get_blocks method,
+	 * which may decide to handle it or also return an unmapped
+	 * buffer head.
+	 */
+	create = dio->rw & WRITE;
+	if (dio->flags & DIO_SKIP_HOLES) {
+		if (block_in_file < (i_size_read(inode) >> blkbits))
+			create = 0;
+	}
 
-		ret = (*sdio->get_block)(dio->inode, fs_startblk,
-						map_bh, create);
+	ret = (*sdio->get_block)(inode, fs_startblk, map_bh, create);
 
-		/* Store for completion */
-		dio->private = map_bh->b_private;
+	/* Store for completion */
+	dio->private = map_bh->b_private;
+
+	if (ret == 0 && buffer_defer_completion(map_bh))
+		ret = dio_set_defer_completion(dio);
 
-		if (ret == 0 && buffer_defer_completion(map_bh))
-			ret = dio_set_defer_completion(dio);
-	}
 	return ret;
 }
 
-- 
2.5.5


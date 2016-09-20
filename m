From: Eric Engestrom <eric.engestrom@imgtec.com>
Subject: [PATCH 2/2] ext4: remove unused variable
Date: Tue, 20 Sep 2016 17:16:19 +0100
Message-ID: <20160920161619.16586-2-eric.engestrom@imgtec.com>
References: <20160920161619.16586-1-eric.engestrom@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Engestrom <eric.engestrom@imgtec.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
To: <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920161619.16586-1-eric.engestrom@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Eric Engestrom <eric.engestrom@imgtec.com>
---
 fs/ext4/page-io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index a6132a7..b4cbee9 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -405,14 +405,12 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 {
 	struct page *data_page = NULL;
 	struct inode *inode = page->mapping->host;
-	unsigned block_start, blocksize;
+	unsigned block_start;
 	struct buffer_head *bh, *head;
 	int ret = 0;
 	int nr_submitted = 0;
 	int nr_to_submit = 0;
 
-	blocksize = 1 << inode->i_blkbits;
-
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageWriteback(page));
 
-- 
Cheers,
  Eric

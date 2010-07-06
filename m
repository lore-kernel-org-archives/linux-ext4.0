From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] disallow FS recursion from sb_issue_discard allocation
Date: Tue, 6 Jul 2010 12:11:56 -0400
Message-ID: <20100706161155.GA24461@redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
 <20100702181430.GD26916@redhat.com>
 <Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021554550.11102@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1007021605410.13662@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	Alasdair G Kergon <agk@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007021605410.13662@hs20-bc2-1.build.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Filesystems can call sb_issue_discard on a memory reclaim path
(e.g. ext4 calls sb_issue_discard during journal commit).

Use GFP_NOFS in sb_issue_discard to avoid recursing back into the FS.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blkdev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index baf5258..dbb510c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -933,7 +933,7 @@ static inline int sb_issue_discard(struct super_block *sb,
 {
 	block <<= (sb->s_blocksize_bits - 9);
 	nr_blocks <<= (sb->s_blocksize_bits - 9);
-	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
+	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_NOFS,
 				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
 }
 

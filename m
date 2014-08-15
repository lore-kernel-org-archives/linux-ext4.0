From: Chin-Tsung Cheng <chintzung@gmail.com>
Subject: [PATCH v2] ext4: include journal blocks of internal journal in df overhead calcs
Date: Fri, 15 Aug 2014 14:42:51 +0800
Message-ID: <1408084971-1456-1-git-send-email-chintzung@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chin-Tsung Cheng <chintzung@gmail.com>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The journal blocks of external journal device should not
be counted as overhead.

Signed-off-by: Chin-Tsung Cheng <chintzung@gmail.com>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32b43ad..a80b122 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3316,8 +3316,8 @@ int ext4_calculate_overhead(struct super_block *sb)
 			memset(buf, 0, PAGE_SIZE);
 		cond_resched();
 	}
-	/* Add the journal blocks as well */
-	if (sbi->s_journal)
+	/* Add the internal journal blocks as well */
+	if (sbi->s_journal && !sbi->journal_bdev)
 		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
 
 	sbi->s_overhead = overhead;
-- 
1.9.3

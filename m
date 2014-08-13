From: Chin-Tsung Cheng <chintzung@gmail.com>
Subject: [PATCH] ext4: include journal blocks of internal journal in df overhead calcs
Date: Wed, 13 Aug 2014 21:37:23 +0800
Message-ID: <1407937043-23186-1-git-send-email-chintzung@gmail.com>
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
 fs/ext4/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32b43ad..03b2f62 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3316,9 +3316,10 @@ int ext4_calculate_overhead(struct super_block *sb)
 			memset(buf, 0, PAGE_SIZE);
 		cond_resched();
 	}
-	/* Add the journal blocks as well */
-	if (sbi->s_journal)
-		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
+	/* Add the internal journal blocks as well */
+	if ((sbi->s_journal) &&
+		(sbi->s_journal->j_fs_dev == sbi->s_journal->j_dev))
+			overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
 
 	sbi->s_overhead = overhead;
 	smp_wmb();
-- 
1.9.3

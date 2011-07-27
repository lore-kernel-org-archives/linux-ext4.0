From: Sven Eckelmann <sven@narfation.org>
Subject: [PATCHv4 07/11] ext4: Use *_dec_not_zero instead of *_add_unless
Date: Wed, 27 Jul 2011 11:47:46 +0200
Message-ID: <1311760070-21532-7-git-send-email-sven@narfation.org>
References: <1311760070-21532-1-git-send-email-sven@narfation.org>
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-arch@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311760070-21532-1-git-send-email-sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

atomic_dec_not_zero is defined for each architecture through
<linux/atomic.h> to provide the functionality of
atomic_add_unless(x, -1, 0).

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/ext4.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fa44df8..29996e8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2098,7 +2098,7 @@ static inline void ext4_lock_group(struct super_block *sb, ext4_group_t group)
 		 * We're able to grab the lock right away, so drop the
 		 * lock contention counter.
 		 */
-		atomic_add_unless(&EXT4_SB(sb)->s_lock_busy, -1, 0);
+		atomic_dec_not_zero(&EXT4_SB(sb)->s_lock_busy);
 	else {
 		/*
 		 * The lock is busy, so bump the contention counter,
-- 
1.7.5.4

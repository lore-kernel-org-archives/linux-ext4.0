From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 13/14] ext4: use atomic_dec_not_zero()
Date: Mon, 30 Jan 2017 19:48:39 +0100
Message-ID: <20170130184839.19191-1-fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu,
        linux-ext4@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

instead of atomic_add_unless(value, -1, 0)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 164a2e0..3184c25 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2916,7 +2916,7 @@ static inline void ext4_lock_group(struct super_block *sb, ext4_group_t group)
 		 * We're able to grab the lock right away, so drop the
 		 * lock contention counter.
 		 */
-		atomic_add_unless(&EXT4_SB(sb)->s_lock_busy, -1, 0);
+		atomic_dec_not_zero(&EXT4_SB(sb)->s_lock_busy);
 	else {
 		/*
 		 * The lock is busy, so bump the contention counter,
-- 
2.9.3

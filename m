From: Colin King <colin.king@canonical.com>
Subject: [PATCH] ext4: fix spelling mistake: "prellocated" -> "preallocated"
Date: Tue, 27 Jun 2017 14:33:22 +0100
Message-ID: <20170627133322.22701-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38630 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbdF0Nd0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 09:33:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in mb_debug debug message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 95425918875e..581e357e8406 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3567,7 +3567,7 @@ void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 		ext4_set_bits(bitmap, start, len);
 		preallocated += len;
 	}
-	mb_debug(1, "prellocated %u for group %u\n", preallocated, group);
+	mb_debug(1, "preallocated %u for group %u\n", preallocated, group);
 }
 
 static void ext4_mb_pa_callback(struct rcu_head *head)
-- 
2.11.0

From: John Stultz <john.stultz@linaro.org>
Subject: [RFC][PATCH 3/5] ext4: Fix abs() usage in  ext4_mb_check_group_pa
Date: Mon, 14 Sep 2015 18:05:22 -0700
Message-ID: <1442279124-7309-4-git-send-email-john.stultz@linaro.org>
References: <1442279124-7309-1-git-send-email-john.stultz@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Ingo Molnar <mingo@kernel.org>, linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442279124-7309-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The ext4_fsblk_t type is a long long, which should not be used
with abs(), as is done in ext4_mb_check_group_pa().

This patch modifies ext4_mb_check_group_pa() to use abs64()
instead.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 fs/ext4/mballoc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 34b610e..4780ab1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3331,8 +3331,8 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
 		atomic_inc(&pa->pa_count);
 		return pa;
 	}
-	cur_distance = abs(goal_block - cpa->pa_pstart);
-	new_distance = abs(goal_block - pa->pa_pstart);
+	cur_distance = abs64(goal_block - cpa->pa_pstart);
+	new_distance = abs64(goal_block - pa->pa_pstart);
 
 	if (cur_distance <= new_distance)
 		return cpa;
-- 
1.9.1

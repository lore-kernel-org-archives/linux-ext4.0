From: Huaitong Han <huaitong.han@intel.com>
Subject: [PATCH] ext4: add a line break for proc mb_groups display
Date: Wed,  3 Feb 2016 21:19:06 +0800
Message-ID: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Huaitong Han <huaitong.han@intel.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds a line break for proc mb_groups display.

Signed-off-by: Huaitong Han <huaitong.han@intel.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 61eaf74..4424b7b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2285,7 +2285,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 	if (group == 0)
 		seq_puts(seq, "#group: free  frags first ["
 			      " 2^0   2^1   2^2   2^3   2^4   2^5   2^6  "
-			      " 2^7   2^8   2^9   2^10  2^11  2^12  2^13  ]");
+			      " 2^7   2^8   2^9   2^10  2^11  2^12  2^13  ]\n");
 
 	i = (sb->s_blocksize_bits + 2) * sizeof(sg.info.bb_counters[0]) +
 		sizeof(struct ext4_group_info);
-- 
2.4.3

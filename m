From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] Set the initial TRIM information as TRIMMED
Date: Thu, 01 Dec 2011 16:00:52 +0900
Message-ID: <20111201070052.GA29708@july>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, tm@tao.ma
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Now trim information doesn't stored at disk so every boot time. it's cleared.
and do the trim all disk groups.
But assume that it's already trimmed at previous time so don't need to trim it again. So set the intial state as trimmed.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..97ef342 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1098,6 +1098,12 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
 		goto err;
 	}
 	mark_page_accessed(page);
+
+	/*
+	 * TRIM information is not stored at disk so set the initial
+	 * state as trimmed. Since previous time it's already trimmed all
+	 */
+	EXT4_MB_GRP_SET_TRIMMED(this_grp);
 err:
 	ext4_mb_put_buddy_page_lock(&e4b);
 	return ret;

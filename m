From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: add check for inodes_count overflow in new resize ioctl
Date: Sun, 21 Apr 2013 22:57:05 -0400
Message-ID: <1366599425-11561-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Addresses-Red-Hat-Bugzilla: #913245

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/resize.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 08d2312..b27c96d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1882,6 +1882,10 @@ retry:
 		return 0;
 
 	n_group = ext4_get_group_number(sb, n_blocks_count - 1);
+	if (n_group > (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
+		ext4_warning(sb, "resize would cause inodes_count overflow");
+		return -EINVAL;
+	}
 	ext4_get_group_no_and_offset(sb, o_blocks_count - 1, &o_group, &offset);
 
 	n_desc_blocks = num_desc_blocks(sb, n_group + 1);
-- 
1.7.12.rc0.22.gcdd159b

From: Wei Yuan <weiyuan.wei@huawei.com>
Subject: [PATCH] ext3: Remove useless condition in if statement.
Date: Fri, 20 Mar 2015 11:09:10 +0800
Message-ID: <1426820950-4720-1-git-send-email-weiyuan.wei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lczerner@redhat.com>, <lizefan@huawei.com>
To: <jack@suse.cz>, <akpm@linux-foundation.org>,
	<adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In this if statement, the previous condition is useless, the later one has covered it.

Signed-off-by: Weiyuan <weiyuan.wei@huawei.com>
---
 fs/ext3/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index c6874be..24215dc 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -546,8 +546,7 @@ ext3_xattr_set_entry(struct ext3_xattr_info *i, struct ext3_xattr_search *s)
 		free += EXT3_XATTR_LEN(name_len);
 	}
 	if (i->value) {
-		if (free < EXT3_XATTR_SIZE(i->value_len) ||
-		    free < EXT3_XATTR_LEN(name_len) +
+		if (free < EXT3_XATTR_LEN(name_len) +
 			   EXT3_XATTR_SIZE(i->value_len))
 			return -ENOSPC;
 	}
-- 
2.1.0

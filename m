From: ZhangZhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH] ext2/3: use prandom_u32() instead of get_random_bytes()
Date: Wed, 26 Feb 2014 10:32:41 +0800
Message-ID: <530D5249.4020005@huawei.com>
References: <530D4BBB.6090600@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:57301 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaBZCcx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Feb 2014 21:32:53 -0500
In-Reply-To: <530D4BBB.6090600@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Many of the uses of get_random_bytes() do not actually need
cryptographically secure random numbers.  Replace those uses with a
call to prandom_u32(), which is faster and which doesn't consume
entropy from the /dev/random driver.

The commit dd1f723bf56bd96efc9d90e9e60dc511c79de48f has made that for
ext4, and i did the same for ext2/3.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 fs/ext2/ialloc.c | 2 +-
 fs/ext3/ialloc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 7cadd82..32f131a 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -284,7 +284,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
 		int best_ndir = inodes_per_group;
 		int best_group = -1;

-		get_random_bytes(&group, sizeof(group));
+		grp = prandom_u32();
 		parent_group = (unsigned)group % ngroups;
 		for (i = 0; i < ngroups; i++) {
 			group = (parent_group + i) % ngroups;
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 082afd7..60e63e3 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -215,7 +215,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
 		int best_ndir = inodes_per_group;
 		int best_group = -1;

-		get_random_bytes(&group, sizeof(group));
+		grp = prandom_u32();
 		parent_group = (unsigned)group % ngroups;
 		for (i = 0; i < ngroups; i++) {
 			group = (parent_group + i) % ngroups;
-- 
1.8.1.4


.





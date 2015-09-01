From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH v2] fs/ext4: fix potential endless loop in ext4_mb_discard_group_preallocations()
Date: Tue, 1 Sep 2015 14:41:13 +0800
Message-ID: <55E54889.3020909@huawei.com>
References: <55E42270.9040503@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>, <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:9441 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbbIAGli (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2015 02:41:38 -0400
In-Reply-To: <55E42270.9040503@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_mb_discard_group_preallocations(), if free is always less than needed,
and some PAs are always used in every loop, it will be endless loop.

Here we pick a random value to limit the max number of loop.

Change v1 -> v2:
- fix typo error, s/ramdon/random/

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Acked-by: Andreas Dilger <adilger.kernel@dilger.ca>
---
 fs/ext4/mballoc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 34b610e..553fbde 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3836,6 +3836,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 	int err;
 	int busy = 0;
 	int free = 0;
+	int tried = 0;

 	mb_debug(1, "discard preallocation for group %u\n", group);

@@ -3886,9 +3887,11 @@ repeat:
 		list_add(&pa->u.pa_tmp_list, &list);
 	}

-	/* if we still need more blocks and some PAs were used, try again */
-	if (free < needed && busy) {
+	/* if we still need more blocks and some PAs were used, try again,
+	   here 20 is a random value. */
+	if (free < needed && busy && tried < 20) {
 		busy = 0;
+		tried++;
 		ext4_unlock_group(sb, group);
 		cond_resched();
 		goto repeat;
-- 
1.9.1


.







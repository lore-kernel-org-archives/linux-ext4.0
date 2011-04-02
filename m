From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: [PATCH] jbd2: Move bdget out of critical section
Date: Sat,  2 Apr 2011 17:01:16 +0800
Message-ID: <1301734876-22207-1-git-send-email-gaoyang.zyh@taobao.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Zhu Yanhai <gaoyang.zyh@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35338 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab1DBI6j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 04:58:39 -0400
Received: by iyb14 with SMTP id 14so4311810iyb.19
        for <linux-ext4@vger.kernel.org>; Sat, 02 Apr 2011 01:58:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bdget() should not be called when we hold spinlocks since
it might sleep.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
---
 fs/jbd2/journal.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 90407b8..33dd3ef 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2413,10 +2413,12 @@ const char *jbd2_dev_to_name(dev_t device)
 	new_dev = kmalloc(sizeof(struct devname_cache), GFP_KERNEL);
 	if (!new_dev)
 		return "NODEV-ALLOCFAILURE"; /* Something non-NULL */
+	bd = bdget(device);
 	spin_lock(&devname_cache_lock);
 	if (devcache[i]) {
 		if (devcache[i]->device == device) {
 			kfree(new_dev);
+			bdput(bd);
 			ret = devcache[i]->devname;
 			spin_unlock(&devname_cache_lock);
 			return ret;
@@ -2425,7 +2427,6 @@ const char *jbd2_dev_to_name(dev_t device)
 	}
 	devcache[i] = new_dev;
 	devcache[i]->device = device;
-	bd = bdget(device);
 	if (bd) {
 		bdevname(bd, devcache[i]->devname);
 		bdput(bd);
-- 
1.7.4


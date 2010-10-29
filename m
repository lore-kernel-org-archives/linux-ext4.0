From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Fix lazyinit hang after removing request
Date: Fri, 29 Oct 2010 15:20:20 +0200
Message-ID: <1288358420-11643-1-git-send-email-lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, adilger@dilger.ca, lczerner@redhat.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab0J2NU1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Oct 2010 09:20:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the request has been removed from the list and no other request
has been issued, we will end up with next wakeup scheduled to
MAX_JIFFY_OFFSET which is bad. So check for that.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0348ce0..29c3078 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2740,7 +2740,8 @@ cont_thread:
 		if (freezing(current))
 			refrigerator();
 
-		if (time_after_eq(jiffies, next_wakeup)) {
+		if ((time_after_eq(jiffies, next_wakeup)) ||
+		    (MAX_JIFFY_OFFSET == next_wakeup)) {
 			cond_resched();
 			continue;
 		}
-- 
1.7.2.3


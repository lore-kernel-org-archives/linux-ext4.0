From: Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [PATCH] [Coding Style]: fs/ext{3,4}/bitmap.c
Date: Fri,  4 Jan 2008 14:21:34 +0100
Message-ID: <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
 <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mathieu Segaud <mathieu.segaud@regala.cx>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bde.crans.org ([138.231.137.76]:48601 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYADNaR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jan 2008 08:30:17 -0500
In-Reply-To: <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
---
 fs/ext3/bitmap.c |    2 +-
 fs/ext4/bitmap.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/bitmap.c b/fs/ext3/bitmap.c
index 6afc39d..c402bc4 100644
--- a/fs/ext3/bitmap.c
+++ b/fs/ext3/bitmap.c
@@ -15,7 +15,7 @@
 
 static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
 
-unsigned long ext3_count_free (struct buffer_head * map, unsigned int numchars)
+unsigned long ext3_count_free(struct buffer_head *map, unsigned int numchars)
 {
 	unsigned int i;
 	unsigned long sum = 0;
diff --git a/fs/ext4/bitmap.c b/fs/ext4/bitmap.c
index 420554f..a473206 100644
--- a/fs/ext4/bitmap.c
+++ b/fs/ext4/bitmap.c
@@ -15,7 +15,7 @@
 
 static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
 
-unsigned long ext4_count_free (struct buffer_head * map, unsigned int numchars)
+unsigned long ext4_count_free(struct buffer_head *map, unsigned int numchars)
 {
 	unsigned int i;
 	unsigned long sum = 0;
-- 
1.5.3.7

From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] Detect too-large stride or stripe-width specification
Date: Fri,  4 Apr 2008 13:11:18 -0500
Message-ID: <1207332678-10965-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950AbYDKSS2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 14:18:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/mke2fs.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 857d345..144e11a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -799,13 +799,17 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			arg++;
 		}
 		if (strcmp(token, "stride") == 0) {
+			unsigned long stride;
+
 			if (!arg) {
 				r_usage++;
 				badopt = token;
 				continue;
 			}
-			param->s_raid_stride = strtoul(arg, &p, 0);
-			if (*p || (param->s_raid_stride == 0)) {
+			stride = strtoul(arg, &p, 0);
+			param->s_raid_stride = stride;
+			/* check for invalid or too-large stride */
+			if (*p || (param->s_raid_stride != stride)) {
 				fprintf(stderr,
 					_("Invalid stride parameter: %s\n"),
 					arg);
@@ -814,13 +818,17 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			}
 		} else if (strcmp(token, "stripe-width") == 0 ||
 			   strcmp(token, "stripe_width") == 0) {
+			unsigned long stripe_width;
+
 			if (!arg) {
 				r_usage++;
 				badopt = token;
 				continue;
 			}
-			param->s_raid_stripe_width = strtoul(arg, &p, 0);
-			if (*p || (param->s_raid_stripe_width == 0)) {
+			stripe_width = strtoul(arg, &p, 0);
+			param->s_raid_stripe_width = stripe_width;
+			/* check for invalid or too-large stripe width */
+			if (*p || (param->s_raid_stripe_width != stripe_width)) {
 				fprintf(stderr,
 					_("Invalid stripe-width parameter: %s\n"),
 					arg);
-- 
1.5.4.1


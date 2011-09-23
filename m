From: Nikitas Angelinas <nikitasangelinas@gmail.com>
Subject: [PATCH 2/2] ext4: MMP: fix error message rate-limiting logic in kmmpd
Date: Fri, 23 Sep 2011 01:23:09 +0100
Message-ID: <1316737389-5522-3-git-send-email-nikitas_angelinas@xyratex.com>
References: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	nikitas_angelinas@xyratex.com, andrew_perepechko@xyratex.com
To: tytso@mit.edu, adilger.kernel@dilger.ca, adilger@whamcloud.com,
	johann@whamcloud.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42175 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab1IWAYy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Sep 2011 20:24:54 -0400
In-Reply-To: <1316737389-5522-1-git-send-email-nikitas_angelinas@xyratex.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current logic would print an error message only once, and then
'failed_writes' would stay at 1. Rework the loop to increment
'failed_writes' and print the error message every s_mmp_update_interval
* 60 seconds, as intended according to the comment.

Perhaps it would be better to reset 'failed_writes' to 0 on every
successful write, such that new errors are noticed sooner, but maybe in
the interest of efficiency it would be best not to add an operation on
every kmmpd thread run?

Signed-off-by: Nikitas Angelinas <nikitas_angelinas@xyratex.com>
Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
---
 fs/ext4/mmp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 2fca64e..6b32742 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -125,8 +125,9 @@ static int kmmpd(void *data)
 		 * Don't spew too many error messages. Print one every
 		 * (s_mmp_update_interval * 60) seconds.
 		 */
-		if (retval && (failed_writes % 60) == 0) {
-			ext4_error(sb, "Error writing to MMP block");
+		if (retval) {
+			if ((failed_writes % 60) == 0)
+				ext4_error(sb, "Error writing to MMP block");
 			failed_writes++;
 		}
 
-- 
1.7.4.4


From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] blkid: more sanity checks for swap v1
Date: Thu, 17 Apr 2008 16:55:53 -0500
Message-ID: <1208469353-14762-1-git-send-email-sandeen@redhat.com>
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbYDQV5M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2008 17:57:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mkswap followed by pvcreate on a block device
will still turn up as "swap" in blkid, because
pvcreate isn't particularly careful about zeroing
old signatures.  (neither is mkswap, for that matter).

Testing for appropriate version and page counts
gives us a bit more confidence that we have a
real swap (v1) partition.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/blkid/probe.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 45885c3..a070201 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -827,7 +827,7 @@ static int probe_swap0(struct blkid_probe *probe,
 }
 
 static int probe_swap1(struct blkid_probe *probe,
-		       struct blkid_magic *id __BLKID_ATTR((unused)),
+		       struct blkid_magic *id,
 		       unsigned char *buf __BLKID_ATTR((unused)))
 {
 	struct swap_id_block *sws;
@@ -843,6 +843,11 @@ static int probe_swap1(struct blkid_probe *probe,
 	if (!sws)
 		return 1;
 
+	/* check for wrong version or zeroed pagecount, for sanity */
+	if (!memcmp(id->bim_magic, "SWAPSPACE2", id->bim_len) &&
+			(sws->sws_version != 1 || sws->sws_lastpage == 0))
+		return 1;
+
 	/* arbitrary sanity check.. is there any garbage down there? */
 	if (sws->sws_pad[32] == 0 && sws->sws_pad[33] == 0)  {
 		if (sws->sws_volume[0])
-- 
1.5.4.1


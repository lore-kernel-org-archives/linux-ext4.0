From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] blkid: more sanity checks for swap v1 (updated)
Date: Fri, 18 Apr 2008 10:28:44 -0500
Message-ID: <1208532524-4741-1-git-send-email-sandeen@redhat.com>
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYDRP3Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2008 11:29:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(updated for endian issue)

mkswap followed by pvcreate on a block device
will still turn up as "swap" in blkid, because
pvcreate isn't particularly careful about zeroing
old signatures.  (neither is mkswap, for that matter).

Testing for appropriate version and page counts
gives us a bit more confidence that we have a
real swap (v1) partition.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/blkid/probe.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 45885c3..4347ae1 100644
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
@@ -843,6 +843,12 @@ static int probe_swap1(struct blkid_probe *probe,
 	if (!sws)
 		return 1;
 
+	/* check for wrong version or zeroed pagecount, for sanity */
+	if (!memcmp(id->bim_magic, "SWAPSPACE2", id->bim_len) &&
+			(blkid_le32(sws->sws_version) != 1 ||
+			 sws->sws_lastpage == 0))
+		return 1;
+
 	/* arbitrary sanity check.. is there any garbage down there? */
 	if (sws->sws_pad[32] == 0 && sws->sws_pad[33] == 0)  {
 		if (sws->sws_volume[0])
-- 
1.5.4.1


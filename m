From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] libblkid: fix memory overrun in probe_lvm2
Date: Sun,  5 Jan 2014 01:26:43 -0500
Message-ID: <1388903203-5067-4-git-send-email-tytso@mit.edu>
References: <1388903203-5067-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@google.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46015 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaAEG0r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jan 2014 01:26:47 -0500
In-Reply-To: <1388903203-5067-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Ts'o <tytso@google.com>

Addresses-Coverity-ID: #1049167

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/blkid/probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 6f74bd4..dd3604e 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -1360,7 +1360,7 @@ static int probe_lvm2(struct blkid_probe *probe,
 		return 1;
 	}
 
-	for (i=0, b=1, p=uuid, q= (char *) label->pv_uuid; i <= 32;
+	for (i=0, b=1, p=uuid, q= (char *) label->pv_uuid; i < LVM2_ID_LEN;
 	     i++, b <<= 1) {
 		if (b & 0x4444440)
 			*p++ = '-';
-- 
1.8.5.rc3.362.gdf10213


From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH] libblkid: avoid 1-byte stack overflow with long partition
 names
Date: Sat, 15 Nov 2014 00:34:18 +0200
Message-ID: <20141114223417.GA2180@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:49275 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422698AbaKNWeX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2014 17:34:23 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The code in probe_all() parses device names from /proc/partitions into
a char[128] buffer using sscanf() %128[...] format specifier.

If the device name is at least 128 bytes long, scanf() will store
those 128 bytes plus the null byte, overflowing the buffer by a single
byte. Fix by making the buffers 129 bytes long.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 lib/blkid/devname.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/blkid/devname.c b/lib/blkid/devname.c
index 3e2efa9..58baa29 100644
--- a/lib/blkid/devname.c
+++ b/lib/blkid/devname.c
@@ -394,7 +394,7 @@ static int probe_all(blkid_cache cache, int only_if_new)
 {
 	FILE *proc;
 	char line[1024];
-	char ptname0[128], ptname1[128], *ptname = 0;
+	char ptname0[129], ptname1[129], *ptname = 0;
 	char *ptnames[2];
 	dev_t devs[2];
 	int ma, mi;
-- 
2.1.3


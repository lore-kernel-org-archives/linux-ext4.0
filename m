From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] ex4: remove unused assignment
Date: Thu, 25 Oct 2012 15:21:55 +0100
Message-ID: <20121025142151.16543.60773.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53761 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519Ab2JYOUT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 10:20:19 -0400
Received: from localhost.localdomain (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q9PEqIbS006476
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2012 15:52:23 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 526e553..2c5a48f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1373,7 +1373,7 @@ static int mb_find_extent(struct ext4_buddy *e4b, int block,
 	ex->fe_start += next;
 
 	while (needed > ex->fe_len &&
-	       (buddy = mb_find_buddy(e4b, order, &max))) {
+	       mb_find_buddy(e4b, order, &max)) {
 
 		if (block + 1 >= max)
 			break;


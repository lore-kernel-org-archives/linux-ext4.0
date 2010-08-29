From: Andreas Rid <andreas@rid-net.de>
Subject: [patch] e4defrag: relevant file fragmentation: fix arithmetic error
 as non-root
Date: Sun, 29 Aug 2010 17:01:25 +0200
Message-ID: <4C7A7645.8010906@rid-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: k-mio@sx.jp.nec.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:46869 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0H2PBW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Aug 2010 11:01:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi Kazuya Mio,

I found a bug on your patch "[RFC][PATCH V2 5/5] e4defrag: add solving relevant file fragmentation mode"

The variable "blocks_per_group" is only initialized as root cause of restrict access to the super-block.
As a non root user this cause an arithmetic error in function relevant_balloc.

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 3f1df05..6022758 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1662,14 +1662,15 @@ static int relevant_balloc(const char *file, int donor_fd,
 
 		/* Allocating  all blocks in an extent group */
 		while (rest > 0) {
-			int grp_offset;
-			grp_offset = (pi.pi_pstart - first_data_block) % bpg;

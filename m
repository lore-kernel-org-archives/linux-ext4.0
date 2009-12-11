From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: [PATCH] replaced BUG() with return -EIO from ext4_ext_get_blocks
Date: Fri, 11 Dec 2009 16:06:58 +0200
Message-ID: <1260540418-11844-1-git-send-email-surbhi.palande@canonical.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:49509 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZLKOHA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Dec 2009 09:07:00 -0500
Received: from hutte.canonical.com ([91.189.90.181])
	by adelie.canonical.com with esmtp (Exim 4.69 #1 (Debian))
	id 1NJ699-0004z8-IE
	for <linux-ext4@vger.kernel.org>; Fri, 11 Dec 2009 14:07:04 +0000
Received: from a88-112-252-196.elisa-laajakaista.fi ([88.112.252.196] helo=canonical.com)
	by hutte.canonical.com with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <Surbhi.Palande@canonical.com>)
	id 1NJ699-0002Pi-C4
	for linux-ext4@vger.kernel.org; Fri, 11 Dec 2009 14:07:03 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixes the upstream bug# 14286. When the address of an extent
corresponding to a given block is NULL and the tree is being traversed for
fetching such an address, a -EIO should be reported instead of a BUG(). This
situation should normally not occur. However if it does, then the system
should be rendered usable.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
 fs/ext4/extents.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3a7928f..51f87f3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3190,7 +3190,12 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 * this situation is possible, though, _during_ tree modification;
 	 * this is why assert can't be put in ext4_ext_find_extent()
 	 */
-	BUG_ON(path[depth].p_ext == NULL && depth != 0);
+	if (path[depth].p_ext == NULL && depth != 0) {
+		err = -EIO;
+		printk(KERN_ERR "\n ext4 fs error in %s,%s,%s while reading a block ", \
+					__FILE__, __func__, __LINE__);
+		goto out2;
+	}
 	eh = path[depth].p_hdr;
 
 	ex = path[depth].p_ext;
-- 
1.6.3.3


From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: [PATCH] ext4: do less extent validations
Date: Thu, 12 Mar 2009 16:32:54 +0100
Message-ID: <49B92B26.70402@ph.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040702080606060103080902"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:37440 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755916AbZCLPdE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 11:33:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040702080606060103080902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Based on 2.6.29-rc7 with Aneesh Kumar's patches:
ext4: Validate extent details only when read from the disk
ext4: Add checks to validate extent entries

Sets need_to_validate=0 inside instead of outside the loop.

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>

--------------040702080606060103080902
Content-Type: text/x-patch;
 name="less-extent-validations.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="less-extent-validations.patch"

--- linux-2.6.29-rc7/fs/ext4/extents.c~	2009-03-12 14:51:21.000000000 +0100
+++ linux-2.6.29-rc7/fs/ext4/extents.c	2009-03-12 16:23:41.000000000 +0100
@@ -607,7 +607,6 @@
 ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 					struct ext4_ext_path *path)
 {
-	int need_to_validate = 0;
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
 	short int depth, i, ppos = 0, alloc = 0;
@@ -629,6 +628,7 @@
 	i = depth;
 	/* walk through the tree */
 	while (i) {
+		int need_to_validate = 0;
 		ext_debug("depth %d: num %d, max %d\n",
 			  ppos, le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
 

--------------040702080606060103080902--

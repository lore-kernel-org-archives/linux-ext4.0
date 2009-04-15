From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 4/7] ext4: Remove code handling bio_alloc failure with __GFP_WAIT
Date: Wed, 15 Apr 2009 10:36:16 +0530
Message-ID: <200904151036.16541.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, linux-ext4@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZDOFJz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 01:09:55 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove code handling bio_alloc failure with __GFP_WAIT.
GFP_NOIO implies __GFP_WAIT.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6132353..2a1cb09 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2416,8 +2416,6 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
 			len = ee_len;
 
 		bio = bio_alloc(GFP_NOIO, len);
-		if (!bio)
-			return -ENOMEM;
 		bio->bi_sector = ee_pblock;
 		bio->bi_bdev   = inode->i_sb->s_bdev;
 


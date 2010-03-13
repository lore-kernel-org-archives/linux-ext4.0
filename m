From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] memory leakage in ext4_ext_zeroout
Date: Sat, 13 Mar 2010 14:33:28 +0800
Message-ID: <ac8f92701003122233i6e673351p692dbc2a452b2514@mail.gmail.com>
References: <ac8f92701003110542p6c11ad77l285091cf28928660@mail.gmail.com>
	 <1268402132.32032.13.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Xu Chang Ming <xcmhit@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46283 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab0CMGdb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Mar 2010 01:33:31 -0500
Received: by gyg8 with SMTP id 8so700616gyg.19
        for <linux-ext4@vger.kernel.org>; Fri, 12 Mar 2010 22:33:30 -0800 (PST)
In-Reply-To: <1268402132.32032.13.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Sat Mar 13 14:05:27     2010

When EIO occurs after bio is submitted, there is no memory free
operation for bio, which results in memory leakage. And there is also
no check against bio_alloc() for bio.

Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- o/fs/ext4/extents.c	2010-03-13 13:47:22.000000000 +0800
+++ c/fs/ext4/extents.c	2010-03-13 13:54:36.000000000 +0800
@@ -2568,6 +2568,10 @@ static int ext4_ext_zeroout(struct inode
 			len = ee_len;

 		bio = bio_alloc(GFP_NOIO, len);
+		if (! bio) {
+			ret = -ENOMEM;
+			break;
+		}	
 		bio->bi_sector = ee_pblock;
 		bio->bi_bdev   = inode->i_sb->s_bdev;

@@ -2598,6 +2602,7 @@ static int ext4_ext_zeroout(struct inode
 		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 			ret = 0;
 		else {
+			bio_put(bio);
 			ret = -EIO;
 			break;
 		}

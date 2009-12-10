From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Thu, 10 Dec 2009 09:28:28 -0800
Message-ID: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:20440 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760744AbZLJR2Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 12:28:25 -0500
Received: from kpbe12.cbf.corp.google.com (kpbe12.cbf.corp.google.com [172.25.105.76])
	by smtp-out.google.com with ESMTP id nBAHST1h019871
	for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2009 17:28:30 GMT
Received: from qw-out-1920.google.com (qwc5.prod.google.com [10.241.193.133])
	by kpbe12.cbf.corp.google.com with ESMTP id nBAHRuK0012489
	for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2009 09:28:29 -0800
Received: by qw-out-1920.google.com with SMTP id 5so11170qwc.34
        for <linux-ext4@vger.kernel.org>; Thu, 10 Dec 2009 09:28:28 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a bug in which new blocks returned from an extent created with
ext4_ext_zeroout() can have dirty metadata still associated with them.

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

This is for the problem I reported on 23 Nov ("Bug in extent zeroout: blocks
not marked as new").  I'm not seeing the corruption with this fix that I was
seeing without it.

diff -uprN orig/fs/ext4/extents.c new/fs/ext4/extents.c
--- orig/fs/ext4/extents.c	2009-12-09 15:09:25.000000000 -0800
+++ new/fs/ext4/extents.c	2009-12-09 15:09:37.000000000 -0800
@@ -2474,9 +2474,21 @@ static int ext4_ext_zeroout(struct inode
 		submit_bio(WRITE, bio);
 		wait_for_completion(&event);

-		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+		/* On success, we need to insure all metadata associated
+		 * with each of these blocks is unmapped. */
+		if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+			sector_t block = ee_pblock;
+
 			ret = 0;
-		else {
+			done = 0;
+			while (done < len) {
+				unmap_underlying_metadata(inode->i_sb->s_bdev,
+							  block);
+
+				done++;
+				block++;
+			}
+		} else {
 			ret = -EIO;
 			break;
 		}

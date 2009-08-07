From: Roel Kluin <roel.kluin@gmail.com>
Subject: ext4: buffer underrun in ext4_ext_split()?
Date: Fri, 07 Aug 2009 20:19:49 +0200
Message-ID: <4A7C7045.7040704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:33786 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbZHGSQO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 14:16:14 -0400
Received: by ewy10 with SMTP id 10so1722805ewy.37
        for <linux-ext4@vger.kernel.org>; Fri, 07 Aug 2009 11:16:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If `depth' is less or equal to `at', a buffer underrun occurs

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I am not sure whether this is possible.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index afea652..25bc182 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -822,7 +822,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	}
 
 	/* initialize new leaf */
-	newblock = ablocks[--a];
+	newblock = a ? ablocks[--a] : 0;
 	BUG_ON(newblock == 0);
 	bh = sb_getblk(inode->i_sb, newblock);
 	if (!bh) {

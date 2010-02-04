From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] ext4: ext4_xattr_ibody_set() error ignored in ext4_expand_extra_isize_ea()
Date: Thu, 04 Feb 2010 17:11:27 +0100
Message-ID: <4B6AF1AF.3010008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39426 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176Ab0BDQFk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Feb 2010 11:05:40 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The error handling was missing.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this needed?

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index f3a2f7e..b77930c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1302,6 +1302,8 @@ retry:
 
 		/* Remove the chosen entry from the inode */
 		error = ext4_xattr_ibody_set(handle, inode, &i, is);
+		if (error)
+			goto cleanup;
 
 		entry = IFIRST(header);
 		if (entry_size + EXT4_XATTR_SIZE(size) >= new_extra_isize)

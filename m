From: roel kluin <roel.kluin@gmail.com>
Subject: [PATCH] ext4: fix loop in do_split()
Date: Sat, 29 Nov 2008 04:36:52 -0500
Message-ID: <49310D34.1000205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:58953 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYK2Jg6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Nov 2008 04:36:58 -0500
Received: by ey-out-2122.google.com with SMTP id 6so743075eyi.37
        for <linux-ext4@vger.kernel.org>; Sat, 29 Nov 2008 01:36:57 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

unsigned i >= 0 is always true

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 63adcb7..389cf60 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1198,7 +1198,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	/* Split the existing block in the middle, size-wise */
 	size = 0;
 	move = 0;
-	for (i = count-1; i >= 0; i--) {
+	for (i = count-1; i < count; i--) {
 		/* is more than half of this entry in 2nd half of the block? */
 		if (size + map[i].size/2 > blocksize/2)
 			break;

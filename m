From: Matthieu Dupont <matt.59491@gmail.com>
Subject: [PATCH] In mke2fs, accept a human readable size as input to the 'bytes-per-inode' argument.
Date: Sun, 15 Nov 2015 16:24:54 +0100
Message-ID: <1447601094-19655-1-git-send-email-matt.59491@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34281 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbbKOPY5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Nov 2015 10:24:57 -0500
Received: by wmvv187 with SMTP id v187so142785169wmv.1
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2015 07:24:56 -0800 (PST)
Received: from localhost.localdomain (god59-1-78-222-100-114.fbx.proxad.net. [78.222.100.114])
        by smtp.googlemail.com with ESMTPSA id u139sm13840798wmu.22.2015.11.15.07.24.55
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 15 Nov 2015 07:24:56 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Matthieu Dupont <matt.59491@gmail.com>
---
 misc/mke2fs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 179a4d1..8d61212 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1646,10 +1646,9 @@ profile_error:
 			}
 			break;
 		case 'i':
-			inode_ratio = strtoul(optarg, &tmp, 0);
+			inode_ratio = parse_num_blocks(optarg, -1);
 			if (inode_ratio < EXT2_MIN_BLOCK_SIZE ||
-			    inode_ratio > EXT2_MAX_BLOCK_SIZE * 1024 ||
-			    *tmp) {
+			    inode_ratio > EXT2_MAX_BLOCK_SIZE * 1024) {
 				com_err(program_name, 0,
 					_("invalid inode ratio %s (min %d/max %d)"),
 					optarg, EXT2_MIN_BLOCK_SIZE,
-- 
1.9.1


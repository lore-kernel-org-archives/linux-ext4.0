From: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Subject: [PATCH] ext4: Fixed two coding style errors, spaces required around =
Date: Wed,  4 Feb 2015 12:33:46 +0000
Message-ID: <1423053226-10210-1-git-send-email-oscar.forner.martinez@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:48299 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801AbbBDMd6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2015 07:33:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Two lines with assignation without spaces around the =

Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
---
 fs/ext4/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f58a0d1..60fdc44 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -365,7 +365,7 @@ setversion_out:
 	}
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		err = ext4_resize_begin(sb);
 		if (err)
@@ -451,7 +451,7 @@ mext_out:
 
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		err = ext4_resize_begin(sb);
 		if (err)
-- 
2.2.2


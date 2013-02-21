From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH] e2fsprogs: fix flag settings in e2image.h
Date: Thu, 21 Feb 2013 13:06:58 +0100
Message-ID: <1361448418-26688-1-git-send-email-tracek@redhat.com>
Cc: Tomas Racek <tracek@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab3BUMHV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2013 07:07:21 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1LC7L60003512
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 07:07:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This prevents from SIGSEGV when -s options is used.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 lib/ext2fs/e2image.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/e2image.h b/lib/ext2fs/e2image.h
index c918529..5537980 100644
--- a/lib/ext2fs/e2image.h
+++ b/lib/ext2fs/e2image.h
@@ -19,7 +19,7 @@
 /* Image flags */
 #define E2IMAGE_INSTALL_FLAG	1
 #define E2IMAGE_SCRAMBLE_FLAG	2
-#define E2IMAGE_IS_QCOW2_FLAG	3
+#define E2IMAGE_IS_QCOW2_FLAG	4
 
 struct ext2_image_hdr {
 	__u32	magic_number;	/* This must be EXT2_ET_MAGIC_E2IMAGE */
-- 
1.7.11.7


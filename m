From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] include <linux/fs.h> into linux/ext2_fs.h
Date: Wed, 10 Sep 2008 14:22:03 +0300
Message-ID: <1221045726-5674-1-git-send-email-kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	<linux-ext4@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:34332 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbYIJLVe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2008 07:21:34 -0400
Received: by nf-out-0910.google.com with SMTP id d3so907523nfc.21
        for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 04:21:32 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

linux/fs.h defines FS_IOC* needed by linux/ext2_fs.h

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-ext4@vger.kernel.org>
---
 include/linux/ext2_fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 2efe7b8..f23ba68 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -18,6 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <linux/fs.h>
 
 /*
  * The second extended filesystem constants/structures
-- 
1.5.6.5.GIT


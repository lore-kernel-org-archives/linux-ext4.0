From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH] libext2fs: fix dict_uint_cmp()
Date: Thu, 08 May 2014 10:38:53 +0800
Message-ID: <536AEE3D.6090502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: yawei.niu@intel.com
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59459 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaEHCim (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 May 2014 22:38:42 -0400
Received: by mail-pa0-f54.google.com with SMTP id bj1so751539pad.13
        for <linux-ext4@vger.kernel.org>; Wed, 07 May 2014 19:38:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

dict_uint_cmp() returns an usigned int value in int type, which
could mess the dict key comparison when the difference of two
keys is greater than INT_MAX.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
---
 lib/quota/mkquota.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 9883216..ba8c2da 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -207,7 +207,12 @@ static int dict_uint_cmp(const void *a, const void *b)
 	c = VOIDPTR_TO_UINT(a);
 	d = VOIDPTR_TO_UINT(b);

-	return c - d;
+	if (c == d)
+		return 0;
+	else if (c > d)
+		return 1;
+	else
+		return -1;
 }

 static inline qid_t get_qid(struct ext2_inode *inode, int qtype)
-- 
1.7.1

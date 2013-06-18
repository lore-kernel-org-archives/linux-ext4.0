From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] ext4: fix missing unlock on error in ext4_punch_hole()
Date: Tue, 18 Jun 2013 11:40:34 +0800
Message-ID: <CAPgLHd-2_uHg9q_7nQway8uCigH=wgXxiGm9auYDNL_pByzJHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: tytso@mit.edu, liwang@ubuntukylin.com, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38720 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3FRDkf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Jun 2013 23:40:35 -0400
Received: by mail-bk0-f47.google.com with SMTP id jg1so1520676bkc.34
        for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 20:40:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function ext4_punch_hole()
in the error handling case.
Introduced by commit 1cdec9ca46c2c2a7ce452659f43dac64ad5fbc85.
(ext4: Avoid unnecessarily writing back dirty pages before hole punching)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2644679..06136b5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3538,7 +3538,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	if (ext4_should_order_data(inode)) {
 		ret = ext4_begin_ordered_punch_hole(inode, offset, length);
 		if (ret)
-			return ret;
+			goto out_mutex;
 	}
 
 	/* Now release the pages and zero block aligned part of pages*/


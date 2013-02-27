From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] ext4: fix possible memory leak in ext4_remount()
Date: Wed, 27 Feb 2013 13:18:53 +0800
Message-ID: <CAPgLHd-J=j=aVCpjutq2B1+NMqxz=v50xNcEQA_57Ni_7v9HKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:38707 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3B0FSy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Feb 2013 00:18:54 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so68547bku.41
        for <linux-ext4@vger.kernel.org>; Tue, 26 Feb 2013 21:18:53 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

'orig_data' is malloced in ext4_remount() and should be freed
before leaving from the error handling cases, otherwise it will
cause memory leak.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 373d46c..8ae09e3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4538,6 +4538,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			if (!old_opts.s_qf_names[i]) {
 				for (j = 0; j < i; j++)
 					kfree(old_opts.s_qf_names[j]);
+				kfree(orig_data);
 				return -ENOMEM;
 			}
 		} else



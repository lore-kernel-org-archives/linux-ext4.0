From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] ext4: remove duplicated include from super.c
Date: Wed, 21 Nov 2012 13:30:42 +0800
Message-ID: <CAPgLHd_PAXe7SYKsLOmwYUuYf6CWfyuHA0RLTBFf3mUTKzJhVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52986 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab2KUFan (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2012 00:30:43 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so1314001qat.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2012 21:30:42 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/ext4/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ad6cd8a..c8a6138 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -50,7 +50,6 @@
 #include "xattr.h"
 #include "acl.h"
 #include "mballoc.h"
-#include "ext4_extents.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>



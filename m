From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 28/30] mke2fs: enable inline_data feature on ext4dev filesystem
Date: Fri,  6 Dec 2013 17:58:15 +0800
Message-ID: <1386323897-2354-29-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53939 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751Ab3LFJ4c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:32 -0500
Received: by mail-pb0-f51.google.com with SMTP id up15so785955pbc.38
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:31 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.conf.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 178733f..4c5dba7 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -16,7 +16,7 @@
 		inode_size = 256
 	}
 	ext4dev = {
-		features = has_journal,extent,huge_file,flex_bg,metadata_csum,64bit,dir_nlink,extra_isize
+		features = has_journal,extent,huge_file,flex_bg,metadata_csum,inline_data,64bit,dir_nlink,extra_isize
 		inode_size = 256
 		options = test_fs=1
 	}
-- 
1.7.9.7


From: Lukas Czerner <lczerner@redhat.com>
Subject: [RFC][PATCH] mke2fs.conf: Enable 64bit feature by default
Date: Fri, 21 Jun 2013 16:42:27 +0200
Message-ID: <1371825747-9031-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422893Ab3FUOmb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 10:42:31 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5LEgVki002762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 21 Jun 2013 10:42:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The 64bit feature has been added to the ext4 a long time ago (2006?) so
it should be ok to enable it by default by now. This would allow us to
resize the file system past 16TB when it was originally smaller than
that and user did not specified 64bit feature manually.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.conf.in | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 178733f..dde3219 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -11,8 +11,7 @@
 		features = has_journal
 	}
 	ext4 = {
-		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
-		auto_64-bit_support = 1
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit
 		inode_size = 256
 	}
 	ext4dev = {
-- 
1.8.2.1


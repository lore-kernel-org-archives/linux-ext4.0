From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] mke2fs: Disallow bigalloc with with bs < 4096
Date: Wed,  3 Apr 2013 15:51:39 +0200
Message-ID: <1364997099-22590-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756992Ab3DCNvo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 09:51:44 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r33Dph4s023925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 3 Apr 2013 09:51:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently there is nothing preventing user to create file system with
bigalloc feature enabled and block size smaller than 4096 Bytes. However
such combination does not make much sense at all because the whole point
of bigalloc is to have bigger allocation units.

This patch disallow such combination.

Thanks!
-Lukas
---
 misc/mke2fs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index bbf477a..1f33a20 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1924,6 +1924,12 @@ profile_error:
 				  "smaller than the block size.\n"));
 			exit(1);
 		}
+		if (EXT2_BLOCK_SIZE(&fs_param) < 4096) {
+			com_err(program_name, 0,
+				_("Bigalloc feature is not supported with "
+				  "block size smaller than 4096 B"));
+			exit(1);
+		}
 	} else if (cluster_size) {
 		com_err(program_name, 0,
 			_("specifying a cluster size requires the "
-- 
1.7.7.6


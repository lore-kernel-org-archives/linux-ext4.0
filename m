From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 1/3] e2image: Remove useless exit call
Date: Sat, 16 Mar 2013 10:13:23 +0100
Message-ID: <1363425205-10970-1-git-send-email-tracek@redhat.com>
Cc: Tomas Racek <tracek@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3CPJNf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Mar 2013 05:13:35 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2G9DYcx003677
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sat, 16 Mar 2013 05:13:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Exit is called right after the install_image anyway so this one can
be removed.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 misc/e2image.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index b1badda..6988c4d 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1230,7 +1230,6 @@ static void install_image(char *device, char *image_fn, int type)
 	}
 
 	ext2fs_close (fs);
-	exit (0);
 }
 
 static struct ext2_qcow2_hdr *check_qcow2_image(int *fd, char *name)
-- 
1.7.11.7


From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] break out of ext4_num_dirty_pages() when we hit max_pages
Date: Thu, 09 Sep 2010 14:00:58 -0500
Message-ID: <4C892EEA.6090007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab0IITA7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Sep 2010 15:00:59 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o89J0x7v007051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 9 Sep 2010 15:00:59 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o89J0wLC032203
	for <linux-ext4@vger.kernel.org>; Thu, 9 Sep 2010 15:00:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_num_dirty_pages() will continue scanning after we accumulate
max_pages, possibly for a very long time without doing anything
useful at all.  When we hit max_pages, we should set done=1
so that the break will release the pagevec, exit the loop, and
return from the function.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4b8debe..d88ba4a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1207,8 +1207,10 @@ static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
 				break;
 			idx++;
 			num++;
-			if (num >= max_pages)
+			if (num >= max_pages) {
+				done = 1;
 				break;
+			}
 		}
 		pagevec_release(&pvec);
 	}


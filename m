From: Eric Sandeen <sandeen@redhat.com>
Subject: PATCH 1/2] ext4: stop looping in ext4_num_dirty_pages when max_pages
 reached
Date: Tue, 31 Aug 2010 08:59:06 -0500
Message-ID: <4C7D0AAA.2080808@redhat.com>
References: <4C7D0A00.40601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab0HaN7K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Aug 2010 09:59:10 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7VDxAj5025440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 31 Aug 2010 09:59:10 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o7VDx6BW029467
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 31 Aug 2010 09:59:10 -0400
In-Reply-To: <4C7D0A00.40601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Today we simply break out of the inner loop when we have accumulated
max_pages; this keeps scanning forwad and doing pagevec_lookup_tag()
in the while (!done) loop, this does potentially a lot of work
with no net effect.

When we have accumulated max_pages, just clean up and return.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4b8debe..93497f6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1207,8 +1207,10 @@ static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
 				break;
 			idx++;
 			num++;
-			if (num >= max_pages)
-				break;
+			if (num >= max_pages) {
+				pagevec_release(&pvec);
+				return num;
+			}
 		}
 		pagevec_release(&pvec);
 	}



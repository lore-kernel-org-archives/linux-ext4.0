From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/3] ext4: tidy up a void argument in inode.c
Date: Fri, 22 Oct 2010 16:30:57 -0500
Message-ID: <4CC20291.1040103@redhat.com>
References: <4CC2023A.7060607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056Ab0JVVbA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 17:31:00 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9MLV0aG021899
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Oct 2010 17:31:00 -0400
Received: from liberator.lan (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o9MLUvhm008788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 22 Oct 2010 17:31:00 -0400
In-Reply-To: <4CC2023A.7060607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This doesn't fix anything at all, it just removes a vestige
of prior use from __mpage_da_writepage()

__mpage_da_writepage() had a *void argument leftover from
its previous life as a callback; make it reflect the actual type.

Fixing this up makes it slightly more obvious to read, and 
enables proper typechecking.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Ted, I had a similar change for mpage_put_bnr_to_bhs
which takes an mpd but only wants an inode, but you
absorbed that function in your patch series, so I didn't
submit the change here.


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 50f3bba..854917e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c

@@ -2424,9 +2423,9 @@ static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh)
  * The function finds extents of pages and scan them for all blocks.
  */
 static int __mpage_da_writepage(struct page *page,
-				struct writeback_control *wbc, void *data)
+				struct writeback_control *wbc,
+				struct mpage_da_data *mpd)
 {
-	struct mpage_da_data *mpd = data;
 	struct inode *inode = mpd->inode;
 	struct buffer_head *bh, *head;
 	sector_t logical;


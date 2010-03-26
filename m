From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: use __ext4_get_inode_loc() from ext4_write_inode()
Date: Fri, 26 Mar 2010 15:01:26 -0700
Message-ID: <6601abe91003261501i1a12a953n9c2367ed4b0dd3b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:12531 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab0CZWBa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 18:01:30 -0400
Received: from hpaq2.eem.corp.google.com (hpaq2.eem.corp.google.com [10.3.21.2])
	by smtp-out.google.com with ESMTP id o2QM1Sxh024993
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 15:01:28 -0700
Received: from vws15 (vws15.prod.google.com [10.241.21.143])
	by hpaq2.eem.corp.google.com with ESMTP id o2QM1Q4Y005631
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 23:01:27 +0100
Received: by vws15 with SMTP id 15so195736vws.34
        for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 15:01:26 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix for no-journal ext4_write_inode() code path: ensure in_mem is 0 on call
to __ext4_get_inode_loc()

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

In the no-journal case, ext4_write_inode() simply gets the BH for the inode
table block and calls sync_dirty_buffer() on it.  But it doesn't copy the
in-memory inode contents to the on-disk format on the BH.  So it *must* not
cause the in_mem parameter to __ext4_get_inode_loc() to be 1, which it will
be if it uses ext4_get_inode_loc().


diff -uprN orig/fs/ext4/inode.c new/fs/ext4/inode.c
--- orig/fs/ext4/inode.c	2010-03-22 08:16:57.000000000 -0700
+++ new/fs/ext4/inode.c	2010-03-26 14:50:38.000000000 -0700
@@ -5374,7 +5374,7 @@ int ext4_write_inode(struct inode *inode
 	} else {
 		struct ext4_iloc iloc;

-		err = ext4_get_inode_loc(inode, &iloc);
+		err = __ext4_get_inode_loc(inode, &iloc, 0);
 		if (err)
 			return err;
 		if (wbc->sync_mode == WB_SYNC_ALL)

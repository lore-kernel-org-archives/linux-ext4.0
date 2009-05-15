From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] down i_data_sem only for read when walking tree for fiemap
Date: Fri, 15 May 2009 16:07:32 -0500
Message-ID: <4A0DD994.1090200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48936 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbZEOVHc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2009 17:07:32 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4FL7Yo3016243
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 17:07:34 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4FL7XAk007109
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 17:07:33 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4FL7WCH019624
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 17:07:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Not sure why I put this in as down_write originally; all we are
doing is walking the tree, nothing will change under us and
concurrent reads should be no problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/extents.c
===================================================================
--- linux-2.6.orig/fs/ext4/extents.c
+++ linux-2.6/fs/ext4/extents.c
@@ -3309,10 +3309,10 @@ int ext4_fiemap(struct inode *inode, str
 		 * Walk the extent tree gathering extent information.
 		 * ext4_ext_fiemap_cb will push extents back to user.
 		 */
-		down_write(&EXT4_I(inode)->i_data_sem);
+		down_read(&EXT4_I(inode)->i_data_sem);
 		error = ext4_ext_walk_space(inode, start_blk, len_blks,
 					  ext4_ext_fiemap_cb, fieinfo);
-		up_write(&EXT4_I(inode)->i_data_sem);
+		up_read(&EXT4_I(inode)->i_data_sem);
 	}
 
 	return error;



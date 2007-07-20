From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] fix test in ext2fs_check_desc() for inode table
 within block group
Date: Fri, 20 Jul 2007 16:50:26 -0500
Message-ID: <46A12E22.3030102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbXGTV4K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2007 17:56:10 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l6KLu9Br027517
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 17:56:09 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l6KLu9T1012666
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 17:56:09 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l6KLu95P017571
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 17:56:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The test in ext2fs_check_desc() is off by one; if the inode table
goes all the way to the last block of the block group, it will 
falsely assert that it has extended past it.  The last block
of a range is start + len -1, not start + len.

Testcase to follow.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/lib/ext2fs/check_desc.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/check_desc.c
+++ e2fsprogs-1.40.2/lib/ext2fs/check_desc.c
@@ -61,7 +61,7 @@ errcode_t ext2fs_check_desc(ext2_filsys 
 		 */
 		if (fs->group_desc[i].bg_inode_table < first_block ||
 		    ((fs->group_desc[i].bg_inode_table +
-		      fs->inode_blocks_per_group) > last_block))
+		      fs->inode_blocks_per_group - 1) > last_block))
 			return EXT2_ET_GDESC_BAD_INODE_TABLE;
 	}
 	return 0;

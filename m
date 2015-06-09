From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] ext4: Wait for existing dio workers in ext4_alloc_file_blocks()
Date: Tue,  9 Jun 2015 08:58:46 +0200
Message-ID: <1433833126-28575-2-git-send-email-lczerner@redhat.com>
References: <1433833126-28575-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbbFIG6z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2015 02:58:55 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 79B47AC7C1
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2015 06:58:55 +0000 (UTC)
In-Reply-To: <1433833126-28575-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently existing dio workers can jump in and potentially increase
extent tree depth while we're allocating blocks in
ext4_alloc_file_blocks(). This may cause us to underestimate the number
of credits needed for the transaction because the extent tree depth can
change after our estimation.

Fix this by waiting for all the existing dio workers in the same way as
we do it in ext4_punch_hole. We've seen errors caused by this in xfstest
generic/299, however it's really hard to reproduce.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 13c5ebf..a5f7322 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4678,6 +4678,10 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	if (len <= EXT_UNWRITTEN_MAX_LEN)
 		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
 
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
 	/*
 	 * credits to insert 1 extent into extent tree
 	 */
@@ -4741,6 +4745,8 @@ retry:
 		goto retry;
 	}
 
+	ext4_inode_resume_unlocked_dio(inode);
+
 	return ret > 0 ? ret2 : ret;
 }
 
-- 
1.8.3.1


From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 1/2] ext4: warn on delalloc md block allocation without
 reservation
Date: Mon, 02 Apr 2012 11:14:13 -0400
Message-ID: <4F79C245.8010101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab2DBPOc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2012 11:14:32 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q32FEVF6027055
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2012 11:14:32 -0400
Received: from bfoster.bfoster (dhcp-187-76.bos.redhat.com [10.16.187.76])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q32FEVfu023459
	for <linux-ext4@vger.kernel.org>; Mon, 2 Apr 2012 11:14:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Brian Foster <bfoster@redhat.com>

If we hit a condition where we have allocated metadata blocks that
were not appropriately reserved, we risk underflow of
ei->i_reserved_meta_blocks. In turn, this can throw
sbi->s_dirtyclusters_counter significantly out of whack and undermine
the nondelalloc fallback logic in ext4_nonda_switch(). Warn if this
occurs and fix up the counter to handle only what we've reserved.
This condition is reproduced by xfstests 270 against ext2 with
delalloc enabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/ext4/inode.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c77b0bd..b58845c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -279,6 +279,15 @@ void ext4_da_update_reserve_space(struct inode *inode,
 		used = ei->i_reserved_data_blocks;
 	}
 
+	if (unlikely(ei->i_allocated_meta_blocks > ei->i_reserved_meta_blocks)) {
+		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, allocated %d "
+			 "with only %d reserved metadata blocks\n", __func__,
+			 inode->i_ino, ei->i_allocated_meta_blocks,
+			 ei->i_reserved_meta_blocks);
+		WARN_ON(1);
+		ei->i_allocated_meta_blocks = ei->i_reserved_meta_blocks;
+	}
+
 	/* Update per-inode reservations */
 	ei->i_reserved_data_blocks -= used;
 	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;
-- 
1.7.7.6


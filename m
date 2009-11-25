From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] ext4: ext4_get_reserved_space() must return bytes instead
 of blocks
Date: Wed, 25 Nov 2009 09:57:38 +0300
Message-ID: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, Mingming <cmm@us.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:43482 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZKYG5h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Nov 2009 01:57:37 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KTN00EZYKVQR060@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Wed, 25 Nov 2009 10:02:16 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ab22297..cc4737e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1057,7 +1057,7 @@ qsize_t ext4_get_reserved_space(struct inode *inode)
 		EXT4_I(inode)->i_reserved_meta_blocks;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
-	return total;
+	return (total << inode->i_blkbits);
 }
 /*
  * Calculate the number of metadata blocks need to reserve
-- 
1.6.0.4


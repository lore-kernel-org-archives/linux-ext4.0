From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Avoid stamping on other memories in ext4_ext_insert_index.
Date: Fri, 30 Sep 2011 17:35:04 +0800
Message-ID: <1317375304-5829-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:38474 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757755Ab1I3Jfj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Sep 2011 05:35:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In ext4_ext_insert_index, we initialize 'ix' before checking its validity, so
we have a chance to stamp on memories out of the block. So move the check
before we do the work.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/extents.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..37a1b4d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -776,15 +776,15 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 		ix = curp->p_idx;
 	}
 
-	ix->ei_block = cpu_to_le32(logical);
-	ext4_idx_store_pblock(ix, ptr);
-	le16_add_cpu(&curp->p_hdr->eh_entries, 1);

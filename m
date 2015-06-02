From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v3 1/3] ext4: Verify block bitmap even after fresh initialization
Date: Tue,  2 Jun 2015 19:30:03 +0200
Message-ID: <1433266205-24513-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbbFBRaM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2015 13:30:12 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 4C87AB7CC3
	for <linux-ext4@vger.kernel.org>; Tue,  2 Jun 2015 17:30:12 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we want to rely on the buffer_verified() flag of the block bitmap
buffer, we have to set it consistently. However currently if we're
initializing uninitialized block bitmap in
ext4_read_block_bitmap_nowait() we're not going to set buffer verified
at all.

We can do this by simply setting the flag on the buffer, but I think
it's actually better to run ext4_validate_block_bitmap() to make sure
that what we did in the ext4_init_block_bitmap() is right.

So run ext4_validate_block_bitmap() even after the block bitmap
initialization. Also bail out early from ext4_validate_block_bitmap() if
we see corrupt bitmap, since we already know it's corrupt and we do not
need to verify that.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: nothing changed
v3: nothing changed

 fs/ext4/balloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 955bf49..cd6ea29 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -369,7 +369,7 @@ static void ext4_validate_block_bitmap(struct super_block *sb,
 	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (buffer_verified(bh))
+	if (buffer_verified(bh) || EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
 		return;
 
 	ext4_lock_group(sb, block_group);
@@ -446,7 +446,7 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
 		unlock_buffer(bh);
 		if (err)
 			ext4_error(sb, "Checksum bad for grp %u", block_group);
-		return bh;
+		goto verify;
 	}
 	ext4_unlock_group(sb, block_group);
 	if (buffer_uptodate(bh)) {
-- 
1.8.3.1


From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: ext4_fill_super shouldn't return 0 on corruption
Date: Thu, 18 Nov 2010 09:45:25 +0100
Message-ID: <1290069925-16034-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, djwong@us.ibm.com,
	lczerner@redhat.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab0KRIpd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 03:45:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the start of ext4_fill_super, ret is set to -EINVAL, and any failure path
out of that function returns ret.  However, the generic_check_addressable
clause sets ret = 0 (if it passes), which means that a subsequent failure (e.g.
a group checksum error) returns 0 even though the mount should fail.  This
causes vfs_kern_mount in turn to think that the mount succeeded, leading to an
oops.

Signed-off-by: "Lukas Czerner" <lczerner@redhat.com>
Acked-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 61182fe..3d89b72 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3268,13 +3268,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * Test whether we have more sectors than will fit in sector_t,
 	 * and whether the max offset is addressable by the page cache.
 	 */
-	ret = generic_check_addressable(sb->s_blocksize_bits,
+	err = generic_check_addressable(sb->s_blocksize_bits,
 					ext4_blocks_count(es));
-	if (ret) {
+	if (err) {
 		ext4_msg(sb, KERN_ERR, "filesystem"
 			 " too large to mount safely on this system");
 		if (sizeof(sector_t) < 8)
 			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
+		ret = err;
 		goto failed_mount;
 	}
 
-- 
1.7.2.3


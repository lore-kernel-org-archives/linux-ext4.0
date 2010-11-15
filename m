From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] ext4: ext4_fill_super shouldn't return 0 on corruption
Date: Mon, 15 Nov 2010 13:48:31 -0800
Message-ID: <20101115214831.GA18195@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Patrick J. LoPresti" <lopresti@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37955 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab0KOVsm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Nov 2010 16:48:42 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the start of ext4_fill_super, ret is set to -EINVAL, and any failure path
out of that function returns this ret.  However, the generic_check_addressable
clause sets ret = 0 if it passes, which means that a subsequent failure (e.g.
a group checksum error) returns 0 even though the mount should fail.  This
causes vfs_kern_mount in turn to think that the mount succeeded (because
PTR_ERR(0) is false), leading to an oops.

A simple fix is to avoid using ret for the generic_check_addressable check,
which was last changed in commit 30ca22c70e3ef0a96ff84de69cd7e8561b416cb2.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/super.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 40131b7..a44bc59 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3257,9 +3257,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * Test whether we have more sectors than will fit in sector_t,
 	 * and whether the max offset is addressable by the page cache.
 	 */
-	ret = generic_check_addressable(sb->s_blocksize_bits,
-					ext4_blocks_count(es));
-	if (ret) {
+	if (generic_check_addressable(sb->s_blocksize_bits,
+				      ext4_blocks_count(es))) {
 		ext4_msg(sb, KERN_ERR, "filesystem"
 			 " too large to mount safely on this system");
 		if (sizeof(sector_t) < 8)

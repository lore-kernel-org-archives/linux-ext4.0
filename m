From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v2] ext4: ext4_fill_super shouldn't return 0 on corruption
Date: Mon, 15 Nov 2010 15:03:46 -0800
Message-ID: <20101115230346.GB18195@tux1.beaverton.ibm.com>
References: <20101115214831.GA18195@tux1.beaverton.ibm.com> <4CE1AC38.9040201@redhat.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"Patrick J. LoPresti" <lopresti@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43804 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab0KOXDt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Nov 2010 18:03:49 -0500
Content-Disposition: inline
In-Reply-To: <4CE1AC38.9040201@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the start of ext4_fill_super, ret is set to -EINVAL, and any failure path
out of that function returns ret.  However, the generic_check_addressable
clause sets ret = 0 (if it passes), which means that a subsequent failure (e.g.
a group checksum error) returns 0 even though the mount should fail.  This
causes vfs_kern_mount in turn to think that the mount succeeded, leading to an
oops.

A simple fix is to avoid using ret for the generic_check_addressable check,
which was last changed in commit 30ca22c70e3ef0a96ff84de69cd7e8561b416cb2.

v2: Return -EFBIG in the error case, per Eric Sandeen's suggestion.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 40131b7..120c034 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3257,13 +3257,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
 			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
+		ret = -EFBIG;
 		goto failed_mount;
 	}
 

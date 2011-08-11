From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] ext4: Always verify extent tree blocks
Date: Thu, 11 Aug 2011 14:13:41 -0700
Message-ID: <20110811211348.GK20655@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56822 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1HKVO7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 17:14:59 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It turns out that ext4_ext_check only verifies the validity of the extent block
it's processing if the block has to be read in from the disk.  Unfortunately,
this means that the check is NOT done if the block is already in memory, which
means that if a file has a corrupted extent block, then the first IO peformed
on the file will find the corrupt block and fail, but a second IO will see that
the extent block is in memory, bypass the corruption check, and use garbage
data as if they were extent data.

A simple testcase is to allocate a file with enough extents to overflow the
inode i_block, umount, overwrite the extent block magic with garbage, then
mount the filesystem and try to access the file.  The first access causes the
kernel to spit out an error, but subsequent accesses seem to succeed.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/extents.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ee4b391..bb07b79 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -744,8 +744,6 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	i = depth;
 	/* walk through the tree */
 	while (i) {
-		int need_to_validate = 0;

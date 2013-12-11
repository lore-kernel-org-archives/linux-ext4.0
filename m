From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 33/74] libext2fs: don't error out when punching a totally
 sparse file
Date: Tue, 10 Dec 2013 17:22:00 -0800
Message-ID: <20131211012200.30655.65221.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42973 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3LKBWG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:22:06 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're asked to punch a file with no data blocks mapped to it and a
non-zero length, we don't need to do any work in ext2fs_punch_extent()
and can return success.  Unfortunately, the extent_get() function
returns "no current node" because it (correctly) failed to find any
extents, which is bubbled up to callers.  Since no extents being found
is not an error in this corner case, fix up ext2fs_punch_extent() to
return 0 to callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/punch.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 9dfba2e..ff051f7 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -198,10 +198,17 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 	 * next-lowest extent if 'start' is in a hole, and doesn't set a
 	 * current node if there was a real error reading the extent tree.
 	 * In that case, _get() will error out.
+	 *
+	 * Note: If _get() returns 'no current node', that simply means that
+	 * there aren't any blocks mapped past this point in the file, so we're
+	 * done.
 	 */
 	ext2fs_extent_goto(handle, start);
 	retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
-	if (retval)
+	if (retval == EXT2_ET_NO_CURRENT_NODE) {
+		retval = 0;
+		goto errout;
+	} else if (retval)
 		goto errout;
 	while (1) {
 		op = EXT2_EXTENT_NEXT_LEAF;


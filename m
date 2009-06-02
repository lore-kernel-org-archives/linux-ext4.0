From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 02/24] ext4: fix header check in ext4_ext_search_right() for deep extent trees.
Date: Tue,  2 Jun 2009 08:09:14 -0400
Message-ID: <1243944576-20915-2-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59249 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZFBMJo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:44 -0400
In-Reply-To: <1243944576-20915-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

The ext4_ext_search_right() function is confusing; it uses a
"depth" variable which is 0 at the root and maximum at the leaves,
but the on-disk metadata uses a "depth" (actually eh_depth) which
is opposite: maximum at the root, and 0 at the leaves.

The ext4_ext_check_header() function is given a depth and checks
the header agaisnt that depth; it expects the on-disk semantics,
but we are giving it the opposite in the while loop in this
function.  We should be giving it the on-disk notion of "depth"
which we can get from (p_depth - depth) - and if you look, the last
(more commonly hit) call to ext4_ext_check_header() does just this.

Sending in the wrong depth results in (incorrect) messages
about corruption:

EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2621457: unexpected eh_depth - magic f30a, entries 340,
max 340(0), depth 1(2)

http://bugzilla.kernel.org/show_bug.cgi?id=12821

Reported-by: David Dindorp <ddi@dubex.dk>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 395a87bfefbc400011417e9eaae33169f9f036c0)
---
 fs/ext4/extents.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b24d3c5..acb98c9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1118,7 +1118,8 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
 	ext4_fsblk_t block;
-	int depth, ee_len;
+	int depth;	/* Note, NOT eh_depth; depth from top of tree */
+	int ee_len;
 
 	BUG_ON(path == NULL);
 	depth = path->p_depth;
@@ -1177,7 +1178,8 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 		if (bh == NULL)
 			return -EIO;
 		eh = ext_block_hdr(bh);
-		if (ext4_ext_check_header(inode, eh, depth)) {
+		/* subtract from p_depth to get proper eh_depth */
+		if (ext4_ext_check_header(inode, eh, path->p_depth - depth)) {
 			put_bh(bh);
 			return -EIO;
 		}
-- 
1.6.3.1.1.g75fc.dirty


From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 04/24] ext4: fix bogus BUG_ONs in in mballoc code
Date: Tue,  2 Jun 2009 08:09:16 -0400
Message-ID: <1243944576-20915-4-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59258 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbZFBMJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:45 -0400
In-Reply-To: <1243944576-20915-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

Thiemo Nagel reported that:

# dd if=/dev/zero of=image.ext4 bs=1M count=2
# mkfs.ext4 -v -F -b 1024 -m 0 -g 512 -G 4 -I 128 -N 1 \
  -O large_file,dir_index,flex_bg,extent,sparse_super image.ext4
# mount -o loop image.ext4 mnt/
# dd if=/dev/zero of=mnt/file

oopsed, with a BUG_ON in ext4_mb_normalize_request because
size == EXT4_BLOCKS_PER_GROUP

It appears to me (esp. after talking to Andreas) that the BUG_ON
is bogus; a request of exactly EXT4_BLOCKS_PER_GROUP should
be allowed, though larger sizes do indicate a problem.

Fix that an another (apparently rare) codepath with a similar check.

Reported-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 8d03c7a0c550e7ab24cadcef5e66656bfadec8b9)
---
 fs/ext4/mballoc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 39d7cc1..ceb68db 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1450,7 +1450,7 @@ static void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
 	struct ext4_free_extent *gex = &ac->ac_g_ex;
 
 	BUG_ON(ex->fe_len <= 0);
-	BUG_ON(ex->fe_len >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(ex->fe_len > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ex->fe_start >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 	BUG_ON(ac->ac_status != AC_STATUS_CONTINUE);
 
@@ -3400,7 +3400,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	}
 	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical);
-	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
 
-- 
1.6.3.1.1.g75fc.dirty


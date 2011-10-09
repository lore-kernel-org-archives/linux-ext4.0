From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: handle NULL p_ext in ext4_ext_next_allocated_block()
Date: Sat,  8 Oct 2011 18:01:14 -0700
Message-ID: <1318122074-16056-1-git-send-email-curtw@google.com>
Cc: linux-ext4@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:27975 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1JIBB0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 21:01:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_ext_next_allocated_block(), the path[depth] might
have a p_ext that is NULL -- see ext4_ext_binsearch().  In
such a case, dereferencing it will crash the machine.

This patch checks for p_ext == NULL in
ext4_ext_next_allocated_block() before dereferencinging it.

Tested using a hand-crafted an inode with eh_entries == 0 in
an extent block, verified that running FIEMAP on it crashes
without this patch, works fine with it.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 fs/ext4/extents.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..063a5b8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1395,7 +1395,9 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
 	while (depth >= 0) {
 		if (depth == path->p_depth) {
 			/* leaf */
-			if (path[depth].p_ext !=
+			/* p_ext can be NULL */
+			if (path[depth].p_ext &&
+				path[depth].p_ext !=
 					EXT_LAST_EXTENT(path[depth].p_hdr))
 			  return le32_to_cpu(path[depth].p_ext[1].ee_block);
 		} else {
-- 
1.7.3.1


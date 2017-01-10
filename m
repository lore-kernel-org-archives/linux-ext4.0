From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Trim allocation requests to group size
Date: Tue, 10 Jan 2017 10:32:01 +0100
Message-ID: <20170110093201.1403-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38899 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765267AbdAJJcK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 10 Jan 2017 04:32:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If filesystem groups are artifically small (using parameter -g to
mkfs.ext4), ext4_mb_normalize_request() can result in a request that is
larger than a block group. Trim the request size to not confuse
allocation code.

Reported-by: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7ae43c59bc79..2e9fc7a61048 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3123,6 +3123,13 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	if (ar->pright && start + size - 1 >= ar->lright)
 		size -= start + size - ar->lright;
 
+	/*
+	 * Trim allocation request for filesystems with artificially small
+	 * groups.
+	 */
+	if (size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb))
+		size = EXT4_BLOCKS_PER_GROUP(ac->ac_sb);
+
 	end = start + size;
 
 	/* check we don't cross already preallocated blocks */
-- 
2.10.2


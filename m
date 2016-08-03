From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/11] ext4: Check that external xattr value block is 0
Date: Wed,  3 Aug 2016 12:39:50 +0200
Message-ID: <1470220795-17045-7-git-send-email-jack@suse.cz>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544AbcHCKkd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2016 06:40:33 -0400
In-Reply-To: <1470220795-17045-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we don't support xattrs with values stored out of line. Check
for that in ext4_xattr_check_names() to make sure we never work with
such xattrs since not all the code counts with that resulting is possible
weird corruption issues.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 22d2ebcd1f09..f845cb7c6623 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -199,6 +199,8 @@ ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end,
 	}
 
 	while (!IS_LAST_ENTRY(entry)) {
+		if (entry->e_value_block != 0)
+			return -EFSCORRUPTED;
 		if (entry->e_value_size != 0 &&
 		    (value_start + le16_to_cpu(entry->e_value_offs) <
 		     (void *)e + sizeof(__u32) ||
-- 
2.6.6


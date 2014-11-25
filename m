From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Forbid journal_async_commit in data=ordered mode
Date: Tue, 25 Nov 2014 16:56:15 +0100
Message-ID: <1416930975-13676-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbaKYP4W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 10:56:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Option journal_async_commit breaks gurantees of data=ordered mode as it
sends only a single cache flush after writing a transaction commit
block. Thus even though the transaction including the commit block is
fully stored on persistent storage, file data may still linger in drives
caches and will be lost on power failure. Since all checksums match on
journal recovery, we replay the transaction thus possibly exposing stale
user data.

To fix this data exposure issue, remove the possibility to use
journal_async_commit in data=ordered mode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b53c243a142b..c62445cb01ca 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1701,6 +1701,12 @@ static int parse_options(char *options, struct super_block *sb,
 			return 0;
 		}
 	}
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA &&
+	    test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
+		ext4_msg(sb, KERN_ERR, "can't mount with journal_async_commit "
+			 "in data=ordered mode");
+		return 0;
+	}
 	return 1;
 }
 
-- 
1.8.1.4


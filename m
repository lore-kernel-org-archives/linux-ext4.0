From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix trimming of a single group
Date: Thu,  6 Jan 2011 15:32:58 +0100
Message-ID: <1294324378-21712-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Lukas Czerner <lczerner@redhat.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1AFOdN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jan 2011 09:33:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4_trim_fs() is called to trim a part of a single group, the
logic will wrongly set last block of the interval to 'len' instead
of 'first_block + len'. Thus a shorter interval is possibly trimmed.
Fix it.

CC: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 I've already implemented this fix for ext3.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5b4d4e3..4c4766c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4851,7 +4851,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		if (len >= EXT4_BLOCKS_PER_GROUP(sb))
 			len -= (EXT4_BLOCKS_PER_GROUP(sb) - first_block);
 		else
-			last_block = len;
+			last_block = first_block + len;
 
 		if (e4b.bd_info->bb_free >= minlen) {
 			cnt = ext4_trim_all_free(sb, &e4b, first_block,
-- 
1.7.1


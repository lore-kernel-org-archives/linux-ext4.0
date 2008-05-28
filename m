From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Silence warnings about non-uptodate buffers
Date: Wed, 28 May 2008 23:56:13 +0200
Message-ID: <12120117741472-git-send-email-jack@suse.cz>
References: <12120117733479-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54466 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753620AbYE1V4Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 17:56:16 -0400
In-Reply-To: <12120117733479-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When underlying block device becomes unavailable (e.g. someone pulling an
USB stick from under us), kernel produces warning about non-uptodate buffer
(superblock) being marked dirty. Silence these warnings by making buffer
uptodate before marking it dirty.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 09d9359..298c94f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -510,6 +510,7 @@ static void ext4_put_super (struct super_block * sb)
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 		BUFFER_TRACE(sbi->s_sbh, "marking dirty");
+		set_buffer_uptodate(sbi->s_sbh);
 		mark_buffer_dirty(sbi->s_sbh);
 		ext4_commit_super(sb, es, 1);
 	}
@@ -2659,6 +2660,7 @@ static void ext4_commit_super (struct super_block * sb,
 	ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext4_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
+	set_buffer_uptodate(sbh);
 	mark_buffer_dirty(sbh);
 	if (sync)
 		sync_dirty_buffer(sbh);
-- 
1.5.2.4


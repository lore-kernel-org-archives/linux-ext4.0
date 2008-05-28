From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Silence warnings about non-uptodate buffers
Date: Wed, 28 May 2008 23:56:09 +0200
Message-ID: <12120117734185-git-send-email-jack@suse.cz>
References: <12120117733479-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54451 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753355AbYE1V4P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 17:56:15 -0400
In-Reply-To: <12120117733479-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When underlying block device becomes unavailable (e.g. someone pulling an
USB stick from under us), kernel produces warning about non-uptodate buffer
(superblock) being marked dirty. Silence these warnings by making buffer
uptodate before marking it dirty.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index ef50cbc..2941bc3 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1092,6 +1092,7 @@ static void ext2_commit_super (struct super_block * sb,
 			       struct ext2_super_block * es)
 {
 	es->s_wtime = cpu_to_le32(get_seconds());
+	set_buffer_uptodate(EXT2_SB(sb)->s_sbh);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	sb->s_dirt = 0;
 }
@@ -1101,6 +1102,7 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
+	set_buffer_uptodate(EXT2_SB(sb)->s_sbh);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
 	sb->s_dirt = 0;
-- 
1.5.2.4


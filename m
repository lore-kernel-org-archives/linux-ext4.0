From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCHv5 12/16] ext4: fix race condition in marking SB dirty
Date: Sun,  6 Jun 2010 17:50:25 +0300
Message-ID: <1275835829-1478-13-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
	linux-ext4@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

When synchronizing the superblock, ext4 first starts changing the
SB (a) and then marks the superblock as clean (b). However, meanwhile
(between (a) and (b)) someone else can modify the superblock and
mark it as dirty. This would be a race condition, and the result
would be that we'd end up with a modified superblock which would
nevertheless be marked as clean (because of (b)). This means that
'sync_supers()' would never call our '->write_super()', at least
not until yet another SB change happens.

This patch fixes this race condition by marking the superblock as
clean before starting SB changes.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-ext4@vger.kernel.org

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d1707a0..7b19932 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3372,6 +3372,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
+	sb_mark_clean(sb);
 	/*
 	 * If the file system is mounted read-only, don't update the
 	 * superblock write time.  This avoids updating the superblock
@@ -3392,7 +3393,6 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 					&EXT4_SB(sb)->s_freeblocks_counter));
 	es->s_free_inodes_count = cpu_to_le32(percpu_counter_sum_positive(
 					&EXT4_SB(sb)->s_freeinodes_counter));
-	sb_mark_clean(sb);
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync) {
-- 
1.7.0.1

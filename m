From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH v2 1/4] ext4: Remove useless marking of superblock dirty
Date: Mon,  2 Apr 2012 14:45:36 +0300
Message-ID: <1333367140-28370-2-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jan Kara <jack@suse.cz>

Commit a0375156 properly notes that superblock doesn't need to be marked
as dirty when only number of free inodes / blocks / number of directories
changes since that is recomputed on each mount anyway. However that comment
leaves some unnecessary markings as dirty in place. Remove these.

Artem: tested using xfstests for both journalled and non-journalled ext4.

Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/ialloc.c  |    2 --
 fs/ext4/mballoc.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 409c2ee..b7188c6 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -295,7 +295,6 @@ out:
 		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 		if (!fatal)
 			fatal = err;
-		ext4_mark_super_dirty(sb);
 	} else
 		ext4_error(sb, "bit already cleared for inode %lu", ino);
 
@@ -800,7 +799,6 @@ got:
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
-	ext4_mark_super_dirty(sb);
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 99ab428..3db3dfc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2822,7 +2822,6 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
-	ext4_mark_super_dirty(sb);
 	brelse(bitmap_bh);
 	return err;
 }
@@ -4692,7 +4691,6 @@ do_more:
 		put_bh(bitmap_bh);
 		goto do_more;
 	}
-	ext4_mark_super_dirty(sb);
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
-- 
1.7.7.6

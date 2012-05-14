From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: [PATCH] ext4: turn on i_version updates by default
Date: Mon, 14 May 2012 10:06:18 -0400
Message-ID: <20120514140618.GA29902@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

knfsd needs i_version updates on, as will userspace nfs servers and
probably others.

The only effects are that inode->i_version is bumped (under the i_lock)
in more places, and that ->dirty_inode(I_DIRTY_DATASYNC) may be called
more frequently than once per jiffy on write (see file_update_time).
However the latter appears to be mostly a no-op in that case.

So, simplify our life and just keep this feature turned on all the time.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

If people are worried that the performance impact isn't obvious, I'll
find the time somehow to test this properly....

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e1fb1d5..a99f827 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1483,7 +1483,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		sbi->s_mount_flags |= EXT4_MF_FS_ABORTED;
 		return 1;
 	case Opt_i_version:
-		sb->s_flags |= MS_I_VERSION;
+		/* no-op; this is on by default now */
 		return 1;
 	case Opt_journal_dev:
 		if (is_remount) {
@@ -2979,6 +2979,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_free_orig;
 	}
 	sb->s_fs_info = sbi;
+	sb->s_flags |= MS_I_VERSION;
 	sbi->s_mount_opt = 0;
 	sbi->s_resuid = EXT4_DEF_RESUID;
 	sbi->s_resgid = EXT4_DEF_RESGID;
-- 
1.7.9.5


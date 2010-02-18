From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 06/19] ext2: replace inode uid,gid,mode init with helper v2
Date: Thu, 18 Feb 2010 10:00:03 +0300
Message-ID: <87vddv9ggc.fsf_-_@openvz.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
	<1266432013-9241-1-git-send-email-dmonakhov@openvz.org>
	<20100218012128.GA8897@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100218012128.GA8897@atrey.karlin.mff.cuni.cz> (Jan Kara's
	message of "Thu, 18 Feb 2010 02:21:28 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext2/ialloc.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 15387c9..2c484c6 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -550,16 +550,12 @@ got:
 
 	sb->s_dirt = 1;
 	mark_buffer_dirty(bh2);
-	inode->i_uid = current_fsuid();
-	if (test_opt (sb, GRPID))
+	if (test_opt(sb, GRPID)) {
+		inode->i_mode = mode;
+		inode->i_uid = current_fsuid();
 		inode->i_gid = dir->i_gid;
-	else if (dir->i_mode & S_ISGID) {
-		inode->i_gid = dir->i_gid;
-		if (S_ISDIR(mode))
-			mode |= S_ISGID;
 	} else
-		inode->i_gid = current_fsgid();
-	inode->i_mode = mode;
+		inode_init_owner(inode, dir, mode);
 
 	inode->i_ino = ino;
 	inode->i_blocks = 0;
-- 
1.6.6


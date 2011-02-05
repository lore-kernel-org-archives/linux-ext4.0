From: Tao Ma <tm@tao.ma>
Subject: [PATCH] VFS: call synchronize_rcu after kill_sb.
Date: Sat,  5 Feb 2011 17:01:21 +0800
Message-ID: <1296896481-3650-1-git-send-email-tm@tao.ma>
Cc: linux-ext4@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Boaz Harrosh <bharrosh@panasas.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In fa0d7e3, we use rcu free inode instead of freeing the inode
directly. It causes a problem when we rmmod immediately after
we umount the volume[1].

So we need to call synchronize_rcu after we kill_sb so that
the inode is freed before we do rmmod. The idea is inspired
by Chris Mason[2]. I tested with ext4 by umount+rmmod and it
doesn't show any error by now.

1. http://marc.info/?l=linux-fsdevel&m=129680863330185&w=2
2. http://marc.info/?l=linux-fsdevel&m=129684698713709&w=2 

Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/super.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 74e149e..315bce9 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -177,6 +177,13 @@ void deactivate_locked_super(struct super_block *s)
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_test(&s->s_active)) {
 		fs->kill_sb(s);
+		/*
+		 * We need to synchronize rcu here so that
+		 * the delayed rcu inode free can be executed
+		 * before we put_super.
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=27652
+		 */
+		synchronize_rcu();
 		put_filesystem(fs);
 		put_super(s);
 	} else {
-- 
1.6.3.GIT


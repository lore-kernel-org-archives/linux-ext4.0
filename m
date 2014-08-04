From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] ext4: fix comment in evict_inode()
Date: Mon,  4 Aug 2014 10:26:26 +0200
Message-ID: <1407140787-3742-1-git-send-email-fabf@skynet.be>
Cc: Fabian Frederick <fabf@skynet.be>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

commit 91b0abe36a7b
("mm + fs: store shadow entries in page cache")

replaced truncate_inode_pages by truncate_inode_pages_final

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 367a60c..16d429f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -197,8 +197,8 @@ void ext4_evict_inode(struct inode *inode)
 		 * ready for reaping the inode might still have some pages to
 		 * write in the running transaction or waiting to be
 		 * checkpointed. Thus calling jbd2_journal_invalidatepage()
-		 * (via truncate_inode_pages()) to discard these buffers can
-		 * cause data loss. Also even if we did not discard these
+		 * (via truncate_inode_pages_final()) to discard these buffers
+		 * can cause data loss. Also even if we did not discard these
 		 * buffers, we would have no way to find them after the inode
 		 * is reaped and thus user could see stale data if he tries to
 		 * read them before the transaction is checkpointed. So be
-- 
1.9.1

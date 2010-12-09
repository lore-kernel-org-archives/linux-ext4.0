From: Joe Perches <joe@perches.com>
Subject: [PATCH 10/15] ext2: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:04:03 -0800
Message-ID: <ab8fd6a6f1ef5c6bc6ab631f56e1187cc5de44a3.1291923889.git.joe@perches.com>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
Cc: Jiri Kosina <trivial@kernel.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext2/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index f8aecd2..2e1d834 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -67,7 +67,7 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
 	inode = NULL;
 	if (ino) {
 		inode = ext2_iget(dir->i_sb, ino);
-		if (unlikely(IS_ERR(inode))) {
+		if (IS_ERR(inode)) {
 			if (PTR_ERR(inode) == -ESTALE) {
 				ext2_error(dir->i_sb, __func__,
 						"deleted inode referenced: %lu",
-- 
1.7.3.3.464.gf80b6

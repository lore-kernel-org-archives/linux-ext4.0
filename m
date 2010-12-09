From: Joe Perches <joe@perches.com>
Subject: [PATCH 11/15] ext3: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:04:04 -0800
Message-ID: <62905e31f7483c8681286b90b121f0044163baed.1291923889.git.joe@perches.com>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
Cc: Jiri Kosina <trivial@kernel.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext3/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index bce9dce..268f776 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1047,7 +1047,7 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 			return ERR_PTR(-EIO);
 		}
 		inode = ext3_iget(dir->i_sb, ino);
-		if (unlikely(IS_ERR(inode))) {
+		if (IS_ERR(inode)) {
 			if (PTR_ERR(inode) == -ESTALE) {
 				ext3_error(dir->i_sb, __func__,
 						"deleted inode referenced: %lu",
-- 
1.7.3.3.464.gf80b6

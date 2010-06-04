From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext2: update ctime when changing the file's permission by setfacl
Date: Fri,  4 Jun 2010 17:07:52 +0200
Message-ID: <1275664075-4703-2-git-send-email-jack@suse.cz>
References: <1275664075-4703-1-git-send-email-jack@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1275664075-4703-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext2 didn't update the ctime of the file when its permission was changed.

Steps to reproduce:
 # touch aaa
 # stat -c %Z aaa
 1275289822
 # setfacl -m  'u::x,g::x,o::x' aaa
 # stat -c %Z aaa
 1275289822                         <- unchanged

But, according to the spec of the ctime, ext2 must update it.

Port of ext3 patch by Miao Xie <miaox@cn.fujitsu.com>.

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/acl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index ca7e2a0..2bcc043 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -200,6 +200,7 @@ ext2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 					return error;
 				else {
 					inode->i_mode = mode;
+					inode->i_ctime = CURRENT_TIME_SEC;
 					mark_inode_dirty(inode);
 					if (error == 0)
 						acl = NULL;
-- 
1.6.4.2


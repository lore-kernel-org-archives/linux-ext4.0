From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] vfs: update ctime when changing the file's permission by setfacl
Date: Fri,  4 Jun 2010 17:07:53 +0200
Message-ID: <1275664075-4703-3-git-send-email-jack@suse.cz>
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

generic_acl_set didn't update the ctime of the file when its permission was
changed.

Steps to reproduce:
 # touch aaa
 # stat -c %Z aaa
 1275289822
 # setfacl -m  'u::x,g::x,o::x' aaa
 # stat -c %Z aaa
 1275289822                         <- unchanged

But, according to the spec of the ctime, vfs must update it.

Port of ext3 patch by Miao Xie <miaox@cn.fujitsu.com>.

CC: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/generic_acl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/generic_acl.c b/fs/generic_acl.c
index 99800e5..6bc9e3a 100644
--- a/fs/generic_acl.c
+++ b/fs/generic_acl.c
@@ -94,6 +94,7 @@ generic_acl_set(struct dentry *dentry, const char *name, const void *value,
 			if (error < 0)
 				goto failed;
 			inode->i_mode = mode;
+			inode->i_ctime = CURRENT_TIME;
 			if (error == 0) {
 				posix_acl_release(acl);
 				acl = NULL;
-- 
1.6.4.2


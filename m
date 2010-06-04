From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] jffs2: update ctime when changing the file's permission by setfacl
Date: Fri,  4 Jun 2010 17:07:55 +0200
Message-ID: <1275664075-4703-5-git-send-email-jack@suse.cz>
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

jffs2 didn't update the ctime of the file when its permission was changed.

Steps to reproduce:
 # touch aaa
 # stat -c %Z aaa
 1275289822
 # setfacl -m  'u::x,g::x,o::x' aaa
 # stat -c %Z aaa
 1275289822                         <- unchanged

But, according to the spec of the ctime, jffs2 must update it.

Port of ext3 patch by Miao Xie <miaox@cn.fujitsu.com>.

CC: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jffs2/acl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index a33aab6..54a92fd 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -234,8 +234,9 @@ static int jffs2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 			if (inode->i_mode != mode) {
 				struct iattr attr;
 
-				attr.ia_valid = ATTR_MODE;
+				attr.ia_valid = ATTR_MODE | ATTR_CTIME;
 				attr.ia_mode = mode;
+				attr.ia_ctime = CURRENT_TIME_SEC;
 				rc = jffs2_do_setattr(inode, &attr);
 				if (rc < 0)
 					return rc;
-- 
1.6.4.2


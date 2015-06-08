From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 8/8] fs/ext4/super.c: Use strreplace in ext4_fill_super
Date: Tue,  9 Jun 2015 01:26:56 +0200
Message-ID: <1433806017-10823-9-git-send-email-linux@rasmusvillemoes.dk>
References: <1433806017-10823-1-git-send-email-linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>, Al Viro <viro@ZenIV.linux.org.uk>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433806017-10823-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This makes a very large function a little smaller.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
v2: no changes.

 fs/ext4/super.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ca9d4a2fed41..5f3c43a66937 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3420,7 +3420,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long journal_devnum = 0;
 	unsigned long def_mount_opts;
 	struct inode *root;
-	char *cp;
 	const char *descr;
 	int ret = -ENOMEM;
 	int blocksize, clustersize;
@@ -3456,8 +3455,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #endif
 
 	/* Cleanup superblock name */
-	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
-		*cp = '!';
+	strreplace(sb->s_id, '/', '!');
 
 	/* -EINVAL is default */
 	ret = -EINVAL;
-- 
2.1.3

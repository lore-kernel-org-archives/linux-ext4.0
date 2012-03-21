From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH 3/8] ext2: write superblock only once on unmount
Date: Wed, 21 Mar 2012 18:14:30 +0200
Message-ID: <1332346475-1441-4-git-send-email-dedekind1@gmail.com>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Currently on unmount if we are mounted R/W, we first write the superblock to
the media if it is dirty, and then write it again, which is not optimal. This
patch makes ext2 write the superblock on unmount less times.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext2/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 0090595..d141758 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -130,9 +130,6 @@ static void ext2_put_super (struct super_block * sb)
 
 	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
-	if (sb->s_dirt)
-		ext2_write_super(sb);
-
 	ext2_xattr_put_super(sb);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		struct ext2_super_block *es = sbi->s_es;
-- 
1.7.7.6

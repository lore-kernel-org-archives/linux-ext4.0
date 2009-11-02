From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 06/27] BKL: Remove BKL from ext3 fill_super()
Date: Mon,  2 Nov 2009 11:04:46 +0100
Message-ID: <1257156307-24175-7-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	Jan Blunck <jblunck@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbZKBKHA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:00 -0500
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The BKL is protecting nothing than two memory allocations here.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext3/super.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 38261a5..4b635b7 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1568,19 +1568,14 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	__le32 features;
 	int err;
 
-	lock_kernel();
-
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_fs_info = sbi;
@@ -1589,8 +1584,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_resgid = EXT3_DEF_RESGID;
 	sbi->s_sb_block = sb_block;
 
-	unlock_kernel();

From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 07/27] BKL: Remove BKL from ext3_put_super() and ext3_remount()
Date: Mon,  2 Nov 2009 11:04:47 +0100
Message-ID: <1257156307-24175-8-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	Jan Blunck <jblunck@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbZKBKHA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:00 -0500
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The BKL lock is protecting the remounting against a potential call to
ext3_put_super(). This could not happen, since this is protected by the
s_umount rw semaphore of struct super_block.

Therefore I think the BKL is protecting nothing here.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext3/super.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 4b635b7..3ddce03 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -398,8 +398,6 @@ static void ext3_put_super (struct super_block * sb)
 	struct ext3_super_block *es = sbi->s_es;
 	int i, err;
 
-	lock_kernel();
-
 	ext3_xattr_put_super(sb);
 	err = journal_destroy(sbi->s_journal);
 	sbi->s_journal = NULL;
@@ -448,8 +446,6 @@ static void ext3_put_super (struct super_block * sb)
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
-
-	unlock_kernel();
 }
 
 static struct kmem_cache *ext3_inode_cachep;
@@ -2495,8 +2491,6 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 	int i;
 #endif
 
-	lock_kernel();

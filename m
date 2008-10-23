From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH resend] ext4: fix printk format warning
Date: Fri, 24 Oct 2008 02:47:00 +0400
Message-ID: <20081023224700.GA28845@orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:21734 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYJWWrO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2008 18:47:14 -0400
Received: by fk-out-0910.google.com with SMTP id 18so367735fkq.5
        for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2008 15:47:08 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fs/ext4/balloc.c:607: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1822: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1824: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/ext4/balloc.c |    2 +-
 fs/ext4/inode.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index bd2ece2..f62a885 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -604,7 +604,7 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",
-					dirty_blocks);
+					(long long)dirty_blocks);
 		}
 	}
 	/* Check whether we have space after
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9b4ec9d..a5cd96b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1819,9 +1819,9 @@ static void ext4_print_free_blocks(struct inode *inode)
 			ext4_count_free_blocks(inode->i_sb));
 	printk(KERN_EMERG "Free/Dirty block details\n");
 	printk(KERN_EMERG "free_blocks=%lld\n",
-			percpu_counter_sum(&sbi->s_freeblocks_counter));
+			(long long)percpu_counter_sum(&sbi->s_freeblocks_counter));
 	printk(KERN_EMERG "dirty_blocks=%lld\n",
-			percpu_counter_sum(&sbi->s_dirtyblocks_counter));
+			(long long)percpu_counter_sum(&sbi->s_dirtyblocks_counter));
 	printk(KERN_EMERG "Block reservation details\n");
 	printk(KERN_EMERG "i_reserved_data_blocks=%lu\n",
 			EXT4_I(inode)->i_reserved_data_blocks);

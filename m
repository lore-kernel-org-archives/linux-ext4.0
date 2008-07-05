From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 15/52] ext4: remove redundant code in ext4_fill_super()
Date: Sat,  5 Jul 2008 13:35:41 -0400
Message-ID: <1215279378-30504-16-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33103 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756000AbYGERgd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:33 -0400
In-Reply-To: <1215279378-30504-15-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Li Zefan <lizf@cn.fujitsu.com>

The previous sb_min_blocksize() has already set the block size.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0d560fc..b1166a9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1899,11 +1899,6 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		goto out_fail;
 	}
 
-	if (!sb_set_blocksize(sb, blocksize)) {
-		printk(KERN_ERR "EXT4-fs: bad blocksize %d.\n", blocksize);
-		goto out_fail;
-	}

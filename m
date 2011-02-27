From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 12/17]fs:jbd Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:05 -0800
Message-ID: <1298781250-2718-13-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: trivial@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60433 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1B0Eeu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Feb 2011 23:34:50 -0500
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The Patch below removes one to many "n's" in a word.. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org> 
CC: Jan Kara <jack@suse.cz> 
CC: linux-ext4@vger.kernel.org
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index da1b5e4..eb11601 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -839,7 +839,7 @@ journal_t * journal_init_inode (struct inode *inode)
 	err = journal_bmap(journal, 0, &blocknr);
 	/* If that failed, give up */
 	if (err) {
-		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
+		printk(KERN_ERR "%s: Cannot locate journal superblock\n",
 		       __func__);
 		goto out_err;
 	}
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 97e7346..90407b8 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -991,7 +991,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 	err = jbd2_journal_bmap(journal, 0, &blocknr);
 	/* If that failed, give up */
 	if (err) {
-		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
+		printk(KERN_ERR "%s: Cannot locate journal superblock\n",
 		       __func__);
 		goto out_err;
 	}
-- 
1.7.4.1


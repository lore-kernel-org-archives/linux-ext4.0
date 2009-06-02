From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.27 16/24] ext4: fix typo which causes a memory leak on error path
Date: Tue,  2 Jun 2009 08:09:28 -0400
Message-ID: <1243944576-20915-16-git-send-email-tytso@mit.edu>
References: <1243944576-20915-1-git-send-email-tytso@mit.edu>
 <1243944576-20915-2-git-send-email-tytso@mit.edu>
 <1243944576-20915-3-git-send-email-tytso@mit.edu>
 <1243944576-20915-4-git-send-email-tytso@mit.edu>
 <1243944576-20915-5-git-send-email-tytso@mit.edu>
 <1243944576-20915-6-git-send-email-tytso@mit.edu>
 <1243944576-20915-7-git-send-email-tytso@mit.edu>
 <1243944576-20915-8-git-send-email-tytso@mit.edu>
 <1243944576-20915-9-git-send-email-tytso@mit.edu>
 <1243944576-20915-10-git-send-email-tytso@mit.edu>
 <1243944576-20915-11-git-send-email-tytso@mit.edu>
 <1243944576-20915-12-git-send-email-tytso@mit.edu>
 <1243944576-20915-13-git-send-email-tytso@mit.edu>
 <1243944576-20915-14-git-send-email-tytso@mit.edu>
 <1243944576-20915-15-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Chris Wright <chrisw@sous-sol.org>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59319 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZFBMJx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:09:53 -0400
In-Reply-To: <1243944576-20915-15-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dan Carpenter <error27@gmail.com>

upstream commit: a7b19448ddbdc34b2b8fedc048ba154ca798667b

This was found by smatch (http://repo.or.cz/w/smatch.git/)

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f34dada..5f87023 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2698,7 +2698,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_mb_maxs == NULL) {
 		clear_opt(sbi->s_mount_opt, MBALLOC);
-		kfree(sbi->s_mb_maxs);
+		kfree(sbi->s_mb_offsets);
 		return -ENOMEM;
 	}
 
-- 
1.6.3.1.1.g75fc.dirty


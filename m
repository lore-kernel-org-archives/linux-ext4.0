From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.29 12/18] ext4: really print the find_group_flex fallback warning only once
Date: Tue,  2 Jun 2009 08:07:53 -0400
Message-ID: <1243944479-20574-12-git-send-email-tytso@mit.edu>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu>
 <1243944479-20574-2-git-send-email-tytso@mit.edu>
 <1243944479-20574-3-git-send-email-tytso@mit.edu>
 <1243944479-20574-4-git-send-email-tytso@mit.edu>
 <1243944479-20574-5-git-send-email-tytso@mit.edu>
 <1243944479-20574-6-git-send-email-tytso@mit.edu>
 <1243944479-20574-7-git-send-email-tytso@mit.edu>
 <1243944479-20574-8-git-send-email-tytso@mit.edu>
 <1243944479-20574-9-git-send-email-tytso@mit.edu>
 <1243944479-20574-10-git-send-email-tytso@mit.edu>
 <1243944479-20574-11-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33537 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbZFBMIL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:08:11 -0400
In-Reply-To: <1243944479-20574-11-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Chuck Ebbert <cebbert@redhat.com>

Missing braces caused the warning to print more than once.

Signed-Off-By: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 6b82f3cb2d480b7714eb0ff61aee99c22160389e)
---
 fs/ext4/ialloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index befd95e..345cba1 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -720,11 +720,12 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 		ret2 = find_group_flex(sb, dir, &group);
 		if (ret2 == -1) {
 			ret2 = find_group_other(sb, dir, &group);
-			if (ret2 == 0 && once)
+			if (ret2 == 0 && once) {
 				once = 0;
 				printk(KERN_NOTICE "ext4: find_group_flex "
 				       "failed, fallback succeeded dir %lu\n",
 				       dir->i_ino);
+			}
 		}
 		goto got_group;
 	}
-- 
1.6.3.1.1.g75fc.dirty


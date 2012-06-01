From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] dumpe2fs: print journal's s_errno field if it is non-zero
Date: Thu, 31 May 2012 20:14:55 -0400
Message-ID: <1338509698-24349-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46853 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723Ab2FAAPB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 20:15:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/dumpe2fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 8f4f2e4..8be5764 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -382,6 +382,9 @@ static void print_inline_journal_information(ext2_filsys fs)
 	       (unsigned int)ntohl(jsb->s_maxlen),
 	       (unsigned int)ntohl(jsb->s_sequence),
 	       (unsigned int)ntohl(jsb->s_start));
+	if (jsb->s_errno != 0)
+		printf(_("Journal errno:            %d\n"),
+		       (int) ntohl(jsb->s_errno));
 }
 
 static void print_journal_information(ext2_filsys fs)
-- 
1.7.10.2.552.gaa3bb87


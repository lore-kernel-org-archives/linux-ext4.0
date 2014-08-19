From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] debugfs: fix set_inode_field block[IND|DIND|TIND]
Date: Tue, 19 Aug 2014 08:30:45 -0400
Message-ID: <1408451445-17669-1-git-send-email-tytso@mit.edu>
References: <CABW1wHSXSc-4kNDEzGKxPYTfust0Htc66VkcmoJVxrS-FA9Oog@mail.gmail.com>
Cc: jhe@cs.wisc.edu, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38810 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbaHSMax (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2014 08:30:53 -0400
In-Reply-To: <CABW1wHSXSc-4kNDEzGKxPYTfust0Htc66VkcmoJVxrS-FA9Oog@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After we determine that we can't parse the array value as an integer,
we need to restore the square brackets to the field name, so that we
can find a match with block[IND], block[DIND], and block[TIND] in the
inode field table.

Reported-by: Jun He <jhe@cs.wisc.edu>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 debugfs/set_fields.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 40dc5e7..6104b2b 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -321,8 +321,11 @@ static struct field_set_info *find_field(struct field_set_info *fields,
 	 */
 	if (idx) {
 		array_idx = strtol(idx, &tmp, 0);
-		if (*tmp)
+		if (*tmp) {
+			*(--idx) = '[';
+			*delim = ']';
 			idx = 0;
+		}
 	}
 
 	/*
-- 
2.1.0


From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 05/53] ext4: Eliminate potential double free on error path
Date: Sun, 30 May 2010 22:49:18 -0400
Message-ID: <1275274206-3900-5-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Julia Lawall <julia@diku.dk>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44555 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0EaCuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:14 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

commit d3533d72e7478a61a3e1936956fc825289a2acf4 upstream (as of v2.6.33-rc3)

b_entry_name and buffer are initially NULL, are initialized within a loop
to the result of calling kmalloc, and are freed at the bottom of this loop.
The loop contains gotos to cleanup, which also frees b_entry_name and
buffer.  Some of these gotos are before the reinitializations of
b_entry_name and buffer.  To maintain the invariant that b_entry_name and
buffer are NULL at the top of the loop, and thus acceptable arguments to
kfree, these variables are now set to NULL after the kfrees.

This seems to be the simplest solution.  A more complicated solution
would be to introduce more labels in the error handling code at the end of
the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier E;
expression E1;
iterator I;
statement S;
@@

*kfree(E);
... when != E = E1
    when != I(E,...) S
    when != &E
*kfree(E);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/xattr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0257019..a95769a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1327,6 +1327,8 @@ retry:
 			goto cleanup;
 		kfree(b_entry_name);
 		kfree(buffer);
+		b_entry_name = NULL;
+		buffer = NULL;
 		brelse(is->iloc.bh);
 		kfree(is);
 		kfree(bs);
-- 
1.6.6.1.1.g974db.dirty


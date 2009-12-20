From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/2] fs/ext4: Eliminate double free
Date: Sun, 20 Dec 2009 18:07:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912201806530.26912@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: tytso@mit.edu, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755452AbZLTRHX@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Julia Lawall <julia@diku.dk>

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

---
 fs/ext4/xattr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 83218be..f3a2f7e 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1332,6 +1332,8 @@ retry:
 			goto cleanup;
 		kfree(b_entry_name);
 		kfree(buffer);
+		b_entry_name = NULL;
+		buffer = NULL;
 		brelse(is->iloc.bh);
 		kfree(is);
 		kfree(bs);

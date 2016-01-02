From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ext4: disable retry logic in ext4_set_encrypted_filename
Date: Sat, 02 Jan 2016 20:50:11 +0100
Message-ID: <3125077.SmBO9VTSER@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:57292 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbcABTuU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jan 2016 14:50:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

gcc correctly warns that the ctx variable in ext4_set_encrypted_filename
has gone out of scope in ext4_set_encrypted_filename if we enter the
retry path and a 'goto' into the previous code block can not guarantee
to get the contents back:

fs/ext4/namei.c: In function 'ext4_set_encrypted_filename':
fs/ext4/namei.c:4035:10: warning: 'ctx' may be used uninitialized in this function [-Wmaybe-uninitialized]
   retval = ext4_xattr_set_handle(handle, inode,

I tried moving the variable declaration to the start of the function,
but that does not shut up the warning, as it's apparently too hard
for the compiler to follow the control flow and determine that it's
correct (or for me reading the code, for that matter).

This adds a hack to avoid the undefined behavior at the cost of
losing the chance to retry on a spurious -ENOSPC error. We probably
need a better solution.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 374431bae296 ("ext4 crypto: add ioctls to allow backup of encryption metadata")
---
The warning appeared with next-20121231, which is the latest next release,
nevermind if it has already been fixed in the meantime.

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c03f310200d6..fd2bd090bdfa 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -4113,7 +4113,7 @@ out:
 	}
 	if (handle)
 		ext4_journal_stop(handle);
-	if (do_retry) {
+	if (do_retry /* FIXME: ctx is invalid */ && 0) {
 		do_retry = 0;
 		goto retry;
 	}


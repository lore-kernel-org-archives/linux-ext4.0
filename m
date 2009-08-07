From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12793] ext4 gives wrong errno with too long extended attribute
 values
Date: Fri, 7 Aug 2009 15:02:18 GMT
Message-ID: <200908071502.n77F2I8X018452@demeter.kernel.org>
References: <bug-12793-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42318 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630AbZHGPCR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 11:02:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n77F2IVf018454
	for <linux-ext4@vger.kernel.org>; Fri, 7 Aug 2009 15:02:18 GMT
In-Reply-To: <bug-12793-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12793


Narendra Prasad Madanapalli <narendramind@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |narendramind@gmail.com




--- Comment #1 from Narendra Prasad Madanapalli <narendramind@gmail.com>  2009-08-07 15:02:16 ---
The following patch fixes the issue.

====Patch starts
iff -uNr linux-2.6.30.3-orig/fs/ext4/xattr.c linux-2.6.30.3-fix/fs/ext4/xattr.c
--- linux-2.6.30.3-orig/fs/ext4/xattr.c    2009-07-25 03:17:51.000000000 +0530
+++ linux-2.6.30.3-fix/fs/ext4/xattr.c    2009-08-07 20:27:40.907412651 +0530
@@ -698,7 +698,7 @@
 #define header(x) ((struct ext4_xattr_header *)(x))

     if (i->value && i->value_len > sb->s_blocksize)
-        return -ENOSPC;
+        return -E2BIG;
     if (s->base) {
         ce = mb_cache_entry_get(ext4_xattr_cache, bs->bh->b_bdev,
                     bs->bh->b_blocknr);
====Patch ends

Ran test_xattr.py on the kernel with above fix, it terminates with OSError 7.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

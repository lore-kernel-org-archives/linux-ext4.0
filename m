From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Fri, 18 Jun 2010 15:30:18 GMT
Message-ID: <201006181530.o5IFUIZh002098@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47448 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab0FRPaT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jun 2010 11:30:19 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5IFUIiK002099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jun 2010 15:30:19 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #12 from Eric Sandeen <sandeen@redhat.com>  2010-06-18 15:30:13 ---
Can those who can reproduce this test this patch from mingming?

When unaligned DIO writes, skip zero out the block if the buffer is marked
unwritten. That means there is an asynconous direct IO (append or fill the
hole)
still pending.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/direct-io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-git/fs/direct-io.c
===================================================================
--- linux-git.orig/fs/direct-io.c    2010-05-07 15:42:22.855033403 -0700
+++ linux-git/fs/direct-io.c    2010-05-07 15:44:17.695007770 -0700
@@ -740,7 +740,8 @@
     struct page *page;

     dio->start_zero_done = 1;
-    if (!dio->blkfactor || !buffer_new(&dio->map_bh))
+    if (!dio->blkfactor || !buffer_new(&dio->map_bh)
+        || buffer_unwritten(&dio->map_bh))
         return;

     dio_blocks_per_fs_block = 1 << dio->blkfactor;

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

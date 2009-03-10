From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12829] kernel complains on ENOSPC
Date: Tue, 10 Mar 2009 09:38:24 -0700 (PDT)
Message-ID: <20090310163824.6C767108042@picon.linux-foundation.org>
References: <bug-12829-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039AbZCJQjG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Mar 2009 12:39:06 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2AGcO49020945
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 09:38:45 -0700
In-Reply-To: <bug-12829-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12829





------- Comment #4 from aneesh.kumar@linux.vnet.ibm.com  2009-03-10 09:38 -------
This patch will not fix the problem. But i guess we need this change

-aneesh

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4415bee..671f215 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4652,11 +4652,11 @@ out1:
        if (ar->len < inquota)
                DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
 out3:
-       if (!ar->len) {
+       if (ar->len < reserv_blks) {
                if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
                        /* release all the reserved blocks if non delalloc */
                        percpu_counter_sub(&sbi->s_dirtyblocks_counter,
-                                               reserv_blks);
+                                               reserv_blks - ar->len);
        }

        trace_mark(ext4_allocate_blocks,


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 06:39:50 GMT
Message-ID: <200910270639.n9R6dosP018078@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35357 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbZJ0Gjq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 02:39:46 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9R6do1l018079
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 06:39:50 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #122 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-10-27 06:39:41 ---
Can you test with the below patch

Commit 487caeef9fc08c0565e082c40a8aaf58dad92bbb fixed a deadlock
between get_block and truncate by dropping the i_data_sem during
truncate. But i guess we should make sure we drop any preallocation
that we did as a part of the block allocation. Otherwise we definitely
can get multiple claimed blocks. But this can happen only if we have
block allocation and truncate happening on the same file simultaneously.

With delayed allocation i guess it is possible that pdflush tries to do
block allocation while application does a truncate


diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10539e3..14539b5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -113,6 +113,7 @@ static int ext4_ext_truncate_extend_restart(handle_t
*handle,
      */
     ext4_ext_invalidate_cache(inode);

+    ext4_discard_preallocations(inode);
     return err;
 }

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14472] EXT4 corruption
Date: Thu, 29 Oct 2009 21:38:48 GMT
Message-ID: <200910292138.n9TLcmqC007601@demeter.kernel.org>
References: <bug-14472-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45086 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZJ2Vio (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:38:44 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TLcmid007602
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 21:38:48 GMT
In-Reply-To: <bug-14472-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14472


Parag Warudkar <parag.warudkar@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |parag.warudkar@gmail.com




--- Comment #2 from Parag Warudkar <parag.warudkar@gmail.com>  2009-10-29 21:38:47 ---
I looked at the fsck pics - I have gone through this a few days ago. 

Aneesh suggested to apply the below patch and after applying it and crashing
the machine couple times I have not observed the corruption. So I have reason
to hope this patch below on top of today's git should improve things. Please
try.

commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Oct 27 15:36:38 2009 +0530

   ext4: discard preallocation during truncate

   We need to make sure when we drop and reacquire the inode's
   i_data_sem we discard the inode preallocation. Otherwise we
   could have blocks marked as free in bitmap but still belonging
   to prealloc space.

   Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5c5bc5d..a1ef1c3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -209,6 +209,12 @@ static int try_to_extend_transaction(handle_t *handle,
struct inode *inode)
       up_write(&EXT4_I(inode)->i_data_sem);
       ret = ext4_journal_restart(handle, blocks_for_truncate(inode));
       down_write(&EXT4_I(inode)->i_data_sem);
+       /*
+        * We have dropped i_data_sem. So somebody else could have done
+        * block allocation. So discard the prealloc space created as a
+        * part of block allocation
+        */
+       ext4_discard_preallocations(inode);

       return ret;
 }

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

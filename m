From: Mingming Cao <cmm@us.ibm.com>
Subject: [EXT4 set 9][PATCH
	3/5]Morecleanups:ext4-remove-extra-is_rdonly-check
Date: Sun, 01 Jul 2007 03:38:44 -0400
Message-ID: <1183275524.4010.139.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46882 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387AbXGAHiq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jul 2007 03:38:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Subject: ext4: remove extra IS_RDONLY() check
From: Dave Hansen <haveblue@us.ibm.com>

ext4_change_inode_journal_flag() is only called from one location:
ext4_ioctl(EXT3_IOC_SETFLAGS).  That ioctl case already has a IS_RDONLY()
call in it so this one is superfluous.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
---

 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/inode.c~ext4-remove-extra-is_rdonly-check fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-remove-extra-is_rdonly-check
+++ a/fs/ext4/inode.c
@@ -3352,7 +3352,7 @@ int ext4_change_inode_journal_flag(struc
 	 */

 	journal = EXT4_JOURNAL(inode);
-	if (is_journal_aborted(journal) || IS_RDONLY(inode))
+	if (is_journal_aborted(journal))
 		return -EROFS;

 	jbd2_journal_lock_updates(journal);

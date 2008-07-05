From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 52/52] ext4: Documention update for new ordered mode and delayed allocation
Date: Sat,  5 Jul 2008 13:36:18 -0400
Message-ID: <1215279378-30504-53-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
 <1215279378-30504-30-git-send-email-tytso@mit.edu>
 <1215279378-30504-31-git-send-email-tytso@mit.edu>
 <1215279378-30504-32-git-send-email-tytso@mit.edu>
 <1215279378-30504-33-git-send-email-tytso@mit.edu>
 <1215279378-30504-34-git-send-email-tytso@mit.edu>
 <1215279378-30504-35-git-send-email-tytso@mit.edu>
 <1215279378-30504-36-git-send-email-tytso@mit.edu>
 <1215279378-30504-37-git-send-email-tytso@mit.edu>
 <1215279378-30504-38-git-send-email-tytso@mit.edu>
 <1215279378-30504-39-git-send-email-tytso@mit.edu>
 <1215279378-30504-40-git-send-email-tytso@mit.edu>
 <1215279378-30504-41-git-send-email-tytso@mit.edu>
 <1215279378-30504-42-git-send-email-tytso@mit.edu>
 <1215279378-30504-43-git-send-email-tytso@mit.edu>
 <1215279378-30504-44-git-send-email-tytso@mit.edu>
 <1215279378-30504-45-git-send-email-tytso@mit.edu>
 <1215279378-30504-46-git-send-email-tytso@mit.edu>
 <1215279378-30504-47-git-send-email-tytso@mit.edu>
 <1215279378-30504-48-git-send-email-tytso@mit.edu>
 <1215279378-30504-49-git-send-email-tytso@mit.edu>
 <1215279378-30504-50-git-send-email-tytso@mit.edu>
 <1215279378-30504-51-git-send-email-tytso@mit.edu>
 <1215279378-30504-52-git-send-email-tytso@mit.edu>
Cc: Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33027 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754322AbYGERg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:29 -0400
In-Reply-To: <1215279378-30504-52-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mingming Cao <cmm@us.ibm.com>

Adding some documentations for delayed allocation and new ordered mode.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 Documentation/filesystems/ext4.txt |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 77ed8fe..e2afb6e 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -62,7 +62,7 @@ Mailing list: linux-ext4@vger.kernel.org
 * extent format reduces metadata overhead (RAM, IO for access, transactions)
 * extent format more robust in face of on-disk corruption due to magics,
 * internal redunancy in tree
-* improved file allocation (multi-block alloc, delayed alloc)
+* improved file allocation (multi-block alloc)
 * fix 32000 subdirectory limit
 * nsec timestamps for mtime, atime, ctime, create time
 * inode version field on disk (NFSv4, Lustre)
@@ -73,6 +73,10 @@ Mailing list: linux-ext4@vger.kernel.org
   flex_bg feature
 * large file support
 * Inode allocation using large virtual block groups via flex_bg
+* delayed allocation
+* large block (up to pagesize) support
+* efficent new ordered mode in JBD2 and ext4(avoid using buffer head to force
+  the ordering)
 
 2.2 Candidate features for future inclusion
 
@@ -235,7 +239,9 @@ stripe=n		Number of filesystem blocks that mballoc will try
 			to use for allocation size and alignment. For RAID5/6
 			systems this should be the number of data
 			disks *  RAID chunk size in file system blocks.
-
+delalloc	(*)	Deferring block allocation until write-out time.
+nodelalloc		Disable delayed allocation. Blocks are allocation
+			when data is copied from user to page cache.
 Data Mode
 =========
 There are 3 different data modes:
@@ -249,10 +255,10 @@ typically provide the best ext4 performance.
 
 * ordered mode
 In data=ordered mode, ext4 only officially journals metadata, but it logically
-groups metadata and data blocks into a single unit called a transaction.  When
-it's time to write the new metadata out to disk, the associated data blocks
-are written first.  In general, this mode performs slightly slower than
-writeback but significantly faster than journal mode.
+groups metadata information related to data changes with the data blocks into a
+single unit called a transaction.  When it's time to write the new metadata
+out to disk, the associated data blocks are written first.  In general,
+this mode performs slightly slower than writeback but significantly faster than journal mode.
 
 * journal mode
 data=journal mode provides full data and metadata journaling.  All new data is
@@ -260,7 +266,8 @@ written to the journal first, and then to its final location.
 In the event of a crash, the journal can be replayed, bringing both data and
 metadata into a consistent state.  This mode is the slowest except when data
 needs to be read from and written to disk at the same time where it
-outperforms all others modes.
+outperforms all others modes.  Curently ext4 does not have delayed
+allocation support if this data journalling mode is selected.
 
 References
 ==========
-- 
1.5.6.rc3.1.g36b7.dirty


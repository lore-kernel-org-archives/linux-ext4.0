From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2] ext4: Drop mapped buffer_head check during page_mkwrite
Date: Wed, 26 Aug 2009 10:53:16 +0530
Message-ID: <1251264196-31382-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40312 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZHZFXT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 01:23:19 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp05.au.ibm.com (8.14.3/8.13.1) with ESMTP id n7Q5Kn43028817
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:20:49 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7Q5NKdG180644
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:23:20 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7Q5NKmW029409
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:23:20 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inorder to check whether the buffer_heads are mapped we need
to hold page lock. Otherwise a reclaim can cleanup the attached
buffer_heads. Instead of taking page lock and check whether
buffer_heads are mapped we let the write_begin/write_end callback
does the equivalent. It does have a performance impact in that we
are doing more work if we the buffer_heads are already mapped.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f9c642b..ad99286 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5245,11 +5245,6 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	return err;
 }
 
-static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
-{
-	return !buffer_mapped(bh);
-}

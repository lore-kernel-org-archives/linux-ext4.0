From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2] Fix sub-block zeroing for buffered writes into unwritten extents.
Date: Tue, 28 Apr 2009 09:43:47 +0530
Message-ID: <1240892027-6481-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57683 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZD1ENz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 00:13:55 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3S4C0Iq014981
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 14:12:00 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3S4DrQG1089784
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 14:13:53 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3S4DqxZ019826
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 14:13:53 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to mark the  buffer_head mapping prealloc space
as new during write_begin. Otherwise we don't zero out the
page cache content properly for a partial write. This will
cause file corruption with preallocation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/inode.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c6bd6ce..8dfa97a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2323,6 +2323,14 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
+		bh_result->b_bdev = inode->i_sb->s_bdev;
+		/*
+		 * With sub-block writes into unwritten extents
+		 * we also need to mark the buffer as new so that
+		 * the unwritten parts of the buffer gets correctly zeroed.
+		 */
+		if (buffer_unwritten(bh_result))
+			set_buffer_new(bh_result);
 		ret = 0;
 	}
 
-- 
tg: (51bec03..) preallocate_corruption (depends on: ext4_lock_group_conversion)

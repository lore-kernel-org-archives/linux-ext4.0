From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: BUG: unable to handle kernel NULL pointer dereference at 00000000
	[ext4_new_meta_blocks+0x7c/0xb7]
Date: Tue, 9 Dec 2008 16:11:22 +0530
Message-ID: <20081209104121.GA7572@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:36456 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYLIKoI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Dec 2008 05:44:08 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id mB9AgfuM005887
	for <linux-ext4@vger.kernel.org>; Tue, 9 Dec 2008 21:42:41 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB9AfaLf268150
	for <linux-ext4@vger.kernel.org>; Tue, 9 Dec 2008 21:41:36 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB9Afavi031519
	for <linux-ext4@vger.kernel.org>; Tue, 9 Dec 2008 21:41:36 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I hit the below Oops with the latest patchqueue.

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c04c0e39>] ext4_new_meta_blocks+0x7c/0xb7
*pdpt = 0000000011945001 *pde = 0000000000000000
....
....
EAX: da5dae60 EBX: e8c233e0 ECX: d4cb2000 EDX: 00000000
ESI: e8c23114 EDI: e8c2302c EBP: d4cb2b70 ESP: d4cb2b28

The problem is due to remove-do_blk_alloc patch.

The patch below should fix the crash. 


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e950898..2dd1162 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -650,7 +650,7 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 	 */
 	if (!(*errp) && EXT4_I(inode)->i_delalloc_reserved_flag) {
 		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-		EXT4_I(inode)->i_allocated_meta_blocks += *count;
+		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 	}
 	return ret;


I have one question regarding the patch. What about blocks allocated for
directories for the  ext3 format.  With extent format we are not
setting EXT4_MB_HINT_DATA for non regular files. So i guess we also
need the below patch .


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1647903..89aa870 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -600,7 +600,9 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 	ar.goal = goal;
 	ar.len = target;
 	ar.logical = iblock;
-	ar.flags = EXT4_MB_HINT_DATA;
+	if (S_ISREG(inode->i_mode))
+		/* enable in-core preallocation only for regular files */
+		ar.flags = EXT4_MB_HINT_DATA;
 
 	current_block = ext4_mb_new_blocks(handle, &ar, err);
 

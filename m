From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 15018] ext4 backtraces out of nowhere
Date: Wed, 20 Jan 2010 22:40:25 +0530
Message-ID: <87iqawn1mm.fsf@linux.vnet.ibm.com>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
	<201001182306.o0IN68F9004917@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45287 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0ATRKb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2010 12:10:31 -0500
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp01.in.ibm.com (8.14.3/8.13.1) with ESMTP id o0KHARn3011360
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2010 22:40:27 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0KHARVs1224850
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2010 22:40:27 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0KHAQtJ029565
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2010 22:40:27 +0530
In-Reply-To: <201001182306.o0IN68F9004917@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 18 Jan 2010 23:06:08 GMT, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=15018
> 
> 
> Jan Kara <jack@suse.cz> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |jack@suse.cz, tytso@mit.edu
> 
> 
> 
> 
> --- Comment #2 from Jan Kara <jack@suse.cz>  2010-01-18 23:06:07 ---
> Ah, inlining and such stuff made reading this stack trace quite difficult.
> Anyway, the problem is that we just should not call write_inode_now() in
> ext4_da_reserve_space() when we have transaction already started. And as
> Andreas correctly points out, the patch even introduces a deadlock because it
> can call write_inode_now with wait==1. Moreover we hold page lock when holding
> write_inode_now which introduces a plenty of nasty locking issues I believe.
> The bug has been introduced by commit 0637c6f4135f592f094207c7c21e7c0fc5557834.
> 
> Ted, I think that if we are failing to do the write because of ENOSPC, the only
> reasonable non-deadlocky thing to do is to restart the write completely - i.e.,
> bail out up to ext4_da_write_begin, stop the transaction, drop the page, *do
> some magic*, and start again...
> 

How about the below. I am yet to test the change

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c818972..5af483a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1835,24 +1835,12 @@ repeat:
 	 * later. Real quota accounting is done at pages writeout
 	 * time.
 	 */
-	if (vfs_dq_reserve_block(inode, md_needed + 1)) {
-		/* 
-		 * We tend to badly over-estimate the amount of
-		 * metadata blocks which are needed, so if we have
-		 * reserved any metadata blocks, try to force out the
-		 * inode and see if we have any better luck.
-		 */
-		if (md_reserved && retries++ <= 3)
-			goto retry;
+	if (vfs_dq_reserve_block(inode, md_needed + 1))
 		return -EDQUOT;
-	}
 
 	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
 		vfs_dq_release_reservation_block(inode, md_needed + 1);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-		retry:
-			if (md_reserved)
-				write_inode_now(inode, (retries == 3));
 			yield();
 			goto repeat;
 		}
@@ -3032,7 +3020,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
 {
-	int ret, retries = 0;
+	int ret, retries = 0, quota_retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
@@ -3091,6 +3079,21 @@ retry:
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
+
+	if ((ret == -EDQUOT) && (quota_retries <= 3)) {
+		/*
+		 * Since we do aggressive quota reservation may get no quota error
+		 * even though we may be having quota. Forcing the inode write will
+		 * free up the extra quota reserved. We do it only if we have
+		 * meta data blocks reserved because we do aggressive reservation only
+		 * for meta data blocks.
+		 */
+		if (EXT4_I(inode)->i_reserved_meta_blocks) {
+			write_inode_now(inode, (quota_retries == 3));
+			quota_retries++;
+			goto retry;
+		}
+	}
 out:
 	return ret;
 }

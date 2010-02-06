From: marcus.husar@rose.uni-heidelberg.de
Subject: [PATCH 2/4][2.6.32-stable] ext4: Handle -EDQUOT error on write
Date: Sat, 06 Feb 2010 17:39:21 +0100
Message-ID: <20100206173921.ni6fmpki5ck8so0c@wwwmail.urz.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.uni-heidelberg.de ([129.206.210.211]:46420 "EHLO
	relay2.uni-heidelberg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab0BFReU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Feb 2010 12:34:20 -0500
Received: from ix.urz.uni-heidelberg.de (cyrus-portal.urz.uni-heidelberg.de [129.206.100.176])
	by relay2.uni-heidelberg.de (8.13.8/8.13.8) with ESMTP id o16GdRHA003163
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:39:27 +0100
Received: from wwwmail.urz.uni-heidelberg.de (wwwmail.urz.uni-heidelberg.de [129.206.100.145])
	by ix.urz.uni-heidelberg.de (8.13.8/8.13.8) with ESMTP id o16GdO2V031498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:39:24 +0100
Received: from wwwmail.urz.uni-heidelberg.de (localhost.localdomain [127.0.0.1])
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1) with ESMTP id o16GdLJv020173
	for <linux-ext4@vger.kernel.org>; Sat, 6 Feb 2010 17:39:21 +0100
Received: (from apache@localhost)
	by wwwmail.urz.uni-heidelberg.de (8.13.1/8.13.1/Submit) id o16GdLqt020170
	for linux-ext4@vger.kernel.org; Sat, 6 Feb 2010 17:39:21 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a backport of 1db913823c0f8360fccbd24ca67eb073966a5ffd that
applies cleanly on top of patch 1 of this patchset.

ext4: Handle -EDQUOT error on write

We need to release the journal before we do a write_inode.  Otherwise
we could deadlock.

Signed-off-by: Marcus Husar <marcus.husar@rose.uni-heidelberg.de>
---
       inode.c |   32 ++++++++++++++++++--------------
       1 file changed, 18 insertions(+), 14 deletions(-)

diff -uprN a/fs/ext4/inode.c b/fs/ext4/inode.c
--- a/fs/ext4/inode.c	2010-02-05 09:55:16.068240000 +0100
+++ b/fs/ext4/inode.c	2010-02-05 10:52:12.148240610 +0100
@@ -1866,24 +1866,12 @@ repeat:
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
@@ -3061,7 +3049,7 @@ static int ext4_da_write_begin(struct fi
       			       loff_t pos, unsigned len, unsigned flags,
       			       struct page **pagep, void **fsdata)
       {
-	int ret, retries = 0;
+	int ret, retries = 0, quota_retries = 0;
       	struct page *page;
       	pgoff_t index;
       	unsigned from, to;
@@ -3120,6 +3108,22 @@ retry:

       	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
       		goto retry;
+
+	if ((ret == -EDQUOT) &&
+		EXT4_I(inode)->i_reserved_meta_blocks &&
+		(quota_retries++ < 3)) {
+		/*
+		 * Since we often over-estimate the number of meta
+		 * data blocks required, we may sometimes get a
+		 * spurios out of quota error even though there would
+		 * be enough space once we write the data blocks and
+		 * find out how many meta data blocks were _really_
+		 * required.  So try forcing the inode write to see if
+		 * that helps.
+		 */
+		write_inode_now(inode, (quota_retries == 3));
+		goto retry;
+	}
       out:
       	return ret;
       }






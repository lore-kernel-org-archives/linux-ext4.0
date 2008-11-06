From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V2 1/3] quota: Add reservation support for delayed
	block allocation
Date: Thu, 06 Nov 2008 15:28:10 -0800
Message-ID: <1226014090.6430.51.camel@mingming-laptop>
References: <1225488442.7600.12.camel@mingming-laptop>
	 <20081104171451.816d92d0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:51732 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYKFX2P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 18:28:15 -0500
In-Reply-To: <20081104171451.816d92d0.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Tue, 2008-11-04 at 17:14 -0800, Andrew Morton wrote:
> On Fri, 31 Oct 2008 14:27:22 -0700
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > +int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
> > +{
> > +	int cnt, ret = QUOTA_OK;
> > +
> > +	/*
> > +	 * First test before acquiring mutex - solves deadlocks when we
> > +         * re-enter the quota code and are already holding the mutex
> > +         */
> > +	if (IS_NOQUOTA(inode)) {
> > +		inode_add_bytes(inode, number);
> > +		return ret;
> > +	}
> > +
> > +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	if (IS_NOQUOTA(inode))	{
> > +		/* Now we can do reliable test... */
> > +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +		inode_add_bytes(inode, number);
> > +		return ret;
> > +	}
> > +
> > +	ret = __dquot_alloc_space(inode, number, warn, 0);
> > +	if (ret == NO_QUOTA) {
> > +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +		return ret;
> > +	}
> > +
> > +	/* Dirtify all the dquots - this can block when journalling */
> > +	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> > +		if (inode->i_dquot[cnt])
> > +			mark_dquot_dirty(inode->i_dquot[cnt]);
> > +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > +	inode_add_bytes(inode, number);
> > +	return ret;
> > +}
> 
> I'm going to have to call "ug" on that code.
> 
> Multiple return points per function really is a maintenance problem. 
> It's a great source of code duplication, locking errors and resource
> leaks as the code evolves.
> 
> Can we please rework this code (and any other similar code here) to use
> the usual `goto out' pattern?
> 
> 

Ok, I was following the same style in the quota code, but I will do
that.
> int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
> {
> 	int cnt, ret = QUOTA_OK;
> 
> 	/*
> 	 * First test before acquiring mutex - solves deadlocks when we
>          * re-enter the quota code and are already holding the mutex
>          */
> 	if (IS_NOQUOTA(inode))
> 		goto out;
> 
> 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> 	if (IS_NOQUOTA(inode))	/* Now we can do reliable test... */
> 		goto out_unlock;
> 
> 	ret = __dquot_alloc_space(inode, number, warn, 0);
> 
> 	if (ret == NO_QUOTA) {
> 		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> 		return ret;
> 	}
> 
> <<
> 
> I don't know what to do here - did we really want to skip the
> inode_add_bytes?  

Yes, this is the failure case. In case the request exceeds the quota
limit, we will quit with error without block allocation, so the inode
bytes update should be skipped.

> If so, we could do
> 
> 	number = 0;
> 	goto out_unlock;
> 
> >>
> 
> 	/* Dirtify all the dquots - this can block when journalling */
> 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> 		if (inode->i_dquot[cnt])
> 			mark_dquot_dirty(inode->i_dquot[cnt]);
> out_unlock:
> 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> out:
> 	inode_add_bytes(inode, number);
> 	return ret;
> }
> 
> or something like that.
> 
> 

Attached is the incremental fixes. I will post the  updated series
later.

Thanks,
---
 fs/dquot.c               |   40 +++++++++++++++++-----------------------
 include/linux/quotaops.h |    2 +-
 2 files changed, 18 insertions(+), 24 deletions(-)

Index: linux-2.6.28-rc2/fs/dquot.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/dquot.c	2008-11-06 12:28:22.000000000 -0800
+++ linux-2.6.28-rc2/fs/dquot.c	2008-11-06 12:49:07.000000000 -0800
@@ -1276,33 +1276,28 @@ int dquot_alloc_space(struct inode *inod
 
 	/*
 	 * First test before acquiring mutex - solves deadlocks when we
-         * re-enter the quota code and are already holding the mutex
-         */
-	if (IS_NOQUOTA(inode)) {
-		inode_add_bytes(inode, number);
-		return ret;
-	}
+	 * re-enter the quota code and are already holding the mutex
+	 */
+	if (IS_NOQUOTA(inode))
+		goto out;
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	if (IS_NOQUOTA(inode))	{
-		/* Now we can do reliable test... */
-		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		inode_add_bytes(inode, number);
-		return ret;
-	}
+	if (IS_NOQUOTA(inode))
+		goto out_unlock;
 
 	ret = __dquot_alloc_space(inode, number, warn, 0);
-	if (ret == NO_QUOTA) {
-		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		return ret;
-	}
+	if (ret == NO_QUOTA)
+		goto out_unlock;
 
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		if (inode->i_dquot[cnt])
 			mark_dquot_dirty(inode->i_dquot[cnt]);
+out_unlock:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	inode_add_bytes(inode, number);
+out:
+	if (ret == QUOTA_OK)
+		inode_add_bytes(inode, number);
 	return ret;
 }
 
@@ -1311,17 +1306,16 @@ int dquot_reserve_space(struct inode *in
 	int ret = QUOTA_OK;
 
 	if (IS_NOQUOTA(inode))
-		return ret;
+		goto out;
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	if (IS_NOQUOTA(inode))	{
-		/* Now we can do reliable test... */
-		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		return ret;
-	}
+	if (IS_NOQUOTA(inode))
+		goto out_unlock;
 
 	ret = __dquot_alloc_space(inode, number, warn, 1);
+out_unlock:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+out:
 	return ret;
 }
 
Index: linux-2.6.28-rc2/include/linux/quotaops.h
===================================================================
--- linux-2.6.28-rc2.orig/include/linux/quotaops.h	2008-11-06 12:28:22.000000000 -0800
+++ linux-2.6.28-rc2/include/linux/quotaops.h	2008-11-06 12:48:24.000000000 -0800
@@ -383,7 +383,7 @@ static inline int vfs_dq_alloc_block(str
 static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
 {
 	return vfs_dq_reserve_space(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+			nr << inode->i_blkbits);
 }
 
 static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)






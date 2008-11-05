From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 1/3] quota: Add reservation support for delayed block
 allocation
Date: Tue, 4 Nov 2008 17:14:51 -0800
Message-ID: <20081104171451.816d92d0.akpm@linux-foundation.org>
References: <1225488442.7600.12.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbYKEBPW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 20:15:22 -0500
In-Reply-To: <1225488442.7600.12.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 31 Oct 2008 14:27:22 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> +int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
> +{
> +	int cnt, ret = QUOTA_OK;
> +
> +	/*
> +	 * First test before acquiring mutex - solves deadlocks when we
> +         * re-enter the quota code and are already holding the mutex
> +         */
> +	if (IS_NOQUOTA(inode)) {
> +		inode_add_bytes(inode, number);
> +		return ret;
> +	}
> +
> +	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	if (IS_NOQUOTA(inode))	{
> +		/* Now we can do reliable test... */
> +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +		inode_add_bytes(inode, number);
> +		return ret;
> +	}
> +
> +	ret = __dquot_alloc_space(inode, number, warn, 0);
> +	if (ret == NO_QUOTA) {
> +		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +		return ret;
> +	}
> +
> +	/* Dirtify all the dquots - this can block when journalling */
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> +		if (inode->i_dquot[cnt])
> +			mark_dquot_dirty(inode->i_dquot[cnt]);
> +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> +	inode_add_bytes(inode, number);
> +	return ret;
> +}

I'm going to have to call "ug" on that code.

Multiple return points per function really is a maintenance problem. 
It's a great source of code duplication, locking errors and resource
leaks as the code evolves.

Can we please rework this code (and any other similar code here) to use
the usual `goto out' pattern?


int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
{
	int cnt, ret = QUOTA_OK;

	/*
	 * First test before acquiring mutex - solves deadlocks when we
         * re-enter the quota code and are already holding the mutex
         */
	if (IS_NOQUOTA(inode))
		goto out;

	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
	if (IS_NOQUOTA(inode))	/* Now we can do reliable test... */
		goto out_unlock;

	ret = __dquot_alloc_space(inode, number, warn, 0);

	if (ret == NO_QUOTA) {
		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
		return ret;
	}

<<

I don't know what to do here - did we really want to skip the
inode_add_bytes?  If so, we could do

	number = 0;
	goto out_unlock;

>>

	/* Dirtify all the dquots - this can block when journalling */
	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
		if (inode->i_dquot[cnt])
			mark_dquot_dirty(inode->i_dquot[cnt]);
out_unlock:
	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
out:
	inode_add_bytes(inode, number);
	return ret;
}

or something like that.



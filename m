From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCHv2 1/1] jbd2: Fix I/O hang in
 jbd2_journal_release_jbd_inode
Date: Fri, 27 Aug 2010 15:10:25 -0400
Message-ID: <20100827191025.GV4453@thunk.org>
References: <201007141456.o6EEuFe9004519@d01av03.pok.ibm.com>
 <20100714174458.GA2378@localhost.localdomain>
 <4C3E08E6.2050203@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	cmm@linux.vnet.ibm.com, pmac@au1.ibm.com
To: Brian King <brking@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33583 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab0H0TK2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Aug 2010 15:10:28 -0400
Content-Disposition: inline
In-Reply-To: <4C3E08E6.2050203@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 14, 2010 at 01:58:46PM -0500, Brian King wrote:
> 
> I've been debugging a hang in jbd2_journal_release_jbd_inode
> which is being seen on Power 6 systems quite a lot. When we get
> in the hung state, all I/O to the disk in question gets blocked
> where we stay indefinitely. Looking at the task list, I can see
> we are stuck in jbd2_journal_release_jbd_inode waiting on a
> wake up. I added some debug code to detect this scenario and
> dump additional data if we were stuck in jbd2_journal_release_jbd_inode
> for longer than 30 minutes. When it hit, I was able to see that
> i_flags was 0, suggesting we missed the wake up.
> 
> This patch changes i_flags to be an unsigned long, uses bit operators
> to access it, and adds barriers around the accesses. Prior to applying
> this patch, we were regularly hitting this hang on numerous systems
> in our test environment. After applying the patch, the hangs no longer
> occur. Its still not clear to me why the j_list_lock doesn't protect us
> in this path. It also appears a hang very similar to this was seen
> in the past and then was no longer recreatable:

I've been look at this patch, and I can see how converting to bitops
definitely makes sense.  I can also see how adding
smp_mb__after_clear_bit() makes sense.  However, it's not clear the
smp_mb() call here helps?

> diff -puN fs/jbd2/journal.c~jbd2_ji_commit_barrier_patch fs/jbd2/journal.c
> --- linux-2.6/fs/jbd2/journal.c~jbd2_ji_commit_barrier_patch	2010-07-14 13:46:17.000000000 -0500
> +++ linux-2.6-bjking1/fs/jbd2/journal.c	2010-07-14 13:46:17.000000000 -0500
> @@ -2209,9 +2211,10 @@ void jbd2_journal_release_jbd_inode(jour
>  restart:
>  	spin_lock(&journal->j_list_lock);
>  	/* Is commit writing out inode - we have to wait */
> -	if (jinode->i_flags & JI_COMMIT_RUNNING) {
> +	if (test_bit(__JI_COMMIT_RUNNING, &jinode->i_flags)) {
>  		wait_queue_head_t *wq;
>  		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
> +		smp_mb();
>  		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
>  		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
>  		spin_unlock(&journal->j_list_lock);

						- Ted

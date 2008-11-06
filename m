From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext3: kernel BUG at fs/jbd/journal.c:412!
Date: Thu, 6 Nov 2008 22:46:39 +0530
Message-ID: <20081106171639.GH25194@skywalker>
References: <20081106155025.GE25194@skywalker> <20081106161227.GA9254@ajones-laptop.nbttech.com> <20081106171322.GD18939@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arthur Jones <ajones@riverbed.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:54505 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYKFRY3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 12:24:29 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id mA6HMs3K5963946
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 04:22:54 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6HGqMi138248
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 04:16:52 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA6HGqYS023850
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 04:16:52 +1100
Content-Disposition: inline
In-Reply-To: <20081106171322.GD18939@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 06, 2008 at 12:13:22PM -0500, Theodore Tso wrote:
> On Thu, Nov 06, 2008 at 08:12:27AM -0800, Arthur Jones wrote:
> > Hi Aneesh, ...
> > 
> > On Thu, Nov 06, 2008 at 07:50:25AM -0800, Aneesh Kumar K.V wrote:
> > > I get this with ext4-patchqueue. I guess we have some ext3 patches queued there.
> > 
> > This could be related to a patch I just posted.
> > 
> > See the thread on linux-ext4 called "ext3: slow symlink corruption
> > on umount" for details on how this patch came about...
> 
> No this is the other ext3 patch we have in the patch tree.  I see the
> problem, we're calling __log_space_left in a diagnostic printk after
> we've released the j_state_lock.  Here's the incremental fix:
> 
> diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
> index 5e856de..18e5137 100644
> --- a/fs/jbd/checkpoint.c
> +++ b/fs/jbd/checkpoint.c
> @@ -115,7 +115,7 @@ static int __try_to_free_cp_buf(struct journal_head *jh)
>   */
>  void __log_wait_for_space(journal_t *journal)
>  {
> -	int nblocks;
> +	int nblocks, space_left;
>  	assert_spin_locked(&journal->j_state_lock);
> 
>  	nblocks = jbd_space_needed(journal);
> @@ -139,7 +139,8 @@ void __log_wait_for_space(journal_t *journal)
>  		spin_lock(&journal->j_state_lock);
>  		spin_lock(&journal->j_list_lock);
>  		nblocks = jbd_space_needed(journal);
> -		if (__log_space_left(journal) < nblocks) {
> +		space_left = __log_space_left(journal);
> +		if (space_left < nblocks) {
>  			int chkpt = journal->j_checkpoint_transactions != NULL;
>  			int tid = 0;
> 
> @@ -157,8 +158,7 @@ void __log_wait_for_space(journal_t *journal)
>  			} else {
>  				printk(KERN_ERR "%s: needed %d blocks and "
>  				       "only had %d space available\n",
> -				       __func__, nblocks,
> -				       __log_space_left(journal));
> +				       __func__, nblocks, space_left);
>  				printk(KERN_ERR "%s: no way to get more "
>  				       "journal space\n", __func__);
>  				WARN_ON(1);
> 
> 

you would need the same patch for jbd2

-aneesh

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Mon, 6 Jul 2009 21:00:16 +0530
Message-ID: <20090706153015.GB24136@skywalker>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com> <20090617234604.GF7867@mit.edu> <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com> <20090701183130.GA31235@skywalker> <20090706034144.GB31532@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:59064 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZGFPaU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jul 2009 11:30:20 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id n66FUKq9000745
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jul 2009 21:00:20 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n66FUKnW2203748
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jul 2009 21:00:20 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id n66FUJgU020156
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jul 2009 21:00:20 +0530
Content-Disposition: inline
In-Reply-To: <20090706034144.GB31532@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 05, 2009 at 11:41:44PM -0400, Theodore Tso wrote:
> On Thu, Jul 02, 2009 at 12:01:30AM +0530, Aneesh Kumar K.V wrote:
> > 
> > I looked at the patch in detail and  I guess we should instead force
> > a data=writeback mode if the filesystem is created without a journal.
> > I am not sure what whould be the meaning of data=ordered/data=journal
> > without a journal. So if we find that file system doesn't have a journal
> > then either we should update the default mount option in the filesystem
> > to be of data=writeback. 
> 
> Here's a patch which takes your approach to solving the problem.  What
> do you think? 
> 
> I haven't messed with dealing with the data= mount options in
> fs/ext4/super.c.  That's important from a UI point of view, but we
> needed to fix ext4_jbd2.h since it was unconditionally returning 0 if
> there was no journal for all of the ext4_should_*_data() functions.
> 
> I believe this should DTRT with the -o nobh mount option, but I'd
> appreciate another pair of eyes taking a look at this.
> 
> 	   	   	   	       	 - Ted
> 
> commit 2a73eff8ba80095a871a6b402dfd24bc454e5bdc
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun Jul 5 23:37:13 2009 -0400
> 
>     ext4: fix no journal corruption with locale-gen
>     
>     If there is no journal, ext4_should_writeback_data() should return
>     TRUE.  This will fix ext4_set_aops() to set ext4_da_ops in the case of
>     delayed allocation; otherwise ext4_journaled_aops gets used by
>     default, which doesn't handle delayed allocation properly.
>     
>     The advantage of using ext4_should_writeback_data() approach is that
>     it should handle nobh better as well.
>     
>     Thanks to Curt Wohlgemuth for investigating this problem, and Aneesh
>     Kumar for suggesting this approach.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index be2f426..f800134 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -282,7 +282,7 @@ static inline int ext4_should_order_data(struct inode *inode)
>  static inline int ext4_should_writeback_data(struct inode *inode)
>  {
>  	if (EXT4_JOURNAL(inode) == NULL)
> -		return 0;
> +		return 1;
>  	if (!S_ISREG(inode->i_mode))
>  		return 0;
>  	if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)

We may want to change it after	if (!S_ISREG(inode->i_mode))
So that we don't return 1 for other than regular files.

-aneesh

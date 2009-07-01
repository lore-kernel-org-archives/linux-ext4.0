From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Thu, 2 Jul 2009 00:01:30 +0530
Message-ID: <20090701183130.GA31235@skywalker>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com> <20090617234604.GF7867@mit.edu> <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56942 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZGASbi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2009 14:31:38 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id n61IUhY4025106
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 04:30:43 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n61IVcp5446604
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 04:31:38 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n61IVc0S028021
	for <linux-ext4@vger.kernel.org>; Thu, 2 Jul 2009 04:31:38 +1000
Content-Disposition: inline
In-Reply-To: <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 22, 2009 at 09:42:25AM -0700, Curt Wohlgemuth wrote:
> Hi Ted:
> 
> I think the following patch is sufficient.  It explicitly sets the aops to
> ext4_writeback_aops if there is no delayed allocation and no journal.
> 
> I tested the locale-gen example with all combinations of
> 
>    data=writeback
>    data=ordered
>    data=journal
>    <no journal at all>
> 
> and
> 
>    delalloc
>    nodelalloc
> 
> and it works correctly now.  The paths for writeback seem fine to me for an
> inode w/o a journal.
> 
> 
>        Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
> --- 2.6.26/fs/ext4/inode.c.orig	2009-06-09 20:05:27.000000000 -0700
> +++ 2.6.26/fs/ext4/inode.c	2009-06-22 08:55:13.000000000 -0700
> @@ -3442,15 +3442,12 @@ static const struct address_space_operat
> 
>  void ext4_set_aops(struct inode *inode)
>  {
> -	if (ext4_should_order_data(inode) &&
> -		test_opt(inode->i_sb, DELALLOC))
> +	if (test_opt(inode->i_sb, DELALLOC))
>  		inode->i_mapping->a_ops = &ext4_da_aops;
>  	else if (ext4_should_order_data(inode))
>  		inode->i_mapping->a_ops = &ext4_ordered_aops;
> -	else if (ext4_should_writeback_data(inode) &&
> -		 test_opt(inode->i_sb, DELALLOC))
> -		inode->i_mapping->a_ops = &ext4_da_aops;
> -	else if (ext4_should_writeback_data(inode))
> +	else if (ext4_should_writeback_data(inode) ||
> +	                         EXT4_JOURNAL(inode) == NULL)
>  		inode->i_mapping->a_ops = &ext4_writeback_aops;
>  	else
>  		inode->i_mapping->a_ops = &ext4_journalled_aops;
> 
> 

I looked at the patch in detail and  I guess we should instead force
a data=writeback mode if the filesystem is created without a journal.
I am not sure what whould be the meaning of data=ordered/data=journal
without a journal. So if we find that file system doesn't have a journal
then either we should update the default mount option in the filesystem
to be of data=writeback. Also if the user tried to mount with
data=ordered or data=journal we should print appropriate message and
force ourself to data=writeback.

Once we have data=writeback set then ext4_set_aops will handle the  case
properly.

-aneesh

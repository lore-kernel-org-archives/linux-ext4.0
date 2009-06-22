From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Mon, 22 Jun 2009 22:26:26 +0530
Message-ID: <20090622165626.GB26149@skywalker>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com> <20090617234604.GF7867@mit.edu> <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41277 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbZFVQ4m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2009 12:56:42 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5MGuZVD003311
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 02:56:35 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5MGuhUh790608
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 02:56:43 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5MGug23012815
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 02:56:43 +1000
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

This change is not related to the fix right ?

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

Can you send a patch with this hunk alone. The previous one is not
related to the fix right ?


>  	else
>  		inode->i_mapping->a_ops = &ext4_journalled_aops;
> 
> 

-aneesh

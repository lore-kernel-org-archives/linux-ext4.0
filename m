From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: More buffer head reference leaks
Date: Wed, 15 Jul 2009 11:22:27 +0530
Message-ID: <20090715055227.GA17310@skywalker>
References: <6601abe90907141358w3b16cdb0rb429f8d67d65dc9a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:50078 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbZGOFw7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 01:52:59 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id n6F5odxA006310
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 15:50:39 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6F5qwL41188018
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 15:52:58 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6F5qvul030481
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 15:52:58 +1000
Content-Disposition: inline
In-Reply-To: <6601abe90907141358w3b16cdb0rb429f8d67d65dc9a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 14, 2009 at 01:58:29PM -0700, Curt Wohlgemuth wrote:
> After the patch I posted last week regarding buffer head ref leaks in
> no-journal mode, I looked at all the code that uses buffer heads and
> searched for more potential leaks.
> 
> The patch below fixes the issues I found; these can occur even when a
> journal is present.
> 
> The change to inode.c fixes a double release if
> ext4_journal_get_create_access() fails.
> 
> The changes to namei.c are more complicated.  add_dirent_to_buf() will
> release the input buffer head EXCEPT when it returns -ENOSPC.  There are
> some callers of this routine that don't always do the brelse() in the event
> that -ENOSPC is returned.  Unfortunately, to put this fix into ext4_add_entry()
> required capturing the return value of make_indexed_dir() and
> add_dirent_to_buf().
> 
> I'd appreciate comments on these changes, in particular if I'm just missing
> something obvious here.
> 
>        Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> 
> ---
> diff -Naur orig/fs/ext4/inode.c new/fs/ext4/inode.c
> --- orig/fs/ext4/inode.c	2009-07-14 11:19:01.000000000 -0700
> +++ new/fs/ext4/inode.c	2009-07-14 11:51:42.000000000 -0700
> @@ -758,8 +758,9 @@
>  		BUFFER_TRACE(bh, "call get_create_access");
>  		err = ext4_journal_get_create_access(handle, bh);
>  		if (err) {
> +			/* Don't brelse(bh) here; it's done in journal_forget()
> +			 * below */
>  			unlock_buffer(bh);
> -			brelse(bh);
>  			goto failed;
>  		}
> 

I am not able to find the journal_foget call in the path. brelse is
dropping the buffer_head reference got from sb_getblk right ? Can you
tell me what is that i am missing ?


> diff -Naur orig/fs/ext4/namei.c new/fs/ext4/namei.c
> --- orig/fs/ext4/namei.c	2009-07-14 11:19:46.000000000 -0700
> +++ new/fs/ext4/namei.c	2009-07-14 11:19:28.000000000 -0700
> @@ -1498,12 +1498,14 @@

.. snip..

-aneesh

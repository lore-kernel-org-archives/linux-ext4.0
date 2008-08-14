From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Thu, 14 Aug 2008 23:22:52 +0530
Message-ID: <20080814175252.GA6397@skywalker>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <1218672653.6456.14.camel@mingming-laptop> <20080814015113.GA8078@mit.edu> <200808140859.03171.mail@eworm.de> <1218725903.6749.3.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Hesse <mail@eworm.de>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:56285 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361AbYHNR4s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 13:56:48 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7EHv5bx011363
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 03:57:05 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7EHqx7N206374
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 03:52:59 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7EHqwDJ001141
	for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2008 03:52:59 +1000
Content-Disposition: inline
In-Reply-To: <1218725903.6749.3.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 14, 2008 at 07:58:23AM -0700, Mingming Cao wrote:
> 
> 
> Index: linux-2.6.27-rc3/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.27-rc3.orig/fs/ext4/inode.c	2008-08-14 07:49:14.000000000 -0700
> +++ linux-2.6.27-rc3/fs/ext4/inode.c	2008-08-14 07:49:45.000000000 -0700
> @@ -1576,7 +1576,7 @@ static void ext4_da_release_space(struct
>  		 */
>  		printk(KERN_INFO "ext4 delalloc try to release %d reserved"
>  			    "blocks for inode %lu, but there is no reserved"
> -			    "data blocks\n", inode->i_ino, to_free);
> +			    "data blocks\n", to_free, inode->i_ino);
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		return;
>  	}


I guess you would need a space at the end of each lines.

		printk(KERN_INFO "ext4 delalloc try to release %d reserved "
			    "blocks for inode %lu, but there is no reserved "
			    "data blocks\n", to_free, inode->i_ino);
-aneesh

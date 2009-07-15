From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: More buffer head reference leaks
Date: Wed, 15 Jul 2009 11:53:36 +0530
Message-ID: <20090715062335.GA19313@skywalker>
References: <6601abe90907141358w3b16cdb0rb429f8d67d65dc9a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43414 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZGOGXq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 02:23:46 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n6F6LDc6020377
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 16:21:13 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6F6Njot1327224
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 16:23:45 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6F6Ni1X024574
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 16:23:44 +1000
Content-Disposition: inline
In-Reply-To: <6601abe90907141358w3b16cdb0rb429f8d67d65dc9a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> diff -Naur orig/fs/ext4/namei.c new/fs/ext4/namei.c
> --- orig/fs/ext4/namei.c	2009-07-14 11:19:46.000000000 -0700
> +++ new/fs/ext4/namei.c	2009-07-14 11:19:28.000000000 -0700
> @@ -1498,12 +1498,14 @@
> 
>  	sb = dir->i_sb;
>  	blocksize = sb->s_blocksize;
> -	if (!dentry->d_name.len)
> -		return -EINVAL;
> +	if (!dentry->d_name.len) {
> +		retval = -EINVAL;
> +		goto out;
> +	}
>

Do we really need those goto changes. We just return even at the label "out".
Seperating that out of the patch makes review easier

-aneesh

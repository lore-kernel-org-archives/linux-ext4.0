From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problems with mballoc and uninit_groups option
Date: Fri, 11 Jan 2008 21:15:52 +0530
Message-ID: <20080111154552.GA7339@skywalker>
References: <47877758.1070603@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:50470 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620AbYAKPqE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jan 2008 10:46:04 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m0BFjlJ0001695
	for <linux-ext4@vger.kernel.org>; Sat, 12 Jan 2008 02:45:47 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0BFncWM284166
	for <linux-ext4@vger.kernel.org>; Sat, 12 Jan 2008 02:49:38 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0BFk1jd012688
	for <linux-ext4@vger.kernel.org>; Sat, 12 Jan 2008 02:46:01 +1100
Content-Disposition: inline
In-Reply-To: <47877758.1070603@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2008 at 03:04:08PM +0100, Valerie Clement wrote:
> Hi,
>
> I've got problems with mballoc when I create the ext4 filesystem with  
> the "uninit_groups" option enabled.
>
> First, I do a single test on a filesystem created without the  
> "uninit_groups" option and mounted with the defaults option:
>   dd if=/dev/zero of=/mnt/test/foo bs=1M count=1024
>
> In this case, the file blocks are allocated in the groups 4, 5, 6, 7, 8,  
> 9, 10.
>
> When the filesystem is created with the "uninit_groups" option enabled  
> and mounted with the defaults option, I do the same dd command.
>
> In this case, the file blocks are allocated in the groups 5, 7, 9, 25,  
> 27, 49, 81. It seems that the blocks could be allocated only in the  
> already initialized groups.
>

That is because we skip the uninitialized group in ext4_mb_good_group.
I guess we are trying criteria 0 allocation and we skip uninit group for
criteria 0 . You can tune by setting higher value for
/proc/fs/ext4/partition/orders2_req. Setting it to a high value would
skip criteria 0 allocation for small requests.

I guess you are using delayed allocation ?

-aneesh

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Bad performance results with the latest git patches
Date: Mon, 10 Sep 2007 15:44:20 +0530
Message-ID: <46E518FC.2010405@linux.vnet.ibm.com>
References: <46E1430F.3050702@bull.net> <20070907213716.GH5377@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:53371 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028AbXIJKOv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Sep 2007 06:14:51 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8AAETxa007926
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 20:14:29 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8AAEU274382784
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 20:14:30 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8AAETnt006875
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2007 20:14:30 +1000
In-Reply-To: <20070907213716.GH5377@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Sep 07, 2007  14:24 +0200, Valerie Clement wrote:
>> running ffsb tests (large files creation) on my system with the latest 
>> ext4 git patches against a 2.6.23-rc4 kernel, I've got very bad 
>> performance results: the I/O throughput measured on an ext4 filesystem 
>> is ten times lower than those measured on an XFS filesystem on the same 
>> machine.
>> I have mounted the ext4 filesytem with mballoc, delalloc and 
>> data=writeback options.
>>
>> dmesg output shows plenty of error messages like this:
>>
>> EXT4-fs error (device sdc): ext4_ext_search_right: bad header in inode 
>> #3745797: unexpected eh_depth - magic f30a, entries 81, max 84(0), depth 
>> 0(1)
> 
> It is the message that likely slows down the filesystem.
> 
>> If I removed the second call to ext4_ext_check_header() in the 
>> ext4_ext_search_right() function, the problem disappears, no more error 
>> messages and better throughput values close to those measured on the XFS 
>> filesystem.
>> It seems that the depth value passed in argument is buggy.
>>
>> In a previous line,
>>   while (++depth < path->p_depth) {
>>
>> the depth value is incremented even if we don't enter the loop. Is it 
>> the problem ?
> 
> No, because the "depth" value is not used after the loop is done.  The
> problem is really that the depth decreases down the tree instead of
> increasing.  This is not immediately seen during testing because mballoc
> does a good job of merging extents and files have to be very fragmented
> (heavy multi-threaded IO) and/or very large (>512MB) before the index
> grows outside the inode (depth > 0).
> 
> The problem was in the recently-added "extent sanity checks", and has
> also been fixed:
> 
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Alex Tomas <alex@clusterfs.com>
> Signed-off-by: Johann Lombardi <johann@clusterfs.com>
> 
> diff -u linux-2.6.18.8/fs/ext3/extents.c linux-2.6.18.8/fs/ext3/extents.c
> --- linux-2.6.18.8/fs/ext3/extents.c	2007-06-20 18:54:00.000000000 +0200
> +++ linux-2.6.18.8/fs/ext3/extents.c	2007-06-20 18:54:00.000000000 +0200
> @@ -1069,7 +1069,7 @@ ext3_ext_search_right(struct inode *inode,
>  		if (bh == NULL)
>  			return -EIO;
>  		eh = ext_block_hdr(bh);
> -		if (ext3_ext_check_header(inode, eh, depth)) {
> +		if (ext3_ext_check_header(inode, eh, path->p_depth - depth)) {
>  			brelse(bh);
>  			return -EIO;
>  		}
> 


s/ext3/ext4 :)

I will merge it with new-extent-function.patch. Will also add the above signed-off-by:

-aneesh

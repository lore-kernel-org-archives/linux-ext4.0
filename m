From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: uninit block group/mballoc and fsstress
Date: Thu, 11 Oct 2007 12:26:40 +0530
Message-ID: <470DC928.7000609@linux.vnet.ibm.com>
References: <470CFFE3.7080101@linux.vnet.ibm.com> <20071011044641.GD8122@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39560 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbXJKG47 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 02:56:59 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9B6uemf028681
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 16:56:40 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9B6ug9b4120668
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 16:56:42 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9B6ug3x028433
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 16:56:42 +1000
In-Reply-To: <20071011044641.GD8122@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Oct 10, 2007  22:07 +0530, Aneesh Kumar K.V wrote:
>> I am hitting this with  the below config
>>
>> mke2fs -j -I 256 -O lazy_bg $dev
> 
> Note that "-O lazy_bg" has nothing really to do with the uninit_groups
> feature.  Also, if you don't have the CFS e2fsprogs patches for
> uninit_groups then mke2fs creates an invalid filesystem if the journal is
> large (this was an unrelated bug we fixed while testing uninit_groups).
> Try running e2fsck right after the above mke2fs and you will likely
> see errors.
> 

e2fsprogs found at  

ftp://ftp.clusterfs.com/pub/lustre/other/e2fsprogs

sets unint with -O lazy_bg. Is there any other option that i can use to set
the uninit block group feature ?


>> jbd2_journal_bmap: journal block not found at offset 31780 on sda7
> 
> The problem is that lazy_bg allocates the journal blocks incorrectly, IIRC.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> 

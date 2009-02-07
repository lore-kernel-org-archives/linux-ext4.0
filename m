From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] introduce range check for extent pblock references
Date: Sun, 8 Feb 2009 01:29:44 +0530
Message-ID: <20090207195944.GB25942@skywalker>
References: <498DAA9A.8030309@ph.tum.de> <20090207173239.GA25942@skywalker> <498DD7B5.2040308@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45212 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZBGT74 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Feb 2009 14:59:56 -0500
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n17JwjSI001596
	for <linux-ext4@vger.kernel.org>; Sun, 8 Feb 2009 06:58:45 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n17K0BgL1003706
	for <linux-ext4@vger.kernel.org>; Sun, 8 Feb 2009 07:00:11 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n17JxrIx029724
	for <linux-ext4@vger.kernel.org>; Sun, 8 Feb 2009 06:59:53 +1100
Content-Disposition: inline
In-Reply-To: <498DD7B5.2040308@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 07, 2009 at 07:49:25PM +0100, Thiemo Nagel wrote:
> Aneesh Kumar K.V wrote:
>> On Sat, Feb 07, 2009 at 04:36:58PM +0100, Thiemo Nagel wrote:
>>> This time I have aimed to catch all cases in which an invalid 
>>> physical  block might be used and implemented checks directly in 
>>> ext_pblock() and  idx_pblock() following the assumption that most of 
>>> the times one of  these functions is called a device access to that 
>>> address will follow.  If you think this is too heavy, I could also 
>>> split the check from the  pblock calculation, but in that case I 
>>> could only guess at which of the  several accesses to *_pblock() in 
>>> extents.c a check would be necessary  and where it wouldn't and there 
>>> would be the possibility of missing  something.
>>
>>
>> Do we want to check for validity every time we look at the physical
>> block of the extent. I guess that would be bad performance wise. I guess
>> we should check only once when we read the extent from the disk. ??
>
> Then we need to be careful not to miss a case.  We would need to check  
> every time we either a) read from the physical block ourselves or b)  
> return the physical block number to a caller outside of ext4.  On the  
> other hand I wonder if there are cases where one looks at the physical  
> block number which are not a) or b) and which would not benefit from the  
> added sanity check?
>
> For repeated accesses to the same physical block number I cannot think  
> of a way to bookkeep whether the check already has been done, except if  
> that is implicit in the code flow and I don't know how frequent that  
> case is.  If you think the performance gain is worth the risk of missing  
> a case (either now or during some future change), I can try to rewrite  
> the patch to implement the check on a case-by-case basis.
>

How about the following two patches. The patches have only gone through
simple tests.

-aneesh

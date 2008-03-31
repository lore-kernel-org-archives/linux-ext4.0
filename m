From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: mballoc errors
Date: Tue, 1 Apr 2008 01:48:19 +0530
Message-ID: <20080331201819.GA30646@skywalker>
References: <47EAC302.5040109@redhat.com> <47ECFAC7.3050404@bull.net> <20080331065802.GA19456@skywalker> <47F0FBFE.7060404@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:54476 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbYCaUSa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Mar 2008 16:18:30 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2VKHjE1002659
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 07:17:45 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2VKMH9S265626
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 07:22:17 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2VKIRJq010017
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 06:18:27 +1000
Content-Disposition: inline
In-Reply-To: <47F0FBFE.7060404@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 31, 2008 at 04:58:06PM +0200, Valerie Clement wrote:
> Aneesh Kumar K.V wrote:
>> I looked at the code. Nothing appears straight. I am now running tests.
>> meanwhile you can dump the block ee_pblock in the ext4_ext_zeroout
>> and see if we are zeroing some wrong blocks that would be great.
>>
> I didn't see anything incorrect here for the moment, but adding traces
> in the code often changes the behavior so that I can't reproduce the problem
> running the same test.
>
>>
>>> How I reproduce the problem:
>>> # mkfs.ext3 -I256 -E test_fs -b 1024 /dev/sdc1
>>> # mount -t ext4dev /dev/sdc1 /mnt/test
>>> # fsstress -d /mnt/test -n1000 -p1000
>>>
>>
>> Does the fsstress you are using have fallocate support ?. If so can you 
>> send me the patch so that i can run the same test. 
> No, the fsstress I'm using doesn't support fallocate.

That means it is not due to ext4_ext_zeroout. Which implies we have a
generic file system corruption.

>
>> Also can you disable delalloc and try.
> OK, done. The tests are still running.
>
>> ENOSPC handling with delalloc is not yet done
> I often got the problem when the disk is filled to 10% of its capacity.
>
>

I actually added fallocate to fsstress and created the file filesystem
as you suggested. I am able to reproduce the problem once. Currently
doing a code audit. Will let you know if i make any progress.


-aneesh
>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Ext4 devel interlock meeting minutes (October 1, 2007)
Date: Tue, 02 Oct 2007 17:06:48 +0530
Message-ID: <47022D50.2040908@linux.vnet.ibm.com>
References: <47017053.9060005@linux.vnet.ibm.com> <47020E59.1070609@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:38397 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXJBLhS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2007 07:37:18 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l92BbFXZ020823
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 21:37:15 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l92BbF6e3465406
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 21:37:15 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l92BaxUW009694
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 21:37:00 +1000
In-Reply-To: <47020E59.1070609@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Valerie Clement wrote:
> Avantika Mathur wrote:
>> Multiple Block Allocation:
>> - Main outstanding issue is still need for better documentation of the 
>> code.
>> - Aneesh has marked the places that need explanation with fixme, and 
>> Alex will be adding the needed comments.  If this gets done quickly, 
>> we can try to push this feature to 2.6.24
>> - Aneesh has asked for recommendations for a benchmark to run which 
>> will test the mballoc allocator.  Mingming suggested using dd and 
>> dbench, as was done in the past for basic mballoc patches.  To test 
>> the in-core preallocation, kernel untar tests.  Look at the file 
>> fragmentation after running the test.
> 
> Currently, the mballoc feature is not compatible with the uninit_groups 
> feature. I have just tried a simple test which failed. Isn't this a 
> problem?
> 
> Another point that is not clear for me, is mballoc compatible with 
> delalloc now, or is there still a restriction?
> 

I thought i had merged the patch from Andreas.

http://marc.info/?l=linux-ext4&m=118833298930860&w=2

But i don't see it in  mballoc-core.patch

Will update the mballoc patch 

-aneesh

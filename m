From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: patch queue updated
Date: Wed, 10 Oct 2007 21:45:48 +0530
Message-ID: <470CFAB4.8080408@linux.vnet.ibm.com>
References: <470CBFFF.3080308@linux.vnet.ibm.com> <1192032053.3880.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:45239 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbXJJQQS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2007 12:16:18 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9AGGQaI003236
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 02:16:26 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9AGJoN4276772
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 02:19:50 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9AGDNAj002718
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 02:13:23 +1000
In-Reply-To: <1192032053.3880.11.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Mingming Cao wrote:
> On Wed, 2007-10-10 at 17:35 +0530, Aneesh Kumar K.V wrote:
>> I have updated the patch queue at 
>>
>> http://www.radian.org/~kvaneesh/ext4/patch-series/
>>
>> http://www.radian.org/~kvaneesh/ext4/patch-series/ext4-patch-queue.tar
>>
>> Changes:
>> a) Add large-file-blocktype.patch  large-file.patch patch.
> 
> Could you send them out separately? I noticed that your queue is not
> based on the last ext4 patch queue. You modified mballoc-core.patch
> directly with large file block type changes...but your updated
> mballoc-core.patch doesn't have the latest proc fs fix from Ted. 
> 

It has the changes. http://www.radian.org/~kvaneesh/ext4/patch-series/mballoc-core.patch
I searched for PROC_FS . I did a git pull on patch queue before updating the patches.




> I would appreciate if you separete the largeblocktype changes for
> mballoc out of the core mballoc changes, as that patch is getting really
> big already.
> 
>> b) Add the stable-boundary-patch with dummy change
>> c) Add stable-boundary-undo.patch which undo the above dummy change.
> 
> The stable-boundary patch is being removed from ext4 patch queue,as some
> tools expect a meaning code diff to apply any patch.
> 

That is why i added a dummy change which is reverted by the later patch.



-aneesh

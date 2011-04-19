From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Ext4 Punch Hole Support: Change summary and test case summary
Date: Tue, 19 Apr 2011 13:41:06 -0700
Message-ID: <4DADF362.1040300@linux.vnet.ibm.com>
References: <4DAD3BD7.3080107@linux.vnet.ibm.com> <F28E8BBB-A8B7-44AA-A84C-DB247B2A88CC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53151 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1DSUlL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 16:41:11 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3JKUVtV002608
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 16:30:31 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JKf94c307720
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 16:41:09 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JKf8pt024746
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 16:41:08 -0400
In-Reply-To: <F28E8BBB-A8B7-44AA-A84C-DB247B2A88CC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/19/2011 1:29 AM, Andreas Dilger wrote:
> On 2011-04-19, at 1:37 AM, Allison Henderson wrote:
>> Big Hole Test
>> ---------------------------------------------------------------
>> A hole large hole is punched in a large file (exact file size=638169088 bytes, exact hole size = 638150422 bytes, offset = 6144 bytes),
>> resulting in all but 5 blocks being punched out (2 in the front, 3 in the back).  This test case verifies that the code can properly
>> punch out a hole covering multiple extents.
>>
>> This test is successful when the following conditions are met:
>> - File frag shows extents only for the first two blocks and the last 3 blocks
>> - The test file contains zeros from bytes 6144 to 638156566
>> (* ls and df is not measured here because some blocks will still be reserved
>> as index blocks causing the consumed space to be appear larger)
>
> Shouldn't the remaining two extents fit inside the inode, so there is no need for index blocks, or does the extent removal code not shrink the index blocks?
>
> Cheers, Andreas
>
>
>
>
>
Hi there,

It turns out that it does not.  At one point I spent a good chunk of 
time trying to figure out why the file size was not the number I had 
expected, and found out that there was an index block that was still 
there.  I also found out a normal truncate does the same thing.  A large 
file truncated down to a small file ended up occupying more space than 
an empty file that was grown to the same size.  Since this behavior was 
existing though, we have put this task on our back log as a separate 
work item.

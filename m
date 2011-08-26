From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/5 v6] ext4: fix partial page writes
Date: Fri, 26 Aug 2011 15:46:44 -0700
Message-ID: <4E582254.1010001@linux.vnet.ibm.com>
References: <1314212842-16741-1-git-send-email-achender@linux.vnet.ibm.com> <1314212842-16741-6-git-send-email-achender@linux.vnet.ibm.com> <20110826154713.GB5176@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:41680 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1HZWqu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Aug 2011 18:46:50 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7QMQimj025788
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 16:26:44 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7QMkjsR155594
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 16:46:45 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7QMkjIe002150
	for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 16:46:45 -0600
In-Reply-To: <20110826154713.GB5176@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/26/2011 08:47 AM, Ted Ts'o wrote:
> On Wed, Aug 24, 2011 at 12:07:22PM -0700, Allison Henderson wrote:
>> While running extended fsx tests to verify the preceeding patches,
>> a similar bug was also found in the write operation
>>
>> When ever a write operation begins or ends in a hole,
>> or extends EOF, the partial page contained in the hole
>> or beyond EOF needs to be zeroed out.
>>
>> To correct this the new ext4_discard_partial_page_buffers_no_lock
>> routine is used to zero out the partial page, but only for buffer
>> heads that are already unmapped.
>>
>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>
> I haven't had a chance to debug this yet, but FYI, with this patch
> applied, xfstests #224 causes OOM's to result when running under KVM
> with 1024megs.  I tried doubling the memory to 2048 megs, and it
> passed in 4k standard ext4 mode, but then got hit with the OOM killer
> on test #224 in ext3 emulation mode (nodealloc, and with extents not
> enabled in the file system).  Without this patch, and the first four
> patches in the v6 patch series applied, xfstests #224 passes in all of
> the standard configurations (4k, ext3, 1k, data=journal, etc.)
>
> I don't know why this is happening, but I'll try to dig into it in the
> next day or two.  Any thoughts or fixes you might suggest would be
> much appreciated.
>
> 						- Ted

Alrighty then, I will look into this one and see if I can figure out 
whats going on.  Thx again!

Allison Henderson

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Fix the soft lockup with multi block allocator.
Date: Mon, 24 Dec 2007 11:45:32 -0700
Message-ID: <20071224184532.GA3421@webber.adilger.int>
References: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20071221191020.GM3214@webber.adilger.int> <476FF805.4050700@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Alex Tomas <alex.tomas@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:51044 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbXLXSpe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2007 13:45:34 -0500
Content-Disposition: inline
In-Reply-To: <476FF805.4050700@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 24, 2007  21:18 +0300, Alex Tomas wrote:
> Andreas Dilger wrote:
>> On Dec 21, 2007  16:39 +0530, Aneesh Kumar K.V wrote:
>>> @@ -3790,7 +3782,9 @@ repeat:
>>>   	/* if we still need more blocks and some PAs were used, try again */
>>>  	if (free < needed && busy) {
>>> +		busy = 0;
>>>  		ext4_unlock_group(sb, group);
>>> +		schedule_timeout(HZ);
>>>  		goto repeat;
>>>  	}
>>
>> Is there nothing we could actually wait on instead of just sleeping for
>> 1 second?
>
> actually it was done for simplicity - in my tests busy PA happened quite rare.
> I have no objection to improve this with special wait queue.

If it is a very rare case, then I have no objection.  I just wanted to
avoid some sort of "Nagle" case where suddenly a workload is taking 1s
instead of 1ms to complete each IO.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

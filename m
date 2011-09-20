From: torn5 <torn5@shiftmail.org>
Subject: What to put for unknown stripe-width?
Date: Tue, 20 Sep 2011 12:30:43 +0200
Message-ID: <4E786B53.5020407@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:51343 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1ITKbr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 06:31:47 -0400
Received: from [192.168.7.52] (firewall.itb.cnr.it [155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.5-x5 #31918)
 with ESMTPSA id <01O69YE0AYEGXPMQVC@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Tue, 20 Sep 2011 12:30:43 +0200 (MEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello there,
I am planning some ext4 filesystems which are currently in (LVM over) a 
RAID array having:

stride=1MiB   stripe-witdth=4MiB

BUT ... their RAID could be enlarged with more disks in the future 
and/or they are likely to be moved around live (leveraging LVM, which I 
will align) to other RAIDs which also will have stride=1MiB but unknown, 
as of now, stripe-width.
That's on HDDs, with platters.

What do you suggest for stripe-width?
I don't really know how ext4 works, unfortunately. But I think the 
answer should be among the following values:

-  a) 60MiB: so to be exact multiple of most stripe-widths, in 
particular when number of data disks is any of: 
1,2,3,4,5,10,12,15,20,30,60 . I expect some longer-than-normal seeks 
with HDD heads with 60MiB though.

-  b) 7MiB or 11MiB: (prime numbers so *not* likely multiple of most 
stripe-widths) so to likely see data eventually spreaded equally on the 
various disks (maybe?). That's the opposite reason as (a), so one of 
these two must be wrong.

-  c) 1MiB so to be exact *divisor* (and not multiple) of all possible 
number of disks. This is wrong, isn't it?

-  d) use current optimal of 4MiB, then use tune2fs to alter 
stripe-width when the underlying stripes are changed. This should be 
fine for new writes, but I am not sure what is the impact on reads of 
old data.

Thanks for your help
T5

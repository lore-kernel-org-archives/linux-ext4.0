From: torn5 <torn5@shiftmail.org>
Subject: Ext4 allocation strategy
Date: Fri, 12 Aug 2011 15:47:00 +0200
Message-ID: <4E452ED4.9000307@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:50722 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1HLNzH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Aug 2011 09:55:07 -0400
Received: from [192.168.1.112] (firewall.itb.cnr.it [155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.5-x5 #31826)
 with ESMTPSA id <01O4RNUWZG0MWT79LN@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Fri, 12 Aug 2011 15:47:00 +0200 (MEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,
I can't find info on the ext4 allocation strategy, while this would be 
useful to me to understand ext4 performance implications when I put it 
above complex layers of RAID and LVM.
Just to be clear, i'm NOT talking about the delayed allocation thing.
XFS has the "Allocation Groups" which are relatively well described, for 
ext4 I don't know what to look for. And I also can't find an application 
which gives me a visual map of the ext4 allocated blocks in my 
filesystem so I cannot easily "inspect" this by myself.

So can you tell me something?

In particular, does ext4 start from the beginning of the partition and 
goes upward filling the earliest free spaces like it was for the old 
FAT32, or does it try to spread allocations evenly on all the LBAs 
available to that partition, e.g. by bisecting the largest free space 
every time? Suppose some time passes from one file creation to another.

And how does it behave if it has to create zillions of small files 
simultaneously (multithreaded application): where does it place them?

Thank you

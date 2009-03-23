From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: Re: [Bugme-new] [Bug 12594] New: filesystem corruption while
	running bonnie
Date: Mon, 23 Mar 2009 13:56:00 +0200
Message-ID: <20090323115600.GB21444@smart.research.nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63024 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZCWL5o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Mar 2009 07:57:44 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

directory inode 69634: node (523)
>> not
>> referenced
>> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (524)
>> has
>> invalid depth (2)
>> /dev/mapper/VGODR-tmp: Problem in HTREE directory inode 69634: node (524)
>> not
>> referenced
>> /dev/mapper/VGODR-tmp: Invalid HTREE directory inode 69634
>> (/tmp/Bonnie.3813). 
>> 
>> I've got a gzip'ed dump of /tmp available on request.
>
> htree went bad.  It's strange that exercising tmpfs would do this.
> 
> I always get worried when I see device-mapper in the picture.  It has a
> history..  Perhaps you can describe your device-mapper setup?

Hello, 

Sorry if this message misses the thread.

Could this be connected ?
http://marc.info/?l=linux-ext4&m=123755620515122&w=2
Ext3/ext4 corruption on block ramdisk. Also HTREE is corrupted under stress
tests with several concurrent fsstress (LTP util) processes.

Tested on latest 2.6.29-rc8 kernels, on quad Xeon machine with enough RAM.
Testcase: http://marc.info/?l=linux-kernel&m=122666866015665&w=2


Denis


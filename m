From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: possible ext4 race situation freezing linux
Date: Tue, 24 Feb 2009 09:38:17 -0600
Message-ID: <49A41469.6090604@redhat.com>
References: <1235478142.11758.9.camel@localhost.localdomain> <20090224141749.GC5482@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Friedrich Berendsen <afberendsen@gmail.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40942 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbZBXPiY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 10:38:24 -0500
In-Reply-To: <20090224141749.GC5482@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Feb 25, 2009 at 01:22:22AM +1300, Andreas Friedrich Berendsen wrote:
>> Kernel version: 2.26.28.7
>> efs2progs version: 1.41.4
>> arch: x86_64 (amd)
>>
>> I made this test four times and the results  were the same: linux
>> freezes and becomes unresponsive. Only solution is to reset the box. I
>> do not know if the problem is with the USB devices sub-subsystem or a
>> possible ext4 race condition.
> 
> Can you use alt-sysrq to get some stack traces or a register dump out,
> so we can see where the kernel is hanging?
> 
>       	      	    	       	  - Ted

alt-sysrq-w would be a good place to start (just in case you're not
familiar w/ the sysrq keys)

It'd also be great to test w/ 2.6.29, as a deadlock was fixed there
recently (it's on its way to .28.x too AFAIK)

Thanks,

-Eric

From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: Re: possible ext4 race situation freezing linux
Date: Wed, 25 Feb 2009 06:03:33 +1300
Message-ID: <1235495013.11758.37.camel@localhost.localdomain>
References: <1235478142.11758.9.camel@localhost.localdomain>
	 <20090224141749.GC5482@mit.edu>  <49A41469.6090604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:5443 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZBXRDl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 12:03:41 -0500
Received: by rv-out-0506.google.com with SMTP id g37so2556548rvb.1
        for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 09:03:39 -0800 (PST)
In-Reply-To: <49A41469.6090604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tso & Eric,

I'll try again to reproduce the error, but when the system freezes, I
have the X interface running. And, indeed, I'm not familiar with the
behaviour of sysreq. Which sysrq should I use when the problem happens?
Will the system change to the text interface? If there are no disk
activity (all leds are off), where the information will be recorded?

-- Berendsen

-----Original Message-----
From: Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Andreas Friedrich Berendsen <afberendsen@gmail.com>,
linux-ext4@vger.kernel.org
Subject: Re: possible ext4 race situation freezing linux
Date: Tue, 24 Feb 2009 09:38:17 -0600

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
-- 
__________________________________________
Andreas Friedrich Berendsen
SCA OCP MSCA A+ Linux+ Network+ HpMASE


From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bad ext4 sync performance on 16 TB GPT partition
Date: Mon, 01 Mar 2010 10:22:06 -0600
Message-ID: <4B8BE9AE.5080601@redhat.com>
References: <alpine.LNX.2.00.1002260926140.18232@wong.science-computing.de> <87ljegb4ow.fsf@openvz.org> <alpine.LNX.2.00.1002261546380.18232@wong.science-computing.de> <4B8809C2.2000300@redhat.com> <alpine.LNX.2.00.1003010908360.26560@wong.science-computing.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Karsten Weiss <K.Weiss@science-computing.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0CAQWR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Mar 2010 11:22:17 -0500
In-Reply-To: <alpine.LNX.2.00.1003010908360.26560@wong.science-computing.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Karsten Weiss wrote:
> Hi Eric,
> 
> On Fri, 26 Feb 2010, Eric Sandeen wrote:
> 
>>> => The problem shows only with the CentOS / Red Hat 5.4 kernels (including 
>>> RH's test kernel 2.6.18-190.el5). Aadmittedly ext4 is only a technology 
>>> preview in 5.4...
>>>
>>> I've also tried the latest CentOS 5.3 kernel-2.6.18-128.7.1.el5 but 
>>> couldn't mount the device (with -t ext4dev).
>>>
>>> 2.6.18-164.el5 (the initial CentOS 5.4 kernel) has the bug, too.
>>>
>>> I'm willing to test patches if somebody wants to debug the problem.
>> Ok, that's interesting.  We've not had bona-fide RHEL customers report
>> the problem, but then maybe it hasn't been tested this way.
> 
> I think so because, as I mentioned, the issue can be reproduced with the 
> RH test kernel 2.6.18-190.el5 x86_64 (http://people.redhat.com/jwilson/el5/),
> too.
> 
>> 2.6.18-178.el5 and beyond is based on the 2.6.32 codebase for ext4.
>>
>> Testing generic 2.6.32 might also be interesting as a datapoint,
>> if you're willing.
> 
> Sorry for the delay, here's the (good) 2.6.32 result:
> 
> # /usr/bin/time bash -c "dd if=/dev/zero of=/mnt/large/10GB bs=1M count=10000 && sync"
> 10000+0 records in
> 10000+0 records out
> 10485760000 bytes (10 GB) copied, 46.3369 seconds, 226 MB/s
> 0.00user 14.17system 0:59.53elapsed 23%CPU (0avgtext+0avgdata 6224maxresident)k
> 0inputs+0outputs (0major+1045minor)pagefaults 0swaps
> 
> To summarize:
> 
> Bad:  2.6.18-164.el5 (CentOS)
> Bad:  2.6.18-164.11.1el5 (CentOS)
> Bad:  2.6.18-190.el5 (RH)
> Good: 2.6.32
> Good: 2.6.33
> 

Thanks, I'll have to investigate that.  I guess something may have gotten lost
in translation in the 2.6.32->2.6.18 backport.....

-Eric

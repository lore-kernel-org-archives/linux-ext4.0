From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bad ext4 sync performance on 16 TB GPT partition
Date: Fri, 12 Mar 2010 09:20:39 -0600
Message-ID: <4B9A5BC7.3030508@redhat.com>
References: <alpine.LNX.2.00.1002260926140.18232@wong.science-computing.de> <87ljegb4ow.fsf@openvz.org> <alpine.LNX.2.00.1002261546380.18232@wong.science-computing.de> <4B8809C2.2000300@redhat.com> <alpine.LNX.2.00.1003010908360.26560@wong.science-computing.de> <4B8BE9AE.5080601@redhat.com> <alpine.LNX.2.00.1003121227040.13248@wong.science-computing.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Karsten Weiss <K.Weiss@science-computing.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934020Ab0CLPUw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Mar 2010 10:20:52 -0500
In-Reply-To: <alpine.LNX.2.00.1003121227040.13248@wong.science-computing.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Karsten Weiss wrote:
> Hi Eric!
> 
> On Mon, 1 Mar 2010, Eric Sandeen wrote:
> 
>>> Sorry for the delay, here's the (good) 2.6.32 result:
>>>
>>> # /usr/bin/time bash -c "dd if=/dev/zero of=/mnt/large/10GB bs=1M count=10000 && sync"
>>> 10000+0 records in
>>> 10000+0 records out
>>> 10485760000 bytes (10 GB) copied, 46.3369 seconds, 226 MB/s
>>> 0.00user 14.17system 0:59.53elapsed 23%CPU (0avgtext+0avgdata 6224maxresident)k
>>> 0inputs+0outputs (0major+1045minor)pagefaults 0swaps
>>>
>>> To summarize:
>>>
>>> Bad:  2.6.18-164.el5 (CentOS)
>>> Bad:  2.6.18-164.11.1el5 (CentOS)
>>> Bad:  2.6.18-190.el5 (RH)
>>> Good: 2.6.32
>>> Good: 2.6.33
> 
> In the meantime I've also reproduced the problem on another machine with a 
> Red Hat 5.5 Beta (x86_64) installation and decided to open a bug on RH's 
> bugzilla:
> 
> Bad ext4 sync performance on 16 TB GPT partition
> https://bugzilla.redhat.com/show_bug.cgi?id=572930

Thanks, and thanks for double-checking upstream.

>> Thanks, I'll have to investigate that.  I guess something may have gotten lost
>> in translation in the 2.6.32->2.6.18 backport.....
> 
> Did you come up with anything I could test?

I'll look into this...
 
> Is anyone else able to reproduce the problem?

Since it's not an upstream problem, this issue is probably best discussed
in the RHEL bug, now.

Thanks,
-Eric

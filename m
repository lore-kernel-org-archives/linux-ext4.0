From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bad ext4 sync performance on 16 TB GPT partition
Date: Fri, 26 Feb 2010 11:49:54 -0600
Message-ID: <4B8809C2.2000300@redhat.com>
References: <alpine.LNX.2.00.1002260926140.18232@wong.science-computing.de> <87ljegb4ow.fsf@openvz.org> <alpine.LNX.2.00.1002261546380.18232@wong.science-computing.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Karsten Weiss <K.Weiss@science-computing.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965499Ab0BZRuC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Feb 2010 12:50:02 -0500
In-Reply-To: <alpine.LNX.2.00.1002261546380.18232@wong.science-computing.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Karsten Weiss wrote:
> Hi Dmitry!
> 
> On Fri, 26 Feb 2010, Dmitry Monakhov wrote:
> 

...

>>> * I did not try a vanilla kernel so far.
>> IMHO It would be really good to know vanilla kernel's stats.
> 
> I did a quick&dirty compilation of vanilla kernel 2.6.33 and repeated the 
> test:
> 
> # /usr/bin/time bash -c "dd if=/dev/zero of=/mnt/large/10GB bs=1M count=10000 && sync"
> 10000+0 records in
> 10000+0 records out
> 10485760000 bytes (10 GB) copied, 50.044 seconds, 210 MB/s
> 0.01user 13.76system 1:04.75elapsed 21%CPU (0avgtext+0avgdata 6224maxresident)k
> 0inputs+0outputs (0major+1049minor)pagefaults 0swaps
> 
> => The problem shows only with the CentOS / Red Hat 5.4 kernels (including 
> RH's test kernel 2.6.18-190.el5). Aadmittedly ext4 is only a technology 
> preview in 5.4...
> 
> I've also tried the latest CentOS 5.3 kernel-2.6.18-128.7.1.el5 but 
> couldn't mount the device (with -t ext4dev).
> 
> 2.6.18-164.el5 (the initial CentOS 5.4 kernel) has the bug, too.
> 
> I'm willing to test patches if somebody wants to debug the problem.

Ok, that's interesting.  We've not had bona-fide RHEL customers report
the problem, but then maybe it hasn't been tested this way.

2.6.18-178.el5 and beyond is based on the 2.6.32 codebase for ext4.

Testing generic 2.6.32 might also be interesting as a datapoint,
if you're willing.

-Eric

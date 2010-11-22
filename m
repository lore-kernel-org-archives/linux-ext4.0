From: Christoph Bartoschek <bartoschek@or.uni-bonn.de>
Subject: Re: ext4_alloc_context occupies 150 GiB of memory and makes the system unusable
Date: Mon, 22 Nov 2010 16:37:58 +0100
Message-ID: <201011221637.58275.bartoschek@or.uni-bonn.de>
References: <201011221323.25342.bartoschek@or.uni-bonn.de> <4CEA8B4A.3030608@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brical.or.uni-bonn.de ([131.220.141.99]:46842 "EHLO
	brical.or.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0KVPiA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Nov 2010 10:38:00 -0500
Received: from wse04.or.uni-bonn.de (bg-1.or.uni-bonn.de [131.220.141.100])
	by brical.or.uni-bonn.de (Postfix) with ESMTP id E2FD63B6D6
	for <linux-ext4@vger.kernel.org>; Mon, 22 Nov 2010 16:37:58 +0100 (CET)
Received: from imap.or.uni-bonn.de (mailserver.or.uni-bonn.de [131.220.143.135])
	by wse04.or.uni-bonn.de (Postfix) with ESMTP id 81983C40A
	for <linux-ext4@vger.kernel.org>; Mon, 22 Nov 2010 16:37:59 +0100 (CET)
Received: from burns.bruehl.pontohonk.de (wse00.or.uni-bonn.de [131.220.143.130])
	by imap.or.uni-bonn.de (Postfix) with ESMTPS id 40B621FE9E
	for <linux-ext4@vger.kernel.org>; Mon, 22 Nov 2010 16:37:59 +0100 (CET)
In-Reply-To: <4CEA8B4A.3030608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Montag, 22. November 2010 schrieben Sie:

> > We see that Slab uses most of the memory. And within slab nearly
> > everything is
> > 
> > used for ext4_alloc_context. There is the output of slabtop:
> >  Active / Total Objects (% used)    : 364597 / 1070670469 (0.0%)
> >  Active / Total Slabs (% used)      : 52397 / 39688960 (0.1%)
> >  Active / Total Caches (% used)     : 107 / 193 (55.4%)
> >  Active / Total Size (% used)       : 159579.25K / 150697605.41K (0.1%)
> >  Minimum / Average / Maximum Object : 0.02K / 0.14K / 4096.00K
> >  
> >   OBJS     ACTIVE  USE OBJ SIZE    SLABS OBJ/SLAB CACHE SIZE NAME
> > 
> > 1070187012      0   0%    0.14K 39636556       27 158546224K
> > ext4_alloc_context
> 
> and it's all unused... (inactive)
> 
> To make matters worse drop_caches doesn't touch the slabs, IIRC, but you
> might try: echo 3 > /proc/sys/vm/drop_caches

I tried it and it did not improve anything.


> > I see no reason why ext4 should use so much memory. What is it used for?
> > And how can I release it to get it used for my processes.
> 
> You may need to reboot, or at best unmount ext4 filesystems and/or rmmod
> the ext4 module, if the drop_caches trick doesn't work.
> 
> The fact that this doesn't get reclaimed seems to point to a problem
> with the vm though, I think (aside from the craziness of ext4 using
> this slab so heavily without my patch...)

I see the problem for the first time and I do not know whether it is 
reproducable. We have several similar machines with similar workloads but none 
has shown such a problem till now.

I'm going to reboot the machine. If it shows the problem again I will try a 
newer kernel and then the patch.

Some workload will be lost, but the machine did not do anything useful for 
three days now :)

Thanks,
Christoph

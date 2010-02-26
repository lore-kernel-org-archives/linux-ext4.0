From: Karsten Weiss <K.Weiss@science-computing.de>
Subject: Re: Bad ext4 sync performance on 16 TB GPT partition
Date: Fri, 26 Feb 2010 16:47:04 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1002261546380.18232@wong.science-computing.de>
References: <alpine.LNX.2.00.1002260926140.18232@wong.science-computing.de> <87ljegb4ow.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.belwue.de ([129.143.2.15]:33954 "EHLO smtp2.belwue.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085Ab0BZPrO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Feb 2010 10:47:14 -0500
Received: from mx3.science-computing.de (mx3.science-computing.de [193.197.16.20])
	by smtp2.belwue.de with ESMTP id o1QFlChs011334
	for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2010 16:47:12 +0100 (MET)
	env-from (prvs=6660bea79=K.Weiss@science-computing.de)
In-Reply-To: <87ljegb4ow.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry!

On Fri, 26 Feb 2010, Dmitry Monakhov wrote:

> > Kernels:
> > * 2.6.18-164.11.1.el5 x86_64 (latest CentOS 5.4 kernel)
> > * 2.6.18-190.el5 x86_64 (latest Red Hat EL5 test kernel I've found from
> >   http://people.redhat.com/jwilson/el5/ which contains an ext4 version 
> >   which (according to the rpm's changelog) was updated from the 2.6.32
> >   ext4 codebase.
> Hmm.. It is hard to predict differences between vanilla tree.
> This is no only ext4 related. writeback path is changed dramatically.
> It is not easy to port writeback code to 2.6.18 with full performance
> improvements but without introducing new issues.
> > * I did not try a vanilla kernel so far.
> IMHO It would be really good to know vanilla kernel's stats.

I did a quick&dirty compilation of vanilla kernel 2.6.33 and repeated the 
test:

# /usr/bin/time bash -c "dd if=/dev/zero of=/mnt/large/10GB bs=1M count=10000 && sync"
10000+0 records in
10000+0 records out
10485760000 bytes (10 GB) copied, 50.044 seconds, 210 MB/s
0.01user 13.76system 1:04.75elapsed 21%CPU (0avgtext+0avgdata 6224maxresident)k
0inputs+0outputs (0major+1049minor)pagefaults 0swaps

=> The problem shows only with the CentOS / Red Hat 5.4 kernels (including 
RH's test kernel 2.6.18-190.el5). Aadmittedly ext4 is only a technology 
preview in 5.4...

I've also tried the latest CentOS 5.3 kernel-2.6.18-128.7.1.el5 but 
couldn't mount the device (with -t ext4dev).

2.6.18-164.el5 (the initial CentOS 5.4 kernel) has the bug, too.

I'm willing to test patches if somebody wants to debug the problem.

-- 
Karsten Weiss

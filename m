From: Karsten Weiss <K.Weiss@science-computing.de>
Subject: Re: Bad ext4 sync performance on 16 TB GPT partition
Date: Fri, 12 Mar 2010 12:37:31 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1003121227040.13248@wong.science-computing.de>
References: <alpine.LNX.2.00.1002260926140.18232@wong.science-computing.de> <87ljegb4ow.fsf@openvz.org> <alpine.LNX.2.00.1002261546380.18232@wong.science-computing.de> <4B8809C2.2000300@redhat.com> <alpine.LNX.2.00.1003010908360.26560@wong.science-computing.de>
 <4B8BE9AE.5080601@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.belwue.de ([129.143.2.12]:57575 "EHLO smtp1.belwue.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab0CLLwW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Mar 2010 06:52:22 -0500
Received: from mx3.science-computing.de (mx3.science-computing.de [193.197.16.20])
	by smtp1.belwue.de with ESMTP id o2CBbcWc011970
	for <linux-ext4@vger.kernel.org>; Fri, 12 Mar 2010 12:37:39 +0100 (MET)
	env-from (prvs=68006298b=K.Weiss@science-computing.de)
In-Reply-To: <4B8BE9AE.5080601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric!

On Mon, 1 Mar 2010, Eric Sandeen wrote:

> > Sorry for the delay, here's the (good) 2.6.32 result:
> > 
> > # /usr/bin/time bash -c "dd if=/dev/zero of=/mnt/large/10GB bs=1M count=10000 && sync"
> > 10000+0 records in
> > 10000+0 records out
> > 10485760000 bytes (10 GB) copied, 46.3369 seconds, 226 MB/s
> > 0.00user 14.17system 0:59.53elapsed 23%CPU (0avgtext+0avgdata 6224maxresident)k
> > 0inputs+0outputs (0major+1045minor)pagefaults 0swaps
> > 
> > To summarize:
> > 
> > Bad:  2.6.18-164.el5 (CentOS)
> > Bad:  2.6.18-164.11.1el5 (CentOS)
> > Bad:  2.6.18-190.el5 (RH)
> > Good: 2.6.32
> > Good: 2.6.33

In the meantime I've also reproduced the problem on another machine with a 
Red Hat 5.5 Beta (x86_64) installation and decided to open a bug on RH's 
bugzilla:

Bad ext4 sync performance on 16 TB GPT partition
https://bugzilla.redhat.com/show_bug.cgi?id=572930

> Thanks, I'll have to investigate that.  I guess something may have gotten lost
> in translation in the 2.6.32->2.6.18 backport.....

Did you come up with anything I could test?

Is anyone else able to reproduce the problem?

-- 
Karsten Weiss

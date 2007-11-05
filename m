From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH][RFC]Ext4: Use get_cpu()/put_cpu() in preemptible
	context
Date: Mon, 05 Nov 2007 10:40:07 -0800
Message-ID: <1194288007.20278.6.camel@localhost.localdomain>
References: <E1Inx4A-0002PQ-00@kernel>
	 <1194044898.3966.6.camel@localhost.localdomain>
	 <472BB037.5010606@linux.vnet.ibm.com>
	 <1194050108.3966.18.camel@localhost.localdomain>
	 <20071103050137.GE2863@webber.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35313 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbXKESkO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 13:40:14 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA5Ie90O031186
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 13:40:09 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA5Ie9hP479680
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 13:40:09 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA5Ie99b029938
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 13:40:09 -0500
In-Reply-To: <20071103050137.GE2863@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-11-03 at 13:01 +0800, Andreas Dilger wrote:
> On Nov 02, 2007  17:35 -0700, Mingming Cao wrote:
> > Index: linux-2.6.24-rc1/fs/ext4/mballoc.c
> > ===================================================================
> > --- linux-2.6.24-rc1.orig/fs/ext4/mballoc.c	2007-11-02 17:22:18.000000000 -0700
> > +++ linux-2.6.24-rc1/fs/ext4/mballoc.c	2007-11-02 17:23:02.000000000 -0700
> > @@ -4006,7 +4006,8 @@ static void ext4_mb_group_or_file(struct
> >  		return;
> >  
> >  	BUG_ON(ac->ac_lg != NULL);
> > -	ac->ac_lg = &sbi->s_locality_groups[smp_processor_id()];
> > +	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
> > +	put_cpu();
> >  
> >  	/* we're going to use group allocation */
> >  	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
> 
> Shouldn't the put_cpu() be after ac->ac_lg is no longer being used?
> I guess there would otherwise be a danger of other processes using
> the same s_locality_groups[] struct?

>From the code, the concurrent use of the same s_locality_groups is being
protected by the ac_lg->lg_sem. The put_cpu() instruction is before the
lock is taken.


Mingming

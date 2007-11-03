From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC]Ext4: Use get_cpu()/put_cpu() in preemptible
	context
Date: Sat, 3 Nov 2007 13:01:37 +0800
Message-ID: <20071103050137.GE2863@webber.adilger.int>
References: <E1Inx4A-0002PQ-00@kernel> <1194044898.3966.6.camel@localhost.localdomain> <472BB037.5010606@linux.vnet.ibm.com> <1194050108.3966.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48257 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbXKCFCS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Nov 2007 01:02:18 -0400
Content-Disposition: inline
In-Reply-To: <1194050108.3966.18.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 02, 2007  17:35 -0700, Mingming Cao wrote:
> Index: linux-2.6.24-rc1/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.24-rc1.orig/fs/ext4/mballoc.c	2007-11-02 17:22:18.000000000 -0700
> +++ linux-2.6.24-rc1/fs/ext4/mballoc.c	2007-11-02 17:23:02.000000000 -0700
> @@ -4006,7 +4006,8 @@ static void ext4_mb_group_or_file(struct
>  		return;
>  
>  	BUG_ON(ac->ac_lg != NULL);
> -	ac->ac_lg = &sbi->s_locality_groups[smp_processor_id()];
> +	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
> +	put_cpu();
>  
>  	/* we're going to use group allocation */
>  	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;

Shouldn't the put_cpu() be after ac->ac_lg is no longer being used?
I guess there would otherwise be a danger of other processes using
the same s_locality_groups[] struct?

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

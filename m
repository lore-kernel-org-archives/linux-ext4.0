From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: mballoc avoid use root reserved blocks for non
	root allocation
Date: Fri, 06 Jun 2008 11:59:24 -0700
Message-ID: <1212778764.22102.6.camel@localhost.localdomain>
References: <1212354413.4368.7.camel@localhost.localdomain>
	 <20080606023345.GH30272@mit.edu>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54845 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbYFFS7c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jun 2008 14:59:32 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m56IxVDB012444
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 14:59:31 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m56IxPVN234808
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 14:59:25 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m56IxPa6010032
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 14:59:25 -0400
In-Reply-To: <20080606023345.GH30272@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-06-05 at 22:33 -0400, Theodore Tso wrote:
> On Sun, Jun 01, 2008 at 02:06:53PM -0700, Mingming Cao wrote:
> > ext4: mballoc avoid use root reserved blocks for non root allocation
> > 
> > From: Mingming Cao <cmm@us.ibm.com>
> > 
> > mballoc allocation missed check for blocks reserved for root users. Add
> > ext4_has_free_blocks() check before allocation. Also modified
> > ext4_has_free_blocks() to support multiple block allocation request.
> 
> This was discovered by a Gentoo user who tried compiling on a UP system.....
> 
> > Index: linux-2.6.26-rc4/fs/ext4/balloc.c
> > ....
> > +	if (free_blocks - root_blocks < FBC_BATCH)
> > +		free_blocks =
> > +			percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
> 
> 
> FBC_BATCH is only defined if CONFIG_SMP is defined.  I believe the
> simplest fix is surround the above if statement with an "#ifdef
> CONFIG_SMP", since on UP systems, the percpu counters are always
> exactly correct.
> 

Works for me. One up system the counter is always accurate.

FBC_BATCH is just some value to trigger sum up from per cpu counters to
get the accurate value, we don't need to do this for single UP.

Mingming
> 					- Ted


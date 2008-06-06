From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: mballoc avoid use root reserved blocks for non
	root allocation
Date: Thu, 5 Jun 2008 22:33:45 -0400
Message-ID: <20080606023345.GH30272@mit.edu>
References: <1212354413.4368.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58255 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbYFFCei (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 22:34:38 -0400
Content-Disposition: inline
In-Reply-To: <1212354413.4368.7.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 01, 2008 at 02:06:53PM -0700, Mingming Cao wrote:
> ext4: mballoc avoid use root reserved blocks for non root allocation
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> mballoc allocation missed check for blocks reserved for root users. Add
> ext4_has_free_blocks() check before allocation. Also modified
> ext4_has_free_blocks() to support multiple block allocation request.

This was discovered by a Gentoo user who tried compiling on a UP system.....

> Index: linux-2.6.26-rc4/fs/ext4/balloc.c
> ....
> +	if (free_blocks - root_blocks < FBC_BATCH)
> +		free_blocks =
> +			percpu_counter_sum_positive(&sbi->s_freeblocks_counter);


FBC_BATCH is only defined if CONFIG_SMP is defined.  I believe the
simplest fix is surround the above if statement with an "#ifdef
CONFIG_SMP", since on UP systems, the percpu counters are always
exactly correct.

					- Ted

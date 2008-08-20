From: Andreas Dilger <adilger@sun.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 13:25:36 -0600
Message-ID: <20080820192536.GF3392@webber.adilger.int>
References: <20080820054339.GB6381@skywalker>
 <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54448 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYHTTZt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 15:25:49 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7KJPn9Z008266
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 12:25:49 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K5W00001Z6JVG00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 20 Aug 2008 12:25:48 -0700 (PDT)
In-reply-to: <20080820115331.GA9965@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 20, 2008  07:53 -0400, Theodore Ts'o wrote:
> Also, this is one of the places where it might help if we did
> something like:
> 
> 	freeblocks = percpu_counter_read(&sbi->s_freeblocks_counter);
> 	if (freeblocks < NR_CPUS*4)
> 		freeblocks = percpu_counter_sum(&sbi->s_freeblocks_counter);
>
> 	if (freeblocks < total) {
> 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 		return -ENOSPC;
> 	}

This is definitely a start. Lustre does the freeblocks granting to clients
in a manner that the amount of grant is some fraction of the remaining free
space (up to a maximum), and the clients only have to block and do sync IO
when the free space is very low.

The per-CPU allocation is very similar to having multiple clients...
I don't think NR_CPUS*4 is big enough to avoid the races though.  It
needs to be something like 4 * max(FBC_BATCH, total) * NR_CPUS.

What I think makes sense, however, is that if freeblocks < $threshold that
a global spinlock is taken and the percpu_counter_sum() is done under the
lock before deciding if enough space is left.  Since it is impossible that
the other CPUs get below -FBC_BATCH away from the correct free space they
should all get the spinlock at the same time when we get too low.

> BTW, I was looking at the percpu_counter interface, and I'm confused
> why we have percpu_counter_sum_and_set() and percpu_counter_sum().  If
> we're taking the fbc->lock to calculate the precise value of the
> counter, why not simply set fbc->count?  
> 
> Also, it is singularly unfortunate that certain interfaces, such as
> percpu_counter_sum_and_set() only exist for CONFIG_SMP.  This is
> definitely post-2.6.27, but it seems to me that we probably want
> something like percpu_counter_compare_lt() which does something like this:
> 
> static inline int percpu_counter_compare_lt(struct percpu_counter *fbc,
> 					    s64 amount)
> {
> #ifdef CONFIG_SMP
> 	if ((fbc->count - amount) < FBC_BATCH)
> 		percpu_counter_sum_and_set(fbc);
> #endif
> 	return 	(fbc->count < amount);
> }
> 
> ... which we would then use in ext4_has_free_blocks() and
> ext4_da_reserve_space().
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


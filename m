From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC] ext4-block-reservation.patch
Date: Sat, 23 Dec 2006 14:40:59 -0800
Message-ID: <20061223144059.f515a3a3.akpm@osdl.org>
References: <m37iwjwumf.fsf@bzzz.home.net>
	<m3y7ozvftf.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbWLWWlE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Dec 2006 17:41:04 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3y7ozvftf.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 22 Dec 2006 23:25:16 +0300
Alex Tomas <alex@clusterfs.com> wrote:

Once this code is settled in we should consider removal of the existing
reservations code from ext4.

> +
> +struct ext4_reservation_slot {
> +	__u64		rs_reserved;
> +	spinlock_t	rs_lock;
> +} ____cacheline_aligned;

Should be ____cacheline_aligned_in_smp.

That's assuming it needs to be cacheline aligned at all.  It can consume a
lot of space.

<looks>

oh, this should be allocated with alloc_percpu(), in which case the
open-coded alignment can perhaps go away.

> +
> +int ext4_reserve_local(struct super_block *sb, int blocks)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct ext4_reservation_slot *rs;
> +	int rc = -ENOSPC;
> +
> +	preempt_disable();
> +	rs = sbi->s_reservation_slots + smp_processor_id();

use get_cpu() here.

> +void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
> +{
> +	int i, used_slots = 0;
> +	__u64 chunk;
> +
> +	/* let's know what slots have been used */
> +	for (i = 0; i < NR_CPUS; i++)
> +		if (rs[i].rs_reserved || i == smp_processor_id())
> +			used_slots++;
> +
> +	/* chunk is a number of block every used
> +	 * slot will get. make sure it isn't 0 */
> +	chunk = free + used_slots - 1;
> +	do_div(chunk, used_slots);
> +
> +	for (i = 0; i < NR_CPUS; i++) {

all these NR_CPUS loops need to go away.  Use either
for_each_possible_cpu() or, preferably, for_each_online_cpu() and a hotplug
notifier.

Why is this code using per-cpu data at all, btw?  These optimisations tend
to be marginal in filesystems.  What is the perfomance impact of making
this data be single-superblock-wide-instance?

> +int ext4_reserve_init(struct super_block *sb)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct ext4_reservation_slot *rs;
> +	int i;
> +
> +	rs = kmalloc(sizeof(struct ext4_reservation_slot) * NR_CPUS, GFP_KERNEL);

alloc_percpu()

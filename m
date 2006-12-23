From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] ext4-block-reservation.patch
Date: Sun, 24 Dec 2006 01:47:00 +0300
Message-ID: <m3r6uqtel7.fsf@bzzz.home.net>
References: <m37iwjwumf.fsf@bzzz.home.net> <m3y7ozvftf.fsf@bzzz.home.net>
	<20061223144059.f515a3a3.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	<linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:57687 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753916AbWLWXNS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Dec 2006 18:13:18 -0500
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20061223144059.f515a3a3.akpm@osdl.org> (Andrew Morton's message
	of "Sat\, 23 Dec 2006 14\:40\:59 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi,

>>>>> Andrew Morton (AM) writes:

 AM> Should be ____cacheline_aligned_in_smp.

 AM> That's assuming it needs to be cacheline aligned at all.  It can consume a
 AM> lot of space.

the idea is to make block reservation cheap because it's called
for every page. 

 AM> <looks>

 AM> oh, this should be allocated with alloc_percpu(), in which case the
 AM> open-coded alignment can perhaps go away.

got it.

 >> +
 >> +int ext4_reserve_local(struct super_block *sb, int blocks)
 >> +{
 >> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
 >> +	struct ext4_reservation_slot *rs;
 >> +	int rc = -ENOSPC;
 >> +
 >> +	preempt_disable();
 >> +	rs = sbi->s_reservation_slots + smp_processor_id();

 AM> use get_cpu() here.

ok.

 >> +void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
 >> +{
 >> +	int i, used_slots = 0;
 >> +	__u64 chunk;
 >> +
 >> +	/* let's know what slots have been used */
 >> +	for (i = 0; i < NR_CPUS; i++)
 >> +		if (rs[i].rs_reserved || i == smp_processor_id())
 >> +			used_slots++;
 >> +
 >> +	/* chunk is a number of block every used
 >> +	 * slot will get. make sure it isn't 0 */
 >> +	chunk = free + used_slots - 1;
 >> +	do_div(chunk, used_slots);
 >> +
 >> +	for (i = 0; i < NR_CPUS; i++) {

 AM> all these NR_CPUS loops need to go away.  Use either
 AM> for_each_possible_cpu() or, preferably, for_each_online_cpu() and a hotplug
 AM> notifier.

hmm, i see.

 AM> Why is this code using per-cpu data at all, btw?  These optimisations tend
 AM> to be marginal in filesystems.  What is the perfomance impact of making
 AM> this data be single-superblock-wide-instance?

well, even on 2way box a single-lock reservation was in top10.

thanks, Alex

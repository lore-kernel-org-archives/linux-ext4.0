From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Mon, 8 Dec 2008 14:22:26 -0800
Message-ID: <20081208142226.c7b46f04.akpm@linux-foundation.org>
References: <4936D287.6090206@cosmosbay.com>
	<4936EB04.8000609@cosmosbay.com>
	<20081206202233.3b74febc.akpm@linux-foundation.org>
	<493BCF60.1080409@cosmosbay.com>
	<20081207092854.f6bcbfae.akpm@linux-foundation.org>
	<493C0F40.7040304@cosmosbay.com>
	<20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	<20081208221241.GA2501@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
	davem@davemloft.net, a.p.zijlstra@chello.nl, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbYLHWXa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 17:23:30 -0500
In-Reply-To: <20081208221241.GA2501@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 8 Dec 2008 17:12:41 -0500
Theodore Tso <tytso@mit.edu> wrote:

> Actually, if all popular architectures had a hardware-implemented
> atomic_t, I wonder how much ext4 really needs the percpu counter,
> especially given ext4's multiblock allocator; with ext3, given that
> each block allocation required taking a per-filesystem spin lock,
> optimizing away that spinlock was far more important for improving
> ext3's scalability.  But with the multiblock allocator, it may that
> we're going through a lot more effort than what is truly necessary.

I expect that the performance numbers for the percpu counters in the
superblock are buried away in the historical git changelogs somewhere. 
I don't recall how much difference it made.

An atomic_inc() of an fs-wide counter will have similar cost to
spin_lock() of an fs-wide lock.

If the multiblock allocator can avoid doing one atomic_inc() for each
block and can instead do atomic_add(large_value, &counter) then yes,
I'm sure that an fs-wide atomic_long_t would be OK.

Of course, similar changes should be made in trucate, etc.

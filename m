From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] ext2 statfs improvement for block and inode free count
Date: Fri, 20 Jul 2007 03:01:19 -0600
Message-ID: <20070720090119.GD5992@schatzie.adilger.int>
References: <1184377014.15968.14.camel@dyn9047017100.beaverton.ibm.com> <20070718201808.ccc7bdf5.akpm@linux-foundation.org> <1184858282.18188.83.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:41799 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbXGTJBW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jul 2007 05:01:22 -0400
Content-Disposition: inline
In-Reply-To: <1184858282.18188.83.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 19, 2007  08:18 -0700, Badari Pulavarty wrote:
> In my setups (4 & 8-way), I didn't measure any significant performance
> improvements (in any reasonable workload). I see some decent
> improvements on cooked-up (1 million stats) tests :(

I don't have any numbers to publish, but this did help internally
for large filesystems.

> > Well there's a tradeoff here.  At large CPU counts, percpu_counter_sum()
> > becomes quite expensive - it takes a global lock and then goes off fishing
> > in every CPU's percpu_alloced memory.
> > 
> > So there is some value of (num_online_cpus / sb->s_groups_count) at which
> > this change becomes a loss.  Where does that value lie?
> 
> Yes. I debated long time whether I should submit this or not - due to
> very reason. Old code wasn't holding any locks. I don't have any high
> count CPU machine (>8way) with me. I will request for time on one.

Considering that large (16TB) filesystems have 128000 groups in them,
I'd suspect that iterating over all of the group descriptors is a loss
until you have an unusually huge number of CPUs.  What was even worse
was before caching "overhead" it walked the groups list twice (once
for "overhead" and once for the per-group summary).

It might be that for the filesystem sizes ext2 is used on this isn't
a win, but I didn't submit the patch for ext2...

> I added WARN_ON() to see if percpu sum doesn't match
> computed sum. I saw few stacks in a 24 hour run of fsx runs. 

That could just be because the filesystem is changing between these
two checks...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 performance falloff
Date: Fri, 4 Apr 2014 16:56:04 -0400
Message-ID: <20140404205604.GC10275@thunk.org>
References: <533EE547.3030504@numascale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Steffen Persvold <sp@numascale.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Daniel J Blueman <daniel@numascale.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <533EE547.3030504@numascale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Apr 05, 2014 at 01:00:55AM +0800, Daniel J Blueman wrote:
> On a larger system 1728 cores/4.5TB memory and 3.13.9, I'm seeing very low
> 600KB/s cached write performance to a local ext4 filesystem:

Hi Daniel,

Thanks for the heads up.  Most (all?) of the ext4 don't have systems
with thousands of cores, so these issues generally don't come up for
us, and so we're not likely (hell, very unlikely!) to notice potential
problems cause by these sorts of uber-large systems.

> Analysis shows that ext4 is reading from all cores' cpu-local data (thus
> expensive off-NUMA-node access) for each block written:
> 
> if (free_clusters - (nclusters + rsv + dirty_clusters) <
> 				EXT4_FREECLUSTERS_WATERMARK) {
> 	free_clusters  = percpu_counter_sum_positive(fcc);
> 	dirty_clusters = percpu_counter_sum_positive(dcc);
> }
> 
> This threshold is defined as:
> 
> #define EXT4_FREECLUSTERS_WATERMARK (4 * (percpu_counter_batch *
> nr_cpu_ids))
> 
> I can see why this may get overlooked for systems with commensurate local
> storage, but some filesystems reasonably don't need to scale with core
> count. The filesystem I'm testing on and the rootfs (as it has /tmp) are
> 50GB.

The problem we are trying to solve here is that when we do delayed
allocation, we're making an implicit promise that there will be space
available, even though we haven't allocated the space yet.  The reason
why we are using percpu counters is precisely so that we don't have to
take a global lock in order to protect the free space counter for the
file system.

The problem is that when we start getting close to full, there is the
possibility that all of the cpus might simultaneously try allocate
space at exactly the same time (and while that might sound unlikely,
Murphy's law will dictate that if the downside is that the user will
lose data, and curse the day the file system developers were born, it
*will* happen :-).  So when the free space, minus the space we have
already promised, drops below EXT4_FREE_CLUSTERS_WATERMARK, we start
being super careful.

I've done the calculations, and 4 * 32 * 1728 cores = 221184 blocks,
or 864 megabytes.  That would mean that the file system is over 98%
full, so that's actually pretty reasonable; most of the time there's
more free space than that.

It looks like the real problem is that we're using nr_cpu_ids, which
is the maximum possible number of cpu's that the system can support,
which is different from the number of cpu's that you currently have.
For normal kernels nr_cpu_ids is small, so that has never been a
problem, but I bet you have nr_cpu_ids set to something really large,
right?

If you change nr_cpu_ids to total_cpus in the definition of
EXT4_FREECLUSTERS_WATERMARK, does that make things better for your
system?

Thanks,

					- Ted

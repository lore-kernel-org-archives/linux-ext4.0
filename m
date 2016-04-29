From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH v5 0/2] ext4: Improve parallel I/O performance on NVDIMM
Date: Fri, 29 Apr 2016 12:38:20 -0400
Message-ID: <57238DFC.6010108@hpe.com>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Waiman Long <Waiman.Long@hpe.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/29/2016 12:27 PM, Waiman Long wrote:
> v4->v5:
>   - Change patch 1 to disable i_dio_count update in do_dax_io().
>
> v3->v4:
>   - For patch 1, add the DIO_SKIP_DIO_COUNT flag to dax_do_io() calls
>     only to address issue raised by Dave Chinner.
>
> v2->v3:
>   - Remove the percpu_stats helper functions and use percpu_counters
>     instead.
>
> v1->v2:
>   - Remove percpu_stats_reset() which is not really needed in this
>     patchset.
>   - Move some percpu_stats* functions to the newly created
>     lib/percpu_stats.c.
>   - Add a new patch to support 64-bit statistics counts in 32-bit
>     architectures.
>   - Rearrange the patches by moving the percpu_stats patches to the
>     front followed by the ext4 patches.
>
> This patchset aims to improve parallel I/O performance of the ext4
> filesystem on DAX.
>
> Patch 1 disables update of the i_dio_count as all DAX I/Os are synchronous
> and should be protected from whatever locking was done by the filesystem
> caller or within dax_do_io() for read (DIO_LOCKING).
>
> Patch 2 converts some ext4 statistics counts into percpu counts using
> the helper functions.
>
> Waiman Long (2):
>    dax: Don't touch i_dio_count in dax_do_io()
>    ext4: Make cache hits/misses per-cpu counts
>
>   fs/dax.c                 |   14 ++++++--------
>   fs/ext4/extents_status.c |   38 +++++++++++++++++++++++++++++---------
>   fs/ext4/extents_status.h |    4 ++--
>   3 files changed, 37 insertions(+), 19 deletions(-)
>

 From my testing, it looked like that parallel overwrites to the same 
file in an ext4 filesystem on DAX can happen in parallel even if their 
range overlaps. It was mainly because the code will drop the i_mutex 
before the write. That means the overlapped blocks can get garbage. I 
think this is a problem, but I am not expert in the ext4 filesystem to 
say for sure. I would like to know your thought on that.

Thanks,
Longman

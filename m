From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH 0/3] dax, ext4: Improve DAX performance in ext4
Date: Fri,  3 Jun 2016 18:28:14 -0400
Message-ID: <1464992897-34063-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a follow-up of the patch series

  [PATCH v5 0/2] ext4: Improve parallel I/O performance on NVDIMM
  https://lkml.org/lkml/2016/4/29/583

It is rebased to the latest 4.7-rc1 release. It has an additional patch
to advantage of the fact that the inode i_mutex is now an i_rwsem.

Patch 1 changes the locking in dax_do_io() to get a shared lock
instead of an exclusive lock for reading. That allows parallel reads
to happen.

Patch 2 converts some ext4 statistics counts into percpu counts to
reduce cacheline contention for parallel reads.

Patch 3 passes in the DIO_SKIP_DIO_COUNT flag to dax_do_io() as DAX
I/Os are synchronous and there is no need to update DIO count as
long as either the lock is taken or the count has been updated in
the caller.

Waiman Long (3):
  dax: Take shared lock in dax_do_io()
  ext4: Make cache hits/misses per-cpu counts
  ext4: Pass DIO_SKIP_DIO_COUNT to dax_do_io

 fs/dax.c                 |    9 +++++----
 fs/ext4/extents_status.c |   38 +++++++++++++++++++++++++++++---------
 fs/ext4/extents_status.h |    4 ++--
 fs/ext4/inode.c          |   24 ++++++++++++++++++------
 4 files changed, 54 insertions(+), 21 deletions(-)

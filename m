From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH v3 0/2] ext4: Improve parallel I/O performance on NVDIMM
Date: Tue, 12 Apr 2016 14:12:53 -0400
Message-ID: <1460484775-33359-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

v2->v3:
 - Remove the percpu_stats helper functions and use percpu_counters
   instead.

v1->v2:
 - Remove percpu_stats_reset() which is not really needed in this
   patchset.
 - Move some percpu_stats* functions to the newly created
   lib/percpu_stats.c.
 - Add a new patch to support 64-bit statistics counts in 32-bit
   architectures.
 - Rearrange the patches by moving the percpu_stats patches to the
   front followed by the ext4 patches.

This patchset aims to improve parallel I/O performance of the ext4
filesystem on fast storage devices like NVDIMM.

Patch 1 eliminates duplicated inode_dio_begin()/inode_dio_end() calls.

Patch 2 converts some ext4 statistics counts into percpu counts using
the helper functions.

Waiman Long (2):
  ext4: Pass in DIO_SKIP_DIO_COUNT flag if inode_dio_begin() called
  ext4: Make cache hits/misses per-cpu counts

 fs/ext4/extents_status.c |   38 +++++++++++++++++++++++++++++---------
 fs/ext4/extents_status.h |    4 ++--
 fs/ext4/indirect.c       |   10 ++++++++--
 fs/ext4/inode.c          |   12 +++++++++---
 4 files changed, 48 insertions(+), 16 deletions(-)

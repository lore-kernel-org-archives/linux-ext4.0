From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH 0/3] ext4: Improve parallel I/O performance on NVDIMM
Date: Fri,  1 Apr 2016 23:09:35 -0400
Message-ID: <1459566578-30221-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patchset aims to improve parallel I/O performance of the ext4
filesystem on fast storage devices like NVDIMM.

Patch 1 eliminates duplicated inode_dio_begin()/inode_dio_end() calls.

Patch 2 provides a set of simple percpu statistics count helper functions.

Patch 3 converts some ext4 statistics counts into percpu counts using
the helper functions.

Waiman Long (3):
  ext4: Pass in DIO_SKIP_DIO_COUNT flag if inode_dio_begin() called
  percpu_stats: Simple per-cpu statistics count helper functions
  ext4: Make cache hits/misses per-cpu counts

 fs/ext4/extents_status.c     |   20 +++++---
 fs/ext4/extents_status.h     |   11 ++++-
 fs/ext4/indirect.c           |   10 +++-
 fs/ext4/inode.c              |   12 ++++-
 include/linux/percpu_stats.h |  103 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 141 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/percpu_stats.h

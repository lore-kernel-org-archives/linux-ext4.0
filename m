From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH v2 0/4] ext4: Improve parallel I/O performance on NVDIMM
Date: Fri,  8 Apr 2016 12:16:18 -0400
Message-ID: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t6225.austin.hp.com ([15.73.96.126]:37353 "EHLO
	g1t6225.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbcDHQQp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2016 12:16:45 -0400
Received: from g2t4622.austin.hp.com (g2t4622.austin.hp.com [15.73.212.79])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g1t6225.austin.hp.com (Postfix) with ESMTPS id 048483121
	for <linux-ext4@vger.kernel.org>; Fri,  8 Apr 2016 16:16:44 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
filesystem on fast storage devices like NVDIMM. It also introduces a
set of percpu statistics count helper functions that facilitate the
management of percpu statistics counts.

Patch 1 provides a set of simple percpu statistics count helper
functions.

Patch 2 enables the use of 64-bit counts for 32-bit architectures.

Patch 3 eliminates duplicated inode_dio_begin()/inode_dio_end() calls.

Patch 4 converts some ext4 statistics counts into percpu counts using
the helper functions.


Waiman Long (4):
  percpu_stats: Simple per-cpu statistics count helper functions
  percpu_stats: Enable 64-bit counts in 32-bit architectures
  ext4: Pass in DIO_SKIP_DIO_COUNT flag if inode_dio_begin() called
  ext4: Make cache hits/misses per-cpu counts

 fs/ext4/extents_status.c     |   22 ++++---
 fs/ext4/extents_status.h     |   11 +++-
 fs/ext4/indirect.c           |   10 +++-
 fs/ext4/inode.c              |   12 +++-
 include/linux/percpu_stats.h |   64 +++++++++++++++++++++
 lib/Makefile                 |    2 +-
 lib/percpu_stats.c           |  128 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 232 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/percpu_stats.h
 create mode 100644 lib/percpu_stats.c


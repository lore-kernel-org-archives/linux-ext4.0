From: Jan Kara <jack@suse.com>
Subject: [PATCH 0/6] ext4: Punch hole and DAX fixes
Date: Wed, 14 Oct 2015 13:30:21 +0200
Message-ID: <1444822227-29984-1-git-send-email-jack@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138AbbJNLam (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Oct 2015 07:30:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This series fixes a long standing problem of racing punch hole and page fault
resulting in possible filesystem corruption or stale data exposure. We fix the
problem by using a new inode-private rw_semaphore i_mmap_sem to synchronize
page faults with truncate and punch hole operations.

When having this exclusion, the only remaining problem with DAX implementation
are races between two page faults zeroing out same block concurrently (where
the data written after the first fault finishes are possibly overwritten by
the second fault still doing zeroing). That is dealt with by patches 5 and 6
in this series where we implement block zeroing directly in ext4_map_blocks().

The patches survived xfstests run both in dax and non-dax mode.

								Honza

From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/7, v3] fs: fix up AIO+DIO+O_SYNC to actually do the sync part
Date: Thu, 29 Mar 2012 18:04:58 -0400
Message-ID: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, jack@suse.cz,
	hch@infradead.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Currently, AIO+DIO+O_SYNC writes are not actually sync'd (for xfs), or
they are sync'd before the I/O is actually issued (everybody else).
The following patch series fixes this in two parts.  First, for the
file systems that use the generic routines, Jan has provided some
generic infrastructure to perform the syncs after the I/O is completed.
Second, for those file systems which require some endio processing of
their own for O_DIRECT writes (xfs and ext4), I've implemented file
system specific syncing.  This passes the updated xfs-tests 113 test
I posted earlier, as well as all of the tests in the aio group.  I
tested ext3, ext4, xfs, and btrfs only.

This is a data integrity path, and the current code does not honor
O_SYNC, so any review would be greatly appreciated.

Cheers,
Jeff

Changes since v2: updated the xfs patch to resolve conflicts with new
code (the flush workqueue is now one per mount point).

[PATCH 1/7] vfs: Handle O_SYNC AIO DIO in generic code properly
[PATCH 2/7] ocfs2: Use generic handlers of O_SYNC AIO DIO
[PATCH 3/7] gfs2: Use generic handlers of O_SYNC AIO DIO
[PATCH 4/7] btrfs: Use generic handlers of O_SYNC AIO DIO
[PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 6/7] ext4: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 7/7] filemap: don't call generic_write_sync for -EIOCBQUEUED

From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/7, v2] fs: fix up AIO+DIO+O_SYNC to actually do the sync part
Date: Fri,  2 Mar 2012 14:56:08 -0500
Message-ID: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
Cc: jack@suse.cz, hch@infradead.org
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759231Ab2CBT5B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 14:57:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

Comments, as always, are appreciated.

Cheers,
Jeff

[PATCH 1/7] vfs: Handle O_SYNC AIO DIO in generic code properly
[PATCH 2/7] ocfs2: Use generic handlers of O_SYNC AIO DIO
[PATCH 3/7] gfs2: Use generic handlers of O_SYNC AIO DIO
[PATCH 4/7] btrfs: Use generic handlers of O_SYNC AIO DIO
[PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 6/7] ext4: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 7/7] filemap: don't call generic_write_sync for -EIOCBQUEUED

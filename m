From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v3 0/5] add a test for reporting writeback errors across all fds on fsync
Date: Wed, 31 May 2017 09:08:15 -0400
Message-ID: <20170531130820.17634-1-jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net, dhowells@redhat.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbdEaNI2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 May 2017 09:08:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patchset is a companion to the Linux kernel patch series I recently
posted with the cover letter:

    [PATCH v5 00/17] fs: introduce new writeback error reporting and convert ext2 and ext4 to use it

That patchset adds a new userland-visible change to report errors on
all open file descriptions when there is an error on fsync, not just
the first one to race in.

Note that this set contains a patch to emulate $SCRATCH_LOGDEV on btrfs,
but the kernel patches for that are not quite ready yet. The test did
pass on btrfs in an earlier incarnation of the set, however.

Jeff Layton (5):
  generic: add a writeback error handling test
  ext4: allow ext4 to use $SCRATCH_LOGDEV
  generic: test writeback error handling on dmerror devices
  ext3: allow it to put journal on a separate device when doing
    scratch_mkfs
  btrfs: allow it to use $SCRATCH_LOGDEV

 common/dmerror             |  13 ++--
 common/rc                  |  16 ++++-
 doc/auxiliary-programs.txt |   8 +++
 src/Makefile               |   2 +-
 src/fsync-err.c            | 161 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/998          |  64 ++++++++++++++++++
 tests/generic/998.out      |   2 +
 tests/generic/999          |  76 +++++++++++++++++++++
 tests/generic/999.out      |   3 +
 tests/generic/group        |   2 +
 tools/dmerror              |  44 +++++++++++++
 11 files changed, 384 insertions(+), 7 deletions(-)
 create mode 100644 src/fsync-err.c
 create mode 100755 tests/generic/998
 create mode 100644 tests/generic/998.out
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out
 create mode 100755 tools/dmerror

-- 
2.9.4

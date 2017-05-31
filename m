From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 00/17] fs: introduce new writeback error reporting and convert ext2 and ext4 to use it
Date: Wed, 31 May 2017 08:45:23 -0400
Message-ID: <20170531124540.8782-1-jlayton@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

v5: don't retrofit old API over the new infrastructure
    add fstype flag to indicate how wb errors are tracked within that fs
    add more function variants that take a errseq_t "since" value
    add second errseq_t to struct file to track metadata wb errors
    convert ext4 and ext2 to use the new APIs

v4: several more cleanup patches
    documentation and kerneldoc comment updates
    fix bugs in gfs2 patches
    make sync_file_range use same error reporting semantics
    bugfixes in buffer.c
    convert nfs to new scheme (maybe bogus, can be dropped)

v3: wb_err_t -> errseq_t conversion
    clean up places that re-set errors after calling filemap_* functions

v2: introduce wb_err_t, use atomics

This is v5 of the patchset to improve how we're tracking and reporting
errors that occur during pagecache writeback. The main difference in
this set from the last one is that I've stopped trying to retrofit the
old error tracking API on top of the new one. This is more work since
we'll have to touch each fs individually, but should be safer as the
"since" values used for checking errors will be more deliberate.

There are several situations where the kernel can "lose" errors that
occur during writeback, such that fsync will return success even
though it failed to write back some data previously. The basic idea
here is to have the kernel be more deliberate about the point from
which errors are checked to ensure that that doesn't happen.

An additional aim of this set is to change the behavior of fsync in
Linux to report writeback errors on all fds instead of just the first
one. This allows writers to reliably tell whether their data made it to
the backing device without having to coordinate fsync calls with other
writers.

To do this, we add a new typedef: errseq_t. This is a 32-bit value
that can store an error code, and a sequence number so we can tell
whether it has changed since we last sampled it. This allows us to
record errors in the address_space and then report those errors only
once per file description.

This set just alters block device files, ext4 and the legacy ext2
driver. If this general approach seems acceptable, then I'll start
converting other filesystems in follow-on patchsets. I'd also like
to get this into linux-next as soon as possible to ensure that we're
banging out any bugs that might be lurking here.

I also have a couple of xfstests for this as well that I'll re-post
soon.

Jeff Layton (17):
  lib: add errseq_t type and infrastructure for handling it
  fs: new infrastructure for writeback error handling and reporting
  mm: tracepoints for writeback error events
  fs: add a new fstype flag to indicate how writeback errors are tracked
  Documentation: flesh out the section in vfs.txt on storing and
    reporting writeback errors
  fs: adapt sync_file_range to new reporting infrastructure
  mm: add filemap_fdatawait_range_since and
    filemap_write_and_wait_range_since
  dax: set errors in mapping when writeback fails
  block: convert to errseq_t based writeback error tracking
  block: add sync_blockdev_since and sync_filesystem_since
  fs: add f_md_wb_err field to struct file for tracking metadata errors
  fs: allow __generic_file_fsync to support both flavors of error
    reporting
  jbd2: conditionally handle errors using errseq_t based on FS_WB_ERRSEQ
    flag
  ext4: convert to errseq_t based error tracking
  fs: add a write_one_page_since
  ext2: convert to errseq_t based writeback error tracking
  fs: convert ext2 to use write_one_page_since

 Documentation/filesystems/vfs.txt |  50 ++++++++-
 drivers/dax/device.c              |   1 +
 fs/block_dev.c                    |  29 +++++-
 fs/dax.c                          |  18 +++-
 fs/ext2/dir.c                     |  25 +++--
 fs/ext2/file.c                    |  29 ++++--
 fs/ext2/super.c                   |   2 +-
 fs/ext4/dir.c                     |   8 +-
 fs/ext4/ext4.h                    |   8 +-
 fs/ext4/extents.c                 |  24 +++--
 fs/ext4/file.c                    |   5 +-
 fs/ext4/fsync.c                   |  23 ++++-
 fs/ext4/inode.c                   |  19 ++--
 fs/ext4/ioctl.c                   |   9 +-
 fs/ext4/super.c                   |   9 +-
 fs/file_table.c                   |   1 +
 fs/internal.h                     |   8 ++
 fs/jbd2/commit.c                  |  29 ++++--
 fs/jbd2/recovery.c                |   5 +-
 fs/jbd2/transaction.c             |   1 +
 fs/libfs.c                        |  26 +++--
 fs/open.c                         |   3 +
 fs/sync.c                         |  62 +++++++++++-
 include/linux/errseq.h            |  19 ++++
 include/linux/fs.h                |  82 ++++++++++++++-
 include/linux/jbd2.h              |   3 +
 include/linux/mm.h                |   2 +
 include/linux/pagemap.h           |  32 ++++--
 include/trace/events/filemap.h    |  52 ++++++++++
 lib/Makefile                      |   2 +-
 lib/errseq.c                      | 208 ++++++++++++++++++++++++++++++++++++++
 mm/filemap.c                      | 145 ++++++++++++++++++++++++++
 mm/page-writeback.c               |  53 +++++++---
 33 files changed, 892 insertions(+), 100 deletions(-)
 create mode 100644 include/linux/errseq.h
 create mode 100644 lib/errseq.c

-- 
2.9.4

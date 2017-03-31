From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Fri, 31 Mar 2017 15:25:59 -0400
Message-ID: <20170331192603.16442-1-jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz,
        willy@infradead.org, neilb@suse.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

During LSF/MM this year, we had a discussion about the current sorry
state of writeback error reporting, and what could be done to improve
the situation. This patchset represents a first pass at the proposal
I made there.

It first adds a new set of writeback error tracking infrastructure to
ensure that errors are properly stored and reported at fsync time. It
also makes a small but significant change to ensure that writeback
errors are reported on all file descriptors, not just on the first one
where fsync is called.

Note that this is a _very_ rough draft at this point. I did some by-hand
testing with dm-error to ensure that it does the right thing there.
Mostly I'm interested in early feedback at this point -- does this basic
approach make sense?

Jeff Layton (4):
  fs: new infrastructure for writeback error handling and reporting
  dax: set errors in mapping when writeback fails
  buffer: set wb errors using both new and old infrastructure for now
  ext4: wire it up to the new writeback error reporting infrastructure

 Documentation/filesystems/vfs.txt | 14 +++++++--
 fs/buffer.c                       |  6 +++-
 fs/dax.c                          |  4 ++-
 fs/ext4/dir.c                     |  1 +
 fs/ext4/ext4.h                    |  1 +
 fs/ext4/file.c                    |  1 +
 fs/ext4/fsync.c                   | 15 +++++++---
 fs/ext4/inode.c                   |  2 +-
 fs/ext4/page-io.c                 |  4 +--
 fs/open.c                         |  3 ++
 include/linux/fs.h                |  5 ++++
 mm/filemap.c                      | 61 +++++++++++++++++++++++++++++++++++++++
 12 files changed, 106 insertions(+), 11 deletions(-)

-- 
2.9.3

From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 00/12] jbd2 optimization and bug fixes
Date: Sat,  9 Feb 2013 16:53:40 -0500
Message-ID: <1360446832-12724-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47620 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760843Ab3BIVx7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Feb 2013 16:53:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been recently looking at journalling code in ext4, and it's clear
that no one has really been through this code in a while.  It's easy to
find some easy optimization.

Some general rules of thumb that developers should keep in mind when
making changes to ext4:

1) It's important to minimize the amount of time that a handle is held
active, since a journal commit can't be closed until all handles have
been stopped.  In the ideal world, disk reads and memory allocations
should be done *before* calling ext4_journal_start().

2) It's important that number of credits needed for a particular handle
be large enough; otherwise it's possible that we run out of space in the
journal without being able to finish the handle.

3)  It's also important that we not overestimate then number of credits
needed, since otherwise we might close a transaction too early --- and
in particular, the process which starts the transaction commit process
will tend to suffer the greatest amount of latency.

Currently enabling quotas cause the number of credits required to
balloon significantly.  Most of the time we need nowhere the number of
credits which we reserve, so there's opportunity to optimize things.
(For example, we could make sure create the quota record is created in a
seprate transaction.)


Theodore Ts'o (12):
  jbd2: track request delay statistics
  jbd2: revert "jbd2: add COW fields to struct jbd2_journal_handle"
  jbd2: add tracepoints which provide per-handle statistics
  ext4: move the jbd2 wrapper functions out of super.c
  ext4: pass context information to jbd2__journal_start()
  ext4: grab page before starting transaction handle in write_begin()
  ext4: start handle at the last possible moment in ext4_unlink()
  ext4: start handle at the last possible moment in ext4_rmdir()
  ext4: fix the number of credits needed for ext4_ext_migrate()
  ext4: fix the number of credits needed for ext4_unlink() and
    ext4_rmdir()
  ext4: fix the number of credits needed for acl ops with inline data
  ext4: start handle at the last possible moment when creating inodes

 fs/ext4/acl.c               |   7 ++-
 fs/ext4/ext4.h              |  89 +++++++++++++++++++++++++-
 fs/ext4/ext4_jbd2.c         | 102 ++++++++++++++++++++++++++++++
 fs/ext4/ext4_jbd2.h         |  51 ++++++++++++---
 fs/ext4/extents.c           |  11 ++--
 fs/ext4/file.c              |   2 +-
 fs/ext4/ialloc.c            |  17 ++++-
 fs/ext4/indirect.c          |   7 ++-
 fs/ext4/inline.c            |  10 +--
 fs/ext4/inode.c             | 144 +++++++++++++++++++++++++-----------------
 fs/ext4/ioctl.c             |   4 +-
 fs/ext4/migrate.c           |  15 +++--
 fs/ext4/move_extent.c       |   2 +-
 fs/ext4/namei.c             | 150 +++++++++++++++++++++++---------------------
 fs/ext4/resize.c            |  10 +--
 fs/ext4/super.c             | 117 +++-------------------------------
 fs/ext4/xattr.c             |  11 +---
 fs/ext4/xattr.h             |  68 --------------------
 fs/jbd2/commit.c            |   8 +++
 fs/jbd2/journal.c           |  12 +++-
 fs/jbd2/transaction.c       |  29 ++++++++-
 include/linux/jbd2.h        |  41 +++++-------
 include/trace/events/jbd2.h | 106 ++++++++++++++++++++++++++++++-
 23 files changed, 621 insertions(+), 392 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b


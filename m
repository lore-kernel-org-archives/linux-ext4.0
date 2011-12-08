From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH v2 0/7] fix s_umount thaw/write and journal deadlock
Date: Thu,  8 Dec 2011 10:04:30 -0800
Message-ID: <1323367477-21685-1-git-send-email-kamal@canonical.com>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48188 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1LHSFM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Dec 2011 13:05:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks everyone for the feedback.  Here's [PATCH v2], with these notable
changes since [PATCH 0/5 resend]:
   - made bisect-safe "Freeze and thaw the journal on ext4 freeze"
   - functional change: allow read-only quota subcmds when frozen
   - added "VFS: Rename and refactor writeback_inodes_sb_if_idle"
   - split-out "VFS: Avoid read-write deadlock in try_to_writeback_inodes_sb"
   - split-out "VFS: Document s_frozen state through freeze_super"
   - dropped "VFS: Rename vfs_check_frozen()"

-----

This set of filesystem freeze/thaw deadlock patches is submitted on
behalf of the authors, Kamal Mostafa, Surbhi Palande and Valerie Aurora.
The patches fix the bug:

BugLink: https://bugs.launchpad.net/bugs/897421

Kamal Mostafa (1):
  VFS: Rename and refactor writeback_inodes_sb_if_idle

Surbhi Palande (2):
  Adding support to freeze and unfreeze a journal
  Freeze and thaw the journal on ext4 freeze

Valerie Aurora (4):

  VFS: Fix s_umount thaw/write deadlock
  VFS: Avoid read-write deadlock in try_to_writeback_inodes_sb
  VFS: Document s_frozen state through freeze_super
  Documentation: Correct s_umount state for freeze_fs/unfreeze_fs

 Documentation/filesystems/Locking |    4 +-
 fs/btrfs/extent-tree.c            |    2 +-
 fs/ext4/inode.c                   |    2 +-
 fs/ext4/super.c                   |   13 +++++-----
 fs/fs-writeback.c                 |   46 +++++++++++++++++++++---------------
 fs/jbd2/journal.c                 |    1 +
 fs/jbd2/transaction.c             |   42 +++++++++++++++++++++++++++++++++
 fs/quota/quota.c                  |   21 ++++++++++++++++-
 fs/super.c                        |   26 +++++++++++++++++++++
 fs/sync.c                         |    4 +-
 include/linux/fs.h                |    7 +++++-
 include/linux/jbd2.h              |    7 +++++
 include/linux/writeback.h         |    4 +-
 13 files changed, 143 insertions(+), 36 deletions(-)


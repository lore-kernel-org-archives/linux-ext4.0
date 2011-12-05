From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 0/5 resend] fix s_umount thaw/write and journal deadlock
Date: Mon,  5 Dec 2011 12:54:44 -0800
Message-ID: <1323118489-16326-1-git-send-email-kamal@canonical.com>
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
Received: from youngberry.canonical.com ([91.189.89.112]:53741 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab1LEUzD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2011 15:55:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[resend: This is an unchanged resend of the patches sent on 2011-11-30,
 which were apparently not delivered to some recipients.]

This set of filesystem freeze/thaw deadlock patches is submitted
on behalf of the authors, Surbhi Palande and Valerie Aurora.  The
patches fix the bug:

BugLink: https://bugs.launchpad.net/bugs/897421

Surbhi Palande (2):
  Adding support to freeze and unfreeze a journal
  Thaw the journal when you unfreeze the fs.

Valerie Aurora (3):
  VFS: Fix s_umount thaw/write deadlock
  VFS: Rename vfs_check_frozen() to
  Documentation: Correct s_umount state for

 Documentation/filesystems/Locking |    4 +-
 fs/btrfs/disk-io.c                |    4 +-
 fs/btrfs/file.c                   |    2 +-
 fs/buffer.c                       |    7 +++--
 fs/drop_caches.c                  |    8 ++++++
 fs/ext4/inode.c                   |    2 +-
 fs/ext4/super.c                   |   28 +++++++++------------
 fs/fs-writeback.c                 |   50 ++++++++++++++++++++++++------------
 fs/fuse/file.c                    |    2 +-
 fs/gfs2/file.c                    |    2 +-
 fs/jbd2/journal.c                 |    1 +
 fs/jbd2/transaction.c             |   42 +++++++++++++++++++++++++++++++
 fs/nilfs2/ioctl.c                 |    2 +-
 fs/nilfs2/segment.c               |    2 +-
 fs/ntfs/file.c                    |    2 +-
 fs/ocfs2/file.c                   |    2 +-
 fs/quota/quota.c                  |   12 ++++++++-
 fs/super.c                        |   26 +++++++++++++++++++
 fs/sync.c                         |    9 +++---
 fs/xfs/xfs_mount.h                |    2 +-
 include/linux/fs.h                |    8 ++++-
 include/linux/jbd2.h              |    7 +++++
 mm/filemap.c                      |    2 +-
 mm/filemap_xip.c                  |    2 +-
 24 files changed, 170 insertions(+), 58 deletions(-)


From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH v3 0/4] quota: add project quota support
Date: Wed, 10 Sep 2014 11:52:09 +0800
Message-ID: <CAPTn0cChSQX0MN+fhNaRyzjw668XyKuZUYgQfr9UVbmpyC2K2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62356 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaIJDwK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2014 23:52:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches propose an implementation of project quota
support for ext4. A project is an aggregate of unrelated inodes
which might scatter in different directories. Inodes belongs to a
project possesses a same identification i.e. 'project ID', just
like every inode has its user/group identification. The following
patches adds project quota as supplement to the former uer/group
quota types.

The semantics of ext4 project quota is consistent with XFS. Each
directory can have EXT4_INODE_PROJINHERIT flag set. When the
EXT4_INODE_PROJINHERIT flag of a parent directory is not set, a
newly created inode under that directory will have a default project
ID (i.e. 0). And its EXT4_INODE_PROJINHERIT flag is not set either.
When this flag is set on a directory, following rules will be kept:

1) The newly created inode under that directory will inherit both
the EXT4_INODE_PROJINHERIT flag and the project ID from its parent
directory.

2) Hard-linking a inode with different project ID into that directory
will fail with errno EXDEV.

3) Renaming a inode with different project ID into that directory
will fail with errno EXDEV. However, 'mv' command will detect this
failure and copy the renamed inode to a new inode in the directory.
Thus, this new inode will inherit both the project ID and
EXT4_INODE_PROJINHERIT flag.

4) If the project quota of that ID is being enforced, statfs() on
that directory will take the quotas as another upper limits along
with the capacity of the file system, i.e. the total block/inode
number will be the minimum of the quota limits and file system
capacity.

Changelog:
* v3 <- v2:
  - Add EXT4_INODE_PROJINHERIT semantics.
* v2 <- v1:
  - Add ioctl interface for setting/getting project;
  - Add EXT4_FEATURE_RO_COMPAT_PROJECT;
  - Add get_projid() method in struct dquot_operations;
  - Add error check of ext4_inode_projid_set/get().

v2: http://www.spinics.net/lists/linux-ext4/msg44695.html
v1: http://article.gmane.org/gmane.comp.file-systems.ext4/45153

Any comments or feedbacks are appreciated.

Regards,
                                          - Li Xi

Li Xi(4):
 quota: Adds general codes to enforces project quota limits
 ext4: Adds project ID support for ext4
 ext4: Adds project quota support for ext4
 ext4: Adds ioctl interface support for ext4 project

 Documentation/filesystems/ext4.txt |    4 +
 fs/ext4/ext4.h                     |   33 ++++++++--
 fs/ext4/ialloc.c                   |   10 +++
 fs/ext4/inode.c                    |   78 ++++++++++++++++++++-
 fs/ext4/ioctl.c                    |  100 ++++++++++++++++++++++++++
 fs/ext4/namei.c                    |   20 +++++
 fs/ext4/super.c                    |  136 +++++++++++++++++++++++++++++++++---
 fs/quota/Kconfig                   |    9 +++
 fs/quota/dquot.c                   |  123 +++++++++++++++++++++++++-------
 fs/quota/quota.c                   |    5 +-
 fs/quota/quotaio_v2.h              |    6 +-
 include/linux/quota.h              |    9 +++
 include/uapi/linux/quota.h         |    6 +-
 13 files changed, 491 insertions(+), 48 deletions(-)

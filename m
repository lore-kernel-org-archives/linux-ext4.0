From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/5] Miklos's vfs/nfs/ext4 patches in the ext4.git tree
Date: Sat, 26 Mar 2016 17:09:55 -0400
Message-ID: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I have the following patches in the ext4.git tree which I plan to push
to Linus as bug fixes during this development cycles.  Al, are you
happy with Miklos's v2 version of "fs: add file_dentrY()" patch?

Miklos Szeredi (4):
  fs: add file_dentry()
  nfs: use file_dentry()
  ext4: use dget_parent() in ext4_file_open()
  ext4: use file_dentry()

Theodore Ts'o (1):
  ext4 crypto: use dget_parent() in ext4_d_revalidate()

 fs/dcache.c            |  5 ++++-
 fs/ext4/crypto.c       | 12 ++++++++----
 fs/ext4/file.c         | 12 ++++++++----
 fs/nfs/dir.c           |  6 +++---
 fs/nfs/inode.c         |  2 +-
 fs/nfs/nfs4file.c      |  4 ++--
 fs/overlayfs/super.c   | 33 +++++++++++++++++++++++++++++++++
 include/linux/dcache.h | 10 ++++++++++
 include/linux/fs.h     | 10 ++++++++++
 9 files changed, 79 insertions(+), 15 deletions(-)

-- 
2.5.0


From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 4.19-rc5
Date: Mon, 17 Sep 2018 00:44:44 -0400
Message-ID: <20180917044444.GA29836@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[ This pull request was originally intended for 4.19-rc4, but some
  testing hiccups delayed my sending this earlier.  Given Linus's
  comments, I'm not sure whether PULL requests should be going to Linus
  or Greg, so I'm sending it to both.  -- Ted ]

The following changes since commit 863c37fcb14f8b66ea831b45fb35a53ac4a8d69e:

  ext4: remove unneeded variable "err" in ext4_mb_release_inode_pa() (2018-08-04 17:34:07 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to cce6c9f7e6029caee45c459db5b3e78fec6973cb:

  ext4, dax: set ext4_dax_aops for dax files (2018-09-15 21:37:59 -0400)

----------------------------------------------------------------
Various ext4 bug fixes; primarily making ext4 more robust against
maliciously crafted file systems, and some DAX fixes.

----------------------------------------------------------------
Eric Biggers (1):
      ext4: show test_dummy_encryption mount option in /proc/mounts

Li Dongyang (1):
      ext4: don't mark mmp buffer head dirty

Ross Zwisler (1):
      ext4: close race between direct IO and ext4_break_layouts()

Theodore Ts'o (7):
      ext4: add nonstring annotations to ext4.h
      ext4: check to make sure the rename(2)'s destination is not freed
      ext4: avoid divide by zero fault when deleting corrupted inline directories
      ext4: avoid arithemetic overflow that can trigger a BUG
      ext4: recalucate superblock checksum after updating free blocks/inodes
      ext4: fix online resize's handling of a too-small final block group
      ext4: fix online resizing for bigalloc file systems with a 1k block size

Toshi Kani (2):
      ext4, dax: add ext4_bmap to ext4_dax_aops
      ext4, dax: set ext4_dax_aops for dax files

 fs/ext4/dir.c    | 20 +++++++++-----------
 fs/ext4/ext4.h   | 20 +++++++++++++++++---
 fs/ext4/inline.c |  4 +++-
 fs/ext4/inode.c  | 20 +++++++++++---------
 fs/ext4/mmp.c    |  1 -
 fs/ext4/namei.c  |  6 ++++++
 fs/ext4/resize.c | 23 ++++++++++++++++++++++-
 fs/ext4/super.c  |  4 ++++
 8 files changed, 72 insertions(+), 26 deletions(-)

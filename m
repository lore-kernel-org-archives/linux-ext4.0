Return-Path: <SRS0=BLjJ=NW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38418 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbeKKVjk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 11 Nov 2018 16:39:40 -0500
Date: Sun, 11 Nov 2018 06:51:15 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext4 bug fixes for 4.20-rc2
Message-ID: <20181111115115.GA3085@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 33458eaba4dfe778a426df6a19b7aad2ff9f7eec:

  ext4: fix use-after-free race in ext4_remount()'s error path (2018-10-12 09:28:09 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to eb6984fa4ce2837dcb1f66720a600f31b0bb3739:

  ext4: missing !bh check in ext4_xattr_inode_write() (2018-11-09 11:34:40 -0500)

----------------------------------------------------------------
A large number of ext4 bug fixes, mostly buffer and memory leaks on
error return cleanup paths.

----------------------------------------------------------------
Theodore Ts'o (2):
      ext4: avoid possible double brelse() in add_new_gdb() on error path
      ext4: fix possible leak of sbi->s_group_desc_leak in error path

Vasily Averin (16):
      ext4: avoid potential extra brelse in setup_new_flex_group_blocks()
      ext4: add missing brelse() in set_flexbg_block_bitmap()'s error path
      ext4: add missing brelse() add_new_gdb_meta_bg()'s error path
      ext4: add missing brelse() update_backups()'s error path
      ext4: fix missing cleanup if ext4_alloc_flex_bg_array() fails while resizing
      ext4: fix possible inode leak in the retry loop of ext4_resize_fs()
      ext4: avoid buffer leak on shutdown in ext4_mark_iloc_dirty()
      ext4: avoid buffer leak in ext4_orphan_add() after prior errors
      ext4: remove unneeded brelse call in ext4_xattr_inode_update_ref()
      ext4: fix possible leak of s_journal_flag_rwsem in error path
      ext4: fix buffer leak in ext4_xattr_get_block() on error path
      ext4: release bs.bh before re-using in ext4_xattr_block_find()
      ext4: fix buffer leak in ext4_xattr_move_to_block() on error path
      ext4: fix buffer leak in ext4_expand_extra_isize_ea() on error path
      ext4: fix buffer leak in __ext4_read_dirblock() on error path
      ext4: missing !bh check in ext4_xattr_inode_write()

 fs/ext4/inode.c  |  5 +++--
 fs/ext4/namei.c  |  5 ++++-
 fs/ext4/resize.c | 28 ++++++++++++++++------------
 fs/ext4/super.c  | 17 +++++++++--------
 fs/ext4/xattr.c  | 27 +++++++++++++++++++--------
 5 files changed, 51 insertions(+), 31 deletions(-)

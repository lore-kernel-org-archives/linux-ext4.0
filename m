From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/4] ext4 inline cleanup patches
Date: Wed, 11 Jan 2017 22:49:33 -0500
Message-ID: <20170112034938.5934-1-tytso@mit.edu>
Cc: linux@sciencehorizons.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37308 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752245AbdALDtt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 11 Jan 2017 22:49:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

George Spelvin reported a deadlock problem when using a file system
with inline data enabled when it tries to expand the inode's extra
inode field space.  The second patch is the critical one; the last two
are some cleanups.

Theodore Ts'o (4):
  ext4: add debug_want_extra_isize mount option
  ext4: fix deadlock between inline_data and
    ext4_expand_extra_isize_ea()
  ext4: avoid calling ext4_mark_inode_dirty() under unneeded semaphores
  ext4: propagate error values from ext4_inline_data_truncate()

 fs/ext4/ext4.h   |   2 +-
 fs/ext4/inline.c | 111 +++++++++++++++++++++++++++----------------------------
 fs/ext4/inode.c  |   6 ++-
 fs/ext4/super.c  |   9 ++++-
 fs/ext4/xattr.c  |  30 ++++++---------
 fs/ext4/xattr.h  |  32 ++++++++++++++++
 6 files changed, 110 insertions(+), 80 deletions(-)

-- 
2.11.0.rc0.7.gbe5a750


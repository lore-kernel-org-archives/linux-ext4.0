From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/3] Clean up the EXT4_STATE_DELALLOC_RESERVED state flag
Date: Tue,  2 Sep 2014 18:05:46 -0400
Message-ID: <1409695549-18605-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33732 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbaIBWoB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 18:44:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is another in the series of cleanup patches that address some
long-standing nits/annoyances in the ext4 code base.

I'm sure it won't last, since there are some feature patches being
worked on, but the ext4 tree is currently 500 lines of code lighter than
at the beginning of this development cycle (and this is including the
200 lines added to support /proc/fs/ext4/.../es_shrinker_info).   Most
of the savings came from Dmitry's refactor of ext4_move_extents().

Theodore Ts'o (3):
  ext4: pass allocation_request struct to ext4_(alloc,splice)_branch
  ext4: prepare to drop EXT4_STATE_DELALLOC_RESERVED
  ext4: drop the EXT4_STATE_DELALLOC_RESERVED flag

 fs/ext4/balloc.c   |  3 +-
 fs/ext4/ext4.h     |  1 -
 fs/ext4/extents.c  |  6 +++-
 fs/ext4/indirect.c | 86 ++++++++++++++++++++++++++----------------------------
 fs/ext4/inode.c    | 20 +++----------
 fs/ext4/mballoc.c  | 12 ++------
 fs/ext4/xattr.c    |  6 ----
 7 files changed, 54 insertions(+), 80 deletions(-)

-- 
2.1.0


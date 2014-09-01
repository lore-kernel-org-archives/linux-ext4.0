From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 00/10] ext4: clean up ext4_ext_find_extent()
Date: Mon,  1 Sep 2014 00:06:41 -0400
Message-ID: <1409544411-31544-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58472 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaIAEG5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 00:06:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set fixes a potential memory leak in the error path handling
for ext4_fill_fiemap_extents().  More importantly, it makes the code
clearer so that easier to understand and audit.  The resulting code is
also tighter, both in lines of codes and bytes of compiled object code.
It also avoids some unnecessarily memory allocation and free operations.

Theodore Ts'o (10):
  ext4: teach ext4_ext_find_extent() to free path on error
  ext4: collapse ext4_convert_initialized_extents()
  ext4: drop EXT4_EX_NOFREE_ON_ERR in convert_initialized_extent()
  ext4: drop EXT4_EX_NOFREE_ON_ERR from rest of extents handling code
  ext4: call ext4_ext_drop_refs() from ext4_ext_find_extent()
  ext4: allow a NULL argument to ext4_ext_drop_refs()
  ext4: teach ext4_ext_find_extent() to realloc path if necessary
  ext4: reuse path object in ext4_ext_shift_extents()
  ext4: reuse path object in ext4_move_extents()
  ext4: rename ext4_ext_find_extent() to ext4_find_extent()

 fs/ext4/ext4.h           |  10 +-
 fs/ext4/ext4_extents.h   |   1 +
 fs/ext4/extents.c        | 360 +++++++++++++++++++++--------------------------
 fs/ext4/extents_status.c |   8 +-
 fs/ext4/migrate.c        |  11 +-
 fs/ext4/move_extent.c    |  43 +++---
 6 files changed, 194 insertions(+), 239 deletions(-)

-- 
2.1.0


From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/6] Clean up error handling in fs/ext4/namei.c
Date: Fri, 22 Aug 2014 03:29:44 -0400
Message-ID: <1408692590-13346-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44051 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889AbaHVHaB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 03:30:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series cleans up the error handling in ext4's namei.c file to
use the ERR_PTR convention intead of using a separate int * to return
the error code.  (This code comes from ext3 and predates the
introduction of the ERR_PTR coding convention).

Theodore Ts'o (6):
  ext4: propagate errors up to ext4_find_entry()'s callers
  ext4: convert ext4_dx_find_entry() to use the ERR_PTR convention
  ext4: change ext4_getblk() to use the ERR_PTR convention
  ext4: convert ext4_bread() to use the ERR_PTR convention
  ext4: convert dx_probe() to use ERR_PTR convention
  ext4: convert do_split() to use ERR_PTR convention

 fs/ext4/dir.c   |   8 +--
 fs/ext4/ext4.h  |   6 +-
 fs/ext4/inode.c |  55 +++++++--------
 fs/ext4/namei.c | 210 +++++++++++++++++++++++++++++---------------------------
 fs/ext4/super.c |  18 +++--
 5 files changed, 145 insertions(+), 152 deletions(-)

-- 
2.1.0


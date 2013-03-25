From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/7] ext4 code simplification and clean ups
Date: Sun, 24 Mar 2013 20:06:47 -0400
Message-ID: <1364170014-10295-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55502 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab3CYAG5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Mar 2013 20:06:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I posted an earlier version of the first couple of patches while we were
stablizing ext4 during the last merge window.  I've since done some
further cleanup and rebased these patches v3.9-rc4.

I've also added Zheng's recent patch to clean up ext4_write_end()'s.

Finally, I've added some debugging annotations to make it easier to find
bugs when doing future development work.

Theodore Ts'o (6):
  ext4: collapse handling of data=ordered and data=writeback codepaths
  ext4: fold ext4_alloc_blocks() in ext4_alloc_branch()
  ext4: refactor punch hole code
  ext4: refactor truncate code
  ext4: add mutex_is_locked() assertion to ext4_truncate()
  ext4: add might_sleep() annotations

Zheng Liu (1):
  ext4: fold ext4_generic_write_end() into ext4_write_end()

 fs/ext4/ext4.h              |  12 +-
 fs/ext4/ext4_jbd2.c         |   6 +
 fs/ext4/extents.c           | 245 +----------------------
 fs/ext4/indirect.c          | 473 +++++---------------------------------------
 fs/ext4/inode.c             | 433 ++++++++++++++++++++++++++++------------
 fs/ext4/mballoc.c           |   4 +
 include/trace/events/ext4.h |  10 +-
 7 files changed, 376 insertions(+), 807 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b


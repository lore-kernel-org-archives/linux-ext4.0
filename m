From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/5 v2] add extent status tree caching
Date: Tue, 16 Jul 2013 11:17:58 -0400
Message-ID: <1373987883-4466-1-git-send-email-tytso@mit.edu>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38275 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827Ab3GPPSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jul 2013 11:18:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In addition to fixing a few bugs and addressing review comments, we now
add a new ioctl, EXT4_IOC_PRECACHE_EXTENTS, which forces all of the
extents in an inode to be cached in the extents status tree, and marks
them to be preferentially protected when under memory pressure.  

This is critically important when using AIO to a preallocated file,
since if we need to read in blocks from the extent tree, the
io_submit(2) system call becomes synchronous, which is rather rude to
applications which were expecting the AIO to be "A".

As a bonus, using the extent status tree to store the logical to
physical block mapping is usually more compact that having to keep one
or more extent tree blocks in the buffer cache.

(Should we do this all the time, instead of when the application
explicitly requests it?  Maybe; there could be cases with very large,
fragmented files accessed by an application such as "file" is only needs
to look at a small subset of the file where this could result in an
unnecessary work and memory allocated.  OTOH, 95%+ of the time this
would probably be a win...)


Theodore Ts'o (5):
  ext4: refactor code to read the extent tree block
  ext4: print the block number of invalid extent tree blocks
  ext4: use unsigned int for es_status values
  ext4: cache all of an extent tree's leaf block upon reading
  ext4: add new ioctl EXT4_IOC_PRECACHE_EXTENTS

 fs/ext4/ext4.h              |  19 +++-
 fs/ext4/extents.c           | 259 +++++++++++++++++++++++++++++---------------
 fs/ext4/extents_status.c    |  52 ++++++++-
 fs/ext4/extents_status.h    |  50 +++++----
 fs/ext4/inode.c             |   6 +-
 fs/ext4/ioctl.c             |   3 +
 fs/ext4/migrate.c           |   2 +-
 fs/ext4/move_extent.c       |   2 +-
 include/trace/events/ext4.h |  28 +++--
 9 files changed, 296 insertions(+), 125 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b


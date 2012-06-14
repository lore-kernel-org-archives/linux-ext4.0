From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH v2 0/3] ext4: dio overwrite nolock
Date: Thu, 14 Jun 2012 11:32:07 +0800
Message-ID: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37650 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FNDY2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 23:24:28 -0400
Received: by pbbrp8 with SMTP id rp8so3174066pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2012 20:24:27 -0700 (PDT)
CC: Tao Ma <tm@tao.ma>
CC: Eric Sandeen <sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello list,

Here is the second version of dio overwrite nolock.  In this version, I rework
the stuff as Eric said in order to avoid to copy almost all of
__generic_file_aio_write back into ext4.  Meanwhile, I fix some problems
according to Tao's reply.

This patch set can improve the performance of ext4 when the user does a dio
overwrite because, when a dio overwrite occurs, we don't need to take i_mutex
lock in some conditons.  The condition includes the size of file doesn't be
changed, no buffered I/O and align aio.  So dio write can be parallelized in
these conditions.

In patch 1, ext4_file_dio_write is defined to split buffered I/O and direct I/O
in ext4_file_write so that some code can be added to check whether we can do a
dio overwrite without i_mutex lock later.

In patch 2, a new flag called EXT4_GET_BLOCKS_NOLOCK and a new get_block
function that is named ext4_get_block_write_nolock are defined to do a lookup to
let me know whether the extent of the file at this offset has been initialized
because we need to know whether a dio overwrite needs to modify the metadata of
the file or not.

In patch 3, we implement dio overwrite nolock.  In ext4_file_dio_write, we check
whether we can do a dio overwrite without lock.  Then we use 'iocb->private'
to store this flag to tell ext4_ext_direct_IO to handle it because
file_update_time will start a new journal and it will cause a deadlock.  So we
need to finish to update file time with i_mutex lock, and release lock in
ext4_ext_direct_IO.

v2 <- v1:
 * rebase to 3.5
 * rework ext4_file_dio_write to avoid to copy vfs's code back into ext4
 * add some comments to explain how to determine whether we can do a nolocking
   overwrite dio

In this thread [1], it is the first version of patchset.
1. http://www.spinics.net/lists/linux-ext4/msg31859.html

Regards,
Zheng

Zheng Liu (3):
      ext4: split ext4_file_write into buffered IO and direct IO
      ext4: add a new flag for ext4_map_blocks
      ext4: add dio overwrite nolock

 fs/ext4/ext4.h  |    2 +
 fs/ext4/file.c  |  109 ++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/ext4/inode.c |   86 ++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 165 insertions(+), 32 deletions(-)

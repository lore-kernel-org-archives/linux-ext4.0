From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/3 v3] ext4: dio overwrite nolock
Date: Sun,  1 Jul 2012 22:21:43 +0800
Message-ID: <1341152506-32649-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43746 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2GAONi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 10:13:38 -0400
Received: by dady13 with SMTP id y13so6337998dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 07:13:38 -0700 (PDT)
CC: Tao Ma <tm@tao.ma>
CC: Eric Sandeen <sandeen@redhat.com>
CC: Robin Dong <hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello list,

Here is the third version of dio overwrite nolock.  In this version, I rework
some codes according to Robin's reply.

This patch set can improve the performance of ext4 when the user does a dio
overwrite because, when a dio overwrite occurs, we don't need to take i_mutex
lock in some conditons.  The condition includes the size of file doesn't be
changed, and align aio.  So dio write can be parallelized in these conditions.

In patch 1, ext4_file_dio_write is defined to split buffered I/O and direct I/O
in ext4_file_write so that some codes can be added to check whether we can do a
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

v3 <- v2:
 * change the condition check of dio overwrite nolock in ext4_file_dio_write
 * rename 'create' variable to 'flags' in ext4_get_block_write_nolock
 * remove a duplicated if statement in ext4_ext_direct_IO

v2 <- v1:
 * rebase to 3.5
 * rework ext4_file_dio_write to avoid to copy vfs's code back into ext4
 * add some comments to explain how to determine whether we can do a nolocking
   overwrite dio

Any comments are welcomed.  Thanks.

Regards,
Zheng

Zheng Liu (3):
      ext4: split ext4_file_write into buffered IO and direct IO
      ext4: add a new flag for ext4_map_blocks
      ext4: add dio overwrite nolock

 fs/ext4/ext4.h  |    2 +
 fs/ext4/file.c  |  107 +++++++++++++++++++++++++++++++++++++++++++-----------
 fs/ext4/inode.c |   76 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 153 insertions(+), 32 deletions(-)

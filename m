From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/8 v3] ext4: extent status tree (step 1)
Date: Fri, 26 Oct 2012 21:23:37 +0800
Message-ID: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, hughd@google.com, xiaoqiangnk@gmail.com,
	achender@linux.vnet.ibm.com, lczerner@redhat.com,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, jeff.liu@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52319 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab2JZNMm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 09:12:42 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1922583pad.19
        for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2012 06:12:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here is the v3 of extent status tree.  In this version, the biggest change is
the i_es_lock (a rwlock_t) instead of i_data_sem, which is introduced to protect
extent status tree.  Moreover I improve the SEEK_DATA/SEEK_HOLE.  In previous
version, the unwritten extent is as a data, and now it will lookup page cache to
determine it as a data or a hole.  When it has some data at the given range, the
unwritten extent will be as a data.  Otherwise, it will be as a hole.  Other
changes contain some bug fixes.

About introduction of extent status tree and future works in step2, please see
the comments in patch 2.

Here is a defect after introducing SEEK_DATA/SEEK_HOLE support, which will cause
xfstest #285 failure when the file is block-mapped because in ext4 fallocate(2)
is not supported by block-mapped file.  However, in current version of xfstest,
it cannot trigger any failure because in xfstest the test case has a bug that
will cause no error is reported from #285.  I have submitted a patch to fix it,
but it still doesn't be applied.  Thus, if someone are willing to test
SEEK_DATA/SEEK_HOLE patch, please apply this patch firstly [1].

1. http://patchwork.xfs.org/patch/4276/

I really thanks Jeff Liu, who gives me some advices and inspires me about
SEEK_DATA/SEEK_HOLE improvement, and the function, which looks up page cache to
determine whether an unwritten extent is as a data or a hole, is inspired by
his work for xfs (d126d43f631f996daeee5006714fed914be32368).  Thus, I add a
Signed-off-by for his crediting.

Jeff, I really appreicate if you could allow me to add Signed-off-by in patch 8.
If doing like this is incorrect, please let me know.  Thanks!

v3 <- v2:
 - add rwlock to protect extent status tree
 - improve SEEK_DATA/SEEK_HOLE
 - fix some bugs

Here is the second version:
http://lwn.net/Articles/512899/ 

v2 <- v1:
 - add a BUG_ON to do a sanity check in extent_status_end
 - fix off-by-one problem in extent_status_end accroding to Lukas's comment
 - add more detailed comments in ext4_es_find_extent
 - try to lookup in extent tree cache firstly in ext4_es_find_extent
 - rename ext4_es_add_space to ext4_es_insert_extent
 - rename ext4_es_remove_space to ext4_es_remove_extent

The first version is in this link:
http://www.spinics.net/lists/linux-ext4/msg33101.html

Any feedbacks are appreciated.  Thanks!

Regards,
Zheng
---
Zheng Liu (8):
      ext4: add two structures supporting extent status tree
      ext4: add operations on extent status tree
      ext4: initialize extent status tree
      ext4: let ext4 maintain extent status tree
      ext4: add some tracepoints in extent status tree
      ext4: reimplement ext4_find_delay_alloc_range on extent status tree
      ext4: reimplement fiemap on extent status tree
      ext4: introduce lseek SEEK_DATA/SEEK_HOLE support

 fs/ext4/Makefile            |   2 +-
 fs/ext4/ext4.h              |  10 +-
 fs/ext4/ext4_extents.h      |   3 +-
 fs/ext4/extents.c           | 305 +++++-----------------------------
 fs/ext4/extents_status.c    | 499 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/extents_status.h    |  45 +++++
 fs/ext4/file.c              | 334 ++++++++++++++++++++++++++++++++++++-
 fs/ext4/indirect.c          |   1 +
 fs/ext4/inode.c             |  91 ++++------
 fs/ext4/super.c             |  14 +-
 include/trace/events/ext4.h | 101 +++++++++++
 11 files changed, 1078 insertions(+), 327 deletions(-)

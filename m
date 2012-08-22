From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 0/8 v2] ext4: extent status tree (step 1)
Date: Wed, 22 Aug 2012 14:05:37 +0800
Message-ID: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

Here is the v2 of extent status tree.  In this version, the biggest change is
that the patch set is divided into two parts.  One is in this patch set, which
contains the mature code, and another is about punching hole improvement, which
will be sent out later.  One reason is that I hope these mature codes can be
reviewed and applied ASAP.  Another reason is that the patch set of punching
hole improvement is more relative indenpendent, and Lukas has finished some
works on it.  Meanwhile thses patches are still under disscussion.

Extent status tree is a rb-tree per-inode, which records the delay extent in
memory.  After adding this tree, there are some problems that can be fixed in
ext4, such as simplifing bigalloc quota reservation and fiemap implementation,
adding SEEK_DATA/SEEK_HOLE support.

In patch 1-5, extent status tree is added in order to identify a dealy extent.

In patch 6, Fiemap is improved.  Now we only need to lookup extent status tree
to find a delay extent rather than looking up page cache.

In patch 7, ext4_find_delay_alloc_range is improved using extent status tree to
avoid to lookup page cache.

In patch 8, We introduce lseek SEEK_DATA/SEEK_HOLE support.

v2 <- v1:
 - add a BUG_ON to do a sanity check in extent_status_end
 - fix off-by-one problem in extent_status_end accroding to Lukas's comment
 - add more detailed comments in ext4_es_find_extent
 - try to lookup in extent tree cache firstly in ext4_es_find_extent
 - rename ext4_es_add_space to ext4_es_insert_extent
 - rename ext4_es_remove_space to ext4_es_remove_extent

The first version is in this link:
1. http://www.spinics.net/lists/linux-ext4/msg33101.html

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
      ext4: reimplement fiemap on extent status tree
      ext4: reimplement ext4_find_delay_alloc_range on extent status tree
      ext4: introduce lseek SEEK_DATA/SEEK_HOLE support

 fs/ext4/Makefile            |   2 +-
 fs/ext4/ext4.h              |  10 +-
 fs/ext4/ext4_extents.h      |   3 +-
 fs/ext4/extents.c           | 302 +++++--------------------------------
 fs/ext4/extents_status.c    | 442 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/extents_status.h    |  45 ++++++
 fs/ext4/file.c              | 153 ++++++++++++++++++-
 fs/ext4/indirect.c          |   4 +-
 fs/ext4/inode.c             |  83 ++++-------
 fs/ext4/super.c             |  13 +-
 include/trace/events/ext4.h | 101 +++++++++++++
 11 files changed, 830 insertions(+), 328 deletions(-)

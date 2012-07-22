From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 00/10 v1][RESEND] ext4: extent status tree (step 1)
Date: Sun, 22 Jul 2012 15:59:36 +0800
Message-ID: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com>
Cc: xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[Sorry, it is my fault because the title of patches is out of order.  So I
re-send this patch set]

Hi all,

As these links described and discussed [1-3], this is my first try to implement
extent status tree in ext4.  Although now maybe it is not perfect, I think that
it should be sent out as soon as possible because some one can review these
patches earlier and give me some feedbacks.  So I really appreciate if you can
review and comment this patch set.  Thanks.

This patch set is based-on Yongqiang's and Allison's work.  Thank you for your
excellent work.  Meanwhile I don't change its name from extent status tree to io
tree.  If most developers think that we should change it, I will fix it in next
version.  As previous discussion, extent status tree will bring a lot of
benifits for us, which includes bug fix, improvements and range locking.  In
first step, this patch set aims at improving fiemap implementation and quota
reservation in bigalloc, simplifying punching hole implementation, and
introducing SEEK_DATA/SEEK_HOLE support.

Extent status tree is used to identify a delay extent in ext4.  It aims at
providing a efficient method to lookup some blocks whether these blocks are
belong to a delay extent or not.  If without extent status tree, ext4 needs to
lookup page cache.  So it is too complicated and inefficient.  About the
detailed information, please feel free to see the second patch.  In comment of
the head of this patch it describes the extent status tree in detailed.

Patch [1-5]:
  Extent status tree is added in ext4 in order to identify a delay extent.
Patch [6]:
  Fiemap is re-implemented.  Now we only need to lookup extent status tree to
  find a delay extent rather than lookup page cache.
Patch [7]:
  ext4_find_delay_alloc_range is reworked using extent status tree to avoid to
  lookup page cache.
Patch [8]:
  Introduce lseek SEEK_DATA/SEEK_HOLE support.
Patch [9-10]:
  Avoid writeot all dirty pages in punching a hole, and add two tracepoints in
  ext4_ext_punch_hole

1. http://www.spinics.net/lists/linux-ext4/msg31742.html
2. http://www.spinics.net/lists/linux-ext4/msg32661.html
3. http://www.spinics.net/lists/linux-ext4/msg30281.html

Regards,
Zheng

Zheng Liu (10):
      ext4: add two structures supporting extent status tree
      ext4: add operations on extent status tree
      ext4: initialize extent status tree
      ext4: let ext4 maintain extent status tree
      ext4: add some tracepoints in extent status tree
      ext4: reimplement fiemap on extent status tree
      ext4: reimplement ext4_find_delay_alloc_range on extent status tree
      ext4: introduce lseek SEEK_DATA/SEEK_HOLE support
      ext4: don't need to writeout all dirty pages in punch hole
      ext4: add two tracepoints in punching hole

 fs/ext4/Makefile            |    2 +-
 fs/ext4/ext4.h              |   10 +-
 fs/ext4/ext4_extents.h      |    3 +-
 fs/ext4/extents.c           |  331 ++++++----------------------------
 fs/ext4/extents_status.c    |  426 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/extents_status.h    |   39 ++++
 fs/ext4/file.c              |  152 +++++++++++++++-
 fs/ext4/indirect.c          |    4 +-
 fs/ext4/inode.c             |   83 +++------
 fs/ext4/super.c             |   13 ++-
 include/trace/events/ext4.h |  154 ++++++++++++++++
 11 files changed, 874 insertions(+), 343 deletions(-)

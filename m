From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/3] ext4: punching hole improvement
Date: Thu, 23 Aug 2012 12:25:38 +0800
Message-ID: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
CC: Lukas Czerner <lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all, 

In this patch set, punching hole feature is improved.  The improvements are as
below.

 - add block-based file punching hole support
 - add tracepoint in punching hole

In patch 1, it introduces punching hole feature for block-based file.

In patch 2, we check FALLOC_FL_PUNCH_HOLE flag firstly in ext4_fallocate to
fully enable punching hole feature for extent-based file and block-based file.

In patch 3, a tracepoint is added in ext4_punch_hole.

Currently, Lukas has finished some patches that improves the punching hole
feature in this thread [1].  So I will try to avoid to bring conflicts with his
works.

1. http://www.spinics.net/lists/linux-ext4/msg33158.html

Please feel free to comment these patches.  Thanks!

Regards,
Zheng
---
Zheng Liu (3)
      ext4: add block-based file punching hole support
      ext4: let us fully support punching hole feature in fallocate
      ext4: add tracepoint in punching hole

 fs/ext4/ext4.h              |   1 +
 fs/ext4/extents.c           |  15 +-
 fs/ext4/indirect.c          | 462 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c             |   8 +-
 include/trace/events/ext4.h |  25 +++
 5 files changed, 500 insertions(+), 11 deletions(-)

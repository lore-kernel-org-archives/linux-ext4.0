Return-Path: <SRS0=T+aA=MK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-yw1-f53.google.com ([209.85.161.53]:42575 "EHLO
        mail-yw1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbeI1WsD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2018 18:48:03 -0400
Received: by mail-yw1-f53.google.com with SMTP id h134-v6so2850051ywc.9
        for <linux-ext4@vger.kernel.org>; Fri, 28 Sep 2018 09:23:32 -0700 (PDT)
From: Eric Whitney <enwlinux@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH v3 0/6] ext4: rework bigalloc reserved cluster accounting
Date: Fri, 28 Sep 2018 12:23:10 -0400
Message-Id: <20180928162316.16480-1-enwlinux@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4 can make gross overestimates of the number of reserved clusters
required to handle bigalloc write requests under delayed allocation,
resulting in premature ENOSPC and quota limit failures.

These patches fix the implementation of reserved cluster accounting for
bigalloc file systems configured to use delayed allocation, and fix the
specific bugs described in bugzilla #151491.

v2: Moved functionality that revises pending reservations after
    block/cluster allocation into ext4_es_insert_extent under
    i_es_lock to maintain pending reservation and extents status
    tree consistency.  Renamed ext4_es_is_delunwrit to more
    appropriate ext4_es_is_delonly.  Fixed unwritten extent handling
    bugs resulting in generic/112 failures.

v3: Moved definition for new function ext4_es_is_delonly from patch
    4 to patch 3 to avoid a compilation error in the event of bisection,
    as detected/reported by kbuild testing.

Eric Whitney (6):
  ext4: generalize extents status tree search functions
  ext4: add new pending reservation mechanism
  ext4: fix reserved cluster accounting at delayed write time
  ext4: reduce reserved cluster count by number of allocated clusters
  ext4: adjust reserved cluster count when removing extents
  ext4: fix reserved cluster accounting at page invalidation time

 fs/ext4/ext4.h              |  10 +-
 fs/ext4/ext4_extents.h      |  13 +
 fs/ext4/extents.c           | 595 +++++++++++++++++++---------------------
 fs/ext4/extents_status.c    | 654 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/extents_status.h    |  80 +++++-
 fs/ext4/inode.c             | 113 +++++---
 fs/ext4/mballoc.c           |  14 +-
 fs/ext4/super.c             |   8 +
 include/trace/events/ext4.h |  99 +++++--
 9 files changed, 1188 insertions(+), 398 deletions(-)

-- 
2.11.0

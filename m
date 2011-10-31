From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V3 0/6] ext4: add delayed extent tree for ext4
Date: Mon, 31 Oct 2011 08:55:41 +0800
Message-ID: <1320022547-2284-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58444 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1JaC76 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 22:59:58 -0400
Received: by iaby12 with SMTP id y12so6677937iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 19:59:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
  This patch series add delayed extent tree support for ext4.  More
documentation please refer to fs/ext4/delayed_extents.c which is in
the 2nd patch.

  V2->V3:
        reimplement find_delay_alloc_range on delayed extent tree(PATCH 6).

  V1->V2:
        change list to rb tree.
git diff --stat

 fs/ext4/Makefile          |    2 +-
 fs/ext4/delayed_extents.c |  415 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/delayed_extents.h |   40 +++++
 fs/ext4/ext4.h            |    9 +-
 fs/ext4/ext4_extents.h    |    3 +-
 fs/ext4/extents.c         |  297 ++++----------------------------
 fs/ext4/indirect.c        |    3 +
 fs/ext4/inode.c           |   83 +++------
 fs/ext4/super.c           |   13 ++-
 9 files changed, 543 insertions(+), 322 deletions(-)

[PATCH V3 1/6] ext4: add two structures supporting delayed extent
[PATCH V3 2/6] ext4: add operations on delayed extent tree
[PATCH V3 3/6] ext4: initialize delayed extent tree
[PATCH V3 4/6] ext4: let ext4 maintian delayed extent trees
[PATCH V3 5/6] ext4: reimplement fiemap on delayed extent tree
[PATCH V3 6/6] ext4: reimplement ext4_find_delay_alloc_range on

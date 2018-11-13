Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:43293 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKAj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 13 Nov 2018 05:00:39 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 00/10] fix coding style for ext2 filesystem
Date: Tue, 13 Nov 2018 08:04:38 +0800
Message-Id: <20181113000448.16023-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set fixes some coding style warnings which are from
checkpatch.pl.

Detail warning/error messages are below:

WARNING: function definition argument 'struct inode *' should
also have an identifier name

WARNING: space prohibited between function name and open
parenthesis '(' 

WARNING: line over 80 characters

ERROR: "foo * bar" should be "foo *bar"

---

Chengguang Xu (10):
  ext2: fix coding style for acl.h
  ext2: fix coding style for balloc.c
  ext2: fix coding style for dir.c
  ext2: fix coding style for ext2.h
  ext2: fix coding style for inode.c
  ext2: fix coding style for file.c
  ext2: fix coding style for ialloc.c
  ext2: fix coding style for namei.c
  ext2: fix coding style for super.c
  ext2: fix coding style for xattr.c

 fs/ext2/acl.h    |   4 +-
 fs/ext2/balloc.c |  34 ++++++++--------
 fs/ext2/dir.c    |  18 ++++-----
 fs/ext2/ext2.h   | 100 +++++++++++++++++++++++++++--------------------
 fs/ext2/file.c   |   2 +-
 fs/ext2/ialloc.c |  18 ++++-----
 fs/ext2/inode.c  |  12 +++---
 fs/ext2/namei.c  |  55 ++++++++++++++------------
 fs/ext2/super.c  |  26 ++++++------
 fs/ext2/xattr.c  |  17 ++++----
 10 files changed, 152 insertions(+), 134 deletions(-)

-- 
2.17.2

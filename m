Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbeKSPqF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 19 Nov 2018 10:46:05 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAJ5EenJ038710
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2018 00:23:34 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2nujb5t5yp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2018 00:23:34 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 19 Nov 2018 05:23:34 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, ebiggers@kernel.org,
        tytso@mit.edu
Subject: [PATCH 0/7] Remove fs specific fscrypt and fsverity build config options
Date: Mon, 19 Nov 2018 10:53:17 +0530
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20181119052324.31456-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As a first step to avoid copy-pasting common code across filesystems
which implement fscrypt/fsverity, this commit removes filesystem
specific build config option (CONFIG_EXT4_FS_ENCRYPTION,
CONFIG_EXT4_FS_VERITY, CONFIG_F2FS_FS_ENCRYPTION and
CONFIG_F2FS_FS_VERITY) and replaces it with build options
(CONFIG_FS_ENCRYPTION and CONFIG_FS_VERITY) whose values affect all
the filesystems making use of fscrypt and fsverity. This is done in
order to have a common code base for implementing "post read"
processing across filesystems.

Changelog:
RFC -> V1:
1. Add a new patch to implement S_VERITY/IS_VERITY().
2. Split code that replaces filesystem specific routines with generic
   IS_ENCRYPTED() and IS_VERITY() calls into separate patches.

Chandan Rajendra (7):
  ext4: use IS_ENCRYPTED() to check encryption status
  f2fs: use IS_ENCRYPTED() to check encryption status
  fscrypt: Remove filesystem specific build config option
  Add S_VERITY and IS_VERITY()
  ext4: use IS_VERITY() to check inode's fsverity status
  f2fs: use IS_VERITY() to check inode's fsverity status
  fsverity: Remove filesystem specific build config option

 fs/crypto/Kconfig               |   2 +-
 fs/ext4/Kconfig                 |  35 ---
 fs/ext4/dir.c                   |  10 +-
 fs/ext4/ext4.h                  |  23 +-
 fs/ext4/ext4_jbd2.h             |   2 +-
 fs/ext4/extents.c               |   4 +-
 fs/ext4/file.c                  |   2 +-
 fs/ext4/ialloc.c                |   2 +-
 fs/ext4/inode.c                 |  32 +--
 fs/ext4/ioctl.c                 |   4 +-
 fs/ext4/move_extent.c           |   3 +-
 fs/ext4/namei.c                 |  18 +-
 fs/ext4/page-io.c               |   8 +-
 fs/ext4/readpage.c              |  10 +-
 fs/ext4/super.c                 |  12 +-
 fs/ext4/sysfs.c                 |   8 +-
 fs/f2fs/Kconfig                 |  31 ---
 fs/f2fs/data.c                  |   6 +-
 fs/f2fs/dir.c                   |  10 +-
 fs/f2fs/f2fs.h                  |   9 +-
 fs/f2fs/file.c                  |  16 +-
 fs/f2fs/inode.c                 |   4 +-
 fs/f2fs/namei.c                 |   6 +-
 fs/f2fs/super.c                 |  14 +-
 fs/f2fs/sysfs.c                 |   8 +-
 fs/verity/Kconfig               |   2 +-
 include/linux/fs.h              |   2 +
 include/linux/fscrypt.h         | 416 +++++++++++++++++++++++++++++++-
 include/linux/fscrypt_notsupp.h | 231 ------------------
 include/linux/fscrypt_supp.h    | 204 ----------------
 include/linux/fsverity.h        |   3 +-
 31 files changed, 509 insertions(+), 628 deletions(-)
 delete mode 100644 include/linux/fscrypt_notsupp.h
 delete mode 100644 include/linux/fscrypt_supp.h

-- 
2.19.1

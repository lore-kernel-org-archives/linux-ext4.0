Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725764AbeLDJ5H (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 04:57:07 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wB49rvj8135714
        for <linux-ext4@vger.kernel.org>; Tue, 4 Dec 2018 04:57:06 -0500
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2p5npb53ge-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 04 Dec 2018 04:57:05 -0500
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 4 Dec 2018 09:57:05 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-mips@linux-mips.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com, corbet@lwn.net, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, green.hu@gmail.com,
        deanbo422@gmail.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, richard@nod.at, dedekind1@gmail.com,
        adrian.hunter@intel.com, viro@zeniv.linux.org.uk
Subject: [PATCH V2 0/7] Remove fs specific fscrypt and fsverity build config options
Date: Tue,  4 Dec 2018 15:26:43 +0530
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20181204095650.12562-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In order to have a common code base for fscrypt & fsverity "post read"
processing across filesystems which implement fscrypt/fsverity, this
commit removes filesystem specific build config option
(CONFIG_EXT4_FS_ENCRYPTION, CONFIG_EXT4_FS_VERITY,
CONFIG_F2FS_FS_ENCRYPTION, CONFIG_F2FS_FS_VERITY and
CONFIG_UBIFS_FS_ENCRYPTION) and replaces it with build options
(CONFIG_FS_ENCRYPTION and CONFIG_FS_VERITY) whose values affect all
the filesystems making use of fscrypt and fsverity.

PS: Since I have access to only to x86 and ppc64le machines, I haven't tested the
defconfig files for other architectures.

Changelog:
V1 -> V2:
1. Address the following review comments provided by Eric Biggers,
   - In ext4_should_use_dax(), Use ext4_test_inode_flag() to check for
     fscrypt/fsverity status of an inode.
   - Update documentation associated with fscrypt & fsverity to refer to
     CONFIG_FS_ENCRYPTION and CONFIG_FS_VERITY build flags.
   - Remove filesystem specific fscrypt build configuration from defconfig
     files.
   - Provide a list of supported filesystems for CONFIG_FS_ENCRYPTION and
     CONFIG_FS_VERITY build flags.
   - Update comment describing S_VERITY flag.
2. Remove UBIFS specific encryption build option and make use of the generic
   CONFIG_FS_ENCRYPTION flag.

RFC -> V1:
1. Add a new patch to implement S_VERITY/IS_VERITY().
2. Split code that replaces filesystem specific routines with generic
   IS_ENCRYPTED() and IS_VERITY() calls into separate patches.

Chandan Rajendra (7):
  ext4: use IS_ENCRYPTED() to check encryption status
  f2fs: use IS_ENCRYPTED() to check encryption status
  fscrypt: remove filesystem specific build config option
  Add S_VERITY and IS_VERITY()
  ext4: use IS_VERITY() to check inode's fsverity status
  f2fs: use IS_VERITY() to check inode's fsverity status
  fsverity: Remove filesystem specific build config option

 Documentation/filesystems/fscrypt.rst   |   4 +-
 Documentation/filesystems/fsverity.rst  |   4 +-
 arch/mips/configs/generic_defconfig     |   2 +-
 arch/nds32/configs/defconfig            |   2 +-
 arch/s390/configs/debug_defconfig       |   2 +-
 arch/s390/configs/performance_defconfig |   2 +-
 fs/crypto/Kconfig                       |   5 +-
 fs/ext4/Kconfig                         |  35 --
 fs/ext4/dir.c                           |  10 +-
 fs/ext4/ext4.h                          |  23 +-
 fs/ext4/ext4_jbd2.h                     |   2 +-
 fs/ext4/extents.c                       |   4 +-
 fs/ext4/file.c                          |   2 +-
 fs/ext4/ialloc.c                        |   2 +-
 fs/ext4/inode.c                         |  32 +-
 fs/ext4/ioctl.c                         |   4 +-
 fs/ext4/move_extent.c                   |   3 +-
 fs/ext4/namei.c                         |  18 +-
 fs/ext4/page-io.c                       |   8 +-
 fs/ext4/readpage.c                      |  10 +-
 fs/ext4/super.c                         |  13 +-
 fs/ext4/sysfs.c                         |   8 +-
 fs/f2fs/Kconfig                         |  31 --
 fs/f2fs/data.c                          |   6 +-
 fs/f2fs/dir.c                           |  10 +-
 fs/f2fs/f2fs.h                          |   9 +-
 fs/f2fs/file.c                          |  16 +-
 fs/f2fs/inode.c                         |   4 +-
 fs/f2fs/namei.c                         |   6 +-
 fs/f2fs/super.c                         |  14 +-
 fs/f2fs/sysfs.c                         |   8 +-
 fs/ubifs/Kconfig                        |  11 -
 fs/ubifs/Makefile                       |   2 +-
 fs/ubifs/ioctl.c                        |   4 +-
 fs/ubifs/sb.c                           |   2 +-
 fs/ubifs/super.c                        |   2 +-
 fs/ubifs/ubifs.h                        |   5 +-
 fs/verity/Kconfig                       |   3 +-
 include/linux/fs.h                      |  10 +-
 include/linux/fscrypt.h                 | 416 +++++++++++++++++++++++-
 include/linux/fscrypt_notsupp.h         | 231 -------------
 include/linux/fscrypt_supp.h            | 204 ------------
 include/linux/fsverity.h                |   3 +-
 43 files changed, 532 insertions(+), 660 deletions(-)
 delete mode 100644 include/linux/fscrypt_notsupp.h
 delete mode 100644 include/linux/fscrypt_supp.h

-- 
2.19.1

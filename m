From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/8] Ext4 encryption support for blocksize < pagesize
Date: Fri, 12 Jan 2018 19:41:21 +0530
Message-ID: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44432 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933975AbeALOKa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Jan 2018 09:10:30 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0CEA538122968
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:30 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fes65fwuj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:27 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 12 Jan 2018 07:10:25 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patchset implements code to support encryption of Ext4 filesystem
instances that have blocksize less than pagesize. The patchset has
been tested on both ppc64 and x86_64 machines.

This patchset changes the prototype of the function
fscrypt_encrypt_page(). I will make the relevant changes to the rest
of the filesystems (e.g. f2fs) and post them in the next version of
the patchset.

Chandan Rajendra (8):
  ext4: use EXT4_INODE_ENCRYPT flag to detect encrypted bio
  fs/buffer.c: make some functions non-static
  ext4: decrypt all contiguous blocks in a page
  ext4: decrypt all boundary blocks when doing buffered write
  ext4: decrypt the block that needs to be partially zeroed
  ext4: encrypt blocks whose size is less than page size
  ext4: decrypt blocks whose size is less than page size
  ext4: enable encryption for blocksize less than page size

 fs/buffer.c                     |   6 +-
 fs/crypto/bio.c                 |  25 +++-
 fs/crypto/crypto.c              |  80 ++++++++----
 fs/ext4/inode.c                 |  32 +++--
 fs/ext4/page-io.c               |  58 ++++++---
 fs/ext4/readpage.c              | 275 +++++++++++++++++++++++++++++++++++++++-
 fs/ext4/super.c                 |   9 +-
 include/linux/buffer_head.h     |   4 +
 include/linux/fscrypt.h         |   1 +
 include/linux/fscrypt_notsupp.h |  19 +--
 include/linux/fscrypt_supp.h    |  14 +-
 11 files changed, 436 insertions(+), 87 deletions(-)

-- 
2.9.5

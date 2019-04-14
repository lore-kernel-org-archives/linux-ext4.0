Return-Path: <SRS0=CYDl=SQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CF1C10F13
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71B392084D
	for <linux-ext4@archiver.kernel.org>; Sun, 14 Apr 2019 11:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfDNLhX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 14 Apr 2019 07:37:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726283AbfDNLhX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 Apr 2019 07:37:23 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3EBYIMO133502
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:37:21 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ruvus376t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 14 Apr 2019 07:37:21 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Sun, 14 Apr 2019 12:37:21 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 14 Apr 2019 12:37:17 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3EBbGZD31064094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Apr 2019 11:37:16 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8179028059;
        Sun, 14 Apr 2019 11:37:16 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 121F928058;
        Sun, 14 Apr 2019 11:37:13 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.71.201])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 14 Apr 2019 11:37:12 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [RFC PATCH V2 00/14] Consolidate Post read processing code
Date:   Sun, 14 Apr 2019 17:07:50 +0530
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19041411-0060-0000-0000-0000032CAE8E
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010925; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01188935; UDB=6.00622896; IPR=6.00969712;
 MB=3.00026436; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-14 11:37:20
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041411-0061-0000-0000-000048F290A3
Message-Id: <20190414113804.26769-1-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904140086
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This patchset moves the "post read processing" code into a file of its
own (i.e. fs/post_read_process.c) and modifies the generic
do_mpage_readpge() to make use of the functionality provided.

"Post read processing" implements code to track the state machine that
needs to be executed after reading data from files that are encrypted
and/or have verity metadata associated with them.

With these changes in place, the patchset changes Ext4 to use
mpage_readpage[s] instead of its own custom ext4_readpage[s]()
functions. This is done to reduce duplicity of code across
filesystems. Also, Post read processing source files will be built
only if one of CONFIG_FS_ENCRYPTION and CONFIG_FS_VERITY is enabled.

Members of "struct fscrypt_ctx" that tracked status of a "write"
operation are now made an anonymous structure since the decryption
state tracking members are now moved into "struct post_read_ctx".

The patchset also modifies fs/buffer.c and fscrypt functionality to
get file encryption/decryption to work with subpage-sized blocks.

The following fixes from Eric Biggers are prerequisites for this
patchset,
  fscrypt: fix race where ->lookup() marks plaintext dentry as ciphertext
  fscrypt: only set dentry_operations on ciphertext dentries
  fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
  fscrypt: fix race allowing rename() and link() of ciphertext dentries
  fscrypt: clean up and improve dentry revalidation

The patches can also be obtained from,
"https://github.com/chandanr/linux.git subpage-encryption"

TODO:
1. The subset of the fscrypt_encrypt_page() that deals with
   FS_CFLG_OWN_PAGES case still needs to be tested. UBIFS seems to be the
   only user of this piece of code.
2. Verity changes needs to be added for F2FS and I will add them in the
   next patchset based on the review comments obtained for the current
   patchset.

Changelog:
RFC V1 -> RFC V2:
1. Describe the purpose of "Post processing code" in the cover letter.
2. Fix build errors when CONFIG_FS_VERITY is enabled.

Chandan Rajendra (14):
  ext4: Clear BH_Uptodate flag on decryption error
  Consolidate "post read processing" into a new file
  fsverity: Add call back to decide if verity check has to be performed
  fsverity: Add call back to determine readpage limit
  fs/mpage.c: Integrate post read processing
  ext4: Wire up ext4_readpage[s] to use mpage_readpage[s]
  Remove the term "bio" from post read processing
  Add decryption support for sub-pagesized blocks
  ext4: Decrypt all boundary blocks when doing buffered write
  ext4: Decrypt the block that needs to be partially zeroed
  fscrypt_encrypt_page: Loop across all blocks mapped by a page range
  ext4: Compute logical block and the page range to be encrypted
  fscrypt_zeroout_range: Encrypt all zeroed out blocks of a page
  ext4: Enable encryption for subpage-sized blocks

 Documentation/filesystems/fscrypt.rst |   4 +-
 fs/Makefile                           |   4 +
 fs/buffer.c                           |  85 +++--
 fs/crypto/bio.c                       | 109 ++++---
 fs/crypto/crypto.c                    |  73 +++--
 fs/crypto/fscrypt_private.h           |   3 +
 fs/ext4/Makefile                      |   2 +-
 fs/ext4/ext4.h                        |   2 -
 fs/ext4/inode.c                       |  47 ++-
 fs/ext4/page-io.c                     |   9 +-
 fs/ext4/readpage.c                    | 445 --------------------------
 fs/ext4/super.c                       |  40 ++-
 fs/f2fs/data.c                        | 148 ++-------
 fs/f2fs/super.c                       |   9 +-
 fs/mpage.c                            |  51 ++-
 fs/post_read_process.c                | 155 +++++++++
 fs/verity/verify.c                    |  12 +
 include/linux/buffer_head.h           |   1 +
 include/linux/fscrypt.h               |  20 +-
 include/linux/fsverity.h              |   2 +
 include/linux/post_read_process.h     |  22 ++
 21 files changed, 511 insertions(+), 732 deletions(-)
 delete mode 100644 fs/ext4/readpage.c
 create mode 100644 fs/post_read_process.c
 create mode 100644 include/linux/post_read_process.h

-- 
2.19.1


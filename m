Return-Path: <SRS0=geXL=QZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DCBC10F01
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 10:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562972146F
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 10:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfBRKEN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:04:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728772AbfBRKEM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Feb 2019 05:04:12 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1IA3mbf128519
        for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2019 05:04:11 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2qqs74v39f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2019 05:04:08 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 18 Feb 2019 10:04:07 -0000
Received: from b03cxnp08025.gho.boulder.ibm.com (9.17.130.17)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 18 Feb 2019 10:04:02 -0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1IA41rd29097984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Feb 2019 10:04:01 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EF39136051;
        Mon, 18 Feb 2019 10:04:01 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95241136055;
        Mon, 18 Feb 2019 10:03:58 +0000 (GMT)
Received: from localhost.in.ibm.com (unknown [9.124.35.115])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 18 Feb 2019 10:03:58 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: [RFC PATCH 00/10] Consolidate Post read processing code
Date:   Mon, 18 Feb 2019 15:34:23 +0530
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19021810-0016-0000-0000-000009858C40
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010619; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000280; SDB=6.01162773; UDB=6.00607074; IPR=6.00943349;
 MB=3.00025633; MTD=3.00000008; XFM=3.00000015; UTC=2019-02-18 10:04:06
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19021810-0017-0000-0000-00004230B5F7
Message-Id: <20190218100433.20048-1-chandan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-18_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902180077
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This patchset moves the "post read processing" code into a file of its
own and gets the generic do_mpage_readpge() to make use of the
functionality provided. With these changes in place, the patchset
changes Ext4 to use mpage_readpage[s] instead of its own custom
ext4_readpages() function. This is done to reduce duplicity of code
across filesystems. Based on the reviews provided for this patchset, I
will change F2FS to use mpage_readpage[s] and post the next version of
this patchset to linux-fsdevel mailing list.

The patchset also includes patches from previous postings i.e.
patches to replace per-filesystem encryption config options with a
single config option that affects all filesystems making use of
fscrypt code.

Chandan Rajendra (10):
  ext4: use IS_ENCRYPTED() to check encryption status
  f2fs: use IS_ENCRYPTED() to check encryption status
  fscrypt: remove filesystem specific build config option
  Consolidate "post read processing" into a new file
  fsverity: Add call back to decide if verity check has to be performed
  Introduce REQ_POST_READ_PROC bio flag
  fsverity: Add call back to determine readpage limit
  fsverity: Add call back to verify file holes
  fs/mpage.c: Integrate post read processing
  ext4: Wire up ext4_readpage[s] to use mpage_readpage[s]

 Documentation/filesystems/fscrypt.rst   |   4 +-
 arch/mips/configs/generic_defconfig     |   2 +-
 arch/nds32/configs/defconfig            |   2 +-
 arch/s390/configs/debug_defconfig       |   2 +-
 arch/s390/configs/performance_defconfig |   2 +-
 fs/Makefile                             |   3 +-
 fs/crypto/Kconfig                       |   5 +-
 fs/crypto/bio.c                         |  21 +-
 fs/crypto/crypto.c                      |   1 +
 fs/crypto/fscrypt_private.h             |   4 +-
 fs/ext4/Kconfig                         |  15 -
 fs/ext4/Makefile                        |   2 +-
 fs/ext4/dir.c                           |  10 +-
 fs/ext4/ext4.h                          |  14 +-
 fs/ext4/ext4_jbd2.h                     |   2 +-
 fs/ext4/extents.c                       |   4 +-
 fs/ext4/ialloc.c                        |   2 +-
 fs/ext4/inode.c                         |  29 +-
 fs/ext4/ioctl.c                         |   4 +-
 fs/ext4/move_extent.c                   |   3 +-
 fs/ext4/namei.c                         |  18 +-
 fs/ext4/page-io.c                       |   9 +-
 fs/ext4/readpage.c                      | 444 ------------------------
 fs/ext4/super.c                         |  43 ++-
 fs/ext4/sysfs.c                         |   4 +-
 fs/f2fs/Kconfig                         |  12 +-
 fs/f2fs/data.c                          |   4 +-
 fs/f2fs/dir.c                           |  10 +-
 fs/f2fs/f2fs.h                          |  14 +-
 fs/f2fs/file.c                          |  10 +-
 fs/f2fs/inode.c                         |   4 +-
 fs/f2fs/namei.c                         |   6 +-
 fs/f2fs/super.c                         |   8 +-
 fs/f2fs/sysfs.c                         |   4 +-
 fs/mpage.c                              |  77 +++-
 fs/post_read_process.c                  | 128 +++++++
 fs/ubifs/Kconfig                        |  12 +-
 fs/ubifs/Makefile                       |   2 +-
 fs/ubifs/ioctl.c                        |   4 +-
 fs/ubifs/sb.c                           |   2 +-
 fs/ubifs/super.c                        |   2 +-
 fs/ubifs/ubifs.h                        |   5 +-
 fs/verity/verify.c                      |  12 +
 include/linux/blk_types.h               |   2 +
 include/linux/fs.h                      |   4 +-
 include/linux/fscrypt.h                 | 405 ++++++++++++++++++++-
 include/linux/fscrypt_notsupp.h         | 231 ------------
 include/linux/fscrypt_supp.h            | 204 -----------
 include/linux/fsverity.h                |   3 +
 include/linux/post_read_process.h       |  21 ++
 50 files changed, 757 insertions(+), 1078 deletions(-)
 delete mode 100644 fs/ext4/readpage.c
 create mode 100644 fs/post_read_process.c
 delete mode 100644 include/linux/fscrypt_notsupp.h
 delete mode 100644 include/linux/fscrypt_supp.h
 create mode 100644 include/linux/post_read_process.h

-- 
2.19.1


Return-Path: <SRS0=4TV9=CG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6651CC433E2
	for <linux-ext4@archiver.kernel.org>; Fri, 28 Aug 2020 07:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A37C2071B
	for <linux-ext4@archiver.kernel.org>; Fri, 28 Aug 2020 07:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgH1Hcp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 28 Aug 2020 03:32:45 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32153 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726500AbgH1Hcp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2020 03:32:45 -0400
X-IronPort-AV: E=Sophos;i="5.76,362,1592841600"; 
   d="scan'208";a="98660280"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Aug 2020 15:32:41 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 8F7DF48990DD;
        Fri, 28 Aug 2020 15:32:37 +0800 (CST)
Received: from G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 28 Aug 2020 15:32:38 +0800
Received: from Fedora-31.g08.fujitsu.local (10.167.220.31) by
 G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Fri, 28 Aug 2020 15:32:38 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <darrick.wong@oracle.com>, <ira.weiny@intel.com>, <tytso@mit.edu>,
        <jack@suse.cz>, Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH] ext4: Disallow modifying DAX inode flag if inline_data has been set
Date:   Fri, 28 Aug 2020 15:15:01 +0800
Message-ID: <20200828071501.8402-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 8F7DF48990DD.A0B5A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

inline_data is mutually exclusive to DAX so enabling both of them triggers
the following issue:
------------------------------------------
# mkfs.ext4 -F -O inline_data /dev/pmem1
...
# mount /dev/pmem1 /mnt
# echo 'test' >/mnt/file
# lsattr -l /mnt/file
/mnt/file                    Inline_Data
# xfs_io -c "chattr +x" /mnt/file
# xfs_io -c "lsattr -v" /mnt/file
[dax] /mnt/file
# umount /mnt
# mount /dev/pmem1 /mnt
# cat /mnt/file
cat: /mnt/file: Numerical result out of range
------------------------------------------

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 523e00d7b392..69187b6205b2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -492,7 +492,7 @@ struct flex_groups {
 
 /* Flags which are mutually exclusive to DAX */
 #define EXT4_DAX_MUT_EXCL (EXT4_VERITY_FL | EXT4_ENCRYPT_FL |\
-			   EXT4_JOURNAL_DATA_FL)
+			   EXT4_JOURNAL_DATA_FL | EXT4_INLINE_DATA_FL)
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
-- 
2.25.1




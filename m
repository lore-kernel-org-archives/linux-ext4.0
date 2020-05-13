Return-Path: <SRS0=l1WF=63=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9EAC2D0F9
	for <linux-ext4@archiver.kernel.org>; Wed, 13 May 2020 05:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E100220659
	for <linux-ext4@archiver.kernel.org>; Wed, 13 May 2020 05:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgEMFna (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 May 2020 01:43:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:64338 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728707AbgEMFn3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 May 2020 01:43:29 -0400
IronPort-SDR: Om6q/+QO+rZNP1PcSl8pbvXfoWEyGlmhtZlSC2e+H0oB8jo9Kqx8pP2P1T4MGGW6PCDHGqqlWr
 +ysAhqwJO2zw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2020 22:43:29 -0700
IronPort-SDR: 0vwyJDiJhtRqiY2K0MYIkhU/zfhrLniB8/ZuetgCGHpRkahWn9zuhkWpDhAAVRaRGBEeYlV2P1
 otTV3D6OSVrA==
X-IronPort-AV: E=Sophos;i="5.73,386,1583222400"; 
   d="scan'208";a="262367288"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2020 22:43:29 -0700
From:   ira.weiny@intel.com
To:     linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Cc:     Ira Weiny <ira.weiny@intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] fs/ext4: Narrow scope of DAX check in setflags
Date:   Tue, 12 May 2020 22:43:16 -0700
Message-Id: <20200513054324.2138483-2-ira.weiny@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200513054324.2138483-1-ira.weiny@intel.com>
References: <20200513054324.2138483-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

When preventing DAX and journaling on an inode.  Use the effective DAX
check rather than the mount option.

This will be required to support per inode DAX flags.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/ext4/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bfc1281fc4cb..5813e5e73eab 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -393,9 +393,9 @@ static int ext4_ioctl_setflags(struct inode *inode,
 	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
 		/*
 		 * Changes to the journaling mode can cause unsafe changes to
-		 * S_DAX if we are using the DAX mount option.
+		 * S_DAX if the inode is DAX
 		 */
-		if (test_opt(inode->i_sb, DAX)) {
+		if (IS_DAX(inode)) {
 			err = -EBUSY;
 			goto flags_out;
 		}
-- 
2.25.1


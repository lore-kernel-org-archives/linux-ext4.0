Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFF6C282DD
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 19:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D7ED206BA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 19:05:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G4xFxM7r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbfDQTFG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:05:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42972 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTFG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 15:05:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HIwq4I168713;
        Wed, 17 Apr 2019 19:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=JSVLcxpxPXWyi1ygugKI5o1GQ+joQEvPfhYsIY2BSu4=;
 b=G4xFxM7r71qqe78JbXTHW4ZzrVHhjMKMrwmTw64/396HpK7/hjT+IN329tkrqq0ZG01n
 0sHwQQLYcgN4oJh9DAwYa8qzXEqfVB5W5sMq1m5Xm3q1ZXsgUinS6OTXh/WJsB3urPDQ
 7Mqx7wC94gFmj81duR6niXSi+/EzkJOaASuyzdt58KHP1LplnPoh1njZTG2Q8PqITwv4
 orQbMhXqxmJc6cmBid11/5DloPP8GP3WIhdjz+xV6WFRaO3tiZajXN43XX4JbyGqSU8y
 94QJh60JyIgqlK5lscTJx/LPUVDBq/tUmbDezNLwKF5M1kg04f/9L5GOeGkms0xZ5DmS bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2rvwk3w0c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 19:05:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HJ48D5159042;
        Wed, 17 Apr 2019 19:05:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2rwe7ak1nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 19:05:02 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HJ51of009324;
        Wed, 17 Apr 2019 19:05:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 12:05:01 -0700
Subject: [PATCH 5/8] xfs: clean up xfs_merge_ioc_xflags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org
Date:   Wed, 17 Apr 2019 12:05:00 -0700
Message-ID: <155552790055.20411.3134851745045483842.stgit@magnolia>
In-Reply-To: <155552786671.20411.6442426840435740050.stgit@magnolia>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=590
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170125
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=619 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170125
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Clean up the calling convention since we're editing the fsxattr struct
anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fdabf47532ed..5862b7cead4c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -832,35 +832,31 @@ xfs_ioc_ag_geometry(
  * Linux extended inode flags interface.
  */
 
-STATIC unsigned int
+static inline void
 xfs_merge_ioc_xflags(
-	unsigned int	flags,
-	unsigned int	start)
+	struct fsxattr	*fa,
+	unsigned int	flags)
 {
-	unsigned int	xflags = start;
-
 	if (flags & FS_IMMUTABLE_FL)
-		xflags |= FS_XFLAG_IMMUTABLE;
+		fa->fsx_xflags |= FS_XFLAG_IMMUTABLE;
 	else
-		xflags &= ~FS_XFLAG_IMMUTABLE;
+		fa->fsx_xflags &= ~FS_XFLAG_IMMUTABLE;
 	if (flags & FS_APPEND_FL)
-		xflags |= FS_XFLAG_APPEND;
+		fa->fsx_xflags |= FS_XFLAG_APPEND;
 	else
-		xflags &= ~FS_XFLAG_APPEND;
+		fa->fsx_xflags &= ~FS_XFLAG_APPEND;
 	if (flags & FS_SYNC_FL)
-		xflags |= FS_XFLAG_SYNC;
+		fa->fsx_xflags |= FS_XFLAG_SYNC;
 	else
-		xflags &= ~FS_XFLAG_SYNC;
+		fa->fsx_xflags &= ~FS_XFLAG_SYNC;
 	if (flags & FS_NOATIME_FL)
-		xflags |= FS_XFLAG_NOATIME;
+		fa->fsx_xflags |= FS_XFLAG_NOATIME;
 	else
-		xflags &= ~FS_XFLAG_NOATIME;
+		fa->fsx_xflags &= ~FS_XFLAG_NOATIME;
 	if (flags & FS_NODUMP_FL)
-		xflags |= FS_XFLAG_NODUMP;
+		fa->fsx_xflags |= FS_XFLAG_NODUMP;
 	else
-		xflags &= ~FS_XFLAG_NODUMP;
-
-	return xflags;
+		fa->fsx_xflags &= ~FS_XFLAG_NODUMP;
 }
 
 STATIC unsigned int
@@ -1549,7 +1545,7 @@ xfs_ioc_setxflags(
 		return -EOPNOTSUPP;
 
 	xfs_inode_getfsxattr(ip, false, &fa);
-	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, fa.fsx_xflags);
+	xfs_merge_ioc_xflags(&fa, flags);
 
 	error = mnt_want_write_file(filp);
 	if (error)


Return-Path: <SRS0=RF5E=R7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC7EC4360F
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 17:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E233E21773
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 17:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="1kL5ci9A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfC1Rux (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Mar 2019 13:50:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfC1Rux (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2019 13:50:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SHnFbH045222;
        Thu, 28 Mar 2019 17:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=QWFkhrEj/UWEKTtDQrlQN9lEAI12q4qBRSWOWf5aE6A=;
 b=1kL5ci9A0ShDtplZSlWzGFRsQE+gk47tOhTWQtwBpLPMpXEd6hg00YAALT/cbvgPQpbD
 fnSRohTjoI7RLLX7CKrgTI9aua9FA4uJFerc9hLRPoWwzNvzaQ557M1MvW2SuN0QSHiq
 Vyv6ZN9Q4dbl+qZrZOwxPhv7HhjmXNaz2ZtZoW0G61gU0XjdtrVk5td4aFE4Dm3kpASy
 mt6FbLLqA9hg0d9ntBEfD8WZ6XGz4CW+JpUa8zclDrafj2kiZ4fYgAkdpwPhldW2dOCy
 H40mU8hGB9GJC0afxmCuLPONrqnh5JVL4/mPp3EdEBa2Q/7seZM2RFnjiFvzkC/yCPWr iQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2re6g1g6pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 17:50:50 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2SHonoC029902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 17:50:49 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2SHonCl005937;
        Thu, 28 Mar 2019 17:50:49 GMT
Received: from localhost (/10.159.234.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 10:50:48 -0700
Subject: [PATCH 2/3] xfs: reset page mappings after setting immutable
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org
Date:   Thu, 28 Mar 2019 10:50:47 -0700
Message-ID: <155379544747.24796.1807309281507099911.stgit@magnolia>
In-Reply-To: <155379543409.24796.5783716624820175068.stgit@magnolia>
References: <155379543409.24796.5783716624820175068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9209 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=704 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903280117
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The chattr manpage has this to say about immutable files:

"A file with the 'i' attribute cannot be modified: it cannot be deleted
or renamed, no link can be created to this file, most of the file's
metadata can not be modified, and the file can not be opened in write
mode."

This means that we need to flush the page cache when setting the
immutable flag so that programs cannot continue to write to writable
mappings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   63 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ecdbb3af7de..2bd1c5ab5008 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -998,6 +998,37 @@ xfs_diflags_to_linux(
 #endif
 }
 
+static int
+xfs_ioctl_setattr_flush(
+	struct xfs_inode	*ip,
+	int			*join_flags)
+{
+	struct inode		*inode = VFS_I(ip);
+	int			error;
+
+	if (S_ISDIR(inode->i_mode))
+		return 0;
+	if ((*join_flags) & (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL))
+		return 0;
+
+	/* lock, flush and invalidate mapping in preparation for flag change */
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+	error = filemap_write_and_wait(inode->i_mapping);
+	if (error)
+		goto out_unlock;
+	error = invalidate_inode_pages2(inode->i_mapping);
+	if (error)
+		goto out_unlock;
+
+	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
+	return 0;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+	return error;
+
+}
+
 static int
 xfs_ioctl_setattr_xflags(
 	struct xfs_trans	*tp,
@@ -1067,7 +1098,6 @@ xfs_ioctl_setattr_dax_invalidate(
 {
 	struct inode		*inode = VFS_I(ip);
 	struct super_block	*sb = inode->i_sb;
-	int			error;
 
 	*join_flags = 0;
 
@@ -1092,25 +1122,7 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
 		return 0;
 
-	if (S_ISDIR(inode->i_mode))
-		return 0;
-
-	/* lock, flush and invalidate mapping in preparation for flag change */
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
-	error = filemap_write_and_wait(inode->i_mapping);
-	if (error)
-		goto out_unlock;
-	error = invalidate_inode_pages2(inode->i_mapping);
-	if (error)
-		goto out_unlock;
-
-	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
-	return 0;
-
-out_unlock:
-	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
-	return error;
-
+	return xfs_ioctl_setattr_flush(ip, join_flags);
 }
 
 /*
@@ -1356,6 +1368,17 @@ xfs_ioctl_setattr(
 	if (code)
 		goto error_free_dquots;
 
+	/*
+	 * If we are trying to set immutable then flush everything to disk to
+	 * force all writable memory mappings back through the pagefault
+	 * handler.
+	 */
+	if (!IS_IMMUTABLE(VFS_I(ip)) && (fa->fsx_xflags & FS_XFLAG_IMMUTABLE)) {
+		code = xfs_ioctl_setattr_flush(ip, &join_flags);
+		if (code)
+			goto error_free_dquots;
+	}
+
 	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);


Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2A6C282E0
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 19:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AF812073F
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 19:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tRqmVUCd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733085AbfDQTEx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:04:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTEw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 15:04:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HIwxFG185859;
        Wed, 17 Apr 2019 19:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=4IWcQHbcbjjSoElqhy/tH+JNcEGf6skHkkWEdbPjeHg=;
 b=tRqmVUCdtc64SZ25M9a40kcXY5x9K2C2RkhU0OLtxqr4uvK47U56Z9UQPb7P3W3p0kXF
 4Sgqo2dYkSMmcm6KJVCx7wtK93sfJWaBP6/Si5OTuzRYeNg/hCaBMS4lTqvChmc1hG4N
 KQaIZE/OgssJkGJK6BvX4twk4hO+5rhCGG1RZ67r5mENkS5CQEINl5Fq2fWuteZk8hz/
 UBTNGYgD//ZLqGGTs3JYnkwggNTr9iIDhqpvF3wJqKgRfUKTnH8ZeCo/b9n17zVZ2Nw2
 XD9U2w96YrSciTMZ41Xc9IkdBmtNjmec05cVC5qhD9FZ7iq+KYmjKukYb71lc2KFGCMd tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2rusnf2vgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 19:04:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HJ34Zc081759;
        Wed, 17 Apr 2019 19:04:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ru4vtyxrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 19:04:49 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3HJ4mcK021504;
        Wed, 17 Apr 2019 19:04:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 12:04:48 -0700
Subject: [PATCH 3/8] xfs: flush page mappings as part of setting immutable
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org
Date:   Wed, 17 Apr 2019 12:04:47 -0700
Message-ID: <155552788742.20411.8968554209133632884.stgit@magnolia>
In-Reply-To: <155552786671.20411.6442426840435740050.stgit@magnolia>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=834
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170125
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=858 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170125
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
immutable flag so that all mappings will become read-only again and
therefore programs cannot continue to write to writable mappings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   52 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 21d6f433c375..de35cf4469f6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1009,6 +1009,31 @@ xfs_diflags_to_linux(
 #endif
 }
 
+/*
+ * Lock the inode against file io and page faults, then flush all dirty pages
+ * and wait for writeback and direct IO operations to finish.  Returns with
+ * the relevant inode lock flags set in @join_flags.  Caller is responsible for
+ * unlocking even on error return.
+ */
+static int
+xfs_ioctl_setattr_flush(
+	struct xfs_inode	*ip,
+	int			*join_flags)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	/* Already locked the inode from IO?  Assume we're done. */
+	if (((*join_flags) & (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL)) ==
+			     (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL))
+		return 0;
+
+	/* Lock and flush all mappings and IO in preparation for flag change */
+	*join_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(ip, *join_flags);
+	inode_dio_wait(inode);
+	return filemap_write_and_wait(inode->i_mapping);
+}
+
 static int
 xfs_ioctl_setattr_xflags(
 	struct xfs_trans	*tp,
@@ -1103,25 +1128,22 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
 		return 0;
 
-	if (S_ISDIR(inode->i_mode))
+	if (!S_ISREG(inode->i_mode))
 		return 0;
 
 	/* lock, flush and invalidate mapping in preparation for flag change */
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
-	error = filemap_write_and_wait(inode->i_mapping);
+	error = xfs_ioctl_setattr_flush(ip, join_flags);
 	if (error)
 		goto out_unlock;
 	error = invalidate_inode_pages2(inode->i_mapping);
 	if (error)
 		goto out_unlock;
-
-	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
 	return 0;
 
 out_unlock:
-	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, *join_flags);
+	*join_flags = 0;
 	return error;
-
 }
 
 /*
@@ -1367,6 +1389,22 @@ xfs_ioctl_setattr(
 	if (code)
 		goto error_free_dquots;
 
+	/*
+	 * Wait for all pending directio and then flush all the dirty pages
+	 * for this file.  The flush marks all the pages readonly, so any
+	 * subsequent attempt to write to the file (particularly mmap pages)
+	 * will come through the filesystem and fail.
+	 */
+	if (S_ISREG(VFS_I(ip)->i_mode) && !IS_IMMUTABLE(VFS_I(ip)) &&
+	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE)) {
+		code = xfs_ioctl_setattr_flush(ip, &join_flags);
+		if (code) {
+			xfs_iunlock(ip, join_flags);
+			join_flags = 0;
+			goto error_free_dquots;
+		}
+	}
+
 	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);


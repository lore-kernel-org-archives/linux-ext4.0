Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B93AC282DD
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 19:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19BA62073F
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 19:05:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ty8ztUIv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733126AbfDQTE7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:04:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59792 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTE7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 15:04:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HIwxfA185854;
        Wed, 17 Apr 2019 19:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=zgeFdbVmG1TK+fQkYDH0nD1tNP1Z0/Zd4X+7bdmp6NI=;
 b=Ty8ztUIvKudlqlNWiWbmcrPv1zaTbL8/h4BynehDUGbyWK8a4eQ9U/wR6/a/JjzD+RZF
 rcOZeJAgmQMSl0b1rCoJefIFHrVi5gcXPW4Y8I0AcMdR2F/9wVLjT7mkp+JxnIxQ/e0j
 lll/WFWyyoJ9zWVX2Linfpjsv53NWCEvy8wkr4+71B7hNmuR1OAwDFfPXBmjqunNTPOM
 a7Xi8x52l23Xu2OZVOE8PsLXFd2m845UcujSw+Zgo6hoE+2E4W0hubYTWiU/ADlqMxr2
 9Q2pD6lJqvxQP7hRUxpV8Rd/9a61A+mHWjttt4ClAASQeDV87hSKE8r+dZ6OY8iflMtB 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2rusnf2vh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 19:04:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HJ34CP081722;
        Wed, 17 Apr 2019 19:04:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ru4vtyxt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 19:04:56 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HJ4tG5020142;
        Wed, 17 Apr 2019 19:04:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 12:04:54 -0700
Subject: [PATCH 4/8] xfs: refactor setflags to use setattr code directly
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org
Date:   Wed, 17 Apr 2019 12:04:54 -0700
Message-ID: <155552789415.20411.7571353210034623032.stgit@magnolia>
In-Reply-To: <155552786671.20411.6442426840435740050.stgit@magnolia>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170125
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170125
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the SETFLAGS implementation to use the SETXATTR code directly
instead of partially constructing a struct fsxattr and calling bits and
pieces of the setxattr code.  This reduces code size and becomes
necessary in the next patch to maintain the behavior of allowing
userspace to set immutable on an immutable file so long as nothing
/else/ about the attributes change.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   76 ++++++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index de35cf4469f6..fdabf47532ed 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -882,38 +882,46 @@ xfs_di2lxflags(
 	return flags;
 }
 
-STATIC int
-xfs_ioc_fsgetxattr(
-	xfs_inode_t		*ip,
-	int			attr,
-	void			__user *arg)
+static inline void
+xfs_inode_getfsxattr(
+	struct xfs_inode	*ip,
+	bool			attr,
+	struct fsxattr		*fa)
 {
-	struct fsxattr		fa;
-
-	memset(&fa, 0, sizeof(struct fsxattr));
+	memset(fa, 0, sizeof(struct fsxattr));
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	fa.fsx_xflags = xfs_ip2xflags(ip);
-	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa.fsx_cowextsize = ip->i_d.di_cowextsize <<
-			ip->i_mount->m_sb.sb_blocklog;
-	fa.fsx_projid = xfs_get_projid(ip);
+	fa->fsx_xflags = xfs_ip2xflags(ip);
+	fa->fsx_extsize = XFS_FSB_TO_B(ip->i_mount, ip->i_d.di_extsize);
+	fa->fsx_cowextsize = XFS_FSB_TO_B(ip->i_mount, ip->i_d.di_cowextsize);
+	fa->fsx_projid = xfs_get_projid(ip);
 
 	if (attr) {
 		if (ip->i_afp) {
 			if (ip->i_afp->if_flags & XFS_IFEXTENTS)
-				fa.fsx_nextents = xfs_iext_count(ip->i_afp);
+				fa->fsx_nextents = xfs_iext_count(ip->i_afp);
 			else
-				fa.fsx_nextents = ip->i_d.di_anextents;
+				fa->fsx_nextents = ip->i_d.di_anextents;
 		} else
-			fa.fsx_nextents = 0;
+			fa->fsx_nextents = 0;
 	} else {
 		if (ip->i_df.if_flags & XFS_IFEXTENTS)
-			fa.fsx_nextents = xfs_iext_count(&ip->i_df);
+			fa->fsx_nextents = xfs_iext_count(&ip->i_df);
 		else
-			fa.fsx_nextents = ip->i_d.di_nextents;
+			fa->fsx_nextents = ip->i_d.di_nextents;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+}
+
+STATIC int
+xfs_ioc_fsgetxattr(
+	xfs_inode_t		*ip,
+	int			attr,
+	void			__user *arg)
+{
+	struct fsxattr		fa;
+
+	xfs_inode_getfsxattr(ip, attr, &fa);
 
 	if (copy_to_user(arg, &fa, sizeof(fa)))
 		return -EFAULT;
@@ -1528,10 +1536,8 @@ xfs_ioc_setxflags(
 	struct file		*filp,
 	void			__user *arg)
 {
-	struct xfs_trans	*tp;
 	struct fsxattr		fa;
 	unsigned int		flags;
-	int			join_flags = 0;
 	int			error;
 
 	if (copy_from_user(&flags, arg, sizeof(flags)))
@@ -1542,37 +1548,13 @@ xfs_ioc_setxflags(
 		      FS_SYNC_FL))
 		return -EOPNOTSUPP;
 
-	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
+	xfs_inode_getfsxattr(ip, false, &fa);
+	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, fa.fsx_xflags);
 
 	error = mnt_want_write_file(filp);
 	if (error)
 		return error;
-
-	/*
-	 * Changing DAX config may require inode locking for mapping
-	 * invalidation. These need to be held all the way to transaction commit
-	 * or cancel time, so need to be passed through to
-	 * xfs_ioctl_setattr_get_trans() so it can apply them to the join call
-	 * appropriately.
-	 */
-	error = xfs_ioctl_setattr_dax_invalidate(ip, &fa, &join_flags);
-	if (error)
-		goto out_drop_write;
-
-	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
-	if (IS_ERR(tp)) {
-		error = PTR_ERR(tp);
-		goto out_drop_write;
-	}
-
-	error = xfs_ioctl_setattr_xflags(tp, ip, &fa);
-	if (error) {
-		xfs_trans_cancel(tp);
-		goto out_drop_write;
-	}
-
-	error = xfs_trans_commit(tp);
-out_drop_write:
+	error = xfs_ioctl_setattr(ip, &fa);
 	mnt_drop_write_file(filp);
 	return error;
 }


Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398E1C282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 19:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09736206BA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 19:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IYcwQmYE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733182AbfDQTFT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:05:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36476 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTFS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 15:05:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HIwgMN174829;
        Wed, 17 Apr 2019 19:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wwH+dFPY/+6jiJ8mJY7n3VjQ63XBMb5dD4MTB8SRVYk=;
 b=IYcwQmYE6nVO+cuR70n2STHh5AXZROrMhXU4nDqDaRVNB0zL8AgySJ5GPkT0nt4x0xpR
 SPnf8/MA24T9qfGDC31M96gYa9DHK/3AfMd80K+VP0GftwosLLD+8Trl6wbxpC75F1xq
 FbqwC0MzZ2QyhzCA6aY7zMEnrBk4+WLXDYEQ4a+pZDvdWAfZScTgdfGXy9e1sLbqbvnQ
 TAlN5ywoCIwuFvmMQDsmyLCfNZoasXimNFTVZwrWmgUW1j1habantpoNoluqQM8VXpG3
 ZmPulfllJv8nqT6wO2xI98mFf1jmdvRnDZohc6E92/UTbpH3qKASA0ik7/CxtC7gr94y HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2ru59dcx51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 19:05:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HJ4BU8192873;
        Wed, 17 Apr 2019 19:05:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2rv2tvj2rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 19:05:15 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HJ5ECV009461;
        Wed, 17 Apr 2019 19:05:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 12:05:14 -0700
Subject: [PATCH 7/8] btrfs: don't allow any modifications to an immutable
 file
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-mm@kvack.org
Date:   Wed, 17 Apr 2019 12:05:13 -0700
Message-ID: <155552791345.20411.13373076079148473736.stgit@magnolia>
In-Reply-To: <155552786671.20411.6442426840435740050.stgit@magnolia>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=768
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170125
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=788 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170125
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't allow any modifications to a file that's marked immutable, which
means that we have to flush all the writable pages to make the readonly
and we have to check the setattr/setflags parameters more closely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/ioctl.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)


diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cd4e693406a0..632600e4be0a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -180,6 +180,44 @@ static int check_fsflags(unsigned int flags)
 	return 0;
 }
 
+/* Do all the prep work to check immutable status and all that. */
+static int btrfs_ioctl_check_immutable(struct inode *inode,
+				       unsigned int fsflags,
+				       const unsigned int immutable_fsflag)
+{
+	struct btrfs_inode *binode = BTRFS_I(inode);
+	int ret;
+
+	/*
+	 * Wait for all pending directio and then flush all the dirty pages
+	 * for this file.  The flush marks all the pages readonly, so any
+	 * subsequent attempt to write to the file (particularly mmap pages)
+	 * will come through the filesystem and fail.
+	 */
+	if (S_ISREG(inode->i_mode) && !IS_IMMUTABLE(inode) &&
+	    (fsflags & immutable_fsflag)) {
+		inode_dio_wait(inode);
+		ret = filemap_write_and_wait(inode->i_mapping);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * If immutable is set and we are not clearing it, we're not allowed to
+	 * change anything else in the inode.  Don't error out if we're only
+	 * trying to set immutable on an immutable file.
+	 */
+	if (!(binode->flags & BTRFS_INODE_IMMUTABLE) ||
+	    !(fsflags & immutable_fsflag))
+		return 0;
+
+	if ((binode->flags & ~BTRFS_INODE_IMMUTABLE) !=
+	    (fsflags & ~immutable_fsflag))
+		return -EPERM;
+
+	return 0;
+}
+
 static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
@@ -225,6 +263,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		}
 	}
 
+	ret = btrfs_ioctl_check_immutable(inode, fsflags, FS_IMMUTABLE_FL);
+	if (ret)
+		goto out_unlock;
+
 	if (fsflags & FS_SYNC_FL)
 		binode->flags |= BTRFS_INODE_SYNC;
 	else
@@ -433,6 +475,11 @@ static int btrfs_ioctl_fssetxattr(struct file *file, void __user *arg)
 		goto out_unlock;
 	}
 
+	ret = btrfs_ioctl_check_immutable(inode, fa.fsx_xflags,
+					  FS_XFLAG_IMMUTABLE);
+	if (ret)
+		goto out_unlock;
+
 	if (fa.fsx_xflags & FS_XFLAG_SYNC)
 		binode->flags |= BTRFS_INODE_SYNC;
 	else


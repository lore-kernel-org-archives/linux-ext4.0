Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB388C282DE
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 20:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8956820880
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 20:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bf+U77Rr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfDGU12 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 7 Apr 2019 16:27:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfDGU12 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Apr 2019 16:27:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x37KJAPu068364;
        Sun, 7 Apr 2019 20:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=8Z5m1t1XYo17k81EeuKWtqQr0sJBxzEuI/QLbKGy0SI=;
 b=Bf+U77RrhMcfTj1v1gaW3yOQVeLbEwkx+IqYrvDZSHA4XvFsHoVdzDQp1UJmGyYGl1NY
 nLmP2BJmYhQ+lLH/nQ4fJGT5knqbikx5g72pw8AfspalqslfMMd+EyB1qTEXgHUtZpvm
 pwcVuKpb4P0r25JdLmQfPxNFhFqQXAyaHml+q2pWD5UPO8SPBRLfcaEUDXqOxHQAMOTs
 VFadZXcrryQADXtYye8y12fGrQgz9yCanT8vW5eNfdCu3nroDUxu9oR7JBBT8TxSceVc
 n/PO+0jiArYAl3Q7QA/0NTDttRHUGrR1eUS80qh8BkUZbNCK9FDSqJX08JYUdsr85KVZ Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2rphme3be2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Apr 2019 20:27:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x37KPpp5193773;
        Sun, 7 Apr 2019 20:27:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rpkehduqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Apr 2019 20:27:23 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x37KRMgr027225;
        Sun, 7 Apr 2019 20:27:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Apr 2019 13:27:22 -0700
Subject: [PATCH 2/4] xfs: unlock inode when xfs_ioctl_setattr_get_trans
 can't get transaction
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Date:   Sun, 07 Apr 2019 13:27:16 -0700
Message-ID: <155466883603.633834.5683596746694707981.stgit@magnolia>
In-Reply-To: <155466882175.633834.15261194784129614735.stgit@magnolia>
References: <155466882175.633834.15261194784129614735.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=911
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904070193
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=938 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904070193
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We passed an inode into xfs_ioctl_setattr_get_trans with join_flags
indicating which locks are held on that inode.  If we can't allocate a
transaction then we need to unlock the inode before we bail out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ecdbb3af7de..91938c4f3c67 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1142,7 +1142,7 @@ xfs_ioctl_setattr_get_trans(
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
-		return ERR_PTR(error);
+		goto out_unlock;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | join_flags);


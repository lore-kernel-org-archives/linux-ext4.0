Return-Path: <SRS0=oERZ=R2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DADC43381
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 00:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 202D12192B
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 00:37:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OVV57YTT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfCWAh1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Mar 2019 20:37:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfCWAh1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2019 20:37:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2N0YSBH008994;
        Sat, 23 Mar 2019 00:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=AqFC1IkFJA/njrQDUkjWsExuU7SgnafpNSL2bHQV66Y=;
 b=OVV57YTTcGBMWjTnU+NieOTDgzJ4P6mCn1KNsQw/40I3h1ZxIqB4uooL44OEczBzpbTZ
 nzluY5Mk+5Z0Urt3BnrUyrP0kGS9D6cll5Ti6SoQJR0cNt5mJ/0abNPRRz4HLVLfRr9X
 iKFfshrNnD/NlWNwFBfr3MEmwMLFD7FTIzDrPeezHuvjXTRMJ4jgKO9X2QSbJFZwz4uF
 Zdn7gvhcHaV7SFoM1Hbhubw+MZsMTQ8f/tWEj9HnewNkLeAzqkAqtg/UxG20Q2Od9QCf
 yOT8LlMz9wtGdC1qr8+jFDBdUvjreJSwhCl8U6VqJ1JTRdsNhGX941aUEwqc2DlXAYaV pw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2r8rjv8n18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Mar 2019 00:37:25 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2N0bODd029108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Mar 2019 00:37:24 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2N0bOOm019233;
        Sat, 23 Mar 2019 00:37:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Mar 2019 17:37:24 -0700
Date:   Fri, 22 Mar 2019 17:37:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH] xfs: prohibit fstrim in norecovery mode
Message-ID: <20190323003720.GQ1183@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190323003532.GB1180@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9203 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903230002
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The xfs fstrim implementation uses the free space btrees to find free
space that can be discarded.  If we haven't recovered the log, the bnobt
will be stale and we absolutely *cannot* use stale metadata to zap the
underlying storage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_discard.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 93f07edafd81..9ee2a7d02e70 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -161,6 +161,14 @@ xfs_ioc_trim(
 		return -EPERM;
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
+
+	/*
+	 * We haven't recovered the log, so we cannot use our bnobt-guided
+	 * storage zapping commands.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return -EROFS;
+
 	if (copy_from_user(&range, urange, sizeof(range)))
 		return -EFAULT;
 

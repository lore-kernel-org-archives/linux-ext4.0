Return-Path: <SRS0=geXL=QZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F63C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 18:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 386FE217F9
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Feb 2019 18:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qfzahI2P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390552AbfBRSOF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 13:14:05 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51038 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732601AbfBRSOF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2019 13:14:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1IICw3W044985;
        Mon, 18 Feb 2019 18:14:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=0dZlSy5dXD3/fpU5t36qwnu/vx+efv1Te5jzEs678+s=;
 b=qfzahI2PX8cYKaNG8EptjiEUYDlNo00qx8I+fMSIDQgCccZZPhntohjV1tHEdypjK9Jg
 1l/t9GushNx2BEwAV7HabxLQw9jXs0VgAq8MUOrbCfTQlT2XGFwOubMWufVkIkigTmcO
 E2BzMjRG3cnytk54zH2HOzT5SudLPdNpYVcXIZuiYhURS42hs8CH1GLxKXGPBiHVPz9t
 x+HDdSDmBlZa9sTibC4CAAT/J8FXXJUzi2Y6XI9VvUEBo5y/6T3H9zzzAISQpSUJpeqk
 pNRi051xRTxztxYpihYOkyj2/41dk6KlsPeg/gwNcq8xijStJh1FPZ8EXnYjh1g0rtA0 Yg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qp81dymp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Feb 2019 18:14:03 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1IIE2Ym015203
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Feb 2019 18:14:02 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1IIE122002011;
        Mon, 18 Feb 2019 18:14:01 GMT
Received: from localhost (/10.159.243.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Feb 2019 10:14:01 -0800
Date:   Mon, 18 Feb 2019 10:13:59 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH] t_open_tmpfiles: flush log when shutting down filesystem
Message-ID: <20190218181359.GG6477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9171 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902180134
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the caller of t_open_tmpfiles wants to shut down the filesystem, be
sure to flush the log when we shut down so that log recovery will have
to process all the unlinked temporary files.

This is apparently needed to force ext4 to flush updated inode blocks
through the journal at all.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/t_open_tmpfiles.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/t_open_tmpfiles.c b/src/t_open_tmpfiles.c
index 9e70fbaa..da9390fd 100644
--- a/src/t_open_tmpfiles.c
+++ b/src/t_open_tmpfiles.c
@@ -70,7 +70,11 @@ void die(void)
 		fflush(stdout);
 
 		if (shutdown_fs) {
-			int flag = XFS_FSOP_GOING_FLAGS_NOLOGFLUSH;
+			/*
+			 * Flush the log so that we have to process the
+			 * unlinked inodes the next time we mount.
+			 */
+			int flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
 			int ret;
 
 			ret = ioctl(min_fd, XFS_IOC_GOINGDOWN, &flag);

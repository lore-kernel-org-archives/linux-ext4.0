Return-Path: <SRS0=oERZ=R2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99E3C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 00:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B49AD2192B
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 00:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QlkA6a1/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfCWAiW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Mar 2019 20:38:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfCWAiV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2019 20:38:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2N0ZduM016304;
        Sat, 23 Mar 2019 00:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=WSeohjimBCPtZgWD93uZs9LUbtApfDJqmU1I9KWKYEg=;
 b=QlkA6a1/JzzPKajk7vm283n+VoW6kk0YiQKind/s3GM4K0lM4vaneT2S6Z2Zms9I4oBx
 nuIfH8jfpiPu3msRFlNjCk05ad2gz9bMrzxbtswzpVqRtb8zKfYVOsEQbSU02T6XW8OF
 D322w0S/U5vYC5Nt6KEzZ+6nuAzG0UbAHrJ/UcJFY7D0zGwmbRA01x6QoRjD0ZY9a0P6
 g0vvg/1j+VALrF+U57aM4DWWrpjW5Aruj/Wf4/zKUdhYUXHvtHmN5sLpA8dMa/+d8twE
 mPFhEn/niQkwVkSvD9DvAbJeJ75ne4DGPNrqI90kz4P2oeOxZSyeCL3VnD0AoZnuyXXD 2w== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2r8sss0gkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Mar 2019 00:38:18 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2N0cHI3030540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Mar 2019 00:38:17 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2N0cHdT019620;
        Sat, 23 Mar 2019 00:38:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Mar 2019 17:38:17 -0700
Date:   Fri, 22 Mar 2019 17:38:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH] ext4: prohibit fstrim in norecovery mode
Message-ID: <20190323003813.GR1183@magnolia>
References: <20190323003532.GB1180@magnolia>
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

The ext4 fstrim implementation uses the block bitmaps to find free space
that can be discarded.  If we haven't replayed the journal, the bitmaps
will be stale and we absolutely *cannot* use stale metadata to zap the
underlying storage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ioctl.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 3c4f8bb59f8a..bab3da4f1e0d 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1000,6 +1000,13 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!blk_queue_discard(q))
 			return -EOPNOTSUPP;
 
+		/*
+		 * We haven't replayed the journal, so we cannot use our
+		 * block-bitmap-guided storage zapping commands.
+		 */
+		if (test_opt(sb, NOLOAD) && ext4_has_feature_journal(sb))
+			return -EROFS;
+
 		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
 		    sizeof(range)))
 			return -EFAULT;

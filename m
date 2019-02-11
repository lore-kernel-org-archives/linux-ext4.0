Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C92C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 18:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE67121B68
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 18:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oXa66rvn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbfBKSpP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 13:45:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfBKSpO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2019 13:45:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1BIdITb071717;
        Mon, 11 Feb 2019 18:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=fl2awJtT3D25EMkVKV2E9zU3hDURYr+b2iDFNzpLdEI=;
 b=oXa66rvn+Dl0dmxkD7N9T8GcJ1uOGKFVy1JlWLKdAXLp6JnoPKpd/5+Lb2SHtKxBVRV4
 khI1T9hOgcTT2BiyzqBc4S+OIBER0b8m57tcf7VJEYT8whR3c3i3Iplp5n0QEvM77H4t
 jsOD2sPLJC6mr1mFDUzyWGGyJutnXCpMntRpR71WjQJZDkZMBQWKgyx7V/YRDbNoEepU
 u8zzy27VJGx3vVYxtw0Z0GStTSLE7zF8mufPlxeyUOL4zfMhTomFLbU3lxF9/ywCbDxP
 4MA1oXdnz2nEO5ky8+YX6kvMC91H3+mV+Y9Ne5mzkbnYEyCwsqGXqBJ2Cwx+bWvh+e5w vQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2qhredqk7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Feb 2019 18:45:10 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1BIjAfG006982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Feb 2019 18:45:10 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1BIj9V2005247;
        Mon, 11 Feb 2019 18:45:09 GMT
Received: from kadam (/41.202.241.46)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Feb 2019 10:45:09 -0800
Date:   Mon, 11 Feb 2019 21:44:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ext4: prevent very high s_inode_readahead_blks
Message-ID: <20190211184459.GB22106@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=882 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902110137
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

My static checker complains that "arg" can be negative.  That does seem
possible.  I don't know if it causes an issue at run time but it seems
safest to allow negatives.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 60da0a6e4d86..4e0845708c52 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1838,7 +1838,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	} else if (token == Opt_min_batch_time) {
 		sbi->s_min_batch_time = arg;
 	} else if (token == Opt_inode_readahead_blks) {
-		if (arg && (arg > (1 << 30) || !is_power_of_2(arg))) {
+		if (arg && (arg > (1U << 30) || !is_power_of_2(arg))) {
 			ext4_msg(sb, KERN_ERR,
 				 "EXT4-fs: inode_readahead_blks must be "
 				 "0 or a power of 2 smaller than 2^31");
-- 
2.17.1


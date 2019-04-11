Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32568C10F13
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 21:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFF8F20850
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 21:50:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="KftPYl6c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfDKVtz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 17:49:55 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:47542 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbfDKVtz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Apr 2019 17:49:55 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3BLkXvj018314;
        Thu, 11 Apr 2019 22:49:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=jan2016.eng; bh=bBiPovhGnGZGZIXDesz1FBvgCZKSTHZ+GKmRcxtjspg=;
 b=KftPYl6cckHjdh0zzRTpChvU0DsFAZAA91V61waC27bc+QXZHRB442QnNU6JMbheig2J
 v4cxibsLBaI52245XpO02GdXopKwBkuPtWcs5oIXYd/94Q6Hgio3UKTSIl1uquZCl6fK
 d5yhJi8kkncuSTaaLm0mLH1HBmoibOMyRPnaY1fKfjB82rz8lZ5TTIfg5q3umDZ84cP4
 HxQzsNoSTGp+3a4YqFkoh/mF46SKdsEMXILzj6n7FAciX4sgsZD/R/kwD0WS5pEwTkU/
 Gx4EtySGkbk3QAcrAo04OR1C/QW/hMh4x6xKxQ0iiHB2raDE+V5AGuUrO0bs6hMg1U2O cQ== 
Received: from prod-mail-ppoint3 (a96-6-114-86.deploy.static.akamaitechnologies.com [96.6.114.86] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2rsmx5n6sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Apr 2019 22:49:47 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x3BLkc7B023526;
        Thu, 11 Apr 2019 17:49:46 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2rpqeyxex4-1;
        Thu, 11 Apr 2019 17:49:43 -0400
Received: from bos-lpxjs (bos-lpxjs.kendall.corp.akamai.com [172.29.171.194])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id E05B120077;
        Thu, 11 Apr 2019 21:49:42 +0000 (GMT)
Received: from dbanerje by bos-lpxjs with local (Exim 4.86_2)
        (envelope-from <dbanerje@akamai.com>)
        id 1hEhZb-0000VJ-DS; Thu, 11 Apr 2019 17:49:31 -0400
From:   Debabrata Banerjee <dbanerje@akamai.com>
To:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel@vger.kernel.org
Cc:     dbanerje@akamai.com
Subject: [PATCH] ext4: bad mount opts in no journal mode
Date:   Thu, 11 Apr 2019 17:49:17 -0400
Message-Id: <20190411214917.1899-1-dbanerje@akamai.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-11_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904110139
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-11_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904110139
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Fixes:
commit 1e381f60dad9 ("ext4: do not allow journal_opts for fs w/o journal")

Instead of removing EXT4_MOUNT_JOURNAL_CHECKSUM from s_def_mount_opt as
I assume was intended, all other options were blown away leading to
_ext4_show_options() output being incorrect. I don't see why this or
other journal related flags should be removed from s_def_mount_opt
regardless, it is only used for comparison to display opts, and we
already made sure they couldn't be set.

Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
---
 fs/ext4/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6ed4eb81e674..63eef29666e0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4238,7 +4238,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				 "data=, fs mounted w/o journal");
 			goto failed_mount_wq;
 		}
-		sbi->s_def_mount_opt &= EXT4_MOUNT_JOURNAL_CHECKSUM;
 		clear_opt(sb, JOURNAL_CHECKSUM);
 		clear_opt(sb, DATA_FLAGS);
 		sbi->s_journal = NULL;
-- 
2.21.0


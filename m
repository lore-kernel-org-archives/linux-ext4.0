Return-Path: <SRS0=D5Fw=RI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 515A4C43381
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 19:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BA1920842
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 19:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f1CcBW8c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfCETmq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Mar 2019 14:42:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43384 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfCETmq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Mar 2019 14:42:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x25JTH2S118881;
        Tue, 5 Mar 2019 19:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=8xeeXxoxQJDZZ05FydM4O5whfLCwqqrfzZ+vJEEfRNA=;
 b=f1CcBW8cojn84ekDkqLZoo5ULF9TNBcUNIZAaC/LY2vYWyRdS5pf9VMe13kaLCpDfXUi
 mcBSXmVwnmldLf4kze7RSn62mI8yhh+8jCmTfECu+FTmKZbs1lBriFvphJkt0x5oL+/B
 HPugg19KRgfl8Ic/6xrHLaqsnHEF3fSo6x2lxx/IkWbhGbsdibcH6mTza6eeC65PjiEw
 GyUG0siWwcyYOH5rrJejxS57dSSSiQhEoce+eYtDvN0doMi+AAADFg7ou10rAG6KVy86
 63nZt48RZ0R1WfTfDkUakK8c1pepwU/D9jeatB9ZyyOBK8/p04q7cHgYSiJKCNFm/+4K RA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qyjfrfg3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Mar 2019 19:42:44 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x25JggVh026301
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Mar 2019 19:42:43 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x25JggPJ020749;
        Tue, 5 Mar 2019 19:42:42 GMT
Received: from localhost (/10.159.243.250)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Mar 2019 11:42:42 -0800
Date:   Tue, 5 Mar 2019 11:42:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH 6/5] ext4/032: SCRATCH_DIR -> SCRATCH_MNT
Message-ID: <20190305194241.GA4660@magnolia>
References: <155173434205.767.15128498725168844621.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155173434205.767.15128498725168844621.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9186 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=765 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903050127
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use SCRATCH_MNT, not SCRATCH_DIR.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/ext4/032 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/ext4/032 b/tests/ext4/032
index 8534ddd6..277ddef0 100755
--- a/tests/ext4/032
+++ b/tests/ext4/032
@@ -19,8 +19,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 BLK_SIZ=4096
 CLUSTER_SIZ=4096
 
-IMG_FILE=$SCRATCH_DIR/$seq.fs
-IMG_MNT=$SCRATCH_DIR/$seq.mnt
+IMG_FILE=$SCRATCH_MNT/$seq.fs
+IMG_MNT=$SCRATCH_MNT/$seq.mnt
 
 ## Num clusters to blocks.
 c2b()

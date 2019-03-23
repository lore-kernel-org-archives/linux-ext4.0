Return-Path: <SRS0=oERZ=R2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB011C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 00:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68FC92192B
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 00:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="5Mnk398Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfCWAfk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Mar 2019 20:35:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52086 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfCWAfk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2019 20:35:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2N0YpBU042596;
        Sat, 23 Mar 2019 00:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=IaryWyFf+MLnvXtXMqYkpY9bSdHkbtFhdBc3gu+208I=;
 b=5Mnk398ZM/PDbyZv9+SXGn81ySAWcd+1B9d+SBkouPSTP4hkyekFPtpg+GGTbJ8zgz+s
 zYbTNLHIavfiBRKerH/S/z2Xr1j8J1NQgy+Gf8h71/SlwCwt0OFQynVFtNNXPy37jrjI
 DJrJbpD9rG20E3UmgORzUolWLGufTM+rZhM2keI3PqXdCqOTNSzuXw4w04cDIpGPbIzY
 s31wjoDPzS/rjG/dQ8FWOLTGlmmho7x5iIxxEQDGVTAmZdOKM+Og7q6IeZEfqhFBptWW
 eP8+calZ1J1ufkOl628ebhWDnuy5ClLnoIZt/VjD4YSg4rxhEcxnAn5vM08v5Xn1ML8d ow== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2rdaae009g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Mar 2019 00:35:37 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2N0ZaL7017362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Mar 2019 00:35:36 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2N0ZalO014261;
        Sat, 23 Mar 2019 00:35:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Mar 2019 17:35:36 -0700
Date:   Fri, 22 Mar 2019 17:35:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH] generic: prohibit fstrim on journalled filesystems with
 norecovery
Message-ID: <20190323003532.GB1180@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

This test makes sure that we can't use stale unrecovered fs metadata to
drive a DISCARD festival on a disk and thereby destroy user data by
accident.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/714     |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/714.out |    4 +++
 tests/generic/group   |    1 +
 3 files changed, 66 insertions(+)
 create mode 100755 tests/generic/714
 create mode 100644 tests/generic/714.out

diff --git a/tests/generic/714 b/tests/generic/714
new file mode 100755
index 00000000..1849a5e9
--- /dev/null
+++ b/tests/generic/714
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 714
+#
+# Ensure that we can't call fstrim on filesystems mounted norecovery, because
+# FSTRIM implementations use free space metadata to drive the discard requests
+# and we told the filesystem not to make sure the metadata are up to date.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch
+_require_fstrim
+
+rm -f $seqres.full
+
+_scratch_mkfs > $seqres.full 2>&1
+_require_metadata_journaling $SCRATCH_DEV
+
+echo "fstrim on regular mount"
+_scratch_mount >> $seqres.full 2>&1
+$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1 || \
+	_notrun "FSTRIM not supported"
+_scratch_unmount
+
+echo "fstrim on ro mount"
+_scratch_mount -o ro >> $seqres.full 2>&1
+$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1
+_scratch_unmount
+
+echo "fstrim on ro mount with no log replay"
+norecovery="norecovery"
+test $FSTYP = "btrfs" && norecovery=nologreplay
+_scratch_mount -o ro,$norecovery >> $seqres.full 2>&1
+$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1 && \
+	echo "fstrim with unrecovered metadata just ate your filesystem"
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/714.out b/tests/generic/714.out
new file mode 100644
index 00000000..1158a2ff
--- /dev/null
+++ b/tests/generic/714.out
@@ -0,0 +1,4 @@
+QA output created by 714
+fstrim on regular mount
+fstrim on ro mount
+fstrim on ro mount with no log replay
diff --git a/tests/generic/group b/tests/generic/group
index 2e4341fb..c2046293 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -538,6 +538,7 @@
 533 auto quick attr
 534 auto quick log
 535 auto quick log
+714 auto trim
 940 auto quick clone punch
 941 auto quick clone punch
 942 auto quick clone punch

Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C935C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1AAC222A1
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 10:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="ifdVfFk0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438167AbfBNKBL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 05:01:11 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33819 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438158AbfBNKBK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 05:01:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id i130so2827456pgd.1
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 02:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V1G1bYaq+Km34RtW+askrdx+tkF2tFwueJG4dIbkPeU=;
        b=ifdVfFk0kW/IIFB8WwdV72Z5zOa+dcqSXcayZEKzpjOldBkQtPG1dDGADxg7jRHanq
         lqtuH6c3Ts3p6Pw00eubcFHxMZ1LVcx2dtxQWTJ3PEPQ0fsnsvn7hVeMxPjiTHpXhjI/
         lHRli2E/l7df8XeZytTiC73YTJKLizSkB+RLKQlM6lXI8jtqAt9g/jZb/zrAMGebK58K
         ulj6ICONDTdHq4S5eLU/nw7h1wpfwpjqmTlbjSzuRFyEtFc50jWRdr+9u7wUiZu6Gb+L
         CvgUt/mpWsuK8cjMmOfCD6R4BAAcWMEpNktr7ZtmajNLsKcyni7oZep2kZB4x3v7Um/r
         OwaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V1G1bYaq+Km34RtW+askrdx+tkF2tFwueJG4dIbkPeU=;
        b=gvBWvcrq8Op+1RIps/Ed+9XmTJYHVes9ROHp5D18YH/OAUJZvZWXG56YfbnLXFqEyy
         KwUwQeSJrJpdXZylHz5nJHy/sz1Nm788ufn054bpUYHwBI3PDDd6CoUetDFi44A66Z2e
         SCc58hYZ1gv+9Wt/wmaXduDZP22RNN4hOBLozYsLQ49dtRKfhwl7NyLPK4RNnCZIFezj
         KN9/bP77VH09LX8H8iMmwLdLAc5tACH0IwnwcP1jybIbGa/ofKTJNOhJ/J/JTay/UqD8
         SjkDBJmeMZ8M2tPjGnKVI9k3bSDxGjl4otuAvwKDij6181lTzVYaWd8cUiHS26TMA8nF
         ADzQ==
X-Gm-Message-State: AHQUAuYwKbybYf4XsHgH4ZL2Rfwxu776SoPv4eFuaSN9Fyu7gOP4P9R2
        VOf0XL35OTFyI/N8ukgOgkIvBQ==
X-Google-Smtp-Source: AHgI3IZIAJ2VnYK3yffJToNRbYzNLIRAyaxiNDlheljliI94feBaBjQoFhYs3ER9wmq+6PXudHZ08g==
X-Received: by 2002:a65:4101:: with SMTP id w1mr2941529pgp.257.1550138469062;
        Thu, 14 Feb 2019 02:01:09 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::1:5849])
        by smtp.gmail.com with ESMTPSA id i184sm2686952pfc.41.2019.02.14.02.01.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 02:01:08 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc:     kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: [PATCH] generic: add a test for AT_UTIME_BTIME
Date:   Thu, 14 Feb 2019 02:00:14 -0800
Message-Id: <c0d9cb0b181db011a3068fb96bb85e732f508b73.1550138186.git.osandov@fb.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Test that on filesystems supporting btime, the timestamp is updated as
expected.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 common/rc             | 14 ++++++++++
 tests/generic/526     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/526.out | 14 ++++++++++
 tests/generic/group   |  1 +
 4 files changed, 93 insertions(+)
 create mode 100755 tests/generic/526
 create mode 100644 tests/generic/526.out

diff --git a/common/rc b/common/rc
index b8ed1776..d2f43a21 100644
--- a/common/rc
+++ b/common/rc
@@ -3843,6 +3843,20 @@ _require_btime()
 	rm -f $TEST_DIR/test_creation_time
 }
 
+_require_utime_btime()
+{
+	_require_btime
+	_require_xfs_io_command utimes
+	testio=`$XFS_IO_PROG -f -c "utimes 0 0 0 0 0 0" "$TEST_DIR/$$.xfs_io" 2>&1`
+	echo $testio | grep -q "expected 4 arguments" && \
+		_notrun "xfs_io utimes btime support is missing"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "updating inode creation time not supported by this filesystem"
+	echo $testio | grep -q "Invalid" && \
+		_notrun "updating inode creation time not supported by this kernel"
+	rm -f $testfile > /dev/null 2>&1
+}
+
 _require_scratch_btime()
 {
 	_require_scratch
diff --git a/tests/generic/526 b/tests/generic/526
new file mode 100755
index 00000000..c2e47a27
--- /dev/null
+++ b/tests/generic/526
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Omar Sandoval.  All Rights Reserved.
+#
+# FS QA Test 526
+#
+# Test basic AT_UTIME_BTIME functionality.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	rm -f "$TEST_DIR/$$"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_utime_btime
+
+SEC=683153828
+UTIME_NOW=$(((1 << 30) - 1))
+UTIME_OMIT=$(((1 << 30) - 2))
+
+touch "$TEST_DIR/$$"
+
+echo "Set btime"
+$XFS_IO_PROG -c "utimes 0 $UTIME_OMIT 0 $UTIME_OMIT $SEC 0" "$TEST_DIR/$$"
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep btime
+
+echo "Set atime and mtime"
+$XFS_IO_PROG -c "utimes 0 $UTIME_NOW 0 $UTIME_NOW" "$TEST_DIR/$$"
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep btime
+
+echo "Omit btime"
+$XFS_IO_PROG -c "utimes 0 $UTIME_NOW 0 $UTIME_NOW 0 $UTIME_OMIT" "$TEST_DIR/$$"
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep btime
+
+echo "Cycle mount"
+_test_cycle_mount
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep btime
+
+echo "Set btime to now"
+$XFS_IO_PROG -c "utimes 0 $UTIME_OMIT 0 $UTIME_OMIT 0 $UTIME_NOW" "$TEST_DIR/$$"
+# The timestamp changed, so this shouldn't output anything.
+$XFS_IO_PROG -c 'statx -r' "$TEST_DIR/$$" | grep -w "$SEC"
+
+status=0
+exit
diff --git a/tests/generic/526.out b/tests/generic/526.out
new file mode 100644
index 00000000..f9ec18e9
--- /dev/null
+++ b/tests/generic/526.out
@@ -0,0 +1,14 @@
+QA output created by 526
+Set btime
+stat.btime.tv_sec = 683153828
+stat.btime.tv_nsec = 0
+Set atime and mtime
+stat.btime.tv_sec = 683153828
+stat.btime.tv_nsec = 0
+Omit btime
+stat.btime.tv_sec = 683153828
+stat.btime.tv_nsec = 0
+Cycle mount
+stat.btime.tv_sec = 683153828
+stat.btime.tv_nsec = 0
+Set btime to now
diff --git a/tests/generic/group b/tests/generic/group
index cfd003d3..2e0203fc 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -528,3 +528,4 @@
 523 auto quick attr
 524 auto quick
 525 auto quick rw
+526 auto quick
-- 
2.20.1


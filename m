Return-Path: <SRS0=whOe=S4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43922C4321B
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 20:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 176DC21537
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 20:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556311544;
	bh=R7DnHC4uIfvilTq+mQERKcK9WEVcWooKQ1UUzVx6yD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=M2vUsCCxf7SDfzLcHXw1ZEuLwXXzKeddPTXemwQlG/SJyLvTfVBnQ+wPI86jGaD6l
	 S4ZHamoHi8SSLK/CKCiSYcwHTheBUnh9Jgnp8WlkVizzcUoZCWf98suvZyZfEGs1Ei
	 KcDAkYcxlJWeMVrFq9shgWP42KirCeM1KTEGwzQo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfDZUpn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Apr 2019 16:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbfDZUpm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 26 Apr 2019 16:45:42 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A9882146E;
        Fri, 26 Apr 2019 20:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556311541;
        bh=R7DnHC4uIfvilTq+mQERKcK9WEVcWooKQ1UUzVx6yD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKJikhHQl4b+smnnISkTugRVeXKavVq0aoi6tsQ4c2kFD2Ja0gCn095CPeG94k7tP
         Z4wZIMCSbBi3AJmvqSRYeLvlPQUL0iimxoHL88ttZpcMeoMuLqRO6sqZ8HcoVmOQTk
         6yaYWr4hilt83sUABmcOzGLNB3FAEjEMO8y7K5DE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [RFC PATCH 7/7] generic: verify ciphertext of v1 encryption policies with Adiantum
Date:   Fri, 26 Apr 2019 13:41:53 -0700
Message-Id: <20190426204153.101861-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
In-Reply-To: <20190426204153.101861-1-ebiggers@kernel.org>
References: <20190426204153.101861-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Verify ciphertext for v1 encryption policies that use Adiantum to
encrypt file contents and file names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/702     | 43 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/702.out | 10 ++++++++++
 tests/generic/group   |  1 +
 3 files changed, 54 insertions(+)
 create mode 100755 tests/generic/702
 create mode 100644 tests/generic/702.out

diff --git a/tests/generic/702 b/tests/generic/702
new file mode 100755
index 00000000..c7ac7be4
--- /dev/null
+++ b/tests/generic/702
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/702
+#
+# Verify ciphertext for v1 encryption policies that use Adiantum to encrypt file
+# contents and file names.
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/encrypt
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+# Test both with and without the DIRECT_KEY flag.
+_verify_ciphertext_for_encryption_policy Adiantum Adiantum
+_verify_ciphertext_for_encryption_policy Adiantum Adiantum direct
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/702.out b/tests/generic/702.out
new file mode 100644
index 00000000..0dd80dae
--- /dev/null
+++ b/tests/generic/702.out
@@ -0,0 +1,10 @@
+QA output created by 702
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: Adiantum
+	filenames_encryption_mode: Adiantum
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: Adiantum
+	filenames_encryption_mode: Adiantum
+	options: direct
diff --git a/tests/generic/group b/tests/generic/group
index 6bb793cb..f6672b93 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -549,3 +549,4 @@
 544 auto quick clone
 700 auto quick encrypt
 701 auto quick encrypt
+702 auto quick encrypt
-- 
2.21.0.593.g511ec345e18-goog


Return-Path: <SRS0=whOe=S4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E860FC43219
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 20:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAD3320869
	for <linux-ext4@archiver.kernel.org>; Fri, 26 Apr 2019 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556311548;
	bh=jTXts29F5kaYQiApP6D7dZlHYiT1grGN7QRaoKmVCl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sWwcXgr/HB9DzloHsmMUMqjdd4tHfl4O+zjmjwMLxHbqwaW075kE4nVuoGv0XDGlv
	 UHzVXSAGPZcV+Oqo/jD30EAOF3C4L6HwxbQzD2kLIjpeKa5D1UoYPygv4dmuslcpl4
	 R+LrWAXYFU1MxHN2HK0TLuLrvQqvKSYqA4FPD39s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfDZUps (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 26 Apr 2019 16:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfDZUpl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 26 Apr 2019 16:45:41 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 848ED20B7C;
        Fri, 26 Apr 2019 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556311540;
        bh=jTXts29F5kaYQiApP6D7dZlHYiT1grGN7QRaoKmVCl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=073UbYXp+60OJyigE/yYTmQwZsgXTgZc6TOfyF6zfZA0bfp1ISfgyTCHlX+rEWZkt
         lSB27d5suhZDiLx2udxGzFM+rRULgylWt9mmodaRmxC993j0a5MWJgWoGiXZ4FB/4T
         jvgbbdGFPpQBQJ7xu6KyYNIJQlMJmB4xcOojzIJA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [RFC PATCH 5/7] generic: verify ciphertext of v1 encryption policies with AES-256
Date:   Fri, 26 Apr 2019 13:41:51 -0700
Message-Id: <20190426204153.101861-6-ebiggers@kernel.org>
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

Verify ciphertext for v1 encryption policies that use AES-256-XTS to
encrypt file contents and AES-256-CTS-CBC to encrypt file names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/700     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/700.out |  5 +++++
 tests/generic/group   |  1 +
 3 files changed, 47 insertions(+)
 create mode 100755 tests/generic/700
 create mode 100644 tests/generic/700.out

diff --git a/tests/generic/700 b/tests/generic/700
new file mode 100755
index 00000000..c6dc8b90
--- /dev/null
+++ b/tests/generic/700
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/700
+#
+# Verify ciphertext for v1 encryption policies that use AES-256-XTS to encrypt
+# file contents and AES-256-CTS-CBC to encrypt file names.
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
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/700.out b/tests/generic/700.out
new file mode 100644
index 00000000..ea2de143
--- /dev/null
+++ b/tests/generic/700.out
@@ -0,0 +1,5 @@
+QA output created by 700
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
diff --git a/tests/generic/group b/tests/generic/group
index 40deb4d0..22e5c028 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -547,3 +547,4 @@
 542 auto quick clone
 543 auto quick clone
 544 auto quick clone
+700 auto quick encrypt
-- 
2.21.0.593.g511ec345e18-goog


Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60ECEC169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3252B2175B
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="omUJZfwp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfA2RwD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:52:03 -0500
Received: from mail-it1-f178.google.com ([209.85.166.178]:52538 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfA2RwD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 12:52:03 -0500
Received: by mail-it1-f178.google.com with SMTP id d11so5958959itf.2
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 09:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FAUEq+0jzAfBo8axIh972Ofnls+ASfZANgtGOcExyfg=;
        b=omUJZfwpmpNCR9LjkzawY/6QybX7nFi31+0wuz4KyrgINL1NmWDinnfgbXXilHmhkH
         UZIH5H1HsOzwUJPlbDhbskg2zWhms3gmsQSihQmLS6KO0g1Jc1zonfzMHkMd4KEqm/M0
         OeVugmyTx1sv1EnTlzex6cjGZkGddka8UGLFKBiN3QBRGLG/OZ11DAaHrTM5OIkFjFGu
         Hx8cti/zMbSzx6SR+GJB/Gk+fsel98ZNqjqAJX3W2M+OAoTqSBYBu26d4MK5pE1Johmv
         ScbDfznGNld7T2Yd7ZhZMp1Orn5dh3Q8P3dgzNkedKRq7Z1UMxnhMuBfTnoKmaPHm0zi
         eM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FAUEq+0jzAfBo8axIh972Ofnls+ASfZANgtGOcExyfg=;
        b=UuuO3+RtJaxPBvEjvgu/qT+JBRnHQHtN0XJQ6LAN6iw/pHq7eOt66jZLLXKFM++84A
         165me48Ze9k+jYpKYfeDrUNA4IYz9k8eWj4n6qVmib2HK3H+VHlB9agPFqhYdy0sBL4A
         jZcT3HbKIDL08WL+9y8UTs67GDtP1jY3pnSmI8uRjrFS1ZefZExS8VChPWWvEZFr3Ys2
         gCLZOqUi+IhYBosN2d3GEIvu1WfSiQL4diZGGxjvLTbY3vB18UtVJNHxfY4U0Qt7AgVo
         GHUXXQBNjUQrSLI02ImOXPKM5X+m5044G/KyD7qL28ZtNwM0iPCcrthdc2UMEfr8TKrp
         miQg==
X-Gm-Message-State: AJcUukc0owgtcbNuZ6XXGDRoVmK8yUvpYNoarU3vecXy5SbdstDsN3wE
        DxFrY5u1sw//qn9Vr+c5sCKySXxkRDc=
X-Google-Smtp-Source: ALg8bN6UURTy9lmikXBvoXxHudrXGYXX23esuVgoW/3OvFyAPP2b9u6mGYGbdKO4UZZm1j2kTOc37Q==
X-Received: by 2002:a02:2ac6:: with SMTP id w189mr17262105jaw.33.1548784322289;
        Tue, 29 Jan 2019 09:52:02 -0800 (PST)
Received: from C02TN4C6HTD6.us.cray.com ([63.239.150.218])
        by smtp.gmail.com with ESMTPSA id b5sm15838778ioc.21.2019.01.29.09.52.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 09:52:01 -0800 (PST)
From:   Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <c17828@cray.com>
To:     linux-ext4@vger.kernel.org
Cc:     adilger.kernel@dilger.ca
Subject: [PATCH v7 3/4] tests: add test for e2image -b option
Date:   Tue, 29 Jan 2019 20:51:33 +0300
Message-Id: <20190129175134.26652-4-c17828@cray.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190129175134.26652-1-c17828@cray.com>
References: <20190129175134.26652-1-c17828@cray.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The test makes raw image from partition with broken super block
and executes e2fsck.

Signed-off-by: Artem Blagodarenko <c17828@cray.com>
---
 tests/i_zero_super/expect.1 |  22 ++++++++++++++++++++++
 tests/i_zero_super/image.gz | Bin 0 -> 13262 bytes
 tests/i_zero_super/script   |  11 +++++++++++
 3 files changed, 33 insertions(+)

diff --git a/tests/i_zero_super/expect.1 b/tests/i_zero_super/expect.1
new file mode 100644
index 00000000..fda32b96
--- /dev/null
+++ b/tests/i_zero_super/expect.1
@@ -0,0 +1,22 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (7987, counted=7982).
+Fix? no
+
+Free blocks count wrong (11602, counted=11597).
+Fix? no
+
+Free inodes count wrong for group #0 (1493, counted=1488).
+Fix? no
+
+Free inodes count wrong (2997, counted=2992).
+Fix? no
+
+
+test_filesys: ********** WARNING: Filesystem still has errors **********
+
+test_filesys: 11/3008 files (0.0% non-contiguous), 398/12000 blocks
+Exit status is 4
diff --git a/tests/i_zero_super/image.gz b/tests/i_zero_super/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..eea9140194f4dd9ec9dc8bb7b9e2215b950587d2
GIT binary patch
literal 13262
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

literal 0
HcmV?d00001

diff --git a/tests/i_zero_super/script b/tests/i_zero_super/script
new file mode 100644
index 00000000..6b02d86d
--- /dev/null
+++ b/tests/i_zero_super/script
@@ -0,0 +1,11 @@
+if test -x $E2IMAGE_EXE; then
+
+ONE_PASS_ONLY=true
+FSCK_OPT="-n -b 8193 -f"
+PREP_CMD="$E2IMAGE_EXE -r -b 8193 -B 1024 $TMPFILE $TMPFILE.raw; \
+	  mv $TMPFILE.raw $TMPFILE"
+. $cmd_dir/run_e2fsck
+
+else
+	echo "$test_name: $test_description: skipped"
+fi
-- 
2.14.3


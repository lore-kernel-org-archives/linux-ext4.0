Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713864;
	b=JvXu6MQBWBeFJKCrKIypPHW4kLm5QaVllfXYP4/4oY9E1EvP6dOjz5yooH5JpvKRR43m
	 xO5+S/KJf5fINyhPJos0X7P7dB0fOpuC6g/ZkoUi5oC0vMkw31Q/1U8017WX6WAiJXRAd
	 WdKsTXjZ9RqjEU34zzq1oHU8MHuoTjs92OfBVIz/gHBuruiW7mJyGAfkjEhNbUXmRL4Ej
	 KHKUssTlDsJsnr6gxNdz4knlwnRmm6yb3ewfESMTX4fO8vSlf4e81glQkO9MoEproFtJt
	 Dlt9K3PalPHz+qMw2zc+4xf/2Q+AyD5AYlg1p2zajHCFWr9jIAbkxBTWOVUs2yrVdsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713864;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ZZZeIYukdCWP364pgUBHXYe9jSlYdi/HuvPt3s2Wy5g=;
	b=ZcReFB53RvuLh/2aUAFmTDUJqRpyUVDhR2C8raqrabGSU16q9h8PI9j7FFZkN0mzqK1K
	 wWhp4NJSfIu8AM/Fx1BkeBEjmZiX5agqRM80x3OyAEfL7xlHSwmSaavLbMQbIWY7wedit
	 TdUDyVKbjfHzoXjYKCHZRPR3T9mcki3bOfpeqVsnqg5rYAn8es5CH5135sfpH5XaJ7kA8
	 t3ftM0t4ndRXjEXpdbO/TR45otl+Ch3CnhEC0PmQzWeqb+sBix8wOL7Xet1qwjNkc7pQG
	 U8DIZfkIHgzVxIC2+uW28Zd1vwQG+KEpljVv4hoRadqyeYLyuEDDhvWC982egIRtEsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mMppQRyB;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE305606D813
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:51:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE305606D813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mMppQRyB
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e4831c028so3684752f8f.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713861; x=1794318661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZZZeIYukdCWP364pgUBHXYe9jSlYdi/HuvPt3s2Wy5g=;
        b=mMppQRyBgiDrZuU5wTaqAH/darXWrnSV5Ts6f5nXsNaopnxn2V0NPCvR7ROP57SmG5
         XxrXPz9kNwMkg32aCMc5JLE8ZIu6PjUssjjCN/yQQ4Q4VR0JttIoxTUZHxMB3JbimCzx
         N7+k9SacRptVJlOjUe8h7lFzK2q5B1WSagfZvMKm4AbLogKGQ9q4jXCiQ0jWDpO45gtK
         iLhHsvnOqcYhkGC1qP88EfIgJXvrDTo/8kK2yBWUx5cHv2p+/p2KUGQasCBiz+njlVr6
         WFMraIsbbSGlXWRSTv4BAvVbKQCakELfNSKd6yk/YQuFjYxOxYNNPiU296O+HPFShxw/
         oaig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713861; x=1794318661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZZZeIYukdCWP364pgUBHXYe9jSlYdi/HuvPt3s2Wy5g=;
        b=i9uGW8Jb00quZgjRMxdT6qZt05nlajKGlgqUrVEZxJKQD6JVaM5mpVWJyhfWYucDMa
         5h0Y0CKOVo3A34D9+DM/OZCfkPi6ZIgs3esleMW+CDo4yNhBNgxODzB2nkp2yQwQ5EyI
         yPqn0qPD9JY0+04PqEtNFiXfzJdWN6nLruHpmahPbDSAFkWlwJNG367nwJeHG4ZmslCT
         So325B9m/BiV4u8NII7mVUxYiiwbceItXzRtakFEZKZGx6U52OGCruhqd12z1Gqo2omK
         QWdTLjLwWvy3APEIHPwqhikRrQrikzxcxIdVtDPaaw+MGr46K6jOCtEuIMEdyl8A3eAZ
         Ds8Q==
X-Gm-Message-State: APuU4Z9VPZcunHnrRrltR8uRrfoPRt2q7+vyXzW1wh9bKKhcqHNPGw6V
	dvYA+9Y19/su2v+8Wb9uZ4B5AwkMNp7vj7U/e30LrMa68W9k4euL5UXx1RNAmppoPn8=
X-Gm-Gg: AYBFou2Dq6EwV8UOXcaSAAnWWgwcqcw7p+l4Vq0rcXgyusQNzkMIjvyUBSniVsW/jKa
	BFu1PFW/vueHYIgZb66IWSRnBpHwhAs33obO2VTxBvJHl57qZaHaVzczpSm5QWEVIwkVsDiXyQu
	OrbPImFVkOt/RRL/lNgq4dsDaRcGBh4D1ZD6nqyXg0K63unK92jcNi4OJW/9jBNevmDAZlsCsiW
	8XZz7YegueG/31/FBm5HH+e2fMpv49djMvOolXpBz0yMUtcGaOYNCofcKZ5RQu0C5Or9EAsQKZf
	ekgk+5ueq2SFCq/b+UN5vzyswjxJTIalX8GPC1ABfyN1AJJolB4WK9V/qyhFhqSQfjWUzPzaPLM
	1uTsF9vNpAg0J3vCISEgPgDMACxglaPhepBgAH43y/oC3dLsqxcQYcRG4pPmF2XzFCIVXSgz5bK
	CmIQ+qevW5KG7/2z7GrDKDHb2bgKL/VTWVy35anV4j3xbkatAGRmdyRo1XM0wk3al9YEp/AEKzg
	mgy1s2IbIg6Qfzr+eohGd6tviHvWkf+oaZouK5lLd1wA8fbpDUss4jB0rfgcYZUnTnJbkGQPnTB
	NxaanearbgGZ0zwcuHKkH4q0X8wTgXi7Xq5X0yTCKYAV5IPOp83imG2TZxW7
X-Received: by 2002:a05:6000:22c7:b0:485:8cc8:1f5f with SMTP id ffacd0b85a97d-48e6e5087edmr30606952f8f.42.1793713860792;
        Tue, 03 Nov 2026 05:51:00 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:51:00 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 12/13] e2fsck: add test suite for dirdata-specific optimization
Date: Tue,  3 Nov 2026 13:50:36 +0000
Message-ID: <20261103135037.610132-13-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
References: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Add comprehensive test for DIRDATA-specific directory optimization scenarios.
This test validates that Lustre File Identifier (LUFID) and Checksum Hash
(CFHASH) fields are correctly preserved during directory optimization and
rehashing operations.

This test ensures:
- dirdata preservation during rehashing
- Proper dirdata field alignment in optimized entries
- No data loss or corruption during rehashing
- Directory structure consistency with extra fields

The test filesystem contains pre-populated DIRDATA entries that stress
the optimization code paths and validate field handling.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/f_dirdata_optimize/expect.1 |  10 ++++++++++
 tests/f_dirdata_optimize/expect.2 |   7 +++++++
 tests/f_dirdata_optimize/image.gz | Bin 0 -> 32121 bytes
 tests/f_dirdata_optimize/name     |   1 +
 tests/f_dirdata_optimize/script   |   3 +++
 5 files changed, 21 insertions(+)
 create mode 100644 tests/f_dirdata_optimize/expect.1
 create mode 100644 tests/f_dirdata_optimize/expect.2
 create mode 100644 tests/f_dirdata_optimize/image.gz
 create mode 100644 tests/f_dirdata_optimize/name
 create mode 100644 tests/f_dirdata_optimize/script

diff --git a/tests/f_dirdata_optimize/expect.1 b/tests/f_dirdata_optimize/expect.1
new file mode 100644
index 00000000..52368d33
--- /dev/null
+++ b/tests/f_dirdata_optimize/expect.1
@@ -0,0 +1,10 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 102/4096 files (2.9% non-contiguous), 686/2048 blocks
+Exit status is 0
diff --git a/tests/f_dirdata_optimize/expect.2 b/tests/f_dirdata_optimize/expect.2
new file mode 100644
index 00000000..3cf9314e
--- /dev/null
+++ b/tests/f_dirdata_optimize/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 102/4096 files (2.9% non-contiguous), 686/2048 blocks
+Exit status is 0
diff --git a/tests/f_dirdata_optimize/image.gz b/tests/f_dirdata_optimize/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..fcb7f4f866cea3160b77da4998ec69c0817afebd
GIT binary patch
literal 32121
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
ZMJ!?wi&(_JgOz4v>-|UhFxW-d-vJ>t-0T1V

literal 0
HcmV?d00001

diff --git a/tests/f_dirdata_optimize/name b/tests/f_dirdata_optimize/name
new file mode 100644
index 00000000..1649a370
--- /dev/null
+++ b/tests/f_dirdata_optimize/name
@@ -0,0 +1 @@
+optimize directories with dirdata
diff --git a/tests/f_dirdata_optimize/script b/tests/f_dirdata_optimize/script
new file mode 100644
index 00000000..52cf88ed
--- /dev/null
+++ b/tests/f_dirdata_optimize/script
@@ -0,0 +1,3 @@
+FSCK_OPT="-Dyf"
+SECOND_FSCK_OPT="-yf"
+. $cmd_dir/run_e2fsck
-- 
2.52.0


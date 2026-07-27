Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A32413797
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186843; cv=none; b=JaSGwHsZhdNg5aMs6R6TjxIzebTnOOr5XpBhPHvcOGEyIZfUy/jLpL7BVqTw0Bz3zHtRLNvC8Y5erbV8veBZoIvLUe29Eifpj4HLKl5j8orzLa5ii1D5LlwCqAYyVwrnrfCQaYMIxzdu5bgYIvc/xwz7ycCAub/jDJ3YXuAsqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186843; c=relaxed/simple;
	bh=fETnPpD7upfSSEqBOtk5GO3RL7y21gZEcXRBDpgQcmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7GYhIK2rWW3zC7bE5YG71DseILiPG02ojG2VI8ktTj6RC03n9A/anFeM2InJisoEIHu8IWYqQyNjEm0KTU6DXPIUbfLq7mPGcEp9Pdx0b0R2/IrjGYfZSDracdSd9e+WCytUY202+ScJL6m27OBnxouh4l6/zt3vqG+FvSn94I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KQ3714DL; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KQ3714DL"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4798bea72f9so2042471f8f.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186841; x=1785791641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oz0RHKTVYviax0zT3BvQmKZ+RclgIdY+fcncgnfe440=;
        b=KQ3714DLQreuVumBreWuj7ZVNNmS9OcR5MzHAJV+RnFgjqSaRuE9Icj1yDW88buC85
         CcwwQQGQt8bWc6A21KJ2RmHzCoSMdlp+C+A61nDtO/2qBxfde0TNPOqNpU81KvAwP4d8
         cdMxDA95GiDu63r+iq478VYhLOdbWLQp2Ye40VSlnHKvxEvkhFCqJp5SSdiA/YG0RGrY
         Vbrz0jDihrhQnVJhZWar/Satoyo0R+o9K+AgqEiEnD9jNqm8IPFjlFigCgMXdjwu1mHL
         6tP/lLGqmp3F+MQbCwFndelSQnsDJMGt1ZF0tPemclJDBEiTmvtWh7qw2ZmNP+A/UE1x
         vtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186841; x=1785791641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Oz0RHKTVYviax0zT3BvQmKZ+RclgIdY+fcncgnfe440=;
        b=NV73rsqXApV9lfvbZdJ3HU+/mkXYiAgJxZwyaTxGZd+/UgQDHpjCA5jxxvsZ8G43tm
         vmeOLEqooagTHoBTDMhtIlXxHlnG9Q7BTCMTcuE3KZg3GV4BdHm5MSjnVadh48yJw9Zb
         C/gp7vXIf78mAJmPyvHmTTEN3Qcz5W87l6pxa1Re2GLONzkSWwIVY8yMrXDE7QfjCujH
         9FJDnS1/J+rtSj2KTXF8Hd/+36eNuIBDV0YWSWF4BpGvVPk5zdw19J+/MjgaTMcZ+5q4
         XCD+Ifhn/kTS0XSigbB4u42YZ9KOsH3m4JeKlWVOL7ddlEuiL423RPQCFCJYhDNk8Fsz
         d9zg==
X-Gm-Message-State: AOJu0Yz0VWWwzQsSAvz5Ckwc/53UOeB9OKGMaRAvd/MRlTxJHyjLoJTC
	JbQzrC/ZI1Bt3GIsTOZk/mM2TAxqWfYVIqz3s6H061cXOuHOc6j4Pb2zm5CvcSUS
X-Gm-Gg: AR+sD11maBeVUr9vWMZNzgQzEOK1GU8ocbudnwYOUatanCn66QfmpxQKtCNZlPiIZgG
	RPZlZjs6qOBPXrwI9ajydzRhR5z64PkBKVNbyPzvt/kEKKwjPZ7CiregbiIS6ZIeNWGRwSWqRze
	9tnpZ/VaJlxY1RlqtyBXiyW3URqdtgnxUkLIVFGPKZOD5+04x17P+rGKSl+WQjAmw9vMMeneUMw
	ir0xrg0pPg5pWBaueq+nisq2DVVhARmjJAOBQHKZbpOleZu75+YesXsMHouWlw339/9Mpk9oGaE
	JyB0mhF4aqytP9oJWrFzZ7zFWrzRWm1Aqfufq9LcqXI5xe/nZSuuQpZhH/T+j6Ad64SV7MX4hsV
	GT0WrKSpKfa2P4f4SyFvGvoeV94cTh7RjjdcweIf+UCBoy9c9ZutJXAt224RzxY3ATIuanyIGLS
	peiYsutHR8NNb1+Nf88c+sBIM94F/7ZfG7CQ==
X-Received: by 2002:a05:6000:430a:b0:47f:7526:598 with SMTP id ffacd0b85a97d-47fafa57111mr1007301f8f.12.1785186840753;
        Mon, 27 Jul 2026 14:14:00 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:00 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Christoph Hellwig <hch@lst.de>,
	Zorro Lang <zlang@kernel.org>
Subject: [RFC PATCH v4 01/11] generic/366: check minimum dio size correctly
Date: Mon, 27 Jul 2026 17:13:34 -0400
Message-ID: <20260727211353.19736-3-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
References: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

min_dio_alignment requires the file system to be checked to be mounted,
so move the call into the main loop.  Drop the pointless blocksize
argument to _require_odirect, which is only tested on the test device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 tests/generic/366 | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tests/generic/366 b/tests/generic/366
index 271a01bc..cb183c1b 100755
--- a/tests/generic/366
+++ b/tests/generic/366
@@ -20,7 +20,7 @@ _begin_fstest auto quick rw
 . ./common/filter
 
 _require_scratch
-_require_odirect 512	# see fio job1 config below
+_require_odirect
 _require_aio
 
 _fixed_by_fs_commit btrfs xxxxxxxxxxxx \
@@ -30,7 +30,7 @@ iterations=$((32 * LOAD_FACTOR))
 
 fio_config=$tmp.fio
 fio_out=$tmp.fio.out
-blksz=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
+
 cat >$fio_config <<EOF
 [global]
 bs=8k
@@ -57,9 +57,19 @@ filename=file1
 EOF
 _require_fio $fio_config
 
+blksz=""
+
 for (( i = 0; i < $iterations; i++)); do
 	_scratch_mkfs >>$seqres.full 2>&1
 	_scratch_mount
+
+	if [ -z "$blksz" ]; then
+		blksz=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
+		if [[ $blksz -gt 512 ]]; then
+			_notrun "512 byte dio alignment required"
+		fi
+	fi
+
 	# There's a known EIO failure to report collisions between directio and buffered
 	# writes to userspace, refer to upstream linux 5a9d929d6e13. So ignore EIO error
 	# at here.
-- 
2.43.7


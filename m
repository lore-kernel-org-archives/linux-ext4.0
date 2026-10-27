Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793073591;
	b=qtms20yMqy4qoWtPgloDyvr6mHIs9XvM9YtXvz5NRYHBigv4vdrpjWH/oKAIN0RpU3Cr
	 bBpcxvj2d/EzEWj/k5e+LjdphB6uTm/PyxXtbDjeirxpgsEW/8HAEsxBCO1xnGsoionKR
	 FpIHUTeg+fPKG6Ap1TtcJ6bh+tR/PvY7axSA4iAp1T7cHzdAQsMUVWwvLs6s+2CIpHB8b
	 gbPE6fYquzKD95kqcKJNXlMqqoIFjAKqfA3/pC1IuAoEK/lzSOK1/TjEbj6n4pFw446oE
	 /FX8OTY1oGToFkl7Tv5/RY4mui9IDHdT+U0c4kWMReyfUIRVYmpS005ElJWTOSNC3AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793073591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ow0G93l9e0EmY6URJd2RDSyzRNeAkWxjCkJmGzeQGzA=;
	b=cfLvn2wRjG9wvk80u6S59lhGEnFkaPY58EMikr/MvJZv2dPYq4wyLFNQHDODy3Ecn5WF
	 98mgqxUSm5ll9kki80najNdTaZHk/zrT8U4i6x0INukc/0S/Xagfi5Yo+fTJQOo15Bvtx
	 DmTBTTm654CmPj990LtdXzXksL3cUF4/rh1jIYYXy7sOnKUqjnU8Z2LojGI4sNeQ7BCVs
	 2zfiMv0fwQ7l8XiEwZM9BFTxFyxFYPcVCQPE1dM10ovfYOH9BC4Gg+aKGoLLc6B1/nB/r
	 gOZjAdbw31/kQXkV7tciYBl5Kxv5LN5ns4x9xDZDD83I6FecW4zO/eu9tisX58dLmwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="aMwh/y2f";
	arc=none smtp.remote-ip=74.125.229.5
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4A0606A327
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 03:59:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD4A0606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aMwh/y2f
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-35cd538de29so1824323eec.1
        for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2026 20:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793073590; x=1793678390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ow0G93l9e0EmY6URJd2RDSyzRNeAkWxjCkJmGzeQGzA=;
        b=aMwh/y2faS/js83YQ/KEeWIzD4kvOPqz2TU3afqpyyDp1Xs/QMPIUVv3dXmtkk4rh7
         ZLxFlVOCJLFzJYhI7oiFSCfiPQLskB2qIB0Cl/2H/ZEHnrEiZJC9RkDW0NdP4t6mVqvJ
         yrdo52st4GLaEGCCV36JmGMIV9WDuHTqKmBF5SbNQaoqLpQGgsyPfZ6rsHAkmm1M0LRa
         1OUMz+QUhySL6M0FC6oUa7i4M/xOYqGjFvnt3pUv6z61ZO/ngNDiWW2DC/2sHeQMPZpI
         wavf10DMzbXZXKyUA8PeFHipSfLDXz4X2U5iwLWXbQYOko09ZctwzsUnvy5HphzbDr7c
         iJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793073590; x=1793678390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ow0G93l9e0EmY6URJd2RDSyzRNeAkWxjCkJmGzeQGzA=;
        b=cf5izZgSE8RisUtCbHSLOgEeTXCsC3r9kmJTOQagZV1PUMC3eccFvhxpl4L34t+Sao
         /bexdxShjMjMjxBYIW39uDOIdOiL7OoGhH1aJOmYlVkf198K2RsQtT7I2LV+HzZS3/Do
         cJuNrzTBVd7gnQEYL5B/97dHJQN9g1LCiag+cAF8Lz+goa+dSKEFrFmbIF23uv1GVx4J
         jBbJWGylfiIAGS8ivMtWSDkMI+sLNXvAHVELOPAkuc8uZcgJ8Yms7/dhQlK8NeYmAXF7
         JNUetv0tZ2fR0mg+F+5HRB6L+N++mcV7UxJ5dsYwtwgRhiWEYcU/A6ZurH8muLJiE+pc
         mamw==
X-Forwarded-Encrypted: i=1; AKwUvByXruHCJ4clhhxkxmnHeWeEQpPukjB893+aCuVq5PyRTzn+sVqGUdyyT7rDWtiJ8lHCTt8pjfkEriHQ@vger.kernel.org
X-Gm-Message-State: AFq9FYLkOx7Tn+oU44PrE2DEuxxFOrF7OlSIbncA3bVi4t+KajwJE59s
	FrnRCwC1woBYuLApgdNQoOJmaOmCs8yTkWJ7OQoOJV5SrMlP/Msy/4zM
X-Gm-Gg: AYBFou3DZf6JmqY1iTFNu+KNh/XCi/Ous6BLy+VQjYqgHZy7xf/RLVWy+sPOx7iYG4L
	g0vcibf39nGdxLsXf3s8q3Aq23kJHbtiIrJdUTsuqsoptb521+oVOB+LuwRvhFn7RC8S+6VeRyQ
	eQZDCEFZc6/wbu9/hf6UVsgVelvcA1QH8v/jjQYADr4aGL3mh4SEC6YtKsjgwxG4x8/Po9VbRDg
	po+20S7KDepDpK801k6wsbgxHHp0JB3/gFoA+5zbL/XEzLe7dQQS1Rw0+SlGjKqChyK8JDQGBHt
	v+kp7mfOlCEOZc3NRPx4uP4Gl+olrU6dGn0LnVmbnwnzLT8A1hp+AcauwCASpoMemQam6I9z0cF
	rQWf2NfU2N9Hkto2azGamp9Ma59dYjMD1oVqKqULkVEQZYeL6aQUTd4LW8kA8quS3ODnLptZaAO
	bTWMZ5vXVK6SvvXDElvOLoFnpUO6GtICk2w4XAYgacCMHopgNUdTpv4tHTI266p6rIwVNSm3qu7
	oR9qbaeAIc/Ekt0onwIuF0c4iFC4s0QfS2/+mupNH95LUb3b8IEafKGDzcuh3iN050m46albuUH
	6ce+68Y=
X-Received: by 2002:a05:7301:18af:b0:369:f937:9a7a with SMTP id 5a478bee46e88-36a12d7efc5mr979215eec.34.1793073589608;
        Mon, 26 Oct 2026 20:59:49 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8daa3a8sm36899329eec.16.2026.10.26.20.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 20:59:49 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	djwong@kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] ext4: preserve force-fsck requests across unmount
Date: Tue, 27 Oct 2026 03:58:57 +0000
Message-ID: <20261027035857.72265-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

EXT4_TUNE_FL_FORCE_FSCK sets EXT4_ERROR_FS in the on-disk superblock
but leaves s_mount_state unchanged. On a normal read-write unmount,
ext4_put_super() restores s_state from s_mount_state, clearing the
requested flag.

As a result, a successful EXT4_IOC_SET_TUNE_SB_PARAM call can be lost
before e2fsck runs: after unmount it treats the filesystem as clean
and skips the requested check.

Set EXT4_ERROR_FS in s_mount_state as well, matching the state handling
in ext4_clear_journal_err(), so later superblock updates retain the
request.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 fs/ext4/ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498c99..3e444e245c98 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1384,8 +1384,10 @@ static void ext4_sb_setparams(struct ext4_sb_info *sbi,
 		    EXT4_FEATURE_INCOMPAT_CSUM_SEED)
 			es->s_checksum_seed = cpu_to_le32(sbi->s_csum_seed);
 	}
-	if (params->set_flags & EXT4_TUNE_FL_FORCE_FSCK)
+	if (params->set_flags & EXT4_TUNE_FL_FORCE_FSCK) {
+		sbi->s_mount_state |= EXT4_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
+	}
 }
 
 static int ext4_ioctl_set_tune_sb(struct file *filp,
-- 
2.43.0


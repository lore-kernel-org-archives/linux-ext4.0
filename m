Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793237822;
	b=w/BAaCeHMqfgomqGbm6puo/VrW7BFe1FZH6oN+g3eKUoa3Pa68e19JHeMw7hFa/0iSms
	 2EINZFrKzDaTPBvcn1K3aH31c0WlVpNWIrgbwT9usnPdrIDIcczVFjH78yG4LU+l0Y6+G
	 +8rR6og+EAsBEUuYOO6oh9olH2DyJWrilyeEHAkKIDCRFZG1B5redLPGVnNgmdiUYq9hf
	 +NDPOJpgrUBYg05jm+mSMECTL+3T4NWxovuUX7V0kWTiehuNyO22ZrQ7QPy7ygJWkG3iE
	 W+rOYs9IIKDHeV4YKooYqDFeDeCijLobX7m7apXZaH0kgvyp0hclPJsOJQSBVqmNf6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793237822;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ua8SQNKQwB97ZvUclO9jwABs5jUpf1CScj/ICI+TFtE=;
	b=tUfVm9Oz196o3MnF7Qgib9ebEjSEwD93q/xs3KP2McZ22WYKxEzLbofYWLqvKvoTy+Rj
	 9lNUoua66RoN6sUBQMFZc6vjqel6y+IWGRmypsqlRrdGeQTG9S23FqH6GYTSqP/2l9xRF
	 XGjdFt6vXZPQoEJQIiHXUp+5MJvGTuLv6rdOuVaCW9RbbwBnTgWGJD9prFmR+ZvLgW4B0
	 BSUi/UtkmpSoK3yajgsArd5NmvgH0CBKmOfuJDb0AnU6YigyuFxDzCEqm4UuMI11XJ/pB
	 r1hiFY91i7GQoG3t6NHcfm7xldB57a0SI4ohVrxH+G+T7o0Ch1NRHi++wNIKFTq1LyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ljxymD1y;
	arc=none smtp.remote-ip=74.125.229.5
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AAE606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 01:37:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02AAE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ljxymD1y
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-35dc2af1f2fso515281eec.0
        for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 18:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793237821; x=1793842621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ua8SQNKQwB97ZvUclO9jwABs5jUpf1CScj/ICI+TFtE=;
        b=ljxymD1yStlqh6UJL44Vm0LIUAMqUQpeczGCuSfhhUREG/090EFtuULUqgQiIdCFuu
         ToXBRnPYvGky+gOlk5Tal9qXHxc2c5UqR1KadnWFLM8wDtF+h0JrvmIy5Si9OHBB0rrl
         /nkw4c17Ev85zYKOCFzG1zb11MEEGSWHYI2AS97XieBeQGh1GyYtgnf3x4L5iW4r2odG
         vgPdbUhBdKVqthVCAj/Xh1l3Z8EJnwFBsYHXR5ztEDYDfl19SGNxmYUtvQNHM9MkBKlV
         3IaiHtu8nNUaAacdik4p/w04P2JPhnI1hhmq974BDKcZ7qx2OvOaNrQS3Ce37KPbp2/K
         eDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793237821; x=1793842621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ua8SQNKQwB97ZvUclO9jwABs5jUpf1CScj/ICI+TFtE=;
        b=Vcd6iHOALGPPNuxdW5v8GhE3ZjXH9SgVzu9c6Q0q2jReVlPX0Hx8mYUSQ6TnTpe4j+
         emHKPLFuaAx2gnpQflqjtS99k5jRaVQGBFR2t+V5jSR4KPO/tmqxzHb/OOQvS6ADWfld
         qr9oUxuIct73WjcAkS0ElN/PSAmN39apLs5F/cvLJCxz0NDsR4Vch7CcDaHFI8eP+aKt
         xF+WdzduVgr3yoOXqO+HaZnFkeLNoIcFLA6x85SlBowX0oFgS5/iSqE3RgM4b296016n
         9aS8oz3cg4XgLBvxpGZndHmxlfFV3G+O//yT5KdK0iajtfLmofvEp0aqiEfDaXXxRY6d
         t0Qg==
X-Forwarded-Encrypted: i=1; AKwUvBwwytt9SzCa3bnApS3uFjtWZbWR6qm+zypqll/VAvIow/j4gySVz262tdJx3wxa/FRDtyKTc1QYk+Qm@vger.kernel.org
X-Gm-Message-State: AFq9FYL7j7iiqOR3yYeteI23ULbaGA47THiSf9uenTR7gnUEy+VPZgdf
	G1cKfNoqrqeEdB9u0dHafzh6xf7rcrRaqra3nNm46BE8m+0yj+VbyCSh
X-Gm-Gg: AYBFou3FGjDGciigDy7ShI8PBiqzesUnmHTBWkAdudGjeui35qxOAxFVwBU6jFrfDJQ
	LAPIkUj+pq2Y70b597wd3ZUbZtO4q20zO9io0n2OMcy40tELPRN2KDMksnQfcuITgcD5xljxC3F
	MRZ0/u0/dHvWV8Z8uVy7rgfgG1ifJxir8gDlnjhQU5QIRW80quK+9zTvSPxT+xhffcKIsjccqzU
	bqqiX5CGYDW7oj1Jetxk1fo/t+WAvX+PTWVdRf17AVXunfOQQjDdME+XGf3AqjHendAjnu3pSFh
	4IgqxlaIU9FttJS0Q8BpmYi6xDtn36eObLag8g0EHg9KlphZD9V/pLBzlV5N2YOJV5HuuTnAlwS
	7YXHNm/ODSXuKw8s4umRQWKhB0GYZj6jasH4YtdZaiCwrYL89HGCIFyFqDopdpx3IeQjXCiJ/D3
	HGezMc3E6BpshL0xNNDPY72ecmcWdCZ8YSN8KkCauzkLyTENgKYX6hqc1McHDHixnvzHVetrhSD
	9G1l2J4rzCFkKZW1odeV4/DDfL/oBhc1XXHphA1MbKuauk0X90fUErU/v3dmNy48OxtztZJKizr
	shzUd+/An0BR1h3HMT/KZGcBL50jQIvsME2A/aFPcbSWC9t1y9y5k7/n
X-Received: by 2002:a05:7301:4d02:b0:369:a113:756f with SMTP id 5a478bee46e88-36a2046736emr5333281eec.34.1793237820781;
        Wed, 28 Oct 2026 18:37:00 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a239198c9sm11307097eec.15.2026.10.28.18.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:37:00 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: jack@suse.com
Cc: ritesh.list@gmail.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] ext2: preserve IOMAP_F_DIRTY for extending direct writes
Date: Thu, 29 Oct 2026 01:36:16 +0000
Message-ID: <20261029013616.97194-1-dennylin0707@gmail.com>
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

ext2_iomap_begin() sets IOMAP_F_DIRTY for writes that may extend i_size,
but clears the flag after ext2_get_blocks(). When the write uses an
existing mapped block, iomap can then use FUA and skip
generic_write_sync(), even though ext2_dio_write_end_io() updates the
inode size. An O_DSYNC write can therefore return without persisting
the new size.

For example, on a FUA-capable device, a 512-byte O_DIRECT|O_DSYNC write
at offset 512 into a fsynced one-byte file returns successfully and
extends the in-memory size to 1024, while an immediate read of the
on-disk inode still shows size 1. An explicit fsync persists the new
size.

Initialize iomap->flags before setting IOMAP_F_DIRTY so that the flag
survives and the required metadata synchronization takes place.

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 fs/ext2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 12ac4cfe1500..ba23cadb157b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -805,6 +805,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	    (first_block << blkbits) < i_size_read(inode))
 		create = 0;
 
+	iomap->flags = 0;
 	/*
 	 * Writes that span EOF might trigger an IO size update on completion,
 	 * so consider them to be dirty for the purposes of O_DSYNC even if
@@ -818,7 +819,6 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 
-	iomap->flags = 0;
 	iomap->offset = (u64)first_block << blkbits;
 	iomap->bdev = inode->i_sb->s_bdev;
 
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680767;
	b=gwzOkSlPh+J72DJ/2VLga7z/hmANIyGZZyHzv5TUKgZ4Te+zegcoaU7kqReYO2ykzCMY
	 /nqAmCYkQwnzre2iVFzSq2yhezhbB92ocSFqjtU4RpuGvA6oNFAzL36AG0pMw9nbsfvQt
	 PalWwLLsfFx+Ga80gfT5jToXmEazClGb3WgZb0Kjb6l9w34cR/zjFToILLKwI7aR38Tuk
	 gz5St91Lg0hWVm0gfizrDLHt8+mswJfvX86cOFPtSFIWUu9gqVVyUbSR0Amip/Bmoe4eZ
	 JxxAQleV7TVXPQ/hmNFS/+raypsjKZYJfRT8Z5iBLIhUHzpr8fCz0AOsecJbV/QnUtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680767;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=QNV9Grn12kKHSJiLs5T3Kf487Bm6lI3HctQrHxCaqmU=;
	b=NnqonfOW9LtgCE98vghRtFtk/yXYTaHGQnp6W+j9qpVVLJ5EpmmuDJSsH2Z6u3FqnxZn
	 H5XCpUaF+kD6OU2HRHPDZ/JbQ8R7i46DcLR/8hO8jr7NOH59G4OMpbbjOo/TSE6HuUe2J
	 BmkYL2KYTGJ1f8xwbyZb/+gf5WBnKAnRlccH5b6XbbxMXLQ/mGy68t/Xvx+iPAsjJVyG9
	 3jn++FF4TCy9aCKG2aMAF23qpk5Z3P3/qT0XIOYuIGPlpnEO5q2FmzvjRk5+Cj5PB2reA
	 dK00R6Q+vzC80qmx294aPSgbKKSv6q38rgeHkArLIBeKbc06CJqo3cFv+hIhu+Au1Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=c902pZWM;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAB4606A319
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 14:52:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAAB4606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=c902pZWM
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a06c60065fso1338556b3a.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 07:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792680766; x=1793285566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QNV9Grn12kKHSJiLs5T3Kf487Bm6lI3HctQrHxCaqmU=;
        b=c902pZWM+n4QwC8mwy2TjJn98Js9RoDFR0PaRtUDCzSJTUMXm1cOswbgHE6YZXboJl
         s+lVQ+jBvgPfc3g9tupgsNwThSiNSS094wkkUFUuD4PiGP8ZCxdtv1AOuKRt053a/upX
         As07h7+FFUvAsI4Al7SDPf/ix3M+y1LNd4HB+g8XW1U4KUN+tOnuke1q9IEBe8Vyg0cJ
         kkI3Ou7H64RvszbRo3x3JBX2wKsmd3/hlL/WcDVlPvtU3V0LNA/cEOYL0r3svbi4rxja
         2E6QQnKZS5WQCFnznY/GYoNa4RuHDW0jFDXylDZiIZddRBxJtK4afFaK/iL4xM7/VaQB
         UVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680766; x=1793285566;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QNV9Grn12kKHSJiLs5T3Kf487Bm6lI3HctQrHxCaqmU=;
        b=APFwiOBk+PGwlaySjGd5XPWGtecgxSl8fTQQWtBGnfzCoYlXbYkIEOfUBQfx8O2hwE
         eqQGYqyNob0LnS3fY47iK+t3dOnK02zS6nTOlU84DRASy+K0PFQ/f8FBb0ZOFFCq7Z1n
         S7l5XulQxFcr79BUBKMB2zzknhH1MYLsdsY8c/JioPDNrqj9dQMZvxzvQiqxd2DFdcPJ
         bZicEi1t1hVLDEzJmJPzOaxJ8JB/aMUjNH6Om6N0SZNQTwyqrg7dTFGLblcH/cmTV7uY
         7hCdr1apKM9tWfNgWyUM0uOqbpySLJm+AbRTEcrRG3PRG+fYGYw4TtBt7C2q5QyjxML7
         ztgQ==
X-Gm-Message-State: AFq9FYJ8j5nHpV6pCNI2tCmJSYMs7n82xn6B9RrhU6wpqBIxQ+N2wI9D
	eZD/YKRQWSqMcoii7Mxe/U321+YlkJTY5EDfwDbQA9qWravnF+LwdjHQC2Nh9QppHcPghsQFwdG
	opUN5lo0=
X-Gm-Gg: AYBFou1uLXjjVOnFzuV0Nu6Xtp5WXe5yBkQsSKJTqFZ6sgV0eFPQccuO5SUhLCBe8GU
	DmJFns4eL6l27ffqEkQqY6GdtpwOwzpvNv0pbLdYxZv3nqEQzbGpSYeL6Q+DMtMKo0/72HjrgD0
	2vdIs+vPtjjAZOwno1jiuFLI4nv0/J6FTB+i6ip2CnV6H7StMfx6V0SC2YXNKegFxeFJxNblsTM
	p1q6TuOBQhagR/Xkv2n+hfVPz/FEpr9YbSfwGXEHRJWbph71xMouvSMAtyhej2KjeiMZb+5sWi0
	T+fb/CqMISANKJ5vPGA5zwGorMG5oIJ7g1dorfYyAd4MWQbJa/Y9GMGj+wx0d7cS19ddyUzUvF2
	48SvOpdAXvBXHx+QArCkSmbeWNUx9/J3tsbZwtXmRxxnjp2VduRyNlAotuAA8VEHivExachKUKf
	45Aslz2oOk9FnTJwOXoj3q8Tg2AXqOW5PR0Jbm1wHFXXxUIk2DppvklVBLWS3RYuGxT+iSMgMVh
	4UG1MCLrYTVDpojeMB7+d2T/EccfH24PTzgu/iiyP3uIbIMb9C5/PaKWvE=
X-Received: by 2002:a05:6a00:328a:b0:874:705d:f659 with SMTP id d2e1a72fcca58-8a089d2c932mr4362035b3a.39.1792680765922;
        Thu, 22 Oct 2026 07:52:45 -0700 (PDT)
Received: from localhost ([106.38.226.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895fa967sm2263961b3a.47.2026.10.22.07.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:52:45 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	riteshh@linux.ibm.com
Subject: [PATCH 0/6] ext4: fix buffered writeback error handling
Date: Thu, 22 Oct 2026 22:52:35 +0800
Message-Id: <20261022145241.2950379-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
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

This series fixes error handling in ext4 buffered writeback. It prevents
stale data exposure when mapping or io_end_vec allocation fails, reports
unwritten conversion errors to fsync(), and preserves concurrent io_end
flag updates.

The patches are arranged as follows:

1. Move extent mapping error handling out of the loop, without changing
   behavior, so the following fixes can share the partial-folio path.
2. Submit mapped buffers when allocation of the next io_end_vec fails.
   Otherwise, their ranges remain eligible for unwritten conversion even
   though their data was never submitted.
3. Submit mapped buffers when mapping a later extent in the same folio
   fails with a fatal error, and discard buffers still needing mapping.
4. Drop the folio lookup reference if partial-writeback validation fails.
5. Prevent silent data loss by reporting unwritten extent conversion
   failures through fsync(), instead of returning success while direct
   reads still return zeros.
6. Use atomic bitops for io_end flags so failed-bio completion and
   writeback cannot overwrite each other's updates.

Sashiko helped identify these issues.

Julian Sun (6):
  ext4: move extent mapping error handling out of the loop
  ext4: submit mapped buffers when io_end_vec allocation fails
  ext4: prevent stale data exposure after fatal mapping errors
  ext4: put folio on partial writeback validation failure
  ext4: report unwritten extent conversion errors to fsync
  ext4: use atomic bitops for io_end flags

 fs/ext4/ext4.h    |  16 ++--
 fs/ext4/inode.c   | 188 +++++++++++++++++++++++++++++++---------------
 fs/ext4/page-io.c |  24 +++---
 3 files changed, 148 insertions(+), 80 deletions(-)


base-commit: 4403278e4ea2f654f8130a5c03eb8b4516a0f201
-- 
2.39.5


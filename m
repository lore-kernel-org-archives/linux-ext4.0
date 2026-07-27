Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9E236B905
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186783; cv=none; b=eaz5s+ClnC0qOOaZw6j/V4N9GdnTyGR5K0wCM2dSvATchRmxmYu9HD0qDLCNTmt63a19j4LvAQaVOUJaeITbv0B2zX9oe8ozY68bL+Z1jOeL9TGCd/YE79FLcbMVUOUALutH51kO6H0KIW6mxTuzLaOEwVSvnFG9lMCaLARoE/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186783; c=relaxed/simple;
	bh=90rjgUd1LXHKjPgWSMh7PtrzND5nxkvCg44/1PJd/SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aOGbOMO3jFbj70NyK5KSji+Ku0YZPmfwNgJYfcPMKy8kjQp+AARdaqy4FcYLYKLN4PsGrOC5Y3iHq/Il11qjucKF7z/pm7JXBUkKa8ci5FAlPrQz3uFeN0V7jejZRSphPV2up8NYId8zHkS+SNLWhrjMBOIrIweBMr7dmljtPrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EJRQWN7U; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EJRQWN7U"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so31008465e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186780; x=1785791580; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Djix6mFi++SL+iKtbaXi7TL6UT5ybIJWzXHMFHrkZ0s=;
        b=EJRQWN7UBrXmxK0BSHikqeQa72nu18EZ2Nbg1h3oF79xR8ajMHiHL+Y1jmBwrsBSlQ
         wVzUXf2MZQXzDYRCR1/LJn2kLXLSg6Yhms2qhX4NN2pCEGyPMkGFaX1o4JFkX1ypy61x
         1SeQ/t1owsoLLjAP3vquTk5puP+AR7/ZHYn4gYAL8PbLwFpPWG+1KdSIPY3F+S+w38QY
         lx33Gf5vk0DNmVk8sU8c/O6FFYEU7Qdc98p3GKJkNDnCVTqR/t0FcZT6WsodLZRX8fSK
         epTAhq3JNI0Hmy4VRFiM+Q1JTZex5i8oGiyzQPRokc1sjCP/jHExaVNBTukjGQjFZ55s
         f5cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186780; x=1785791580;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Djix6mFi++SL+iKtbaXi7TL6UT5ybIJWzXHMFHrkZ0s=;
        b=ISK5hFfcnz79m7tFNHZ2heAop/72/uSIJ05Ct/TMeEQlMFrqjfUuV6nvnZU1eJPDvg
         HHB7Fg5CO53eyQ02kwDPc8VPGd5voeaS84T0j4eSBWMacD4foa2A5J/cBHZgYxV/dhXN
         8FV2uAajpURNYGvrQfMiMNnYrYC24oAe/fQopfMC9dlsLNhR5150L7wRKK3yHVxo1js6
         S+0gYUtMZt06YPXTdit5jJF0d8phxVS++cTZM36PaLkFpZOpVqEMv3r32nI54d0xgXYw
         xrmWUpNkUuFLwGtpiqxaPZJUiHDRcylYGCNu1kiLe1JTedmVZNIZcGJaHkYAEfQojSKi
         2Vyw==
X-Gm-Message-State: AOJu0YzlzQpHGB58z80XUu9zvjHEt8WUx6/Dxdx26CbKqJx92zLh8P6N
	+66bzSVBhY7hCc/A4pIxtys5N46PmJTs5Cqu/jf+4ERPmEiq9q4nvFZG4PnTLQ==
X-Gm-Gg: AR+sD13ykbi0XCrR3U2noMAjnBwTOd4vrI18goPsB3uBHIzW3ubNJh3RxCTSU9hYYoU
	/ax0PDe60Z0SmxWffkL+KLEvczbjPxkWAfYdxfLEFBRMchCMi12oG3XFpIm6r9qbFCyuM5UN6Qe
	cpEtlkamJlVwR6BqLLF/iZbF7aXHaWcaQ8oOGFHJoBc0i3SDT0Mlo3ROexFJa1Q9MnleMFVIVJE
	y5e3ijjHJ6MG2JsvBRUtVBxgVuU/1kAJcqBG0FIpGrUPxZy1ILmSCnX2clmPBjdlOd7b0NmmujH
	8DQsAiAo6OkUH5GThVhN5FxZSLnRSjN/w9OF40ImH6i5DvAR9JoPB2CljQSt5q8pAA/VMUyWzdu
	JRb6MS8v8BfbBPnJsaj9ZdalRnmKk/1ub4Y/gG28bPDr3HVJV+Cm9qF+RgDfyZDst8CKXbvATK1
	ITRUKNhI40V8P82javjqhBHSPJ3JlSWKKf/A==
X-Received: by 2002:a05:600c:4f16:b0:495:4fd4:f7b6 with SMTP id 5b1f17b1804b1-496b6a31f2amr136535475e9.37.1785186779876;
        Mon, 27 Jul 2026 14:12:59 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44afaecsm24910245e9.2.2026.07.27.14.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:12:59 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [PATCH v6 00/11] Data in direntry (dirdata) feature
Date: Mon, 27 Jul 2026 17:11:12 -0400
Message-ID: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

EXT4 currently stores an 8-byte hash in the directory entry immediately
after the file name to support simultaneous fscrypt and casefold
functionality.

The dirdata feature provides a general mechanism to store multiple
metadata records in each directory entry after the NUL filename
terminator. The unused high 4 bits of 'file_type' indicate which
records are present; each record starts with a 1-byte length field,
providing forward compatibility.

The first user of this feature is LUFID (Locally Unique File ID), an
identifier that must survive rename and be accessible from directory
readdir without an inode lookup.

e2fsprogs support is provided in a separate patch series.

Thanks to Sashiko AI review for identifying several correctness and
safety issues in earlier versions of this series.

Changes in v6:

Patch 09 (LUFID rename support): replace the unconditional kmemdup()
in ext4_lufid_snapshot() with a small inline buffer
(EXT4_LUFID_INLINE_SIZE = 65 bytes: 1-byte header + 4 × 16-byte FIDs),
falling back to heap allocation only when the LUFID payload exceeds that
limit (ddh_length is u8 so the maximum is 255 bytes). Introduce struct
ext4_lufid_snap and ext4_lufid_snap_release() so callers are
storage-agnostic; the two-snapshot case in ext4_cross_rename() now
avoids both heap allocations in the common case.

Artem Blagodarenko (11):
  ext4: validate count against limit in ext4_dx_csum_verify/_set
  ext4: replace ext4_dir_entry with ext4_dir_entry_2
  ext4: add ext4_dir_entry_is_tail()
  ext4: refactor dx_root to support variable dirent sizes
  ext4: add dirdata format definitions and access helpers
  ext4: add ext4_dir_entry_len()
  ext4: rename ext4_dir_rec_len() and clarify dirdata usage
  ext4: dirdata feature
  ext4: add dirdata LUFID support for directory entry rename
  ext4: add dirdata set/get helpers
  ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory
    entries

 fs/ext4/dir.c             |  33 +-
 fs/ext4/ext4.h            | 235 ++++++++-
 fs/ext4/fast_commit.c     |   1 +
 fs/ext4/fast_commit.h     |   1 +
 fs/ext4/inline.c          |  49 +-
 fs/ext4/ioctl.c           |  84 ++++
 fs/ext4/namei.c           | 974 +++++++++++++++++++++++++++++++-------
 fs/ext4/sysfs.c           |   2 +
 include/uapi/linux/ext4.h |  14 +
 9 files changed, 1168 insertions(+), 225 deletions(-)

-- 
2.43.7


Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E174964F
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781898794; cv=none; b=nfiXWMikZzwoQbadwoxHKOzpSe5rwDZNXVIbEEfoRCEZRobo2jzDH//A6ndxFb0MqNsDH/xTeZGbkfQgN/45B1Vy0Pn/Uju+9HuvejmOqF2XjviwaBxPK4Sg53/aqwAiRJoWxhbWUPOOKjpxNOkuG1FJtqb4ii2YA4uH+VtphTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781898794; c=relaxed/simple;
	bh=hcbV0DkhKBkQUJA+w51I84mPYMelfvbNgYLSRjD74KA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DasoBv8Qdeg4ar5nxoQB8nvEZeFinuGhuTAl++vvHm2C9THGt07+iaGPxVwkJK0ORKFBbYjut5NHTO4lGLpn2gTMdk97pW0uTluF4ZdqRxzO6tYuTPSa3b/APeCKoSvaQ9zdFMr/7sSi20vOH/r//LEEYD6nbcQ62Fz0U7jJvTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nxj0DSES; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nxj0DSES"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso33748715e9.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781898792; x=1782503592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YpYtYSOUJ6LlhvZr4y6DbKdAXzo3rUfrqUgg3dSAJcE=;
        b=nxj0DSESGYltz7223mosnyGfUJbKCXyrCwo2Bl0lTC6bFgoCggBApmf2mI9W5CpZxU
         4waQm4ODD/7SUlJDAhcHX46cRQsqHQURSdLttPsiSHgsd3j2HPtLbKyatCSfOvZToaHl
         9ZYccuUL/08jsy4VW+Z49Nfx45dDC72Je99mDw7/4SxT2ZRimUI9WYJyCIi66VD7eyNQ
         jYsiWdCUcNY9eBQD72nHCRYaoTB0yVd7SUnw2FKFHyBPWbfbizLITK2Cgc3Ejm0G82WH
         HUXNsZ0y0JlLIF24OvL0Kjl7v0N6E3OwO0I5u5Ai6KJqnLXjKUMBHVac5EOHplSmWJGA
         kybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781898792; x=1782503592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpYtYSOUJ6LlhvZr4y6DbKdAXzo3rUfrqUgg3dSAJcE=;
        b=WNB2c+ToF7r1orgOzJii7lK/tw8ta0Az6bYqldaSCUiYv2DuP0UbeoHY3aT6VmhoZq
         cvnhYMBpkWowSshror0OtxpiqD5ZUweXwb1GvrBbK429ag4uTecb4aCkar72zpvIq3zw
         aEKJmZQE+MKiG2fIGjsz0tXCGGzgOZW2AQ2kr+4h3Avfcif9Ycck2w2/bllBABq0AjXy
         CgT5d5u0shWW7WEmdHgkwLAy+ydJq3XnBK2f8UXTFG+j9TFGDvQw+tB9kYWxuBk5Ljuk
         9nBCKzTHDOBnY5AXp7ZzNEObXK6q449aaq6BHhg0BCm4cSCGzjM06Kz99aTMJpJMAO1p
         ajVw==
X-Gm-Message-State: AOJu0YzdgvUEhEzGqs6juJvqo59/yZ1z+Ax08CP3HZv6ohn19CEkuwU2
	Ki0LIHkin1isN7WVN0NFx1Az1MkH2eQA0O893kOevKmGnf1iZVPm2PTUGt7mF4IzBaPBMA==
X-Gm-Gg: AfdE7cmZlKevgZofVbAeMva6QitMjeM15V6IdAIFPGiFP9pg8EbeVmCJvMulvfjwfia
	CKMmHe9M8MTO9Sk/ucxWYlfixdlmdEE/STXrR/m1AZp/NMrTSkYkb+EBQxTspLSwjBLkuExOnKx
	ie37UX9p2pyXSRLRrpIxpnXSyvGrxg1+KdMdXqna6tj+n7u+eisBQcuYismG2e46vY6ENPm+xfK
	HF4WNXjopc7xAC2yKFksNopx4qUd4zVXpRafJsPRnsG/kdcdtDGgwHTvAwpWIbvh9p34y7zwIUY
	g61ZdjfY9gKivUFxn0IvpIEyhtuw/kOvtlLnu69k9aqJV6hTM9rEeYrVUfOA8gicGSddw4fjzez
	hVIBKLZVMy8rWlvezgPItVnEKl71aVDzAgSwoLF98nvgWCbKtJGdZyvLmEPghpFyZDpzl+Vk1ot
	/nc708NWy5fVGfWuuVj202i8yR0yVuMd2Zoa903cbHUA==
X-Received: by 2002:a05:600c:4889:b0:492:4658:ac00 with SMTP id 5b1f17b1804b1-4924658ac64mr21846255e9.6.1781898791755;
        Fri, 19 Jun 2026 12:53:11 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e3esm1430822f8f.8.2026.06.19.12.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:53:11 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [RFC PATCH v2 0/6] ext4: tests for the dirdata feature (encryption+casefold, LUFID)
Date: Fri, 19 Jun 2026 15:51:59 -0400
Message-ID: <20260619195205.29384-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These tests cover the ext4 "dirdata" feature (storing extra metadata
in directory entries beyond the file name), sent separately from the
kernel and e2fsprogs dirdata patch series for reference and review.

ext4/064 and ext4/065 verify that encryption and case-insensitive
(casefold) directories continue to work both without and with
dirdata enabled. ext4/066 and ext4/067 exercise the LUFID (Locally
Unique File ID) use of dirdata via a new EXT4_IOC_SET_LUFID ioctl,
using a small set_lufid helper utility added in this series.

Changes in v2:
- Ted Ts'o pointed out that the v1 tests exercised the
  encryption+casefold/dirdata feature combination without actually
  validating that the encrypted hash was stored as a dirdata
  attribute.
  ext4/064 and ext4/065 now use the new _dump_dir_structure helper
  (debugfs-based) to dump and check the on-disk directory entry
  content, confirming the hash is actually present as dirdata rather
  than just exercising the feature combination.
- Added ext4/066 and ext4/067, plus a new common/ext4 helper and the
  src/set_lufid.c utility, to directly verify LUFID data is correctly
  stored in and retrieved from dirdata via EXT4_IOC_SET_LUFID, including
  in combination with encryption+casefold.

Artem Blagodarenko (6):
  ext4: add common helper to check whether dirdata is applied
  ext4/064 encryption + casefold feature combination WITHOUT dirdata
  ext4/065 encryption + casefold + dirdata feature combination
  ext4: add set_lufid utility
  ext4/066: verify LUFID dirdata operations
  ext4/067: LUFID and encryption+casefold+dirdata

 common/config      |   1 +
 common/ext4        |  34 +++++++
 src/Makefile       |   2 +-
 src/set_lufid.c    | 196 ++++++++++++++++++++++++++++++++++++++++
 tests/ext4/064     | 153 ++++++++++++++++++++++++++++++++
 tests/ext4/064.out |  17 ++++
 tests/ext4/065     | 217 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/065.out |  26 ++++++
 tests/ext4/066     | 158 +++++++++++++++++++++++++++++++++
 tests/ext4/066.out |   4 +
 tests/ext4/067     | 137 ++++++++++++++++++++++++++++
 tests/ext4/067.out |   4 +
 12 files changed, 948 insertions(+), 1 deletion(-)
 create mode 100644 src/set_lufid.c
 create mode 100755 tests/ext4/064
 create mode 100644 tests/ext4/064.out
 create mode 100755 tests/ext4/065
 create mode 100644 tests/ext4/065.out
 create mode 100755 tests/ext4/066
 create mode 100644 tests/ext4/066.out
 create mode 100755 tests/ext4/067
 create mode 100644 tests/ext4/067.out

-- 
2.43.7


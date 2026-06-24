Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22FD26F2B9
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309030; cv=none; b=naXp7xIHo+uxxX7Xo3H76ntvbJNU33WS1XMD5SXSUOUt+QPT0WxC3ma5gE/rXRhj9bCymJqulMkAf0/eDmvvZ9gwOWNdIjRTUExW/i4Fhzf3hYaLbcs5QwpMY42MYMr4ENK68oyPmQPn8rncSvdSswuUu66S9mY9ZYCorAUqOwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309030; c=relaxed/simple;
	bh=2GBxFA4cfs+0Zxhz6RNU0abIl3brSeVLn80VKPkmtSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uDnCe0IpvOVtEcl1js7FZ69BboVIn0QGpONHphU0eKX4ybUoaHbwN3OgJm5gq1TDdGJp5F6RI+DfViKObE58GwbR85l/NHpPu/itWAAxs1Ic+1TgXoZfKtONiNjPEdPEhCKjeJKJv1gRNsJ8f/QS3ycQEySvPTaLIs6CtfliKpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YQp2QVRN; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQp2QVRN"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-46255b269c2so745970f8f.3
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782309027; x=1782913827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=140JWCzMK6FmajkHl8w6qT8k5bZxUXlx80xZmvvVAXA=;
        b=YQp2QVRNdE22i5+2eE6whjVAKQ+wI5DGNIRW9jvc/3bVAce6GiMS6HtGbyXTXjns7j
         59BG8HwyEBSUFhq6DND72jhdAx22DrnUyWRxOoVrmmC+um464pvClisphYAKPEX9qD6X
         98vU87R/hIAkxKZFvRnLH8ff6GoEdQZYI1DwMcB86tXmiwChGV29x2MhchdPkyDkYsry
         Ki91qo8tONPnjN9Yv3gESm8iGz0v1uE+qut7PN6aGOPBg32ZLxw+lGQ2swQ8DaTnVsBs
         ezLkbZPkYlJ6WFcfaYn1CRozX0o4wf0aRPFeH9/Myv86v5qlz/b7cl11aFdxVbNPjOlC
         aong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782309027; x=1782913827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=140JWCzMK6FmajkHl8w6qT8k5bZxUXlx80xZmvvVAXA=;
        b=JZLTh1EA/tAqNtOo9qfSLu9v5cX2BoSvvsoVZXfxDxUMr6x/DSzNs/y0GmRn6w7CV0
         562CyeF2ow7QfZaNORTgfMMDv4vAPqud4xEknqq7CyiZb2H3ujN+ulBKdmMVH/77dDdz
         B8yPc1+FPasnQ8YGKEFFyKSnlozJepTD7zV7ht9KWA9nRLtErIZKODzuIkvbA4xA2j/Z
         oSQ6Dut0TcznIABcLSpTjCuTd6I/YG6sabfNM5SvVq3crrOrM8xm+yeGw48vAVIzYmOo
         pO/Srmeu6I0/2E3L+QprTh/RNPh/EqOSeo9gIRE7xkM2HtOXLamihHCA5eblIzK23XO7
         S7zA==
X-Gm-Message-State: AOJu0Yw0OdUo250kerKXbNj0tAZbUEzzq8Nibrk2XsELLgy/xLSTpfH4
	9rY7wU02bxtJcuyxKjkip6tK3hCxC+zHkqDlwD3FTeFMdfZGfNQxDSgVIffvzUHHICE=
X-Gm-Gg: AfdE7cnlNPvB+udCrZ3mxE57Qb4l5pt2jy19FmoCcihH7BbdUzCCA9oc4O/EeNubX/B
	gxrDL4z+ZFeqrmC1cKgceqiiRvkRzp0mo1j10Qxop9u5c3K6zgAUeMD1JOgl+SCDhLGs/pIBia6
	4pWYDz80fVm7UGOjGMWKViLbvY2uTXI+nkjZTRwtMCug2mWFbYFwD3VFIjDsQnvNJOIldi39HBU
	TLGUwOdB5eom9KGF/0FmIsKWni8mbZfxZvggFlAvYiTwETLfVFpwWntnlJvu0gr+/bDo4a15BTo
	gE/b9h07WrtvEEDHIBP1cz2Q3grTSaBFtsh6xBMRAD/M8uA3TzhHsJ7pExZojxRbkh6gHVR8vTk
	ihyy0tCn2C7vkT7JK8uHSALw9CH5qOdC5sxb7hQzfWOo5QJRJRYSP9DSt0HdNS29FJEi2aALQut
	xa1kvQp467cNeuFT0V4M5eQ743eJX+K4+Pkp2tP6PPjTfy
X-Received: by 2002:a05:6000:44d7:b0:460:2ee5:67b8 with SMTP id ffacd0b85a97d-46c07569d64mr4000129f8f.36.1782309027084;
        Wed, 24 Jun 2026 06:50:27 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1e840eefsm7791658f8f.1.2026.06.24.06.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:50:26 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [RFC PATCH v3 0/6] ext4: tests for the dirdata feature (encryption+casefold, LUFID)
Date: Wed, 24 Jun 2026 09:49:51 -0400
Message-ID: <20260624134957.19209-1-ablagodarenko@thelustrecollective.com>
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
  attribute (https://lore.kernel.org/all/20260418214359.GA58909@macsyma-wired.lan/).
  ext4/064 and ext4/065 now use the new _dump_dir_structure helper
  (debugfs-based) to dump and check the on-disk directory entry
  content, confirming the hash is actually present as dirdata rather
  than just exercising the feature combination.
- Zorro Lang asked about a confusingly-named helper
  (_require_encrypted_casefold vs. _require_scratch_casefold); the
  tests now consistently use _require_scratch_casefold.
- Added ext4/066 and ext4/067, plus a new common/ext4 helper and the
  src/set_lufid.c utility, to directly verify LUFID data is correctly
  stored in and retrieved from dirdata via EXT4_IOC_SET_LUFID, including
  in combination with encryption+casefold.

Changes in v3:
- Fixed two off-by-one bugs in src/set_lufid.c, found while testing
  the kernel-side EXT4_IOC_SET_LUFID fixes against this suite:
  - The default (binary fid array) payload path computed
    data_len = sizeof(fid) + 1, copying one byte of stack garbage past
    the 16-byte LUFID struct.
  - The explicit (argv[3]) payload path computed
    data_len = strlen(lufid_data) + 1, treating a NUL terminator as
    part of a binary payload that doesn't have one.
  Both surfaced as a phantom extra FID in ext4/066 and ext4/067's
  dirdata-dump verification once a kernel-side dirdata length
  accounting bug was itself fixed -- that kernel bug had been
  silently masking this test bug by truncating the same garbage byte
  on write.

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


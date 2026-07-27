Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECC836B905
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186842; cv=none; b=qMC0p0QiTDUJBmW27d6jZvEv9JIwGwU9+1nCBtA6QJJaMpTLdwUUuC2DBHi2CfakITh5zK2w+TC9LU0MAYZvlT/uklCCImCzdszEyE9fBLFZF2hk7v/6emyahPR9DCXlOhGThcijPNm7UJ+xnf2CrlRoVDVi/xxxIFZbYe0CzG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186842; c=relaxed/simple;
	bh=PS+DlGdvd6FaOyQQrlgH0KM1iiociTXm/1aodX6xKuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WzjFv7IsiBMOgl4Ifg+wabOXlEnor7QK0pdzoWsXl8esdbljP1dKC55IWp1fJvNmqT85NoTpSs/FN9e+zwnrHbFlfGVF5mSwJq2mm4efLe3Ry3Qj90e28e9YHy0WWmQ4D+/+KYgv7be4IGPk9fkRu0xB+YJC/X94yqgzVxWOM+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QD6l5qpb; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QD6l5qpb"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so2616753f8f.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186839; x=1785791639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/1IP3HuBrpji+FqA1AiB3qmJVZgSIih67uEPwZtbWeI=;
        b=QD6l5qpbahx8ae/sh5pYGqhKiLhvWLK8GtBlXGjf0/AG5emzgGQnmlnmcv3EMhiFWh
         UVGbkI/0/3WXfmmVyUix4Pb6RqoZxuOchvsNUS5fOYqowkt8lhKBL04LLPy8bjunDuub
         hvgzm921KQ7OhBwt3PpesbDL7EiLAwwfe+yxM+PmE4/xqpeGj88Dv9m2VxZm8Z+tCFJE
         hKi0QCaUYenYqbjeJApWAxNHegva6yNbCk2mh8PnuOAo2bs2eOuxDxarl3XolPlNFKIS
         ViBtRPHA7er/p+z2Xl/wJ9fLhmaA+TDW5/y8LVUeSQfVHK3n1qd6zJ/dBxf2jBvKG8UF
         BPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186839; x=1785791639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/1IP3HuBrpji+FqA1AiB3qmJVZgSIih67uEPwZtbWeI=;
        b=Nx6C+0XkQTDy6oLXEO/Faa8dQdqDFaZOKofrxk4M9+vox5CkSLu6oZH3pYATMPWekT
         ik+FAE7YMzt5s9nTkrQ2mCGT9JSkCzoJ11MXhZwZInmyfaxemp68pzu9wSL/cTi4dLTC
         /j2LTTes2qTdgusHvZOc/3aWf6GNvGnqbrvFwDpdbnCCZEh7z+XDDPkhmEcV8v+tovAU
         9MPXqbrtmyI7EhF0TXkXeWQlej/FKzyhyFKVbShxBmmyxXykBR4drYbKujJMVOurOYZI
         osyZb/bNCIfnYxeapBGAhzYH8/3rrw/6Tiz/SMFLlTdBKQ79ZDnwdV/+iVNdYKplGuVP
         dy+A==
X-Gm-Message-State: AOJu0YxxJA+cWqElqd89YmIchRydgD7vgLwS2AwXcFidUNm53aABTYzL
	k8r0FZZTqEmiNNWy3mUOHYimdkCivQcDQajpm5Q6SJSY4G0JWSsxAehZB7V4Ze3s
X-Gm-Gg: AR+sD12k542IpxdHOy3RTCnzOhDlLj+OXVRe/hYKBIPW87HknbovT72MYiijdXRlqMG
	ThUakIi/jreANx5/o9BgihZgfca/CkLolr23vkxAP3Rd4BkoaK5L1kIYL0itBbBFJKRiR3lNUbT
	9cuc/8zni/R8OarkK3UNX8ILsy7ME++d8g2nXAjrnmVoAJhiOO8rfNZ/e3QhVE7Bjan/gzgktuA
	8We65EzUo1QdrCp1dpcMydDgeZQWEs/C5QEqvILgEX14knH6wY3uuTp/eVs+h0jHVk0z/W+XrEw
	KEWTBURco60TNnUbWJ7ZDEEN6inNFZjGgWGlXfXkgoI51A8StnYI9pfPYQiW2B0EUGRb7/dlC2m
	+NDd7hGcx190sTHxUrN0K9r1kE/xV074WVKO1XbcQjkP+jrDutgs1RtPjX6hS9Vhup3kteJsQzK
	jpui/uyU+8Blm81BQkrNK7acyuyoPP1o5hwxaOxaWNdwwC
X-Received: by 2002:a05:6000:25c7:b0:47f:8480:4abd with SMTP id ffacd0b85a97d-47f9fea2c89mr12896833f8f.29.1785186838958;
        Mon, 27 Jul 2026 14:13:58 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:58 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [RFC PATCH v4 0/8] ext4: tests for the dirdata feature (encryption+casefold, LUFID)
Date: Mon, 27 Jul 2026 17:13:32 -0400
Message-ID: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
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

The companion kernel series is:
  [PATCH v6 00/11] Data in direntry (dirdata) feature

ext4/064 and ext4/065 verify that encryption and case-insensitive
(casefold) directories continue to work both without and with
dirdata enabled. ext4/066 and ext4/067 exercise the LUFID (Locally
Unique File ID) use of dirdata via a new EXT4_IOC_SET_LUFID ioctl,
using a small set_lufid helper utility added in this series.
ext4/068 verifies that LUFID is correctly carried through overwrite
rename and RENAME_EXCHANGE. ext4/069 covers LUFID in inline_data
directories.

Changes in v4:
- Added ext4/068: two-part rename test (overwrite rename and
  RENAME_EXCHANGE) that verifies the destination directory slot
  carries the source inode's LUFID after the rename, not the stale
  LUFID of the replaced inode.  Tests the fix in ext4_setent() that
  copies the LUFID dirdata payload through rename.
- Added ext4/069: inline_data directory regression test.  Verifies
  that a LUFID set via EXT4_IOC_SET_LUFID on an entry in an
  inline_data directory survives to disk.  Catches the bug where
  ext4_add_dirent_to_inline() was passing NULL instead of dfid,
  silently losing the LUFID.
- Expanded _dump_dir_structure() in common/ext4 to match directory
  entries by inode number instead of filename when the directory is
  encrypted (ciphertext names on disk do not match the plaintext
  filenames visible through the VFS).
- Minor updates to ext4/065 to use the improved helper and add
  verification of the fid= field in the encrypted+dirdata case.

Artem Blagodarenko (7):
  ext4: add common helper to check whether dirdata is applied
  ext4/064 encryption + casefold feature combination WITHOUT dirdata
  ext4/065 encryption + casefold + dirdata feature combination
  ext4: add set_lufid utility
  ext4/066: verify LUFID dirdata operations
  ext4/067: LUFID and encryption+casefold+dirdata
  ext4/068: test LUFID is carried through overwrite rename and
    RENAME_EXCHANGE

Lustre Development (1):
  ext4/069: test LUFID in inline_data directory entries

 common/config      |   1 +
 common/ext4        |  63 ++++++++++++
 src/Makefile       |   2 +-
 src/set_lufid.c    | 196 +++++++++++++++++++++++++++++++++++
 tests/ext4/064     | 153 +++++++++++++++++++++++++++
 tests/ext4/064.out |  17 +++
 tests/ext4/065     | 252 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/065.out |  26 +++++
 tests/ext4/066     | 159 ++++++++++++++++++++++++++++
 tests/ext4/066.out |   4 +
 tests/ext4/067     | 137 ++++++++++++++++++++++++
 tests/ext4/067.out |   4 +
 tests/ext4/068     | 202 ++++++++++++++++++++++++++++++++++++
 tests/ext4/068.out |   5 +
 tests/ext4/069     | 164 +++++++++++++++++++++++++++++
 tests/ext4/069.out |   7 ++
 16 files changed, 1391 insertions(+), 1 deletion(-)
 create mode 100644 src/set_lufid.c
 create mode 100755 tests/ext4/064
 create mode 100644 tests/ext4/064.out
 create mode 100755 tests/ext4/065
 create mode 100644 tests/ext4/065.out
 create mode 100755 tests/ext4/066
 create mode 100644 tests/ext4/066.out
 create mode 100755 tests/ext4/067
 create mode 100644 tests/ext4/067.out
 create mode 100755 tests/ext4/068
 create mode 100644 tests/ext4/068.out
 create mode 100755 tests/ext4/069
 create mode 100644 tests/ext4/069.out

-- 
2.43.7


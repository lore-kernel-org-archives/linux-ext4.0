Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D58341ADF
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896319; cv=none; b=FCU+hIbIuCpT5IzN94eO95gEr+MBAsFs0ixR75tC6OxpuCVt7qKagc/GdYfQ0HJohkEBpALu80oQO1t6C5tPjbGa5HPcnZDs4nrTHjaHHWPA+74LTJGObVzqebcv3p7H3qHFFCPE5pNJ0Rxm9M2tFGaBkDpJ+cAhlGgGkaFFLgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896319; c=relaxed/simple;
	bh=1uZRTwZQ8mjVZ/YwV1/R6RYC8JtI0f3p3qWnU5GNdhk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ajlIn67RGXSszLBETbnKn1AxojUAPw/iLGTjKVpFurT6RlhBF2hIzJzQU/C9wOFniTBdQWGZmhwUWsHnLnxqhKhbi4colCFWBF4stiACZgX/5C6yy6+tsgv9+SdqJ2T0jtlcQw8nl2+yMrqVSCPbDgZCZljiM8XuGuppFske0Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JEUhiVvJ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEUhiVvJ"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b64c8311so22798625e9.3
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896313; x=1782501113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DwCve8rp4BT5d3Xx1RO7T8ft5anzvu3yyAVQvWKe9Fc=;
        b=JEUhiVvJmw8ykUkC6zoBZRZohb1P5i0F+wFNLAXiGaceXNeAn7qeDZGMqzJT0DelI2
         Ylte5AhuDQcCeSEn0M85U0uQTHKCpG0Xtm0c/kbhA8pGjHGT4jMOThwAvV0TubJ6a4HL
         CSIZXM7Gn6b1AFg+5LNzVSsinFESJB0TWABhHefeji8vEI80N6eeiUQMLux7LwDmBHgd
         G4bqaX9lESRhSGB24nePKyKatNSj5E2hPlGDjNHk/df1WWh/cYmICEK605f6AxVDKqLo
         zafSrH7XepToNVhJjqfEx7JuByDupzbwPA5zNeLx4oBtaW0MW0qPfuunqMh6j5WCAx2p
         KN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896313; x=1782501113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwCve8rp4BT5d3Xx1RO7T8ft5anzvu3yyAVQvWKe9Fc=;
        b=Sq2CTxlmkbmjQ2DO3SODxc0HLQc7eIPWF29ePty9zfwyBANHmqkBUmWKP8tLRCy3dA
         woCD5dcfnN8IdYKo/DH2ygdOVKR6T+UOG8ATCiMgUivFGgMrmOKT/ja/oE7nRp0eKrL8
         7nh/eTp7uVkxvt/wSUa4gPVFJyYrlh5azwnoXczptA5uJF8DIsDiITye1pEmEeDLqepv
         iwPRw+QdjitHK2Q7/IRDD+Ry3o8ROVGsct4OXIdLcLpxA5fad9bvTUDecudUcvDHFenC
         z2lg4O3ArVCU+lPcnGkH5t7m6B6v5KUtQQuo4+yxKjY+evxyczxf9t3pAnZ9bV5zj3VY
         6LIw==
X-Gm-Message-State: AOJu0YzaXOgt4sThdGYeUVvwMkrIXUQiXRLMB1ZHuH6DGdxWI1tbuBl8
	dH5fptBZ7l6MqCmNMNT6F7at5z7Uzc94boQSd0hOMbYLIFAXkALjnHN/vd9s8mSMiQ+xOQ==
X-Gm-Gg: AfdE7cnYFYzXkoPlT/WzUVvOY7AAC9Q0e2//1Xox/W0DYyB9t0KctAidxIYA83uJjNr
	SP35+NF7+v1odsbGC1IITsAicJkl0+agFt7ChGBdC01fziURFFcSgAtrSSlWkO822oa3pktPV4E
	3AccZ04zVjslVUWp1mJMFwP+eDAQUam4Uw+ZbefdXHS/2Q1T64eVGxPRgWBrF9p5R3I8+RbcRW8
	nFqYjJU6hKWVVW7FSc2ZuOkh2phh2I3lAc/0iLv5XPUW1co9b5OyMwwU0SxdsANx55U/We8N3L3
	6tGt8K1oV+VcLQaib+yie2dqq7kBCWbc4yWi8ddYBsyIiK+VQ7uW4wZRGtsBgeTdxeO8Eh8XcAQ
	152F5f2LkYP9LV53+NGjJCSdG/aTpTf/8SQ2D5NRx/244ITg56QMNWN5G0VXseIPXfhT9/B+fpt
	cmRX3nmSrfhdMzMElsR3zLJmpB1/xoM2qL7P/WTibMcg==
X-Received: by 2002:a05:600c:8114:b0:490:cb90:3e00 with SMTP id 5b1f17b1804b1-49240e1960amr75661785e9.14.1781896312789;
        Fri, 19 Jun 2026 12:11:52 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:11:52 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	syzbot@syzkaller.appspotmail.com
Subject: [PATCH v3 00/10] Data in direntry (dirdata) feature
Date: Fri, 19 Jun 2026 15:10:04 -0400
Message-ID: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

EXT4 currently stores a hash in the directory entry
(dirent) immediately after the file name to support
simultaneous fscrypt and casefold functionality.

It has been discussed within the EXT4 community that
this hash could instead be stored in dirdata. This
would make it the second (or third, in the case of
64-bit inode counts) user of dirdata.

At the same time, the existing format—where the hash
is placed after the file name—must continue to be
supported. With these patches, EXT4 can handle the
hash in both formats.

The first user of this feature is  LUFID -
Locally Unique File ID.

Support for fscrypt and case-insensitive directories
with dirdata enabled has been verified using a
dedicated xfstest submitted to the xfstests list as
a separate patch.

e2fsprogs support is provided in a separate patches
series.

Changes in v3:
- Fixed issues reported by automated review of v2:
  - dx_get_dx_info() and get_dx_countlimit() called
    ext4_dir_entry_len() with the directory inode
    hardcoded to NULL, forcing its blocksize fallback
    to 4096 regardless of the real filesystem blocksize.
    Both now pass the real inode through, and
    dx_get_dx_info() also rejects results that fall
    outside the directory block.
  - ext4_dirdata_get() declared a local "dfid" that
    shadowed the function's own "dfid" output parameter,
    so a requested LUFID copy never reached the caller's
    buffer. Renamed the local and fixed the copy.
  - ext4_dirdata_get()/ext4_dirdata_set() compared
    offsets against the raw on-disk rec_len instead of
    decoding it via ext4_rec_len_from_disk(), which is
    incorrect on big-endian hosts and mishandles the
    "0/65535 means full block" sentinel. Both now decode
    rec_len once and use the decoded value throughout.
  - EXT4_IOC_SET_LUFID deleted the existing directory
    entry before re-adding it with the new LUFID data;
    if the re-add failed, the inode was left with no
    directory entry at all. It now attempts to restore
    the original entry on failure, and loudly flags
    inode corruption if that also fails.
- syzbot ci tested the fix for these issues; per its
  request, this is being submitted with the corresponding
  Tested-by tag below.
- Rebased onto the latest codebase.

Artem Blagodarenko (10):
  ext4: replace ext4_dir_entry with ext4_dir_entry_2
  ext4: add ext4_dir_entry_is_tail()
  ext4: refactor dx_root to support variable dirent sizes
  ext4: add dirdata format definitions and access helpers
  ext4: preserve dirdata bits in get_dtype()
  ext4: add ext4_dir_entry_len() and harden dirdata parsing
  ext4: rename ext4_dir_rec_len() and clarify dirdata usage
  ext4: dirdata feature
  ext4: add dirdata set/get helpers
  ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory
    entries

 foofile.txt               |   0
 fs/ext4/dir.c             |   9 +-
 fs/ext4/ext4.h            | 205 +++++++++++-
 fs/ext4/inline.c          |  37 ++-
 fs/ext4/ioctl.c           |  62 ++++
 fs/ext4/namei.c           | 650 ++++++++++++++++++++++++++++----------
 fs/ext4/sysfs.c           |   2 +
 include/uapi/linux/ext4.h |  13 +
 8 files changed, 780 insertions(+), 198 deletions(-)
 create mode 100644 foofile.txt

Tested-by: syzbot@syzkaller.appspotmail.com
-- 
2.43.7


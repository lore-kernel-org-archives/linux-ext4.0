Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CF53F4122
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105136; cv=none; b=grTIMSYOVsuFmqqDj9i+lXAosgFzvcZCvwEdmyOhAl8qGoHqUBnGzwGmyghGO+3nC/hpZFx2OYBV/DGaQV4q85PkRfH93vJNycAerny20N7qY78qDOXi7aajVuHZ7qySE6YcYdTemMnxQl5yeIpwSqCOn1VHyhAxevWNzJ5QQlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105136; c=relaxed/simple;
	bh=W61P6K85KKgM9TdaMzLKTig1QXyZlRUI8sZzNZrFANw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qzi/03i9lGJ4SVFF0kzKAunaTClNJ0DQlzYIXHD5PKgXM7T7KIn+udCzNo6ckpAET8HpCrMd1JKLwUVERcjm0EClrZjmZFj6nhXEGFpCeCUo62BlHpTUyuijuMWIvI0SBNbqQnzEpJ/WPg3K7ZkrL48RtXLbfN0HCBRWOP6NKRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Esc4k+6y; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Esc4k+6y"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490ace40f4bso79726385e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 08:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781105133; x=1781709933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u1xCvYE2m916Ou/rqnA0LVUdbooToRfUY0TXvfb95AQ=;
        b=Esc4k+6yXVbNby/CYUFLOBxcDQjltuQ+ovqyBVXlSQFqbrYbvvGCJFUcj2Q7f4pgOR
         k2VY5saL3D8WM2fu3S21K3x1gYyucYkMwjNpaCTP3tfrgr1FlAnm1irWw0Y7soc/eqF/
         3ffFnxP7M/GMkD99eH7FDXtGb8N1aGeFiRcUFyC9ltJzSspTuaT+f4SUTustYVYkTnyo
         pniYWvU7n+5gHkKXXPM5b0iHJj6/5cqWlPKOwl4d1aIiGtp8A7Q74CBiznDXp3+ICZat
         EQox3W7moXCLoRJGQNlua8aU87Eg9ibTycn4qCSNngmsgyBPGC+2+/tycL4Iw39LDXsl
         GdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781105133; x=1781709933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1xCvYE2m916Ou/rqnA0LVUdbooToRfUY0TXvfb95AQ=;
        b=s2Is0zoolZfa8hbCbUa2j+irW3inMQ0rfU4Aas/lYxofbIwiIsklRMqQ47Fn/ybGBQ
         8EswmE/jogl5oHBAYTaW5/qvfEi/Y8+FafdvdyxFglH+FWckcYNIkKPi+Z3L4g9yrq6z
         liLQsVMqgyjqlrhd2aKrOWFWMMZmTKF41TiztEMz6yoHpyblu2rIFL8TPZYTZge9kZzB
         UaToNun/YL69FM1OzRKV1ZoCbrUUMGKeycOOFfHJUUYeqi3oGv0Y81HoFt9aO7fODFUM
         MWFax2RX/ULLx6g9yzwmZUZrZnZ6CF3gW+D+WL6AITT+spqCI0wFhS8AFxv1Jyb0ZaGI
         64QA==
X-Gm-Message-State: AOJu0YzlaXweMRIVbmRPqZFSFJViGHSXK4ogqYyKBoYq0zNIikU9fpRN
	V3bwPO38TzIsADcUk9sOaRrGv2CQsneak4Plduq+2XTg9lXGnPv+kssBSGdmaMdtcIA=
X-Gm-Gg: Acq92OGQ0KiuvzNVI4EUay/9EarAU/bHgKOH42WjHzTlDDvak1hFlGQW/1P9jzZ/S3c
	ycjgt12n257eQcwa73B9ePOU1XKjHUeWl0v1uUK3G9T1pCdyb7Tkdad33jlxXqp5W0uyi+63tTZ
	aCxVwgVHWSkfi2EeohxMjUbPnc0UPJEDKBn1ovqj4iSjHoCHi9+PAvgvPndyn71BchI+yp9tcl5
	/r262YlHmv1N5q0zbrIHESnE7EIVmxleht4MJ338Zo3M80kmMnkTiCGeGtQLl0iurH2moow+v6C
	A2DVIpQL7mfp7NgssWebqxGxtTw4wEdlTtSDCYVL/Dma+S0/2uxG2iLZGH/hbCAIY802gj01Zww
	vFx/1TcWwftq+xpvqp1yrdEfjsPX8XuijO/ZnEDZSbuUS2d2cRfjR7X0lc6yzWHsZvLOi/zJP/S
	Szt4htFhq6Msc00wOREqah2AX7qhCyfAj+8h1ZlKj7bh5k4FXkuw+3qHX6slUDHs0XZ3a0ZlZ/b
	w==
X-Received: by 2002:a05:600c:1396:b0:490:d946:47cf with SMTP id 5b1f17b1804b1-490d94647e9mr106486585e9.4.1781105132330;
        Wed, 10 Jun 2026 08:25:32 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d6c65sm559103835e9.12.2026.06.10.08.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 08:25:31 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Andreas Dilger <adilger@dilger.ca>,
	syzbot@syzkaller.appspotmail.com
Subject: [PATCH v2 00/10] Data in direntry (dirdata) feature
Date: Wed, 10 Jun 2026 11:24:03 -0400
Message-ID: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
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

Changes in v2:
- Split the patch set into 10 smaller patchesfor
  easier reading and review.
- Added an IOCTL to set the LUFID for testing purposes.
  LUFIDs can be listed via debugfs. Corresponding support
  has been added in the related e2fsprogs series.
- Removed the dirdata mount option.
- Fixed the following issue:
  KASAN: slab-out-of-bounds read in __ext4_check_dir_entry
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
 fs/ext4/ext4.h            | 205 ++++++++++++-
 fs/ext4/inline.c          |  37 ++-
 fs/ext4/ioctl.c           |  62 ++++
 fs/ext4/namei.c           | 587 +++++++++++++++++++++++++++-----------
 fs/ext4/sysfs.c           |   2 +
 include/uapi/linux/ext4.h |  13 +
 8 files changed, 723 insertions(+), 192 deletions(-)
 create mode 100644 foofile.txt

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Tested-by: syzbot@syzkaller.appspotmail.com
-- 
2.43.7


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276830;
	b=fbCh5Y00lXy7fiNthcwiBrXQfVvwxeuhbdC4tlQ0FPkVsX8mWpE30sxJYQ3zwzjIpSTg
	 5pHWIe4rFdQEiyf9ZtfQAa4GDUIr/d9rMDh+mKG+MY8df+kOkrHHaRIAFdYjj24NSVbN1
	 JUC2w2PWkqlPrD8CRZF+98LR2eLjRj6IEqaT4gL/Kp0S65Ks7Ar596MlCBItSjx86znNS
	 PCr9oRiXUMreDeiD1354sjG2z/UE12l/e0z1haIAQSy76BcRPEX1p/ydiwHaHaGOgKCGS
	 8whw1qhHYKB5I6mIRnjrjKqubRONDZCbqrLssjFy370LM603N6M7CUlWz35zVwaor4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276830;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qg6Lr5WyWsKBmawWqK27xdwVBXO4zjE55XpyPaqI9ec=;
	b=JxDxkh2xV42DMyJLEkEtlloIztLfU0FpxZqSRKlZ5iBIMsn0lC7UvlfmHmBv9HndmTKY
	 bmI8pG06fquEMV+CU6QXgHc1Lk+Tl3XQ1uEpdrU2VV8Bf+z+QlpUDFNRk8yh45U8nvgxh
	 2N0mRf1PWw9MLVLUMk2QsoR0R0kmKpKSn8fCDiUIL5yenIEyUoMBABv52kER2dQZ5Rq0x
	 iBKj7nzO2z3qBpByYyXAiaKdQefZdfXRJB4vKnZ35SxzjT1AIQXtp6JNFzb0ne+5PKY89
	 IrDdZi2exeNpndc6DYqQw7wXLSjKfhxJuOdmWUjutSdUVD5ni3IirIN2+LWYWlVSARg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rnA7H2EY;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07336606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07336606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rnA7H2EY
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48bbb06e746so947627f8f.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276828; x=1793881628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qg6Lr5WyWsKBmawWqK27xdwVBXO4zjE55XpyPaqI9ec=;
        b=rnA7H2EYiT58+8T+LbTg5wqSBZDwrpWonfn8teCgApe2nkajIOCtAhk0ImrBL5bsW+
         d+lrqC3lUipKDhRAXsleSfPNO78pIRLvW3UCwx6SqsKyzc1ne9tbecf/64dBJnmD9uTg
         /ySDUVtyEHA7axZdi7bdUUhowDSzMpazwaEndkbhyMzmsSEOZxc9SxynL62lNj5dLSof
         +CUGiP+Laf4hLA/OYzFOTLEsaUsvF9dXAnwkN4CAbxZ0Ugyu9QqbrRKln9U8dEMBqlCO
         wRmz/0GlF1JBBRInQERAE/TB+2tQZT6jtvSm4YbxokqQgXSAlqDpWxY8RBm5cF/PuhLc
         ST6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276828; x=1793881628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qg6Lr5WyWsKBmawWqK27xdwVBXO4zjE55XpyPaqI9ec=;
        b=aQYNkZcwk9JO+uBQim6wGp/q8LKsoOCiJ3p3D0Dq7oqm5TLGqXOS0v6RXvIUhsMfB8
         d346Tq4E7OnaM73mxm0uYGuAyM1wHCItYFgEkAGZV/qUp6DNJNK3h9J8yut8IVCjf4yP
         E2UCX9OCzjHAYrkjZBeLTYzV00HrvGvbRooYrqcNePX3itjhIxpkZlbyOJlmE5E849UQ
         NT9slIH2gGqJixKsCmZKAG6N4EAhIVUsX3hdAQfUYv6DZ1uALSWLTNHftBnyzy9sYCTj
         1nh0kmxdW288M5JwVzIPyuLxOdns9D3HcQ/WxXgnqsQdwDDVkcPmoLtxdQIwSeHFB18A
         Y4LQ==
X-Gm-Message-State: AFq9FYJ2CtF6WvTXlK6guIZswD3tLu7wMVqKvviqCrbJlK/O3RDgjmh3
	SBhYOv2F2VoyzbTnEhYC7VPRTDGY84Gm3p+ToCih9AEjhXTmyfZF9MwJLBfvxQ==
X-Gm-Gg: AYBFou3mAql/1gpk28qTxwsmkB+F7gsN4nb1GLuC9pTqAThcPV9DrkFMLYYU058vVHT
	nQG/yd+t51+5cnREfOLnY2y0MNfWpnlfdFdrIq83gXdXG+mQyMdtyn8VMremmxcKZXyo9Jbg6oY
	I24qHQhjFdn0H05R9Sz9bcD+Tco0L+qsbjGx8nE20T2Le5A9hGTTt8bS5Ugln6N8gaA3cA1TycE
	9ODGPlHdwbbZLJBCBfBhXAGFOamFq1x+b1JMWLQkCK1V2HQh1Zk9rHoegh7q+UMTfoc/Rbn3kyH
	LiCGSKppm1/btYbIFpw3CAbBpmgNREhIbZ7kmAlEt9jGJZRGteBjBNeOXyzym57TxxSBAsYdf3r
	v8hhb8J71pPdnRJPLF0ksxnKKRcy5OM8/htsfeoOtGxuY+H9QXybV8O3FKCVAMNiTWuKrLWKQp6
	qVXuzyMivRhM5R2IQAn9BRHTjxEU2BcIPRy/vc8b04Tf2uxOHNnAoRw2C9fXZK1yoy/RzQeUgSB
	V5quOQN1S3DZ0EzuKzeJ1LADg1c7oIBDt0PXAASRvu4ddsE8PUpFOWHEMT7QAAHl1oxSQEi5woB
	atQtS3S53q3jfXeObLySOewv4FyL3UNMkVw/MuBSYaLm6bWEPL29A6Vu4hAZ
X-Received: by 2002:a05:6000:2312:b0:487:767:b301 with SMTP id ffacd0b85a97d-48e5d5d2b33mr12204566f8f.57.1793276828083;
        Thu, 29 Oct 2026 05:27:08 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:07 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com
Subject: [PATCH v13 00/11] Data in direntry (dirdata) feature
Date: Thu, 29 Oct 2026 12:23:59 +0000
Message-ID: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
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

e2fsprogs support is provided in a separate patch series:
  [PATCH v3 00/13] e2fsprogs: Add support for dirdata feature
and the fstests coverage in:
  [RFC PATCH v5 0/8] ext4: tests for the dirdata feature

As Andreas noted in the v12 thread, patches 1-7 are bugfixes, code
cleanups and reorganisation that do not change behaviour, and could be
reviewed and merged ahead of the main feature in patches 8-11.

Changes in v13:

- Rebased onto ext4.git dev (8c4f6e337634 "ext4: introduce a mount
  option for iomap buffered I/O path").

- Patch 07: also rename the ext4_dir_rec_len() callers added upstream
  since v12 by:
    bc4b7b0414c3 ("ext4: validate readdir offset before accessing dirent")
    9333cc809f0a ("ext4: fix out-of-bounds read in ext4_read_inline_dir()")
    c7e6b863d298 ("ext4: check dir entry fits before reading the hash
                   trailer in ext4_search_dir()")

- Patch 10: keep the hash-trailer bounds check added by c7e6b863d298 in
  ext4_search_dir(), together with the new buf_size argument to
  ext4_match().

- Every patch now builds on its own. In v12 patches 05-10 only built
  with the whole series applied (Sashiko's build-failure reports on
  parts 5 and 7 were correct). The final code is unchanged; only hunks
  moved between patches:
    05: ext4_dir_entry_len() moved here from 06, since dx_get_dx_info()
        is its first user; dx_root_limit() no longer calls
        dx_get_dx_info() before 06 changes its signature;
        dx_node_limit() keeps ext4_dir_rec_len() until the rename in 07.
    07: add_dirent_to_buf() passes dlen = 0 to ext4_find_dest_de(), as
        the inline-data caller already does, until 08 computes it;
        dx_show_leaf() (DX_DEBUG) is renamed here too.
    08: the (struct ext4_dirent_fid *) cast in ext4_dentry_get_fid() is
        added here instead of in 11.
  Each patch was built with W=1 and with DX_DEBUG.

v12: https://lore.kernel.org/linux-ext4/20260801181227.5198-1-ablagodarenko@thelustrecollective.com/

Changes in v12:
- Patch 09: allocate edp in ext4_rename() before ext4_setent() so that
  an -ENOMEM cannot leave a RENAME_WHITEOUT source entry with the LUFID
  flag restored but its bytes already overwritten.

Artem Blagodarenko (11):
  ext4: validate count against limit in ext4_dx_csum_verify/_set
  ext4: replace ext4_dir_entry with ext4_dir_entry_2
  ext4: add ext4_dir_entry_is_tail()
  ext4: add dirdata format definitions and access helpers
  ext4: refactor dx_root to support variable dirent sizes
  ext4: add ext4_dir_entry_len()
  ext4: rename ext4_dir_rec_len() and clarify dirdata usage
  ext4: dirdata feature
  ext4: add dirdata LUFID support for directory entry rename
  ext4: add dirdata set/get helpers
  ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory
    entries

 fs/ext4/dir.c             |   53 +-
 fs/ext4/ext4.h            |  245 ++++++-
 fs/ext4/fast_commit.c     |    1 +
 fs/ext4/fast_commit.h     |    1 +
 fs/ext4/inline.c          |   71 +-
 fs/ext4/ioctl.c           |   85 +++
 fs/ext4/namei.c           | 1283 +++++++++++++++++++++++++++++++------
 fs/ext4/sysfs.c           |    2 +
 include/uapi/linux/ext4.h |   14 +
 9 files changed, 1500 insertions(+), 255 deletions(-)


base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
-- 
2.52.0


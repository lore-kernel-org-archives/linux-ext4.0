Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB773382393
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 12:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033622; cv=none; b=ciumSs0YQgNhzQw9CCN8wwgJPzg8cqib4CDUz+kd1d+pAibHLjElPVoxMdTtA9Eoa67gGMawEmwU1TzMEGZW+uKqvR1i53jXSNl3WH39x79RrNU+Bp2jKyWi9Pb1vSfQK14jjGv2BPR3MF+1pNCfaQoMnr9Auy6YbR5c+6IbH6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033622; c=relaxed/simple;
	bh=IsdBRqTJKbCg8WSuDXr1wka1Dbf6+W8fr56ZaG+a1dI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jiSfQLR8rD5T4GkONB2OjF0VfHgMYZTQaz5S7KKmBp96omDR5fSjrGG/+qzi4LCzBWoDUezmOHdOs7OoLt4aVV1y7k4zSJrn0xQVh8WmLwL5tPqRmnjZKBng/Jg7Gl2noNVmoj9nFGoHigw7IvEPcsu0mFSCplKal1EQ5ebNr0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AktxPnYc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AktxPnYc"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493d92b7db3so7833905e9.2
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 05:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784033619; x=1784638419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oSUI3XHwZ8jJ3ortQJcuexJRtLN3NdlpwmORgbtt83w=;
        b=AktxPnYchlsJXqK6XaMtXkkNJSuLDuR12KCLx//znC2Fd9c/oVTcn03WAYBhM2GUVp
         oPTlPjOqoBqbPOgMgxBzZ1XTnS4G+4+ComtkYqPohuv4bMb3Ia8qxRqgNj25DBNu0hDw
         coqAcpuaN+UtpphTa8w/vZaOSwvjXoEwGj9kWq0oS7Q3HMG5eZsgW2hsxBl8CrhIHIxL
         G6kT3kQYU7OM3pIk8b/RXD043Hlkiu4iwCNsxzmnWiFHJOPTaJVQa6R3ZGketeGlGLgB
         tqr6hUNqyij0FaceNp0zi0y+exP6KW2uG2SJFL0zfIWy518ZkoIZ3QK1FcgGuaSEl+oy
         porQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784033619; x=1784638419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oSUI3XHwZ8jJ3ortQJcuexJRtLN3NdlpwmORgbtt83w=;
        b=cEnqiBBQI2Qcx4N8qwD7uyIe4jrQwIuqR2lsgv6zPvYt7HilA7BdafLiKYK1zj7V9n
         5zxiNPt+6ubGYL6KSmwbkWIK+/jvYYVi58VYX8az7+J3+xS3fmjPq3gwNSkLy5PgIzUi
         EF+mAgSJBDtAKuE21lTCpr5AGmtqXj0rSemRR3tzyufFoTm3hpyZqtvqNBNBDouG6ZxQ
         lPn/+qRAoiK2+DouLwcvnpi8Bh7QElSdXaQFhUeTwgt2YeH59wOc3iO1T5anpo3n/VAs
         N3gRrFKLA9OqZJHq4/4OC3vSB4Ybuy2qhnx27EzZOQ8PqLxN02VV0yT8oWFp0VgVijNu
         Y6MQ==
X-Gm-Message-State: AOJu0YxW/vRlLE/0wtX5lTV/Mlvp/oPheUDRwJjndlQSJ5/53m1dDi8B
	IxegkwN2H4V27UbXy8c1rVKObD78ujXDKhUSpoJ6fi/TsflHz2h3iyERPB+zhf/2
X-Gm-Gg: AfdE7ckZZT7r/Ko/NU8IgqoXjqN+OSzYFlmFduBGHMibhd+XtOWSH2oe1vrfqwmjD0H
	tWrd79lptR2iuTgMLirzk6wNcu1Sg/R39wXVex86sCj3Dw/wzskHNX0MgrinU8hm00f6tJ69S/I
	V9EnMVb8bzqBhgTJ9u+8uDJ+YsEj2r6IvhMS3mPaWFRvVkzzx7OBWPG7dlOLW4fQA4hoxLIwarT
	u/jc1BwXaXj0BNUILNmbbNfI+rUXlj6rI3R0pYVGgQMdEToaBRw2KifiPLGZr7o+wJEQ0EaYIAg
	20dqXIJ6+MThdhDyKetz22ak88h6SgSx+p0bmfmU1sp0d+npNDtycP15keW1sO0B8EsEPziFEM1
	gWjj0MnVbA7pElLNShGr+exYWGAGMlq7pK1QBs8Cn2i3xkDy/gB1ylppNEVxl7njm4gau8Ji+uU
	8b+12gDlKAJhdyZUVaJNY7yOf0TZl/rAvXic1PEityeKn7Cg==
X-Received: by 2002:a05:600c:1392:b0:493:f753:24e8 with SMTP id 5b1f17b1804b1-493fed59338mr121229725e9.6.1784033618882;
        Tue, 14 Jul 2026 05:53:38 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:1827:2101:7130:c718:1edf:8590])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2ed840sm70052405e9.10.2026.07.14.05.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:53:38 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [PATCH v5 00/11] Data in direntry (dirdata) feature
Date: Tue, 14 Jul 2026 08:50:58 -0400
Message-ID: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EXT4 currently stores an 8-byte hash in the directory entry immediately
after the file name to support simultaneous fscrypt and casefold
functionality.

The dirdata feature provides a general mechanism to store multiple
metadata records in each directory entry after the NUL filename
terminator.  The unused high 4 bits of 'file_type' indicate which
records are present; each record starts with a 1-byte length field,
providing forward compatibility.

The first user of this feature is LUFID (Locally Unique File ID), an
identifier that must survive rename and be accessible from directory
readdir without an inode lookup.

e2fsprogs support is provided in a separate patch series.

Changes in v5:
- Added patch 01: validate dx_countlimit::count against limit in
  ext4_dx_csum_verify() and ext4_dx_csum_set() before using it to
  compute the checksummed region; a crafted image could previously
  trigger a slab-out-of-bounds read.  Reported-by: xiaowu.417@qq.com.
- Added patch 09 (LUFID rename support): extend ext4_setent() with a
  src_fid parameter so the source LUFID travels with the inode through
  rename and RENAME_EXCHANGE; introduce ext4_lufid_snapshot() to copy
  the on-disk LUFID into a dynamically-allocated buffer of the correct
  size, supporting payloads with more than one FID.
- Fix resetent regression: when ext4_resetent() restores the source
  entry after a failed whiteout rename, the LUFID flag is now correctly
  preserved by syncing it from the file_type argument rather than
  unconditionally clearing it.
- Fix ENOMEM safety in rename: the LUFID snapshot is only taken when an
  existing destination entry will be overwritten (new.bh != NULL);
  if the snapshot allocation fails the LUFID flag is cleared from the
  file_type passed to ext4_setent() to avoid advertising a stale FID.
- Mark EXT4_FC_REASON_DIRDATA in all paths that write LUFID bytes:
  __ext4_add_entry() (creation and ioctl), ext4_rename() and
  ext4_cross_rename().

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
 fs/ext4/ext4.h            | 232 +++++++++-
 fs/ext4/fast_commit.c     |   1 +
 fs/ext4/fast_commit.h     |   1 +
 fs/ext4/inline.c          |  49 +-
 fs/ext4/ioctl.c           |  84 ++++
 fs/ext4/namei.c           | 912 ++++++++++++++++++++++++++++++--------
 fs/ext4/sysfs.c           |   2 +
 include/uapi/linux/ext4.h |  14 +
 9 files changed, 1101 insertions(+), 227 deletions(-)

-- 
2.43.7


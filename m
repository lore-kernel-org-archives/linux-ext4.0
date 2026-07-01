Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF713438B5
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782915637; cv=none; b=PFrBevyVqxst0JrXD2Sp26oT1yXFT7unMEact2424ct1lh2F7XLYrdqTYdzFmbITE6PQwOCXe/nLr9ZQSNVYpGocEfbrGsYPVEWwuoVJWiEr+95OYSbp9TlMO2qut0eZcQU5nXQVqCFpQZRa5bumyDIFM0nhtvgXqWWRkHbzZyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782915637; c=relaxed/simple;
	bh=Fb4m7RM02pybVE+aIJPJZ3nvE8N/Yp2mY5olzcic/Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sTMEcvw+21qGvWn05ZnpZXZ41A5hyyR6htVkkHqb9dP5WXtVIkaDE9HOSXeg9JhYyix3QxAmItT4HWr/uq9aVcBOF8yyR27wvufqubp1J/7mhsYgSj3slffWwE9eddAzqwhJJaNkQeKvCvyBGtM9WLCCZKaJnrUihvdx22rMtjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TY3d0JrQ; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TY3d0JrQ"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c96cb024ee0so219753a12.1
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 07:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782915636; x=1783520436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nD2OwIScAIp/QX9OAmRACvwCunUHX0Zy3/ChkfevH3o=;
        b=TY3d0JrQFTz5Kl7tfLZSym9E/+7l3FVxWvXI0FPfqnRMHHQ0m9PDzn3f0Quf+6Eeox
         2Z4ilzF5Whz/frAu2DPFd09OForpa7l7aXZQkN6WQpAypAZPS27CG0kFJTIarZtKXV3m
         9fuf+c7bDQ3UxiWwSneI6GqumEGJS8jAw4+odwhr8zLLz91TpfC2qRZ7S74xJHjDedPS
         lEf1aO+koR+dO136qO74XGJT7uaCk0wtY08SFMI/SiT7thuWtMFg2bYw0+earf3gQqJN
         KjN8qifx71sR2dN5gXHooEbHInxXn+PG/YGi2YBRWalmcMoJENSicnp1R5VjGLLU1wMx
         9/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782915636; x=1783520436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nD2OwIScAIp/QX9OAmRACvwCunUHX0Zy3/ChkfevH3o=;
        b=FaN3xggllmm8I0c0KAcP/ESRTa59c0ZDIXHw7GAERiD6TC6VBMfRNZN5Mx65UgSL/0
         nB94e/3zVmeFqdyMS6W2pBvRRYwsXaLGl0HWgRyV76SA+Kqs/Jqjr3/cJmjhJ+BSbiMB
         KP5uQpJ7io9R6QyilMMVpYNb5fFsAy6UsC71z2jyYCI2F1pFsCnN4hn1PYSo0miP7b+g
         blCey1l8JT6twri3Db2hnm2rqVzEJ5jnO5AoCeaSM4d8Tab252/hSKiexhOFnMlVF7aL
         Go8ZKpEQG9nk0RwG6lk3Jsgs+eoB4mI6bjx85hKc1jqSDsy8KL3t+B/w0Zj3EeRT8vZn
         W+4w==
X-Gm-Message-State: AOJu0Yxgph9lBd7JMzf9zv/91jb92impGBfd2lPPN392eb23OXL2VJOB
	8ah54ic4Dv+CyzXujAOwAxTppknQ5iuWe7VBqMK9G1bdfoQWpZoeRd4Xu4+HB1GXHY8=
X-Gm-Gg: AfdE7ckVxwYzvFMzQJUjQXwmGJgGqr/TjcPjAS7s0PHwhExQi8f7SMHFYV3c2TMJGrA
	qwIougTXqwaYTplZtc5pd26oCLjVW9R9F6FxZ68IcCmGZ8Lc8YysRQ552L6NSLTrySU31zJqz3G
	xE32JLny+D0Al8/pgZOULPlbpE16F3uXG7ttS1nb1WDDiPSmTtqkZ3sTfFgtmm/sYrTjv9ICXEz
	h7ipapoPnLWOBMDwUMl2/Z11yQaSJ77L7AIkJF7BMHWoTvpt6A3TzwtJhAe7lRQ1Sni4H5BkQRA
	S75mZn/P3yUxTI/+kcQc/fqWWdDZTvKPplPxJM6hmpwuWgi2cRZ3LkPfmiUFLOzm2jofY2YU3fI
	+bb/pqBvBYZWWBEsRbUsrXutj6kALQLZBsGyFrb3SBpC+KIQR19myz+rgazTQeDJX8c5JxTplKJ
	Ikazs05Fn+sNnbWceV2VGJMlAC8lUltgvx
X-Received: by 2002:a05:6a20:918e:b0:3bf:9fc0:f6c2 with SMTP id adf61e73a8af0-3bfed1bfe6bmr1905706637.11.1782915635572;
        Wed, 01 Jul 2026 07:20:35 -0700 (PDT)
Received: from DESKTOP-DK6PUT8.localdomain ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e32ef8e49sm383894a12.19.2026.07.01.07.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 07:20:34 -0700 (PDT)
From: yizhang089@gmail.com
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 0/6] ext4: fix unaligned edge handling in FALLOC_FL_WRITE_ZEROES
Date: Wed,  1 Jul 2026 22:20:03 +0800
Message-ID: <20260701142009.1510104-1-yizhang089@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Yi <yi.zhang@huawei.com>

Hi,

The current FALLOC_FL_WRITE_ZEROES implementation in ext4 does not
correctly handle unaligned edge blocks. FALLOC_FL_WRITE_ZEROES is
needed to convert the requested range to written extents with zeroed
content, but the existing code only partially zero the edges and never
guarantees that:

  1) edges that are clean unwritten extents or holes get promoted to
     written extents, and
  2) edges that are dirty unwritten or delalloc get their underlying
     extents converted to written before the syscall returns.

Both cases leave the on-disk extent type unwritten, violating the
WRITE_ZEROES contract, and in these cases a subsequent sync buffered
overwrite would still observe pending metadata changes from the
conversion work that should have been completed by WRITE_ZEROES itself.

This series fixes the unaligned edge handling and cleans up a related
redundant i_disksize update. The first three patches are preparatory:
moving ext4_zero_partial_blocks() earlier in ext4_zero_range(),
documenting the return semantics of ext4_load_tail_bh(), and
replacing the single bool output of ext4_zero_partial_blocks() with a
per-edge bitmask (EXT4_PARTIAL_ZERO_START/END). The next two patches
fix the two scenarios above by expanding the aligned allocation range
outward for skipped (clean unwritten or hole) edges, and by writing
back partial-zeroed edges so the underlying extents are converted to
written. The final patch drops the now-redundant
ext4_update_disksize_before_punch() call on the WRITE_ZEROES path,
since WRITE_ZEROES is mutually exclusive with KEEP_SIZE and the
i_disksize update is already handled by ext4_alloc_file_blocks().

Thanks,
Yi.

Discussion Link:
  https://lore.kernel.org/linux-xfs/0b7f1a4f-da1c-4297-8099-98d738070ab7@huaweicloud.com/

Zhang Yi (6):
  ext4: move partial block zeroing earlier in ext4_zero_range()
  ext4: clarify return semantics of ext4_load_tail_bh()
  ext4: track partial-zero outcome per edge in
    ext4_zero_partial_blocks()
  ext4: zero out whole block for clean edges in WRITE_ZEROES
  ext4: write back partial-zeroed edges in WRITE_ZEROES
  ext4: skip ext4_update_disksize_before_punch() in WRITE_ZEROES

 fs/ext4/ext4.h    |  5 ++++-
 fs/ext4/extents.c | 47 +++++++++++++++++++++++++++++++++++++----------
 fs/ext4/inode.c   | 42 +++++++++++++++++++++++++++++++++++-------
 3 files changed, 76 insertions(+), 18 deletions(-)

-- 
2.53.0


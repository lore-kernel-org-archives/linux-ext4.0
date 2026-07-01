Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B93348C5E
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 14:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782915647; cv=none; b=vAL7J2pGbwGl1AgxReUHyVxVuv2IGrrzAu84jRZGWxB8/fOY2ejGkfBQvPm34lTCLNbuhhemvLB32awZ+lgBzAi9iEXsqXdDXw5u1QI7H5dsDQrMkexSSzW4hRcspbF677XhGR6BF1a6pw9vaKzf/qggQIwoLcH2mxVmYc9w4Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782915647; c=relaxed/simple;
	bh=yc2Hyz7KSu0+lW1gLaiBvQG/wcF0zCCeP501YXvzp7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZBSjgW7gI6kgPFxExjHmsT2vh+Zc0eg5BXlTc0Bw1jSakFQkfUXn1YfIe+JMOk6Bm/JOJeof/PaVhSLO0JO60yqv4KXMz1/Xwtufz335fKL4Xn3/KG1XjL+jhn8mEJKU+aryoRsuI+z/4RI5VgtEA9lR6WIdF5H281M3+19VxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+95Gfxp; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+95Gfxp"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c89636920a3so230256a12.1
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 07:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782915645; x=1783520445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VAnbx+5aUJivupEEG6uiMWkDGEOXRc8YwNCEsizzxjY=;
        b=B+95GfxpI75Hayaf7iavht28QvcPoX9NJu9ScGGN5sIAaESEYY/C9/lOzl7GySY5iP
         zOAbpwpJmbMtD5IwIxq7zQ/sqsUOS6aRTPn9sMVqL4/htkjG4A7NrVEvbUMJAnbVEjBD
         9JfFypAYCtFobqGJisnS46No9kWOPYe5JsmsMrxA+acgTiJVm1RfzPcayM3d7xFDdjaj
         WcezlxfBWDVaIxizcHsiAyNFxWiPn4kyepgy1b3bHuHGNUv722I3/gG0wD3Ha4RDG1/L
         EkJWsbeaNVlHKVqqYN1HpLhCtfQY0cpvkHURzFANsV+93zYfySzfxVJeBZYAwvz3uatf
         4vKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782915645; x=1783520445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VAnbx+5aUJivupEEG6uiMWkDGEOXRc8YwNCEsizzxjY=;
        b=o8Nh+ReCpUcGGznIgeJd55bMQ+Pw8K4aXrm7vatxyV2o5ZpZODyUrT0zSmqhFM0E4A
         Rniun7FHDXkn0vfW/+JLIo0ZnZjXpmxO3MtSgEE0JDO5EtNH57dHCat1J5I/YHl4yrDZ
         enOWHK0odnswqJpBKexNG1a515TIGoBoGJ5ybmddKOfDg6bfbWkJ07IFJEb1G4LKHgVh
         D51hH9ABYDFdFLFHhyxJ5mFRQmsrhyL79fJIfO55N8Jgo/wvELBVu23PAc4FcZWEi5M2
         7DcqMXIy76y3vzcps8qgUdn37bLJdh1ARjmhA8PoMALZ+EAKXHGHBsbogVuE/0yAe7qi
         4rcQ==
X-Gm-Message-State: AOJu0YwTjpr+I+82wNEmme0o/MrdwHYhVsJrADubmALQhOH4M/qXVYL7
	/s9f41mc1JD9uDNd579glWwyiY8gtO+ZR5RHhpLBoTk3odBXVdGIBuHsAWQNl3rpQTQ=
X-Gm-Gg: AfdE7ckwN9Tq8Sx8I1iUXbX1L92NTxtZt7xBL9yGNretpTFsuk7vABTpfv4cRRZqRYJ
	W5/PIqB8MjlAjb2P+vD/eM6+H9o7mjosRO9RO+EeAdSpSZVuVzTXzGzIK5Z/ys/+e09+IqyCWKU
	G1c4B4NhStKV9ldHKnZq9aTf7ClMupW7VwvJTdqxuAmg/zxt7L7/+CojN9UKsDVBOwaSFIDIgbM
	CJbyYZU27m6L0jwJNfT8wTz7X4EwMsrUgxtP1smlL4wD491xfRFuVfw/Cw7VGdnjvO6tXyYaj0v
	wIVQjUSa5TkieAnYpmDZ5Yn+jmZDI8HIXJLze21aboaj7OoEUepc5Pwzw8m6QGJEe/vgSpv+3RA
	6ahzgS9HLSKA+YEr/Tm5QTsQx16erP8BPq2bMEw7pg7knPgO08MNi/237GvUMzdGhwch6ps5ysP
	oSsBxUPnYsNn5p6cgAybMWQEKaH324h/6qWaglv6dB+aY=
X-Received: by 2002:a05:6300:6715:b0:3bf:b0b8:58b5 with SMTP id adf61e73a8af0-3bff422d1d6mr1010582637.36.1782915645158;
        Wed, 01 Jul 2026 07:20:45 -0700 (PDT)
Received: from DESKTOP-DK6PUT8.localdomain ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e32ef8e49sm383894a12.19.2026.07.01.07.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 07:20:44 -0700 (PDT)
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
Subject: [PATCH 1/6] ext4: move partial block zeroing earlier in ext4_zero_range()
Date: Wed,  1 Jul 2026 22:20:04 +0800
Message-ID: <20260701142009.1510104-2-yizhang089@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701142009.1510104-1-yizhang089@gmail.com>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Yi <yi.zhang@huawei.com>

In ext4_zero_range(), move the ext4_zero_partial_blocks() call, which
handles unaligned edges, into the same branch where the unaligned range
is preallocated, immediately after ext4_alloc_file_blocks(). This is
safe because there is no dependency between partial block handling and
the subsequent full block handling.

This change will be used by later patches that handle unaligned
FALLOC_FL_WRITE_ZEROES operations, which will need to check the partial
zeroed result.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 125f628e738a..27ca641e701b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4734,10 +4734,16 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	}
 
 	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
-	/* Preallocate the range including the unaligned edges */
+	/*
+	 * Preallocate the range including the unaligned edges, and zero
+	 * out partial blocks if they already contain data.
+	 */
 	if (!IS_ALIGNED(offset | end, blocksize)) {
 		ret = ext4_alloc_file_blocks(file, offset, len, new_size,
 					     flags);
+		if (!ret)
+			ret = ext4_zero_partial_blocks(inode, offset, len,
+						       &partial_zeroed);
 		if (ret)
 			return ret;
 	}
@@ -4770,10 +4776,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	if (IS_ALIGNED(offset | end, blocksize))
 		return ret;
 
-	/* Zero out partial block at the edges of the range */
-	ret = ext4_zero_partial_blocks(inode, offset, len, &partial_zeroed);
-	if (ret)
-		return ret;
 	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
 		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
 						   end - 1);
-- 
2.53.0


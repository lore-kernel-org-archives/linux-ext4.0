Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C633451B0
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 14:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782915693; cv=none; b=KEd836CEgIHWM47Q9ejPBikQyV9QGsx2HMyrv2wsD9jLa0ZQ807H2lXEG+tYh7o5eg3rilkQ/uWNyvmUNT0NJQeDd8s7g7HwBn0MEuJE0NglEQspO+S8kVbaRuKxi49eWnTyuuTINzYmaK/JglMkq3zu5Y3Du+NECfjBdT9SsNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782915693; c=relaxed/simple;
	bh=iRWnmB3n4mXDtaTJezBVflP8PXOZYbOZtUjv4DLQQZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNF8hBcwth5e4/UnnBX+g+L4KUxES3aZPl5UCV7QTTG6x2O2vx1U+Z6nBPxZEGSleADovZi02Vnd3TzbGoUkuK0KY16Axwjp27/VE4UwOjtqJJOrXoCLjXxXIXpH/w0HK6SVpOHmmldnzRi+d69sfxfjF/AyuLlcreb8UlHbkR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d69ypUh8; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d69ypUh8"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c9e2489e117so146025a12.0
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 07:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782915692; x=1783520492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xalwgHUXq8zbjTwGJ1t/+Gt6kZFOt5YBAHy7z8R+4IY=;
        b=d69ypUh8OKMIEV5R8dqhA+feBctLFB2isFJ7zN37DvVQ6Is5yz1qaHXscj0Efo2A/W
         Lkkp79sD8+HvhIGBPTF9aiUga1SD3Y/MnbiQtCy4nQJ/nLI4oLKWY1Pw2Xqo9fgawOhw
         22FD/vkpn30dyGyInJZ1avHPGZm53kslcnz2SG8v1ZgVKRKuK6Hf6gMf7+MEezXUvp30
         yUvreaCrRLrpYguqYzHkVLoyIP3ALGfeKo8IC5PxZjcJefd1koKYwJ8Fz18NPcutnQ9s
         iCG/m10k/jCx8ShcQZwvQWKVZycdb5vwmnuTqmtxlOqblZ/waDoQlsQELp9YzyvexXeU
         x7Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782915692; x=1783520492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xalwgHUXq8zbjTwGJ1t/+Gt6kZFOt5YBAHy7z8R+4IY=;
        b=KECCVC1wm59TjQIWbeHSVFXa5edid7kKXv53Lu8UeoOb5H+qBAJBz4yKnc0z4SQBCb
         vEYupmBA+aQaFMzduYJO5nCpDwkaLjD7BN6B7UZG837WvPFPd1PxTET0e2dJdBXObwde
         RrxNwJDJVNT6+0BxGcxfE9/VKIx6ddArMeEAB1kTFl3rR3e1BQDcnQX1WaEdTqIGvQ/V
         +6ME19m81bTzYaCGJkE2XW+lXU5kOZM2Z8oHTJujWyQTr81s//sU8o7aWfrYQYHyvkNl
         +h7oaYopPrhvUT8bO+gGkQBjMHoyvASTIoCgFToezGCiN/+fb3HLn+NsiNJvtWh1W/Nn
         MSJw==
X-Gm-Message-State: AOJu0YyaZABkzMhb/rn9fqQYllt9klCzKsaIVmQ0ksQsXpKt8HgZ9OKB
	DVVU8DK4naJuH2AFU0Nbmc7jU1CYFqBpd3eAw7paoQcsqgxZXhvxXx0W4uHJfDg0dmY=
X-Gm-Gg: AfdE7cl1kaprMolTY2hcZlMMgE2y1jLUNS39J6Qbkmh9LoHZ6XdZB+ZLbD0BElfnkD2
	lYMuRNaNok08fs6tY1CsvGh7Ps83OMcyu5c5fplLPDdW9OTL/2OvcL+y5Wh1QHnPoAjJ8lNq8gV
	agSmydavmvdS6ROsYInuxfr+4UzaQqwlKUF7oT4NQZ4t3whChmS1uzIUwKLnZWlC0vuWI8OeFZS
	F4VmWB+0zF7D8n6Qp1Wtz072vz4Gp6QbeUk+eDXDSB9flPLwwHO2X78gYjmIF7lpGqFdyU1KNIY
	+nCpVaZOYMz1FNCQzkTEHhmKC30/AMEX578i0ptmycP06t0a0cbwncD0XmAPRXrizRQBo/pyqsQ
	Az46kqrloKSDYLXYdEEFRXOZmm77QVw7i2IcD7qaxu2rg/t5ZA2X4z3/eB4lbpNUAAr2uS4AoEC
	cYOzE8z0HCcbtKh7Oy2kW5LRXBBhfylcHo
X-Received: by 2002:a05:6a21:b89:b0:3bf:a941:8932 with SMTP id adf61e73a8af0-3bfed2112bcmr1882908637.19.1782915691998;
        Wed, 01 Jul 2026 07:21:31 -0700 (PDT)
Received: from DESKTOP-DK6PUT8.localdomain ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e32ef8e49sm383894a12.19.2026.07.01.07.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 07:21:31 -0700 (PDT)
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
Subject: [PATCH 6/6] ext4: skip ext4_update_disksize_before_punch() in WRITE_ZEROES
Date: Wed,  1 Jul 2026 22:20:09 +0800
Message-ID: <20260701142009.1510104-7-yizhang089@gmail.com>
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

FALLOC_FL_WRITE_ZEROES is mutually exclusive with FALLOC_FL_KEEP_SIZE.
In ext4_zero_range(), when end > i_disksize, new_size is always set to
end for WRITE_ZEROES, so the i_disksize update should not be lost.

The ext4_update_disksize_before_punch() call is only needed for the
ZERO_RANGE path in ext4_zero_range(), as it handles the case where
KEEP_SIZE may preserve the original disk size. Skip it for WRITE_ZEROES
to avoid unnecessary work and potential confusion.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c083703bf704..38753c2ef910 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4748,9 +4748,11 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 			return ret;
 	}
 
-	ret = ext4_update_disksize_before_punch(inode, offset, len);
-	if (ret)
-		return ret;
+	if (mode & FALLOC_FL_ZERO_RANGE) {
+		ret = ext4_update_disksize_before_punch(inode, offset, len);
+		if (ret)
+			return ret;
+	}
 
 	/* Now release the pages and zero block aligned part of pages */
 	ret = ext4_truncate_page_cache_block_range(inode, offset, end);
-- 
2.53.0


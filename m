Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138316;
	b=AtLMysKkLOM815TbUMFtVDmdgzmGtdIQvSKy/z+5Q3zDkoeOJLQgj9uHjSp4zqNh5tC4
	 GUJDfbxtd89676B4T5yMpLXf5u1MyoHb+vQmQC6jmxCXNFiLiVtfdef+j4FjSiczofq53
	 mKclSEa8p0DXh+zdJQWm/CYHACQMmCoAZ46GTEuRMzWUT46flBxkgVoliB2GZMQ10sgVO
	 WN32JEUu6yFbevYKyHJ2B9jxTkZek45INMbkrhl8C/Cs6ME80NJ8GVv8qPVB+I69rDF8a
	 YCVoHmWjhP6AEoDSKooFPqQ3z4d9oTMqE3kg4WPqCW/uw5dgESHu2zCUuZNPKEHcgjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138316;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W9OJQx+TcWNp0m+XcidattXlpUlog8C9yogSLSSgROM=;
	b=QYTO7j1hiwaP8uf4Rk4fdZeOw3BhsvxG/eiLuYxbBzvQ4HXyjGoPD39mEDsaRYq0fvxy
	 mN63sgZWgXq6AmoHhZfn87LUblafhWkXJt2ZOanLtYW9a5/ObWw4h7+gSH6lv6rn/LxL9
	 eyfPN0LLOqldaAoWnHSHwN1R7n6TdC08X4YQsdddk57P4PnNHzG3B3pLizxFWrGe8lW51
	 z/py0EEVYWWeMjHhxna8sSw2oCVyUxAZFHwJSXQ3zwUyruaIiprZIcWncu1voi0SCNWTN
	 woer2DK0CPTXPdgWv9UxcxXSVHrb8PYCH8yovL2ZGWMK/F8+WddD/YbklBfuBLTqf3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oKDsmVms;
	arc=none smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD86606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:58:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAD86606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oKDsmVms
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8ab3d3c5761so2941727b3.1
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 14:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793138315; x=1793743115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W9OJQx+TcWNp0m+XcidattXlpUlog8C9yogSLSSgROM=;
        b=oKDsmVmsuk3dkIKPLXCEgrrBz0xgLo11lpY3b+3BJxL16XSKxaj0p+Bmb6QSRClvjk
         vQgeub/fwL+j+/KqtYUrPWdmrqMOoHx4qRiN7qr8wi7AoYcTOgTu8qTvLTN8mlMLlta3
         PRadaYH+I4mJfMBwrxUUOTN4Y17NnYPF5kfY7qSiXSUYMB6ANOrfA2ad1Z7YMIcWrkC4
         ikNN/NuZ7clzkhppK02X+qnkR7AXWJPHiDKqadRAar6whNKO1V0O+2g15MNOLrrR0eHR
         DhtfZtaofy0tspWXl2SLaHkWgeiBPnzHNxLwCbUXaJurLi0FF2JQJ69msPaVlOWQ1s3H
         utUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138315; x=1793743115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W9OJQx+TcWNp0m+XcidattXlpUlog8C9yogSLSSgROM=;
        b=GU9BrreddzFM/hxlpQDzl/4l5Lsn6AQq7REiYdn5hwiSiqKCe83W3ZgiofPHIHn8H7
         nDvYwLjbJEnAk/69YU3cjwDs32yRpKo9eCXEB/9IUCT7Use/tcpva/KwTbjcD8CvPabn
         sl2lg3dsMBxdqmJrMsH4Xy5exzQr8URiTmVFzSYa26zGJ6nREBKCn9I+nRvKfZa/H/zp
         qTUJsep1/adBlf2+05gqp8LyPHwHCv3bst6GrKDi6idIZG7v4b+LjoL7zbrXQ126Lj+Q
         oS+8jcIVsuFvbHBnaruX8GVpxTd11tiwNj8zI5TVGO6AlDkfk4ToJt19rmOqrztQqfyb
         OL+Q==
X-Forwarded-Encrypted: i=1; AKwUvBxxDDCiXuwUK2Clth1SA5FKeoPLlOLOF5ENSeEJ+GKZaear+2Swz38hoFCsdOM5613k5D8tja1sCYfO@vger.kernel.org
X-Gm-Message-State: AFq9FYKGvq9UsiEtiobGjiT9zcYrO/RmQ8dY/ZsSJK0XPBN84d3n5aVd
	IcZR+xwe4s57n0MreeEM6stKfbxh/+ekIGczZvWPx1ZgcZF1wAHg28Gl
X-Gm-Gg: AYBFou0Hxppr0X2Wsu5Ulj69G+bEOUY3hrJLQHtLhBBEFyXGKk3uV1MTqu/Bljxynzn
	jZ5pAPFonkpT3NN6HxC8iNkLPa5bVolaJnsNT8lsAR/NBANFsFBFnfO8lkic1k4a4FaLOq7gwFy
	fhkC7mT9K6Rr2lE9R7bg2hDS/KkSh3WhmpYkXZ/84hkUpdU3qu1nXppd6NtizH8VyfgGPX05+hw
	19i1+F/7qoUdt3UOT/BChAvYpJmAF5hhYsqpzAW+8+suGQyc7Wnat/L66XjlSVbdKZW2OTN09mS
	FdacMJQW/QB8h8AMsqBoyWdTs71jY8jN/t91EJU2wuYeOb/qLLzVFPRIdnFvmj4S/C8j7zEukjz
	JTCDeRmwlpfQslOLs6TKftsDVlnSbEKOJI9sS79lqnJTUKZUpkpq5QItE5csHrWzoyGBu1JOUB2
	iDVd1BqGY6rs6CFziXnEjXdfhrG5gFJFHlztlHF37MZHQRIU16rOV5nHspV9fBTPbivJj8zf894
	yQ5ooi+1t//P1CBW6hFdfy3/VcF+c2GoxGXLQlwc72Q+PzEKuuZ0WXJluhIzjldI+/dwdwXjnDe
	+0UXZDta2IKFgNoJf6VHPr4jBE+j7rPe
X-Received: by 2002:a05:690c:e194:20b0:8b1:7346:f1b0 with SMTP id 00721157ae682-8b1b5bbd517mr2470267b3.18.1793138314743;
        Tue, 27 Oct 2026 14:58:34 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e67cbf1sm18555897b3.33.2026.10.27.14.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:58:34 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>
Subject: [PATCH 1/5] nilfs2: convert iomap ops to ->iomap_next()
Date: Tue, 27 Oct 2026 14:53:22 -0700
Message-ID: <20261027215326.2693300-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261027215326.2693300-1-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
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

Convert nilfs2 iomap_ops to the new ->iomap_next() callback. The callback
is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/nilfs2/iomap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
index e130ed63abd9..359786c97f2b 100644
--- a/fs/nilfs2/iomap.c
+++ b/fs/nilfs2/iomap.c
@@ -67,6 +67,8 @@ static int nilfs_iomap_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(nilfs_iomap_next, nilfs_iomap_begin);
+
 const struct iomap_ops nilfs_iomap_ops = {
-	.iomap_begin = nilfs_iomap_begin,
+	.iomap_next = nilfs_iomap_next,
 };
-- 
2.52.0


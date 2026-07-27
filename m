Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060554314BC
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187496; cv=none; b=G/QQ89eI0baZetu1r6Do6nIcZujPH3GTQtSMtv03P4uWoxTxa+7Q1ne8rJtI5lkcxasSDuGX64yogYZ7quucOwwxbnt6SCpvhVjSCSDqixCAQah+G8T2woPCl1uPO71RxLen+Qz/CTQz7E1drz8ucrNyOm9slIZWPJLsuDR5Esc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187496; c=relaxed/simple;
	bh=Fjw5DSYb9KRQ1xyLxsho1mmISLRJMKjPVMoKEf1qwyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqcjdArEbnE+cANl6OABk0+4ye+EZmVzjTk1ElPXVRw5bcKpgW9yzT5ZH/7Arj4c+hQtuhRfTl7kgv4KSS8LpGKgm+BlRckKndSQSepmWYoMTtCrsXfPkJlbzcK0BPcL07diZB5M4HZ1gzX8QZsinzZpZiZCA3iFlpU857CH5Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SrSQv5FM; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrSQv5FM"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ceaf8a1265so38585225ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187494; x=1785792294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+DsR/dFj2nYHw6/Q7iYssphd45mi2AeTA7D0yo+w0Uw=;
        b=SrSQv5FMtcSnQU5eIisu4nW0bQ21xKiagmub0wyWeR2PtOyKAW7ExaOs7h6W6fL9r5
         xMm1/Iyekw3ysjIuoRF/+GmUz1e/Nz2FDCLHB/F73+EeVHGOq8GgIHSq1UpzQr1qMdzO
         ic4htFe+ieH4W8fZYp7Ymz07+ubZXYtod8+rJUspbCjnZU5VwQRQoZRhBs25iPYBR3DF
         jQLNQTE/QuP0a/EiddGnNcHYpLWwQUaDNRc/Ktwljbc8hvjbGKVo/+aoEXSrtX9dUr9N
         K3hU1EfdSsbFc7L22cCSnpJDrWFZHyuGUjofSZYyXCrpG6jcATUlMHM9fdz4rp+rNI9W
         2eng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187494; x=1785792294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+DsR/dFj2nYHw6/Q7iYssphd45mi2AeTA7D0yo+w0Uw=;
        b=UtUCHBpl5YgV6Jvqe2KZO8nJa3RksOywO9q7MycoGWsE5SmDRePuuBLX2BW8clP2wX
         zaEkEudwzk4yhwkOPwNzf3NrQ3qc976xrsNDcl7FgVAQZC8lqgdW4f4XAtlXKm7zPX+g
         GO3mVwQZjQymzLb6Z065iqgocHpYcQp1ZaGR2T9coYSf7406HOTX+SU7cV6ldgxCs8Wo
         BlG4V8ToxIWSkDsvYBRZmgzfOb+SVDM0EDVxVrK4oeKVr94spsyVp4rMBmch7FPOu2J6
         ajz3Lc811z8BXwpYj2i5rRcNQo8+W2+cVIRXWtI9ep/kc5j46W4exL+p+A3W+qLcUDtN
         pOVw==
X-Forwarded-Encrypted: i=1; AHgh+RpVPeBRWBBOYg2bw+LtqXxvVhjCTmrk/069m/OTI4jQWcAmpAumanrJ/vz344rXUV82DbYVxbLIU9WH@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1QCgxyLma1HvoQiqHT/yr7RaCfkHrw87zSifOQf2yQSv2ilqq
	NcVdJ/T/qL9gdGIGq41+1HAzC+fTwEzGUdej4PSSZlo1Ww6yUNysTa2B
X-Gm-Gg: AR+sD11IeWJG11mVm1YGXPsDOLjiEzPPFwwK3CC8W+exaR2Ru6YVoMfyEXzvowXfIL6
	7Pk/QkEUQyhf8gvBSwhF9L9vUr1/Tb1oQTaYf0Mqjtc541UbiZ2FLn9Ml7IInbxTKcBMiBAbOIW
	9UFa8KHiDOtEnhrJ67Gqe66D3OI+nNN9B9Bm/LsjtYA4Ntd4Dsue7qvZLn8bM1BGrMFnshfws9t
	Cttt2aJY4hU9Qdii9qWHYdP1U7dK1+l3KgKUGRwIm3nfn7t8KcyUylE1fa2EMfSTNEvb/MI/qea
	XFA49xAWwxYFOT2FGwlDaTG4KsFxTvtJbsXMItO85mZhL4FITW+Xfe5ZW6nt3H7uMebpHI0YAnj
	+BH/qovN5WDVXto7sKysASc5LXQG5gbdYdRdepML1f6r8g1Ifglr6Iy6nT4YD4TPg85abOKHZ2q
	xhBwBQGC4bEQeRk8JeUu1gjkBTeYfTd9RrZW8BWoIW/ZVhV7IXm1Zz
X-Received: by 2002:a17:902:d98c:b0:2ca:73aa:b48f with SMTP id d9443c01a7336-2d00f3e13f3mr9522575ad.35.1785187494348;
        Mon, 27 Jul 2026 14:24:54 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:5::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59bc49sm40516525ad.7.2026.07.27.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:53 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 13/21] block: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:50 -0700
Message-ID: <20260727211758.1116539-14-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert block iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 block/fops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 15783a6180de..4cff76e9eb71 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -453,8 +453,10 @@ static int blkdev_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(blkdev_iomap_next, blkdev_iomap_begin);
+
 static const struct iomap_ops blkdev_iomap_ops = {
-	.iomap_begin		= blkdev_iomap_begin,
+	.iomap_next		= blkdev_iomap_next,
 };
 
 #ifdef CONFIG_BUFFER_HEAD
-- 
2.52.0


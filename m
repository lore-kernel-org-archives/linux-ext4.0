Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E449A4F7987
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353436; cv=none; b=tDMQoFdC6Z1TUIIhT5WpqVNtDnyB0oxq1U7EAuchSxy7wJImaFXbr3qO3704wHEweRKBRf+aTWFDkQODnOkxvTrR6/o0pCQU7QeWCyMy+sPHba5M1OA24I5it7DAkoTNO0VsCYvYmuYuq4reCXzs457PmEZL3k0mylkdUa6QVBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353436; c=relaxed/simple;
	bh=Fjw5DSYb9KRQ1xyLxsho1mmISLRJMKjPVMoKEf1qwyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zdv4NPZQNifVEC7kueanGGjlU3AwQHEOVV2yPYGdE/kWANkZCevihAFNYTv1aea2ZtV1b7lFeXzQ4gfWDl5dwco+MCGDzlbZOpRyURdlCWg1dWkw18q4Z3KkE0JrxkvG4JlmbVGqkbMj4EyNxzgnWXuV+afFNLC/TGbaATGXu4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m33pBlXn; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m33pBlXn"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cbb973e6749so1557520a12.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353424; x=1785958224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+DsR/dFj2nYHw6/Q7iYssphd45mi2AeTA7D0yo+w0Uw=;
        b=m33pBlXn9JVAQMOzYqZK8DmyRBf2oVJBsTPoEiCzK1MHeRc0nZ5WoZ10PMero8OCJA
         VdkIXqB2ctNyTtde8T+NBieF9aFQfast2Z5PZhwMz69l4eyBSpbC4pnfDnVjFopj/su3
         euAFDKJ2Df0EGcnJ9DR8Xx/N3G11g2DKghxe7K/zBG3/E8Hym5Fi8g+L5YUQ489OHLlN
         bf/VFVZ8kEpz96qLuhd03cJSpuFHbpzeHjsDzcpBLt/MqQSRa/BmuFV2zDcuoxZ7wG89
         7nOWeaTvDQU81HHLjWJLEvBQesbYkzbVTyyxSGRcexKyU8fnTUaRgzkBS+Xxa6nFIDKW
         BUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353424; x=1785958224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+DsR/dFj2nYHw6/Q7iYssphd45mi2AeTA7D0yo+w0Uw=;
        b=WwVTRZ3R6+DqdgIJaRF+MaH02gZM4TKcvLP5dvF79fvjxSOe7DOFLesDqi/oxx71NH
         WOtwv5Yuhzn0Y23f3vbry/8vzZKTGB8c0jH2IEnd9xGqCFX/bXb0KgDGCS0hWcEK0M23
         307uiGdQVDSb/xHtMejS2IKwS8TCzlkAKW5l91VYLSAKd0dixm3CVLB89+KrJ4fxxOK8
         Pi8Gw/766EVyaI+UU0mK0STAVLA8h/iC320JU9ALvuHJMsVChMsgLnJyu8haI+0xxFZO
         IXCZ2wu6kk2vft28vkWSu+KILxunq84q580GI+lLadRtjazOOdwxY3Ae4QRfN6Kcb4V1
         +w4A==
X-Forwarded-Encrypted: i=1; AHgh+Rryr7812gtInEW49CuyRHOjbFhgwt6kiOZVEcS5pvPDyHayM50qQpqwNhcHKxp9+m/k1G3Lz3C/TBFy@vger.kernel.org
X-Gm-Message-State: AOJu0YxNT5zy2NNIglY/etxHPTKjo2vrhaZkfnA9bIffB2aOBxMaj3IN
	alCrOVtYvdkhH9t9TYjFcojIPAZnJVDXbYSyiaOZTzPst1SosNE3GfFK
X-Gm-Gg: AR+sD13iE9FvrylILVUXDblfXROnUlh6CwUuTMlD7ltiHIa/QoiZOG/IWYxh7hC8213
	1jcblq1MDIFWyaLR+LUcnbyqnc5KxOISh+Bhc1Y8Ytet0mJWioqAj/57Xy+LZL8H+MXnmOI8XWL
	hL72Dl5QpRT0wXr9oNxUdCyByjES0STUkmkmRjzowVlfw8yQaVkoNfN8WN+jEPRaTy6hQ6Sy2X7
	5OG1ebXbBeLnpaCYdDm9TSSOGsV4Y3gQ9o4GbeROonE9U1dCilRpidvJ9W6q26iE8Q3rzRcH9uw
	v2Q0Whc5CpgAz5LQiyfbLncNLHAjmcf2mLbWdWRukXBDa+yI1W1Lqv5gs9F6vv8PHX+Gfh0eDgD
	Vtp2QZYdkqC1eBj/zusVEwWyfuT64sU1ZywKq2Q/QMEGlFdzzgFychbKJaeCpLMYGtGJ97A6I4j
	YWUi+EKc3gc7TMd/TOH3cEwJP0gkneUTM6av1TCI44WRWAEgV7y+40mJE+zlRe/ZrXYOJo7aKNU
	E/Z0MMgXKEuQsgLQ02Hd7yFMpqDn2+DvoZrrnpv
X-Received: by 2002:a05:6a20:4313:b0:3c4:396d:4a6c with SMTP id adf61e73a8af0-3c8aafc0362mr10655921637.5.1785353423821;
        Wed, 29 Jul 2026 12:30:23 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba92bb37sm1264179a12.30.2026.07.29.12.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:22 -0700 (PDT)
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
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 14/22] block: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:29 -0700
Message-ID: <20260729192737.3190206-15-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
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


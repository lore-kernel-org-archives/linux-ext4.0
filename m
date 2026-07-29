Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD1248551A
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353438; cv=none; b=qbfuBk6WTrbJ/kgPKs2w/Yo8/KvyN/WT9qPeJAmI0UgqcscPNlTnqsFlDCg+v8wmRH+7q3WStNMQbdkNQsHWBLQwO1j7+FwbUTQ/h3tPOtbgeqhUhWWdx1mE6ea03cC3FAVc37lG9TPz/i8W70EAf1+ivy+rRpzdKX3D7f8KT8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353438; c=relaxed/simple;
	bh=bAIl0EYJtqhiY+G9Xwxws/qkXqkeERtNBUa0GVKm6tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeRWFJHMwb1XedijH9TBmbgDpqPKUnakgEz9npB7/3RdM4mnGtDoMR3DB7V/Ffxnl3QpCWTYA6R5lPM6zX2TxG1hptoyplvtwF4NPK3Sh5N8yFEdkWVrH//PA2lCVDodHN8H0zKy/QpvkIQnCrInIxlU6rstJ+W06J2YLmr9jPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJbF8JiN; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJbF8JiN"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc61541f8cso786715ad.0
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353430; x=1785958230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2JkSd7oYJPFcviDB7E5uYmo6tGTEnQPMBBxrAZJVXw=;
        b=FJbF8JiN53OlaZjmgIxbxDQKFi4NzFEzQsFYwDBLYMm8hBKnpMLGx23+AALliOnRDm
         y/7i5If7yUrRtE+hurlTKtxreO4AV2I46ngn4eidmkJq0QRbNOvaMa0hzZbUQ5B1fiWn
         9b5dM6pB2gcs2jEDs0oB1QUWXwO/4JWFnHwu+8nfiQKRJrAHrcs2n7g1BwB8Jp2cvE7p
         DhpsdhvT9gqxFngHaxUQtY83csf814enHyTGclw6BX/xO/B7sfoKAJ9vNR/pcwuk/LHS
         A2CAG7JxiJKnDlHWfrCM0DpVAJl30YPPOWhO/m/g176f4ss07KoDWFUtSj7qTa1JECFH
         ynlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353430; x=1785958230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N2JkSd7oYJPFcviDB7E5uYmo6tGTEnQPMBBxrAZJVXw=;
        b=KMKkL+oucn0sa5qR+Zjs74hA4bEJvFvtHxb4PnbTUoE7ur2a6N42Myd0T78ewdZ5ck
         qkMfiRzeIJQaEid2Mpz5Bvl06+FbDAhhmgvDRsaiOYCrx43uqiRV4qAuXXKpgxmvgMkr
         Hb0Icbr8IpiW9W7LwM3ezRrqnn/WZd5/6TQEyZVJuRT7pdz2s76KAMLYszUfcHiU5KIO
         dDre8HOuiZ04GSKR9ocAuyV71ePr4sBf/J2aGIlAT9pNQczOMEFTjB2Q4Vhksg4rKxpw
         0d0rVGfOKcq4w/FwZhp5BGigzluHOyLGL7RpTapYVUNEBv7jIHs9s6H/g7u4kfkZ8//9
         Zd7A==
X-Forwarded-Encrypted: i=1; AHgh+RrGEcppI3teCRvZIB0ldeO+Au3+XuxR9j3LB1r354wu3QAjXBpnNlX0Q3BBkUWXTcEbXRGFUmKiXFn1@vger.kernel.org
X-Gm-Message-State: AOJu0YwvAs1HXK+Wrt5Y4DA5SCFygBsusDsAziZfP1AR9XkvKTQQnjBY
	WwnFpJhJZPquDHfaaHqtZGIqKKvt4uSy7gHVWnFR6JkBi8SkRAmu9drn
X-Gm-Gg: AR+sD13Wu8LmzT//QJsBRTwbofJpx8w7xHaTtsONVvE7jdRDDhjYKKRw8v4G/ukwVtN
	K/MAQz9wLIdEYgGMn47gEA0NY80V7Y7eUt/UP36O+kVjsdRj+03qCk4vAO1nrv4h46TelG13sai
	DdHa/dQZW6axbOVmsnjW0kQWIrlM0Ixao+UVOnJVrB9p4VLQ6IJj1FwKNnYGUDdggmrmhn8NgAu
	ZS/m9Y+9zydO6Lfwaua2iQh857kkZZWSkf1j5hWcDilc/DdjV/vAN05KxbP6SOanvRRlkWl9WIt
	VP/v/mAV1DAuE0tLml0+wceBPMk8e65lJQSSEMiVlmUU3/5XEYYby1LzGFZ8Wx0T9cpQWKK67mG
	H45KnaJGaEPSr//LZ4be5ykxQKvf5FYKyhrdSUddXi6Cv/c7LMeMK+YFjwHBCPdV/wiQKMy6T4L
	vwS8I/1B/xIOE0zbJf19mkPWoOZk4vbsYo+jRHPdQD1XqV6g8qYsjmgNe9+MqWcTDNc1sQg0W4T
	kTNDraxqgS/Mtj7sMUT2LVweat4gz0FnFU7oG38
X-Received: by 2002:a17:902:ffcf:b0:2c9:e846:a589 with SMTP id d9443c01a7336-2d0266f9cedmr39156595ad.13.1785353429695;
        Wed, 29 Jul 2026 12:30:29 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a4af04sm16305135ad.31.2026.07.29.12.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:29 -0700 (PDT)
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
Subject: [PATCH v5 17/22] hpfs: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:32 -0700
Message-ID: <20260729192737.3190206-18-joannelkoong@gmail.com>
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

Convert hpfs iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/hpfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 29e876705369..6a629ab956fc 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -156,8 +156,10 @@ static int hpfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(hpfs_iomap_next, hpfs_iomap_begin);
+
 static const struct iomap_ops hpfs_iomap_ops = {
-	.iomap_begin		= hpfs_iomap_begin,
+	.iomap_next		= hpfs_iomap_next,
 };
 
 static int hpfs_read_folio(struct file *file, struct folio *folio)
-- 
2.52.0


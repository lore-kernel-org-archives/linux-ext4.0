Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855454854E1
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353435; cv=none; b=FF5ZgaHQyOo7wrNtGcbJOuqSu6VyDBzzZyvPNrZexSjNORYO2GNyzReOPP3/S0PqfZsdGXV/Ohai8FFJZRnPtoG5k0bw5ef3MvgyR6fmQH7akrp7VAqVkZBWs+JGYxZCytzm4dZgPGJk6Lo+PQWKvx0Zvs6xITxg3YH6SeZKFBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353435; c=relaxed/simple;
	bh=3Fbl5MaGSEhPrjx9pliGoJqPoQm8nDp7ZS+WKqitgus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMyp7tUgziQ/Oz6JQkMnClewj+5QaCZRWO+2zBt/NUqALKQBiBs/PBqQSV8kHxY0GhVguM3aRP011JDDmOSa1UkbF0U2AJwZNLIgXinYTZlsbtgOw6G+yQGKBlI7YSXQXEIacg/hQZOYmik9FrWLsmOWkniWAZtXRnM9k3vzVQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H06m41OB; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H06m41OB"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d02b4c3601so9022805ad.3
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353426; x=1785958226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jH+TeFe4eS2WsKabb3CNPoYBr5KTegiyeJHR2iqxc70=;
        b=H06m41OByIOb+7bpYmBbvmgaAAu5JSrdjwMfjBhS8Ju5+anz8twzpKFbzmc/07yDpE
         bTGsmLbIQPXeKV215TyGAR/OCymAFn/kSx+rpmRuajT4Ko71uKal1mCOuUaJCqqmcrpJ
         461Ze4ctidrkn5V1LvcJHxtxTYgLEFBA1MaPJgnN5sB1jkZsZWkBFPTMHx2Hc2LT9ITA
         D0TIJUCe5TZZa+6q1ia+5h3ROzEPW5yA1EWqkZFhiJCpVSZ74kxHFl/FQhDNJx4nK9Am
         S3tAmu08WpFNqaGxdalUlWp7G4/RLjXOwCs14EgQGwzvT7zFq9AM1Tmpjiyk7q+2xxj2
         3IAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353426; x=1785958226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jH+TeFe4eS2WsKabb3CNPoYBr5KTegiyeJHR2iqxc70=;
        b=p7fzqF/vHHwzWTxL2pj6hJzeh1SGGYgyYtYgzIfgpl+hBt2zirfPx8GneFozrgxrfx
         rrEjugkvOAq2ZprRCB3vNIVMkVLMMGb1WoRtab4OCwpE8juI2m9G4XGCVfxeSSq+02Ux
         DGv/hUougmiYjBc1PoqXyaLkHDMqxJqxTFAhrif2GDi6gH8AmWQZe9X9LIN80ab5cueX
         0hO5zDct2vGiheqBUV72rbdT6I1eW3ck3UUMiKzXeADpOiHFD+WwvOMMoK0ryB9hHF0K
         ze/1aurD/ryLePpVsgTrCWKNxKZF2vwepw3GZJcxmtcQNYYwzDPhisjfgdHAoKXgWN9X
         Chpg==
X-Forwarded-Encrypted: i=1; AHgh+RqOAuNJsTzD8rM0KvDF98dl6SOvv3yVc/pOSsyX6Rp8xZ0wLUochJsQyGDGDn/O67lug5Qo0DcFxdhI@vger.kernel.org
X-Gm-Message-State: AOJu0YxKwPGOhS7gVTzPrbkRV6+gcWH4R/BW8CMjtC1glpo34k9bGQCj
	Ur4R69w/MNPPsmWr082XkdMo7psIGcZ08rtzbs5H2Wdk0fyu4igqsdZ+
X-Gm-Gg: AR+sD11e2nYfguDdxOXUN3xwLsnc5iOpxqVDsM5vq8d6ICqU9boOQ79HgqNLMlX3dSL
	UQW97gy1EM5cEYfnUuU0mTT1ISPLGzBwVm5B7w/NKV4zyg9kXGUhmDn1ZQmW3IQ3uf6flW/m8qS
	lkNvWeR8wGnLixUh7F/Ie+AIVHc7+AsorncQibONn5ejD4YmJaa1bq1KT6g9Nlqxm9+93VVhAuB
	SjXiH3v7IYHrMp/pYU0KkEatVObmK82ugGx1sqavcaZxMSEQ0JIZHPA1tBDXNk/eIZP9aJmBxzs
	EmZbpEVmxaf+4vgH7dBdojKHCDTCGrYrf3dBez2aCw7p1WPLjW59rwQJmn8WNPylq7HkUv8ImN/
	ShCv1xTOeiZDgf05Q9Op3cnB/29vV+ZqwOs2ltt4hdrerochtea7eCjnY7Y8TISELlAfVWMsjlx
	Hr0bC8Fh126pITS6IPFa/RFKeGAritHl4nojb2+UzL2a+EvOK4hxo82AVhJXwiDLsq0uJoKyPh0
	CftIQ6tDaKJUw8jcVOac7AS7+gz18S3CXM16XBwt77eAoyPOQ==
X-Received: by 2002:a17:902:cec3:b0:2c9:d55d:2d3 with SMTP id d9443c01a7336-2d033b2ad0cmr1860175ad.15.1785353425702;
        Wed, 29 Jul 2026 12:30:25 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a16987sm15596345ad.16.2026.07.29.12.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:25 -0700 (PDT)
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
Subject: [PATCH v5 15/22] f2fs: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:30 -0700
Message-ID: <20260729192737.3190206-16-joannelkoong@gmail.com>
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

Convert f2fs iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/f2fs/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a765fda71536..8977ad379f50 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4653,6 +4653,8 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(f2fs_iomap_next, f2fs_iomap_begin);
+
 const struct iomap_ops f2fs_iomap_ops = {
-	.iomap_begin	= f2fs_iomap_begin,
+	.iomap_next	= f2fs_iomap_next,
 };
-- 
2.52.0


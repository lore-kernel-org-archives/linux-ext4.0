Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0863AFAEB
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353422; cv=none; b=CvBOCBKCJxOJLOmRyFN9O5gXciww/fUC8OHQp6IY2mydzwgd04GV13brqLlatexnWpYJ7+diTZTpDPXJHETOSL0kDNKeiuXyotNll/eNgUgm7oWoJneWly5dHG7PmUveZxWZqKi+6l5G3e+cenkz0/2Oe47L3VqDo3lPS/PFDpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353422; c=relaxed/simple;
	bh=1LODBsXTJz074zPmHlKPolHt/XzrgN7p/Zc0cYoesy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKRz8N9IWnxRgI3G6QshZ8s6Cz3OzXI+AW6/NWK+0280AYc6D96hhbUH5qk37OPEG+R9bKwEsuG7wsVraEdpk63vKUKV+HvFkzrfYOJtBa29g0m1wJ3SLwx9JKYP5scwYozi4QIVl6c5l8+mu6FWUs56OlL7wZKoR3VZw9MZcPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EoItSVoQ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EoItSVoQ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cad8076b01so18162615ad.2
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353412; x=1785958212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Cj5pCwh9UiKuAyGTCN2ecA2rWhLN61eKI8rtelBEo0=;
        b=EoItSVoQKQVIL734m0fcIWVZ9zz4QMBKJxFKBGgm9VLzNpt7KiQu0lnC4FF/i/WXCK
         RQDFD8KU7Ys1AyNBsN6wjiIJjg2FZ03gsLXmJwrv6RirDcG/0nCjJvI/OAkn+EYAebe9
         XM4Y2hShgFKvCPCiTFJZPrZfmlBImBiVuyX/OIp8f+zOEbMc9MfKPCoiXPWQ7ncVzJdU
         oih6QXvepGuRChQFUT+Om34RlmmJNPCD+05YetzzgWp1LQDwVUoiX9Xl15undzpq3cV6
         4wu6t0NN1LrVbiBe4T8mHS8gjf9YF9VEZwcpaDO7aZ8OX1PJF49fa7CSreUyI39747RJ
         Neow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353412; x=1785958212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Cj5pCwh9UiKuAyGTCN2ecA2rWhLN61eKI8rtelBEo0=;
        b=c8On1HJ5MGEDnP+Vt4CtIuQM7W24Y8ou7ZLUzdpc7Y3ogmBoQ6JYglSO3m8y/aH8lt
         KIG/g9444WvrkFT5wc6sI20tl/gV4/B8cRCSgh5cWd65wIB0tlTpRXbcc0kFgM8QMWDa
         pOgUzHM34gvIkmuXSq2CDmjPOLuQgvzrUQeKbWZaSj1nTpDLCMFpHLXtYU9QWCbl/lyf
         2MEkT5tKQrSmuhN0IT3PDrzr7P2sLqG2mRgL+F263wxdLPCrw06hvVvZOFTzGtpxSpnm
         AyZKKe0fpr4KZwmQzX5FMRQkoi5R3PlEKUgu0mwHXnuZrpqp5n2iTDrSx8pE4uwJdZDq
         cA4Q==
X-Forwarded-Encrypted: i=1; AHgh+RqN5CEA7X4eFu8QsP04fC5llSyuWHL2P7RDmKWsXNLeaLiUUp8RaHYJExMKNPF4//qYG/B+0tB0wWqk@vger.kernel.org
X-Gm-Message-State: AOJu0YxB+o/4SwrM5yuXM4R/ztrcxsQoiVvI5IG2X5FvBOXAjg3+01d3
	Ks9I6NtAnFwBvR19iOAaXjpL5sp5/fP1JRwA+Eayhv20hgxG7CEA2mp3
X-Gm-Gg: AR+sD11ncIkeJBxy/mGfYOKzL7o6XtIrt+4X+FxIFGb4GVv3aXjXtrymipxKrK9IN+3
	2Fvh2evMoA1BPfDfwZza6rb5GhZy0ePKklZumYSGmiyU+apBTPH/mCSWQaHYbe3nu55du8MpXox
	zcSajRhRVQkZRezh1GQBmm9btXqJFJE8ZYrd++gVa42s/Lqv7FzdEoZuJ5Nh/RWc1QKwI1G58Fc
	s3VmOu7CoSQYYZbiH0D+jNWJgRpu9pDAYS5OcB4faudV84shM3yeFlkmmx+zz/k5OdLwdSN1ih5
	ZS0VmMWd44kqH82u8AK7lJug3TtEXCc5M1VDyjhkazb/OtH9xV3b6QS7RmS7AvPsyHUK2IpYZRF
	Hq7iPVK3jsKTiA768sBX04QB+uKsOWjxsfZrt1CjttDvQUH4AtA2Y51bwk44CIoZqxUzbfjFFyq
	ty7hyMPr31VoSAy500xeDADYRrBsz98L5Wq2PkHCW8uaC4SdX+uSqAyfvA+LeaH9Sd7v//jYFWj
	+K6uK6kxopyfKnI+2WxtDLLA2xO6UF6O/nJvi5rLDhKbK+HQvU=
X-Received: by 2002:a17:902:d492:b0:2ca:5970:732d with SMTP id d9443c01a7336-2d0340d9998mr1527565ad.41.1785353412042;
        Wed, 29 Jul 2026 12:30:12 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:47::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bc9fe9sm15534575ad.51.2026.07.29.12.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:09 -0700 (PDT)
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
Subject: [PATCH v5 10/22] ext4: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:25 -0700
Message-ID: <20260729192737.3190206-11-joannelkoong@gmail.com>
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

Convert ext4 iomap_ops to the new ->iomap_next() callback. Each callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ext4/extents.c | 4 +++-
 fs/ext4/inode.c   | 8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91c97af64b31..15972410d460 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5171,8 +5171,10 @@ static int ext4_iomap_xattr_begin(struct inode *inode, loff_t offset,
 	return error;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_xattr_next, ext4_iomap_xattr_begin);
+
 static const struct iomap_ops ext4_iomap_xattr_ops = {
-	.iomap_begin		= ext4_iomap_xattr_begin,
+	.iomap_next		= ext4_iomap_xattr_next,
 };
 
 static int ext4_fiemap_check_ranges(struct inode *inode, u64 start, u64 *len)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b48c54f3312b..bf9755b541be 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3850,8 +3850,10 @@ int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_next, ext4_iomap_begin);
+
 const struct iomap_ops ext4_iomap_ops = {
-	.iomap_begin		= ext4_iomap_begin,
+	.iomap_next		= ext4_iomap_next,
 };
 
 static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
@@ -3905,8 +3907,10 @@ static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_next_report, ext4_iomap_begin_report);
+
 const struct iomap_ops ext4_iomap_report_ops = {
-	.iomap_begin = ext4_iomap_begin_report,
+	.iomap_next = ext4_iomap_next_report,
 };
 
 /*
-- 
2.52.0


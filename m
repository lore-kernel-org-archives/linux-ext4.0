Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E8543030E
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187494; cv=none; b=VFcfA/k72Xg5m8LvR+Y9G4KfHK6QpksGZaNJQHuYoHB5HiB1giJAQISo6lUYCh7CiQWRp45bxAJC8vjfxnklwupI+L797yvLGqRq+VQpnHen6EIU3saZzvae/U9ER9DCtb6Pgr7SNGp3jlhExBYRfYRyTn/RbWP1QJx9hoggWgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187494; c=relaxed/simple;
	bh=NkWTxDB7BVf5kr2NeMKSqq0wtS9n6p/N2UG9HabFDJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLds2Tx+Ur/N29h1fbfpeF/B+4AS/6y+/USf0z/TG5if0P6fVK9hvKbQVJHTuQjX4hU4MQbn8413QEhBGb0dMr6/HGyY93daIeBJW1VKgdGAiRJga5JhllU7yboYcDxdDi2b4YyPF+mIuugINQ/qzUf2ol1qpqluqhiKcBViPng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbqwMeVC; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbqwMeVC"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso307483a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187492; x=1785792292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e6+Ei9NFKggzOoAWAaPtMOQsJgv2L14jqLZIvC8zwcM=;
        b=HbqwMeVCX974YpYO10UEAgGWwkIX6cQ6tYny0r/YvThQigrbWuU7GtnothhhK5fgMx
         9uvIEWz+hVpGFyz8FyO7r96a9NAUzTCyQ5hRxkgJRUimaLKtIOtvjuD8nE+u0rMiF2d6
         mnrzWFfHNj1HkwPGOHjepVxUAFDBDgtKtWiaGuRd9/IGe/Obr0XUDEAkz7Qy9XTVhyjd
         w3oLjb+0rWf3KnTeimJSsnydejkHjnDBGt10nesUmTf6eFl/XPpHtCkJDDcFfBPFDqsL
         8bH9IOi21FNfoZ9HH4d8HInSOmcdX01dYU+bxzczi14R3Mr+vVYiIL0ZFk4htCOfUf3L
         58yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187492; x=1785792292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e6+Ei9NFKggzOoAWAaPtMOQsJgv2L14jqLZIvC8zwcM=;
        b=FAuIYFVcJkldKBXc5TRLXpovBKBwvnaZqQ64MKsHQFZ6alBlKtSYvSy/YkUsOMS7zT
         12DbV4ctTkTCzpFh2g/QtxemJ7KEOBYKGRWFuZSbHh3rfZBB3FNFkFS9jBfjJpUvQT90
         Zr/Lij7cOtEi+OTVj4IQjlHFFVYS/dVo0ZlK/Tmt6BwRRZw5uoT+uHkteAgrGDyYXg2F
         XLM4AWVATt9CRSjTQfhjW8CJtHxPIJDR+1Jy3pPjhVIKFr9gLYEjt1iwBggFANN0Eg0u
         n4ItMDboK3Bvq2+JVH6zaEWRUHDmMn9hHMwNKb0LEiEnaPBclBQTWbZYjPs3pI1Cv4V5
         nVqA==
X-Forwarded-Encrypted: i=1; AHgh+RqXlLxl8pNIa9+lPycpQhSA7cPjdHHBVKvT4TNy7niTnPWaP7FZ3h8R0NVSLom8Z38tM7GpCer4Kr0B@vger.kernel.org
X-Gm-Message-State: AOJu0YzMK+/IyPDE/8PuYMJR+Dv8I8zoq1+lQ2GzxryCQGIj2QxVeSs5
	M9jm3RyzvnBHI4DQMS15PRhebcl5BE2RILQS87MNAzbpk4g1hh5tfVJB
X-Gm-Gg: AR+sD115hy8rL+JYF5tfYzCOf7L6WpJr12KyxxlNWNmWCEv1ddPt0CYZNzDCTurfJhm
	hMZw8PrmkuK/7D6i2mrphCIrMADXnCjSMGHqEHsYB3bSh1vY1K9FHyWHofbD+rOVdDVKurfkTU0
	YYlb4xuZEi+YCEZEegi9vqMEsmvs09MsTtjG0WtLhxXr9vP6x7siHSYdMKmPFkUl6BUgquE5kvv
	jhGKo+gTwLvOPyNEW8PJp3/8R/XV1STnfK/DuM0nFIPomWMHdK0Scsx+gVhqUz5lsZgdOB54i5i
	vQ4SQe7/ljzXP3/NIlyV8sjyNWaREDjGsr+XQNOJZY2pGEjuEcocvOGux5D06sDsiuSA+qOWKrx
	t9O0POTrIj+pfPVp+1vxihzDCwckd6+wzXJdeZuG5sM/YucwRx46PXyvJYUvWZUlmp2cdFAoWvk
	RpZ0bQPrVNbCF0UK7WhF5FMPGKE99KWxzS/mkxZT8acZV17UizXvE+48mY0w55Kq0OfwDUwi1+T
	qF5yu5Dyede1vs5PHwz3CTnofL+RCSLbFX9/Iiv
X-Received: by 2002:a17:90b:1804:b0:38e:9ca8:e99 with SMTP id 98e67ed59e1d1-38f66c425d2mr347628a91.5.1785187492156;
        Mon, 27 Jul 2026 14:24:52 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6412acd7sm345271a91.6.2026.07.27.14.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:51 -0700 (PDT)
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
Subject: [PATCH v4 12/21] ext2: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:49 -0700
Message-ID: <20260727211758.1116539-13-joannelkoong@gmail.com>
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

Convert ext2 iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT_END() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ext2/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 29808629cce5..7e0fa9c454e1 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -860,9 +860,11 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ext2_iomap_next, ext2_iomap_begin,
+				  ext2_iomap_end);
+
 const struct iomap_ops ext2_iomap_ops = {
-	.iomap_begin		= ext2_iomap_begin,
-	.iomap_end		= ext2_iomap_end,
+	.iomap_next		= ext2_iomap_next,
 };
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
2.52.0


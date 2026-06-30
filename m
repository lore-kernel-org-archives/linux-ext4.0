Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F313C1973;
	Tue, 30 Jun 2026 16:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782837789; cv=none; b=XkjYfb9JCV1LLIL6KZTyIQFWpf7SAKUVUNcWsVMu90Frv/tBhS6vjik5hmKrCkOaILC6zjZ4gA1OusX5C+6uDSJh4TyTJm8vTNsG5BL8DyAedp/KXbUhLdxVCBx5L49kLZbTS/n7U8XuxRPGMQ+A+fOkbESTbIYN7xVvJfrwhxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782837789; c=relaxed/simple;
	bh=b1w8sQpA0E1ppiFJ9AdKj3QxoRDGZqHwXGbRfhfSk6s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uE3HIxHAviwUNrcr4Zejjv6XXQ+KzZEpWbJfn88kpnzDlYk8cCJPUEeNXQhtMAEss38qoVXIciQgkwa3Mp+NDA+qu9QFJq60oM0nY8Pqyo8jCou/rlidTfsVCkOFRmpDQOVfX6jbLTc72G2PQPpj7yH7xKcGvtOQxryfdyVobxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Pm8q2bNb; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Pm8q2bNb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782837788; x=1814373788;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dfEaDMcD/X4BvJz8kgmN6OdiA54u42vn5FML36FMDHc=;
  b=Pm8q2bNbu7oY9LYUkFQDINIfVubHgksI+u4U4Mm3+TGJR0k9rft6qz/d
   gnsPTVOAa/RrTgKuo9S6HLlVQkZoL45Ttn+P3Wb+t+3Kq9oIuNDg9UXDt
   BNUx6/6EXmV+W0yqa28Ctbdax7uMBZADXcp+lGt6pPBTHcLTazEGsUw9n
   9nQyy3HObcarIlCFlQu3S4ZgEfKNKnCs7gk3o5HbTnJXfdTW4sKQHS4Hh
   RvlvkQ3Uy8LCbVulmKP1qMqTdnehuI4ucQrg/1pNxYfJK9wA+Ig8Mwa9A
   jvxcQJ8qdRoJCy1iispt41qpQENjYzSb2wyJabAnWOiahbIeenMJ9oGma
   w==;
X-CSE-ConnectionGUID: aSW3M+gmTkCbAkOQnV3uPQ==
X-CSE-MsgGUID: cYhpdRAlRk+JnQbBTf3yiQ==
X-IronPort-AV: E=Sophos;i="6.24,234,1774310400"; 
   d="scan'208";a="22770581"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 16:43:05 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:26069]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.143:2525] with esmtp (Farcaster)
 id edf2782b-f685-43e8-b232-8db52ffe363b; Tue, 30 Jun 2026 16:43:05 +0000 (UTC)
X-Farcaster-Flow-ID: edf2782b-f685-43e8-b232-8db52ffe363b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 16:43:05 +0000
Received: from c889f3b07a0a.amazon.com (10.106.83.21) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 16:43:03 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <stable@vger.kernel.org>
CC: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH 5.10.y] ext4: add bounds check for inline data length in ext4_read_inline_page
Date: Tue, 30 Jun 2026 17:42:56 +0100
Message-ID: <20260630164255.51218-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D032UWA001.ant.amazon.com (10.13.139.62) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[ Upstream commit 356227096eb66e41b23caf7045e6304877322edf ]

ext4_read_inline_page() does not validate that the inline data length
fits within a page before copying data. If the inline size exceeds
PAGE_SIZE due to filesystem corruption, this could lead to a kernel
memory write beyond the page boundary.

Add a bounds check after computing len, returning -EFSCORRUPTED if the
value exceeds PAGE_SIZE.

The upstream commit replaced a BUG_ON(len > PAGE_SIZE) in
ext4_read_inline_folio(). In 6.1 and earlier, the function is still named
ext4_read_inline_page() and the BUG_ON was never present, so this patch
adds the bounds check directly.

Fixes: 46c7f254543d ("ext4: add read support for inline data")
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
---
 fs/ext4/inline.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 129f7ff56b43..edaa88202260 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -513,6 +513,14 @@ static int ext4_read_inline_page(struct inode *inode, struct page *page)
 		goto out;
 
 	len = min_t(size_t, ext4_get_inline_size(inode), i_size_read(inode));
+	if (len > PAGE_SIZE) {
+		ext4_error_inode(inode, __func__, __LINE__, 0,
+				 "inline size %zu exceeds PAGE_SIZE", len);
+		ret = -EFSCORRUPTED;
+		brelse(iloc.bh);
+		goto out;
+	}
+
 	kaddr = kmap_atomic(page);
 	ret = ext4_read_inline_data(inode, kaddr, len, &iloc);
 	flush_dcache_page(page);
-- 
2.50.1




Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705




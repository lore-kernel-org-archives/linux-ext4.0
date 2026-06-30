Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DCE3BED19;
	Tue, 30 Jun 2026 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782837577; cv=none; b=fUpRQ0mcq6mQnw0k5apG7gQZe1wk4SiLC1+aJEdmcMWrrJXxaUoWhJH5zOrj0RTGNMEVjs+3ENF4U3MF+5wVj/V8QBHexp+ZNh4/Tx+YBmoAz74kJP3hUtC3z42DNg3wAkXEx+jgCnc45sb3I7yqM3YHzB7qkoNqfgIN/VB8NdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782837577; c=relaxed/simple;
	bh=tjShsfv5J1PHlz8pRDsWcoEbBD3PNna7R7QwK13bCvc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DcLPK1jvCQc1ItvXKymSJkHX2tkofW6nBsaZbxANaoRpwZyRNvKmiauSgH18VzZWMOCewuQrmHkntvHSEQhcf+qS2cX0QCKvt6PeAjibWQLkmYF1lSnYjJibA3EiEfHNOpVF/Is1VNytt1+NnXZcuBk3YiwhfI7QuX8S5Ac/TUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=iy+PXLpC; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="iy+PXLpC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782837576; x=1814373576;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p7pK64rp9xmz3dBE6Bd7/SpiY7VfAZEXZEbUorlryec=;
  b=iy+PXLpCWce88qz5rsRKfdEVGfrG5weIR2d+YItTIB/J7Jhoji318tbb
   ZBzCcjwyW6caaj3GnSLcbKD5MuCFZBwsmb6EAUrup7+HOWLvXq/adU9X/
   eVhRDp0RxyDG64XZysqbCdMJukR2YDUm9yL84e43iqMgTxWaFOysat+2z
   VpYWbgvD+pGja83Faft5fYQB4KtmB+5wW+b4s8W6zDiVMInPjqI4vn2wJ
   JgkiAbIMpNEuaw15CP4+WTbMR84R81fXdDnAV6gEsc6iyE5TcaKXBuVDR
   1lMXDhkND2eNBRnEUof1cjprreTZ9/HXc4+Znew4Sso1zzYDseb3DbkfJ
   Q==;
X-CSE-ConnectionGUID: 5lJjVnkoQAaM2RBHfqOrHg==
X-CSE-MsgGUID: HPsQgVjiQkiUjHITKEhiFA==
X-IronPort-AV: E=Sophos;i="6.24,234,1774310400"; 
   d="scan'208";a="22583745"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 16:39:34 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:5246]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.30.151:2525] with esmtp (Farcaster)
 id b4d90bc7-5502-4e52-a9e6-1432f987b99c; Tue, 30 Jun 2026 16:39:33 +0000 (UTC)
X-Farcaster-Flow-ID: b4d90bc7-5502-4e52-a9e6-1432f987b99c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 16:39:33 +0000
Received: from c889f3b07a0a.amazon.com (10.106.83.21) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 16:39:32 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <stable@vger.kernel.org>
CC: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yuto Ohnuki
	<ytohnuki@amazon.com>
Subject: [PATCH 5.15.y] ext4: add bounds check for inline data length in ext4_read_inline_page
Date: Tue, 30 Jun 2026 17:39:24 +0100
Message-ID: <20260630163923.50039-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
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
index c5b1f9af2309..5d5f99ed9746 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -517,6 +517,14 @@ static int ext4_read_inline_page(struct inode *inode, struct page *page)
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




Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9A036B07E;
	Wed, 28 Jan 2026 15:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614040; cv=none; b=Vxyd0zZcFIugtXvCOTagH15KOPda3gRvPAmPJVT4DT6JVN8Kde+9VVIj6o+s13JA4mmNQ3cul6vTC5G38Agx097Q6ncD7U3z4/soQWllbgKxbLSCbanUM4GK+9YqCpSPqI3U1rDn+4BvSv4gZomTrc6kcZ57DdYi5a0Y+i2INnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614040; c=relaxed/simple;
	bh=jhsCEEAqNPDcQ2Ukgq/Z04gBE+CWeDXFu38TsNXFeb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOlZ+0lujHWE4BqInZ0suAskyy0jh2kD7Pa0m5nHl+N7jLHMC8fDqr+6bnjiyRakoqHWGUmBELPBeax0R64duT+YjtT4DeLU1u0TbaZ9XCSzZy8LQH4agI1vv7C0u2eailB8c7z1ISbrBea22HdgPtblP6gxtiE2cfkAi93oTDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dVd18Exm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dVd18Exm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=msMVIu9sG+zHlGxQl6P3akWEAjf+4WBK4vAVLStngPE=; b=dVd18ExmGCZkFJamtEf4SC4uGg
	yV7ELCrRHGaowT2XAI9d6uv85hBkyFZ6T55gL8l8xXkoeauB9hfuaMEhcWUS/v6UBaxETZUdoBqHF
	Qun4+VI0tOGfTyxCyyMIsAPdqlAckqEHofmOBsOHKJmBk6W8llANX7HkOBYUr68xUBx0Ydx+DDQYE
	e9LyiB2hWj17lQ/ulxSomAHsC9xUTxYjXI+LwZAL57jkA8fHvsLw56sotK0+jUGuporlyq9Z1Q3XO
	IOI8rLuF9vkagfCUtbpIozg9FJiJsLFaOtdCVaDYsHSO+vBzAbOroU40L2D+KpCxzydoIZoPWeJCK
	BmYkucvA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vl7Rm-0000000GHNR-2aOy;
	Wed, 28 Jan 2026 15:27:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: [PATCH 04/15] f2fs: don't build the fsverity work handler for !CONFIG_FS_VERITY
Date: Wed, 28 Jan 2026 16:26:16 +0100
Message-ID: <20260128152630.627409-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128152630.627409-1-hch@lst.de>
References: <20260128152630.627409-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use IS_ENABLED to disable this code, leading to a slight size reduction:

   text	   data	    bss	    dec	    hex	filename
  25709	   2412	     24	  28145	   6df1	fs/f2fs/compress.o.old
  25198	   2252	     24	  27474	   6b52	fs/f2fs/compress.o

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/f2fs/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 7b68bf22989d..40a62f1dee4d 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1833,7 +1833,7 @@ void f2fs_decompress_end_io(struct decompress_io_ctx *dic, bool failed,
 {
 	int i;
 
-	if (!failed && dic->need_verity) {
+	if (IS_ENABLED(CONFIG_FS_VERITY) && !failed && dic->need_verity) {
 		/*
 		 * Note that to avoid deadlocks, the verity work can't be done
 		 * on the decompression workqueue.  This is because verifying
-- 
2.47.3


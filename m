Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D581013AA2F;
	Mon, 26 Jan 2026 04:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769403166; cv=none; b=BinxUMrAp+kqgpAq/Uu+Z4J4hWIxp3nEU+ufahBZZuJQKaEJtYcun/q9ZZ28VD9hbOOITDfi6AVt2Oax8BlVVWd42fpK+DE2XYP+5wTUD8rJORu3JDE1KaTb9RPQWgcMZAu6sg36g934TbCiabM3Fe1bjlwOOQaghzxqgg9qdfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769403166; c=relaxed/simple;
	bh=jhsCEEAqNPDcQ2Ukgq/Z04gBE+CWeDXFu38TsNXFeb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aowjlW82QTWuo/Q1gLInn9Bws/4e+u3a0F2xEAtBY8nIXxCYhv24cQM2ihYANfnrf1HJFA/eaLE/qlZ/vBNEmlx3LXuO/Uyl0t5AZSvCkr/OdDl1ByM/T9LpMhBV8LIUWvcE6YuwmK2ac/G30x9k3xIVA6eVk80WD9xtezjTgfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=25c5Ta7G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="25c5Ta7G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=msMVIu9sG+zHlGxQl6P3akWEAjf+4WBK4vAVLStngPE=; b=25c5Ta7GQUDobn0Tj5TWcEk9FF
	mn4meeagTervwGPMltG1T9z1ye1U1VS+t+gazG3hRDG6+eGKVRAhSPm5dOVEE4d832K4JH1nxbkxW
	DT6cOkBZE3C6GZMgiL7DdjUOgLXueC5DTv5yhZ6F4J6yH6kUsMU4wsvuXtwvcOs6w6nklAwpMNrpj
	6hbVlkvf92lMiczrJNWcuD2rzaiLewVmTuxksauReVN1baUjLcCC6j4tj+Jb9kmDHY27R0EyEmjC5
	QgoblTW7pu8wrQYbjgiWr3b6pPKE1KWAoYg9ZEL0yjhcyz5lchLO//7rlAms64vPmd6xf6epIfRqv
	aj+awHhQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkEaf-0000000BuQ1-2QIb;
	Mon, 26 Jan 2026 04:52:42 +0000
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
Subject: [PATCH 04/16] f2fs: don't build the fsverity work handler for !CONFIG_FS_VERITY
Date: Mon, 26 Jan 2026 05:50:50 +0100
Message-ID: <20260126045212.1381843-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126045212.1381843-1-hch@lst.de>
References: <20260126045212.1381843-1-hch@lst.de>
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


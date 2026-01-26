Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258CB30DD13;
	Mon, 26 Jan 2026 04:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769403186; cv=none; b=d6ljElKCEfbdQlVR9jLCz7J+RAYIOLtKBmyZwT5Bon+IBjR+xrQ/tx2vSQTW6xq9TPbAc4hPsGZ5XmzMZwxmTW+XanAuWFuut5gV3tm90sFhWdG887q+c38kq5qzVATxzVwViEuV0tB6pzLj6Vuy1s5FyRjqLGcS/pXqh7diRTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769403186; c=relaxed/simple;
	bh=qZiYTDHMhBoOSdKH6VShTwyoXM45leJmtC3mHtd4yyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPwswRvsOHW8+qep7zn2Xk9rcy+AlVxB9QWYunYWicP62TUq4+Dp7+1Pz8w8n+ZZZwVNXlY2hmY8yG2F2VgaEKoVpQzJTUC1A+vkSem/d+vsroueDG4UCGmjdMKG/8cMwEuJMgZ9U/52ywiP94YOtwoLpfk/GCqVyHvV8wwTczA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m15PEti3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m15PEti3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wwLY2TDIZ4xwQYv8o9VPQbGppsy2AB3bN2D3HceRICk=; b=m15PEti3IyvavP31tG9iY8FGdu
	HxW6ufaVGqAv3esj4IqCH3v3Afbpevgf9Q4GykN3RFOV1ywngLSKyM+eUggVgm5r5oY+TRBP075At
	bScieccBAQhq4isPA50YCUFNozgy48ngl3/BVmc1WEsnI1xo6ytXjNRLBIc+5rNaWsB1dUlZwJlQT
	pEDYthy6vFHZyiP6ZekGoFpjnAQsl7qL9Xut0g5ngU+vFiTE5AT3xbAgt9zH1bHvA+IyfzFn7B5pM
	PUBWhMri0H6zRen4Xtfv5I0whqCDZTqeisFL64ZHBIMvCa+1hBpNrPuB3cRYTsdVxVgoHIr0/fr55
	fGRfI4Aw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkEb0-0000000BuRt-3FXb;
	Mon, 26 Jan 2026 04:53:03 +0000
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
Subject: [PATCH 07/16] fsverity: don't issue readahead for non-ENOENT errors from __filemap_get_folio
Date: Mon, 26 Jan 2026 05:50:53 +0100
Message-ID: <20260126045212.1381843-8-hch@lst.de>
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

Issuing more reads on errors is not a good idea, especially when the
most common error here is -ENOMEM.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/verity/pagecache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
index 1efcdde20b73..63393f0f5834 100644
--- a/fs/verity/pagecache.c
+++ b/fs/verity/pagecache.c
@@ -22,7 +22,8 @@ struct page *generic_read_merkle_tree_page(struct inode *inode, pgoff_t index,
 	struct folio *folio;
 
 	folio = __filemap_get_folio(inode->i_mapping, index, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio)) {
+	if (PTR_ERR(folio) == -ENOENT ||
+	    !(IS_ERR(folio) && !folio_test_uptodate(folio))) {
 		DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
 
 		if (!IS_ERR(folio))
-- 
2.47.3


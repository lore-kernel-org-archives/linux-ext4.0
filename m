Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vj4URvfu"
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADC9C9
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2023 21:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=YUSFa1cdq2g65yFLogoyfHTJ4BClbsI0dVC47+Abz1A=; b=vj4URvfusCAzyJaHpozs+wwj1B
	KAMS/zsWlKd+HHowyW9NCSPEtdHFbpYmojnjEHRf0Ahe1FxNLCES8VYkeAa8XuYgYa+PYaz+spBs+
	/+kRlfTkjVfI1DKJ1yWSuyKpr8k9OXFSE/4wKHY1XiyWTn5Ayyx/46FISJnLBpIppoDrrt6pwJ6iH
	cm9jmNvLDqFlxVuA+uTpkWox07GPfMlNGn6kIsWz+Rw5OVOJtd+tikSz5e88pOyerRa08ThstiT2A
	LlHh3WWVn8V9qHsWCuCXME5rexGMMI9MZ67vfqINh3wNZYePRymqc0aW7XBd9IGtSlda+7w6pO6Zp
	E0gc9PNw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rDeIw-004H4x-OJ; Thu, 14 Dec 2023 05:30:39 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: Convert ext4_da_do_write_end() to take a folio
Date: Thu, 14 Dec 2023 05:30:35 +0000
Message-Id: <20231214053035.1018876-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's nothing page-specific happening in ext4_da_do_write_end();
it's merely used for its refcount & lock, both of which are folio
properties.  Saves four calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ext4/inode.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 83ee4e0f46f4..216ad9bcca45 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2947,7 +2947,7 @@ static int ext4_da_should_update_i_disksize(struct folio *folio,
 
 static int ext4_da_do_write_end(struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
-			struct page *page)
+			struct folio *folio)
 {
 	struct inode *inode = mapping->host;
 	loff_t old_size = inode->i_size;
@@ -2958,12 +2958,13 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	 * block_write_end() will mark the inode as dirty with I_DIRTY_PAGES
 	 * flag, which all that's needed to trigger page writeback.
 	 */
-	copied = block_write_end(NULL, mapping, pos, len, copied, page, NULL);
+	copied = block_write_end(NULL, mapping, pos, len, copied,
+			&folio->page, NULL);
 	new_i_size = pos + copied;
 
 	/*
-	 * It's important to update i_size while still holding page lock,
-	 * because page writeout could otherwise come in and zero beyond
+	 * It's important to update i_size while still holding folio lock,
+	 * because folio writeout could otherwise come in and zero beyond
 	 * i_size.
 	 *
 	 * Since we are holding inode lock, we are sure i_disksize <=
@@ -2981,14 +2982,14 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 
 		i_size_write(inode, new_i_size);
 		end = (new_i_size - 1) & (PAGE_SIZE - 1);
-		if (copied && ext4_da_should_update_i_disksize(page_folio(page), end)) {
+		if (copied && ext4_da_should_update_i_disksize(folio, end)) {
 			ext4_update_i_disksize(inode, new_i_size);
 			disksize_changed = true;
 		}
 	}
 
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	if (old_size < pos)
 		pagecache_isize_extended(inode, old_size, pos);
@@ -3027,10 +3028,10 @@ static int ext4_da_write_end(struct file *file,
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
-	if (unlikely(copied < len) && !PageUptodate(page))
+	if (unlikely(copied < len) && !folio_test_uptodate(folio))
 		copied = 0;
 
-	return ext4_da_do_write_end(mapping, pos, len, copied, &folio->page);
+	return ext4_da_do_write_end(mapping, pos, len, copied, folio);
 }
 
 /*
-- 
2.42.0


Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D547E3B38B0
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014161; cv=none; b=McvGP9Sw94aDhtaAQ0qw/uDPalqpljwRNwqkH59+2+3+VX+NSFovTDBJazr2//3YaXthS2icelIg00NyGAQL88pLf6IZuODpZYoVRkndOSy/X7FrshjOdeswU/M7pTj038E8S3wAaN2PkidQ/syYtheE2Oqb43txIgabO6D0MfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014161; c=relaxed/simple;
	bh=21rbptBohvHLbIzoeM8IfhTkwdubfon9k5dpdTlpgfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRQWumBgCcyBVX+kVeJpyk1CPGrly7ne2KQIb75FLEnjxQQ8C1ou4fVPVGRAl3svvfM4A/PTaiINIkcsaTcjn24xE3o22PJ4JJdI4qAF6h7WlYO2uNEftaXUwkoymokztexIjmJnd2GOZa/8JXPvsZ4lzLcjq0n7TiL9oxlNrPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 64DBA5BEDB;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59A414281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j13hFZlOvWl2CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 07438A0B4A; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 21/41] fs: Stop using i_private_data for metadata bh tracking
Date: Fri, 20 Mar 2026 14:41:16 +0100
Message-ID: <20260320134100.20731-62-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1862; i=jack@suse.cz; h=from:subject; bh=21rbptBohvHLbIzoeM8IfhTkwdubfon9k5dpdTlpgfs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5+RXfvEFOavnw88KSkCELSYzUGb6FJxDza0 lFuc/BYWXOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OfgAKCRCcnaoHP2RA 2cVdCADcHKi3nENibDjh07t9tbXyUjkh5c1Polgi3FSaCQm47zS25K8aFptUxE2/oY8ejx7lyWp A+8xQcd21feMFPNOSI5mebAUxEmRB8Lgx1x6CHLQd0D6LlajkimXDuNt96nf+oklVRD/H8BcwDK HRgqbSaj0IJAwDNPgEPIn1y9JtSheML/XPlQP9uLuqfTP7I8JnfxyBS/9FxWrPTG+BbNyXNBQjV FHoiSlj/Uz9ZJlTG+NsU2p2A2akXMddVm3za2fBHhQLK5HWuK+eIeL7LD3J/FOxBNTBu6jRl9bA H+LgpsYFNtKQC0n8Q7/8/hIR9zPmkIaTfAtDesjgnuGLH1Mr
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 64DBA5BEDB
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

All filesystem using generic metadata bh tracking are using bdev mapping
as a backing for these bhs. Stop using i_private_data for it and get to
bdev mapping directly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index bd48644e1bf8..c85ccfb1a4ec 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -574,9 +574,10 @@ static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
-	struct address_space *buffer_mapping = mapping->i_private_data;
+	struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
-	if (buffer_mapping == NULL || list_empty(&mapping->i_private_list))
+	if (list_empty(&mapping->i_private_list))
 		return 0;
 
 	return fsync_buffers_list(&buffer_mapping->i_private_lock,
@@ -679,11 +680,6 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 	struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 	mark_buffer_dirty(bh);
-	if (!mapping->i_private_data) {
-		mapping->i_private_data = buffer_mapping;
-	} else {
-		BUG_ON(mapping->i_private_data != buffer_mapping);
-	}
 	if (!bh->b_assoc_map) {
 		spin_lock(&buffer_mapping->i_private_lock);
 		list_move_tail(&bh->b_assoc_buffers,
@@ -868,7 +864,8 @@ void invalidate_inode_buffers(struct inode *inode)
 	if (inode_has_buffers(inode)) {
 		struct address_space *mapping = &inode->i_data;
 		struct list_head *list = &mapping->i_private_list;
-		struct address_space *buffer_mapping = mapping->i_private_data;
+		struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
 		spin_lock(&buffer_mapping->i_private_lock);
 		while (!list_empty(list))
-- 
2.51.0


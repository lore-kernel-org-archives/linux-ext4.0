Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5751B42379D
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213815; cv=none; b=eRQDVVZ3iHgByZ9RhadUwTXimtH6lwvzmEmYOq50iCYM84YAN3t+ew1aQGb6VQ0tpXhT20Sm0llsJGxMzR8j4eYve5+yAMGxtG7x8WIWKjDpmIjOc6a3ZPt/5EAyLGSzxph29beLPogUWRPe2iasjEmRvvpEVyYdIg75EiiUk3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213815; c=relaxed/simple;
	bh=tKjRk1t0n7fy4kXkItDZOgQtWkprop70nNQUPf8pbr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzMEqi/20GcPBPkgjQLxwaiWVg/Q93JNzBPAY/ASQDh8+s52LZ3GcghVby32kKmj9Nnb7lLOOJeHIhEc2YL0Dxitgr6EzG3pfXYJfD0kgi64AHj2Rzj37dIJEKIlKY/KnpYtF8G+GNE1K5P1IRU1jQbyC4MtxSC0NzXHlqZWZYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C476C789D9;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BCED7779B3;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 36keLgXxWGoTXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9A252A0BA1; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 14/21] udf: Fold udf_update_inode() into udf_write_inode()
Date: Thu, 16 Jul 2026 16:55:36 +0200
Message-ID: <20260716145527.3580300-35-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1493; i=jack@suse.cz; h=from:subject; bh=tKjRk1t0n7fy4kXkItDZOgQtWkprop70nNQUPf8pbr4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDrJbc/2Ho6jRq2NOf+BtUFzD/GgoGcyXPBS JR0tsQbH4yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw6wAKCRCcnaoHP2RA 2e71CACvHhyT7HGVIwqgUB9Gxu99TtxSBmirwuFwZzA9HqxOplWR+CSXnozcMW3Oq0Mb1FNtwsV DXj33jtihKUPZCeVxoK5AurXgBqvv1bngA8XBXa6UYDZxDXUR6POz9gZQqoj1nc6y/Kw2HDo9EL SR+1CJxqenZDRfd/cuPHX4E8owavVj5AGcDiWAbV4AwMJsIwcM4gM4+UhRob04tY7gZOMOEJUy/ TqpeVId6aZ4vXJ7k5ay9Fy6fTjdjpS28zdrLQhwedPgSttceWnEi4jfs4xbgNrfRTePaZlAxBVe suTrifWblUB6N7OtA+2kd2fC4wy2xpLSuAelKh7j2JPPt9Wl
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: C476C789D9
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]

There is no point in udf_update_inode() anymore as it has a single
caller. Just fold udf_update_inode() into it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 8cf0562f34bb..68c6c2ba8ed1 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -51,7 +51,6 @@
 struct udf_map_rq;
 
 static umode_t udf_convert_permissions(struct fileEntry *);
-static int udf_update_inode(struct inode *, int);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static int inode_getblk(struct inode *inode, struct udf_map_rq *map);
 static int udf_insert_aext(struct inode *, struct extent_position,
@@ -1698,11 +1697,6 @@ void udf_update_extra_perms(struct inode *inode, umode_t mode)
 		iinfo->i_extraPerms |= FE_PERM_O_DELETE;
 }
 
-int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
-{
-	return udf_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
-}
-
 int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 {
 	struct buffer_head *bh;
@@ -1735,7 +1729,7 @@ static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time
 		iinfo->i_crtime = time;
 }
 
-static int udf_update_inode(struct inode *inode, int do_sync)
+int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct buffer_head *bh = NULL;
 	struct fileEntry *fe;
-- 
2.51.0


Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5743A6EF0
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016541; cv=none; b=Lse0Di3Y5mbzvFCrpr5ccjfOpfef78C66boRhc+Cmersz3nZij9KJOQPYyVjqFuE29O1zFNf/Iby1GnqJ4udyKwYHQ4cZ5crfJSgF5vw3q4SJVCZXEFmYXbfSYOYWYP+wfKKVkWJQ7EqQiUAZXhLsycfqcLN1kzcFg9Q1gtzHDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016541; c=relaxed/simple;
	bh=8cE3sQidwM+f+dGVdKAji9skW3jqkURoyOaSPxyz1J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDry8T8AVb33hp22yUZAih6DS5TeGnyMRilmxfuM1jZAI2bPnaSeU+y6zjZqREL1A4VAxq+SRTSLlUaOxLmvS5L/NmfSq0/3fOhhEI8E5L6Y/qwFy+0ErzRFBEZ72EgfrGRWFRi3HZsK4JsWzMvp8hNKZcaAjyP5iScwq6z+Ehs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 942E9760EE;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AA3E779AE;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e2+pFSGsRmoLGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 435EBA10AE; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 12/19] udf: Fold udf_update_inode() into udf_write_inode()
Date: Thu,  2 Jul 2026 20:21:09 +0200
Message-ID: <20260702182057.2832980-31-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2093; i=jack@suse.cz; h=from:subject; bh=8cE3sQidwM+f+dGVdKAji9skW3jqkURoyOaSPxyz1J4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwTr/+siNAeKYiKYvX6xtF7SOWOSzNxSju9A 6xYFrAmXpWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasEwAKCRCcnaoHP2RA 2ZBCB/9hKZVoaEd2TIrVOYB+L++3XCSxqTFzkD1a4+ublxvqKlJJPsK6DrAsX+WgO0xzB4E5bUX Owy5wFTTxKidZdt6pTfqEWKaIEbxLJ5an2h/14fVAhPc21PZ/SYNWibek5Ve2y7DhPyCycjL+Gs Yx0Z8spR9Nh9EAVd3dJwlpnqf7dUQVkpkzXzoP2OeMFoS+bXtqw4Py/bv7Oz4qpefjj0dkaRz5M jW8DejAMDHABuR1qJir1wsF96Fs9GHgQNB4CaFLQW8PtY1jOojkN4OjlLKrkFHuB1VwZOgMcwB0 A+t+CW8x/a367GDNNJv+P+CbwRcgLBXsSSUnzVbNTVemLZSo
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 942E9760EE
X-Rspamd-Action: no action

There is no point in udf_update_inode() anymore. Just use
udf_write_inode() everywhere and fold udf_update_inode() into it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index d5396d42df18..d991a671c0a6 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -51,7 +51,6 @@
 struct udf_map_rq;
 
 static umode_t udf_convert_permissions(struct fileEntry *);
-static int udf_update_inode(struct inode *, int);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static int inode_getblk(struct inode *inode, struct udf_map_rq *map);
 static int udf_insert_aext(struct inode *, struct extent_position,
@@ -141,7 +140,7 @@ void udf_evict_inode(struct inode *inode)
 		if (!inode->i_nlink) {
 			want_delete = 1;
 			udf_setsize(inode, 0);
-			udf_update_inode(inode, 0);
+			udf_write_inode(inode, NULL);
 			if (IS_SYNC(inode))
 				udf_sync_inode_metadata(inode, NULL);
 		}
@@ -938,7 +937,7 @@ static int inode_getblk(struct inode *inode, struct udf_map_rq *map)
 	inode_set_ctime_current(inode);
 
 	if (IS_SYNC(inode)) {
-		udf_update_inode(inode, 0);
+		udf_write_inode(inode, NULL);
 		udf_sync_inode_metadata(inode, NULL);
 	} else
 		mark_inode_dirty(inode);
@@ -1704,11 +1703,6 @@ void udf_update_extra_perms(struct inode *inode, umode_t mode)
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
@@ -1741,7 +1735,7 @@ static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time
 		iinfo->i_crtime = time;
 }
 
-static int udf_update_inode(struct inode *inode, int do_sync)
+int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct buffer_head *bh = NULL;
 	struct fileEntry *fe;
-- 
2.51.0


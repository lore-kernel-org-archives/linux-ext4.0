Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144F0383C7C
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014185; cv=none; b=qdWYyGSob42RmI2xQzqNdCeR3wRiQiz6Cd6AA8aGnqf69DGZAbQPdcaI7VpZKEhwf/vIolMYvQKJ8TO/P7n0XKtIhwJo5OIcOSfJuvw+5gSDY8QwTs+6uldqwxyM0u/RtsW1odnYTvPTFac7n5xBNo7MLWsWuc9ShdUpFzVrNh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014185; c=relaxed/simple;
	bh=2/a9eqgQlz/3Mb1WXg09pHnceFw4nNkq4pR2iqKrJoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuXqwfsfiJUeoijfVTxNG1ETHrhIjWSEjJzsx4nEFxAUsRew/ZEhK3Xqbs1sfkxExRtK8xHwJt9GHP+cxhTJ4V62KrzDmOtfGCtoaLSQWCsTc1yXTsh0NSchp8J8BRRNFgS5iX0Gubw50bA/VSyxrrh6s1tdaFCfS20TjAZf2kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7CA1D5BEE1;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 720F34281C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bprXG5lOvWmCCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3446EA0A9E; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 26/41] fs: Drop osync_buffers_list()
Date: Fri, 20 Mar 2026 14:41:21 +0100
Message-ID: <20260320134100.20731-67-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2464; i=jack@suse.cz; h=from:subject; bh=2/a9eqgQlz/3Mb1WXg09pHnceFw4nNkq4pR2iqKrJoM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6C3a5/P0oUM3bDlZR3EzEk1N3kzljC9F9eH VlmIijoJKmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OggAKCRCcnaoHP2RA 2atiCADHbFrgbVpWv9NVZTcZXfG2z55SjOTpG8Q5RJZHnVhy7IxVgM9VuhxzUg/FR3cTgaxSFIc GjI16zjLWZpfTYBPto1eKQPvUMmOpUpqyFd7fwA6B3J0AuJMkh7F5xS+eZ5MvUtcs05rhzO3lGR FpTt0wrNPsJz7Jg6q5WbQZTltnamlkF4ZG9fGrnf0F2hAf/bDG3BSid4Sb/sReh6JkPvbOUJczP TjSH1Bt0SRJMnsL3xGw/Dj+8hFzdvz2S15972F3M/ON3C0gcDxqUj1m07ir1YosmCZ52AgON3oA zn1RhDf0YG8GG7PDaRqQrlCwd/CLTqBKdJJBBGGFmKMGodhY
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 7CA1D5BEE1
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

The function only waits for already locked buffers in the list of
metadata bhs. fsync_buffers_list() has just waited for all outstanding
IO on buffers so this isn't adding anything useful. Comment in front of
fsync_buffers_list() mentions concerns about buffers being moved out
from tmp list back to mappings i_private_list but these days
mark_buffer_dirty_inode() doesn't touch inodes with b_assoc_map set so
that cannot happen. Just delete the stale code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 43 ++-----------------------------------------
 1 file changed, 2 insertions(+), 41 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c85ccfb1a4ec..1c0e7c81a38b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -526,41 +526,6 @@ int inode_has_buffers(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(inode_has_buffers);
 
-/*
- * osync is designed to support O_SYNC io.  It waits synchronously for
- * all already-submitted IO to complete, but does not queue any new
- * writes to the disk.
- *
- * To do O_SYNC writes, just queue the buffer writes with write_dirty_buffer
- * as you dirty the buffers, and then use osync_inode_buffers to wait for
- * completion.  Any other dirty buffers which are not yet queued for
- * write will not be flushed to disk by the osync.
- */
-static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
-{
-	struct buffer_head *bh;
-	struct list_head *p;
-	int err = 0;
-
-	spin_lock(lock);
-repeat:
-	list_for_each_prev(p, list) {
-		bh = BH_ENTRY(p);
-		if (buffer_locked(bh)) {
-			get_bh(bh);
-			spin_unlock(lock);
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
-				err = -EIO;
-			brelse(bh);
-			spin_lock(lock);
-			goto repeat;
-		}
-	}
-	spin_unlock(lock);
-	return err;
-}
-
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
@@ -777,7 +742,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
 	struct buffer_head *bh;
 	struct address_space *mapping;
-	int err = 0, err2;
+	int err = 0;
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
@@ -844,11 +809,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 	}
 	
 	spin_unlock(lock);
-	err2 = osync_buffers_list(lock, list);
-	if (err)
-		return err;
-	else
-		return err2;
+	return err;
 }
 
 /*
-- 
2.51.0


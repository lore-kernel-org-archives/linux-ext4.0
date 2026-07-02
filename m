Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9E53A6EF0
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016494; cv=none; b=lNceu7Q55WYk59FzRfPcP/6u2WxTErHXpfh7Uh2XM2ihoGqoMmeCAOFIdUJcb7DUM/BlmEw49qqVSkfs1E9HXZgGodnuTboTz5QF6A2OVK4U8RJWyD9ZvurSSiOm4+E4wVuuu8eZ7z4S7ZZEu7NYGiT/HFQ/AhkHcwEbNI3+x1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016494; c=relaxed/simple;
	bh=lCLdoytTOUGx1v7oqdqnfZTxyA3BlMBH34J8iPYWMjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQxYU0Ns+1bSPD/Ic7VlOUxkwtuv60Cn+RZhXkBuNSJDv+P4ERgEtLLqboprUFIW+bUQIK8dBKEqH2cTFmP1FCt26lM1mdxGpdo+oLlnIN1eQlZ8XXhTtcL2cRJeqo4BrG6KCWRgi9A+WGjp0h1T02CjFNGfLy7d/hEZr3JG1Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pqbZ4lqa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lywdUXo0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pqbZ4lqa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lywdUXo0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B1FBA760E1;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=pqbZ4lqamKI7qBC72JHN6kOr/S7Dt7kZ5muY2jCq+dLskuvobjOjsWxgZJy3tJ1RXNc5+h
	iDgQ1Ex9lciVVWH8aYZULKRdUU9XcqL6nzg6ZvsCTPCDk6vEAD8tmq9Ez0tXH/rLGAQdKd
	Bqq1lolkT59qwUlA1Z2+U1w1Ey4Hg7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=lywdUXo0gMacB0HdEGCUmL4Aa8m8helenHrB/5FhjA7HN0mZc5RrkGrdp7VyZscTMrfl+t
	46D/RcfZNFXwS8AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A265F779AD;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eCywJyCsRmrrFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0F36BA10A1; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 02/19] fs: Fix possible UAF in mark_buffer_write_io_error()
Date: Thu,  2 Jul 2026 20:20:59 +0200
Message-ID: <20260702182057.2832980-21-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1576; i=jack@suse.cz; h=from:subject; bh=lCLdoytTOUGx1v7oqdqnfZTxyA3BlMBH34J8iPYWMjM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwKErioIRacwcJcg4nXKac0E4sPK8sy4vXCP ek16dHgma+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasCgAKCRCcnaoHP2RA 2UIEB/wNm4XVhnZ9Z9WBsZgpgNSYy4iPFGMmwpbI0ST0hjXxzHTYqSg9MNYIrgfbOhHYoXHYmIx XvsuU9tGHnb9HO/LpKBNr/nqBEo+D6lu7c2bRwBb3XmQ063ct/RDGELl1R+ZdWsODKtAwKbJ0Ji gzCcbE23+Gwdh7TwUCNoJPhnDEXTmDIpgnln4pZROUsDO19uQb/n2x50EOQOgmlqA+NTestoJEl ib79DsPU0kikGf+Lia8uBzr4XJ5qk1UNb8q1m9fa9iwJz5SZD1oi7vCIX8/LNrHMD+xtWABhbhs 7XzScru4TJLhlTBxa8SRujXVzYFBlLhQ8xi53RvgjvBRWKZ1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1FBA760E1
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

When filesystem is freeing inode it calls mmb_invalidate() which removes
bhs from inode's metadata bh tracking and clears b_mmb for them. However
if the inode is getting deleted, we don't bother with calling mmb_sync()
before and thus these buffers can be under IO and we can be racing with
IO completion handler calling mark_buffer_write_io_error(). This race
can lead to mark_buffer_write_io_error() either hitting NULL pointer
reference or trying to operate on already freed inode. Protect the
mapping handling with RCU to make sure mmb and inode aren't freed before
we are done with them.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9af5f061a1f8..daaa6614a6d6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1123,12 +1123,18 @@ EXPORT_SYMBOL(mark_buffer_dirty);
 
 void mark_buffer_write_io_error(struct buffer_head *bh)
 {
+	struct mapping_metadata_bhs *mmb;
+
 	set_buffer_write_io_error(bh);
 	/* FIXME: do we need to set this in both places? */
 	if (bh->b_folio && bh->b_folio->mapping)
 		mapping_set_error(bh->b_folio->mapping, -EIO);
-	if (bh->b_mmb)
-		mapping_set_error(bh->b_mmb->mapping, -EIO);
+	/* Protect us from mmb & inode getting freed while we work on it */
+	rcu_read_lock();
+	mmb = READ_ONCE(bh->b_mmb);
+	if (mmb)
+		mapping_set_error(mmb->mapping, -EIO);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(mark_buffer_write_io_error);
 
-- 
2.51.0


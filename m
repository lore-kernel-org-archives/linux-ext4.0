Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C7D3F4831
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149399; cv=none; b=B5VzVw451Mhwa3htwzqby0VfaJbVzgonFS/0BLCUcmegWD9X5dQOEFPoAi+hX+H92e3D2P32kYN1bcJ/q8Qv/N4BehBbeclJ8LYBC7pCMgFFd/ID7UyqqDvwGznNDwCuzltsamMhgxXINnurP8ZE8EGUWqFmYJt03iCaZeX4iOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149399; c=relaxed/simple;
	bh=lCLdoytTOUGx1v7oqdqnfZTxyA3BlMBH34J8iPYWMjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY9it9BiW7teef7WLnuE/a0xjqDaU2OuMHYrFzfqtaWw9z20dhfb07EtpxTOOZNVvdxmwEM0LPtPujscr+H/CEHGeO+IiHoB1Qf0ihVPjOd8Bezpr6uqeoz9yDDt581FBNRM7Mnfz+S+DGtTID67rznj6rcB3Ck1a9qqXbt7P94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N/EUFi/8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jUzu17sg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D3lhgBsC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=s9qZ95cL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N/EUFi/8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jUzu17sg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D3lhgBsC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="s9qZ95cL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C34A33F44;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=N/EUFi/8HDB8X006eAczJfujF5LjhfAqOKAToaiUkH9gkFT3d7tigoP8pnFtWwdOvM+Lhv
	Zprf4ZqJ7FFceAnwxxMqmeCnW4B6d8e5FwT2/QXSVw71nh5lnYnCx8PM4JSVa6k95VCCUM
	igq1ugxYcR2JLsL3ufU7tFc1DlgB1SE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=jUzu17sgVImGB14yLWcWlXg8vRPDq9gzht2vMSby8tCTmGr9JmazkMEOfBZfXSXnjFyjy5
	B7+ySY87LuirNtCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=D3lhgBsCNM8Szy69w7JPEVJ4X+IhXpGokSpq4MZAjd0fYniyAsWg3SBNI18lTgwI90qBx/
	fEXCS9j1CFtpxmvfPrIEVtHCm4gggJ33eYInuWH5SxcLbFq8p0SwQM3kJpxaq4QfVUTUmQ
	tCgaBeLjulbS0vdcqYLeooS/ufpe7J4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=s9qZ95cLCC6iC3pmbetMhcyHMbg/X6KRsgJXtOulcUfsS4HfLBJoAy4c9FGOhb6Hq/gYo5
	p6DpTBgN6wiJWQCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2D4F779C2;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hdCnK8s3Z2oDawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 30321A1320; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v5 02/20] fs: Fix possible UAF in mark_buffer_write_io_error()
Date: Mon, 27 Jul 2026 12:49:20 +0200
Message-ID: <20260727104923.3828017-22-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1576; i=jack@suse.cz; h=from:subject; bh=lCLdoytTOUGx1v7oqdqnfZTxyA3BlMBH34J8iPYWMjM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze0ErioIRacwcJcg4nXKac0E4sPK8sy4vXCP ek16dHgma+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3tAAKCRCcnaoHP2RA 2dtcB/9B/rmAfDdWzh8ygaiz1KSUt8UpoYAcmvD0D662abZemq5C9a+Nu00xZ3aZh9OFdmTl++s FTESvvHs+/MaPG+J1oFDLauLiVYlbrljcT1h7mgEpsxeGXyq1x6JNqpq97C9ZVdLw9qT4Pjr+kw qpjUAtKy22dF5870cXi4n0HGcDs5ozJs7DVq7d/bU5LnJqm+oVhpZTZivhO3goVwR1pERHCcH+w uzi40LgnQIg383iPjXN4QpLq7+n13ZJpdxhQTWqMoFtHCru7VCDu6HJFmdAXWOUZjvQc7aFjs0q gMIlQpqWZ0SkKVmmzn4mZtOc1NbspFLE8eSi9NcSqPTAD4If
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

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


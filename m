Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BA841B354
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213760; cv=none; b=sCX9tx7wVIb5A+p0vG3RrViqaofUpVQtkaZ9o9+Jw69ewyh6Pb6xBMGpheOm0Y0vr80B8esJMHO3a+hmHOdeQFOFucBM8eEy9Vu2G0/dM9PyKSoTmIylmTU32aCJCQUuJ0Ct+ZuXbQeoOe9I65wgrQuAzdEixS6J4Z8GCUPKSDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213760; c=relaxed/simple;
	bh=lCLdoytTOUGx1v7oqdqnfZTxyA3BlMBH34J8iPYWMjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLmudih8jq2RgqTO5m0PIzTtRhKMAAC+s9sl5o8V20tFfHkuDyrux1PiHp9+CkDPsvypZrv+r9gZR6hftPXfy3RTvHgsV3ld8CPIhhhYYk2eYqL+RiF6E1jhGk77tkz68XlyFE4kycK9wltf0MtLEh+Eo7oF1cdZVIod4IqhdTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KZ0Xph6o; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=q8IWVJRw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KZ0Xph6o; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=q8IWVJRw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KZ0Xph6o";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q8IWVJRw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KZ0Xph6o";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q8IWVJRw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 06686789CE;
	Thu, 16 Jul 2026 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=KZ0Xph6oYqfiDzvJLHHNfzTbMlMSZMuMG8uEealyj9uRdf71ROj+G5r3A/6frxRbjz+y5M
	WXaLAFBFvIXOF2ORujOrxOuvdp5vwDp01e7Y2tKtgxYEoWHcyn07v7XxVsmG9drfr929nv
	AdO6ubk3Bg6IzPlpwnurRNfaBP/BPkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=q8IWVJRw9UMMFEIGxN0I9Vl68Aw8l9vQz0LKsU9UPfoB9or/8aR33eoVnWEirpm5QDKJq+
	5ZMbsNUn+4N1tIDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=KZ0Xph6oYqfiDzvJLHHNfzTbMlMSZMuMG8uEealyj9uRdf71ROj+G5r3A/6frxRbjz+y5M
	WXaLAFBFvIXOF2ORujOrxOuvdp5vwDp01e7Y2tKtgxYEoWHcyn07v7XxVsmG9drfr929nv
	AdO6ubk3Bg6IzPlpwnurRNfaBP/BPkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hh/T6RKIqi39FLo5IcT+l+smt+dxsJh0xD8E76s0EIM=;
	b=q8IWVJRw9UMMFEIGxN0I9Vl68Aw8l9vQz0LKsU9UPfoB9or/8aR33eoVnWEirpm5QDKJq+
	5ZMbsNUn+4N1tIDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0F58779AD;
	Thu, 16 Jul 2026 14:55:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AuHrNvzwWGrgXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:55:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5E5BDA08E2; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 02/21] fs: Fix possible UAF in mark_buffer_write_io_error()
Date: Thu, 16 Jul 2026 16:55:24 +0200
Message-ID: <20260716145527.3580300-23-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1576; i=jack@suse.cz; h=from:subject; bh=lCLdoytTOUGx1v7oqdqnfZTxyA3BlMBH34J8iPYWMjM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDgErioIRacwcJcg4nXKac0E4sPK8sy4vXCP ek16dHgma+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw4AAKCRCcnaoHP2RA 2UFECACj9hoOzous511NO38Tqm+VhYgm198L9cIcvG/VkGHXDHuH6TihxU0r//pa8l0h1B/zEyx 8c79vACLfRVtSQ8La1vtDRsw8nE1LEbH7QvfyzaiyhMo/ZR3mvDaEJjX6Iw/DptWm4uLx2Fb8j3 mcmu/Gs6DDliSVTqbngGNr2AjcsrGoxpwcdDcw7XH+Snwt22KE1qIdj+gpM3jU6bRE3GGiwfcZ2 iNbOu2P6QRZdTOSm/y8wahNauLe1utxTokqmsANwXcpzut2UEhTWCfN+5qgj8r0FOZfpqP4MLgH oO+FhC/s3GC53jzh1R+8qgOVmMMnnufXAlJdBD1RzBdU+vgk
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -5.30

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


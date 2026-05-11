Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797E337B027
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501653; cv=none; b=Zau4EmY71y9cZ6boF58YTM8v1G7sjQ2/tfc/D8PiizB1H4oeC+jY0ca+5atwpvskVWYz64hDxdsQt0mQZAR9q39qhk6ho+4KuSQa6SAnQmgJ5Pn8Ziw8v5/KeaWskXuuRRp6IM2I5jSW0egP86GhkWhQNKWkBvddNz9BTRhgesM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501653; c=relaxed/simple;
	bh=cdlKdknbXyyJ9sHOEahaH++v8c8jc1GPV/g1a8cLwaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A9FQsD7B59/Qe/yoFOlCOSBmG6bOrt+5+zK07a0t2w/Jz/ina60U2jHaQzQmKdXEsuaRHo6Mwt+qYLb0UEpp5lJL5DurHdf4RHE0PlmKstppSs6drbb9s94Qj20zzPWzxgOOw6hlMfdem+Rt6fu7eABgS9u9aghtrSl7eM1mkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k20++z2q; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HEqnYZ3G; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k20++z2q; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HEqnYZ3G; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k20++z2q";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HEqnYZ3G";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k20++z2q";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HEqnYZ3G"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D14E85C3DC;
	Mon, 11 May 2026 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=W2JvIFC4KxRA/Wbb6l4Tk0ewNrHAwglo/N8hCwt7/5o=;
	b=k20++z2qDQUA9YVM4pDGR4bnonORDHtpw8Wy8cjJgkUtwiIm0+vQ81XnSd7FciPZRULmtO
	3/KFQfTLrC9MxRzZ6+zN30BQ+5t3xoUfkuwW4TIgxBfaJNdKAOHKB6HquG4SRc12guBZP3
	r9+pvy3o4pTCgxbVYk/NdbQRPTHdjak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501650;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=W2JvIFC4KxRA/Wbb6l4Tk0ewNrHAwglo/N8hCwt7/5o=;
	b=HEqnYZ3GPwk4rt5AsULw1RTFraI6EkWnTN6Xv7CRwPlOFAnbL48eKBcZo8RDJy+jdrKMen
	9rlHOwsDIbuzoPAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k20++z2q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HEqnYZ3G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=W2JvIFC4KxRA/Wbb6l4Tk0ewNrHAwglo/N8hCwt7/5o=;
	b=k20++z2qDQUA9YVM4pDGR4bnonORDHtpw8Wy8cjJgkUtwiIm0+vQ81XnSd7FciPZRULmtO
	3/KFQfTLrC9MxRzZ6+zN30BQ+5t3xoUfkuwW4TIgxBfaJNdKAOHKB6HquG4SRc12guBZP3
	r9+pvy3o4pTCgxbVYk/NdbQRPTHdjak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501650;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=W2JvIFC4KxRA/Wbb6l4Tk0ewNrHAwglo/N8hCwt7/5o=;
	b=HEqnYZ3GPwk4rt5AsULw1RTFraI6EkWnTN6Xv7CRwPlOFAnbL48eKBcZo8RDJy+jdrKMen
	9rlHOwsDIbuzoPAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3950593A3;
	Mon, 11 May 2026 12:14:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KRi9LxLIAWrFWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6BE71A079E; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/9] fs: Fix missed inode write during fsync
Date: Mon, 11 May 2026 14:13:50 +0200
Message-ID: <20260511115725.28441-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=957; i=jack@suse.cz; h=from:subject:message-id; bh=cdlKdknbXyyJ9sHOEahaH++v8c8jc1GPV/g1a8cLwaQ=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGLIYj/9dlftVznpd6KvNDaxuKSK6/F/cUte4di5x8zD4v j9Ztzahk9GYhYGRg0FWTJFldeRF7WvzjLq2hmrIwAxiZQKZwsDFKQAT6bnNwXB/wuynvlcWd26q brlbadX5qjdOkEG1RjHjSPMs/tq5q/7N7Nvz2ud85lWvdLdMpeZpUzOjiu1Y1JaHqt7TrNf1n3E sMKSW+1zCHyEZ7ufSLu9rGXvzPN0qNR7peCh6JmeWz/+n7e//niPxl+V5W7UjfG0OBc9CV884/z K6+/+v7NtayXqBopuLWZcp+DNH5v7usreq2lk5QZCzJlD36p/4GZe/3XTXn7t89v/3BydtNXmSf +7C9d0O68s+/PWav0YxiLlcQ42P/aDowpl8F7colbywnu8TMlMyL8f9NDOfScuCE3lVRYmbGfMn 6BVUXEp4X+skzb1u7f4skS+brBtZSp+kTvAJ/SLMW3wYAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mail.parknet.co.jp,mit.edu,vger.kernel.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: D14E85C3DC
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -1.51

Hello,

this patch series fixes the possibly missing inode write during fsync(2) for
filesystems using generic metadata bh tracking. The inherent problem is that
.write_inode methods clear inode dirty bit but they only copy inode contents
into to the buffer cache. Because buffer carrying the inode is shared among
multiple inodes, it cannot be tracked by the generic metadata bh tracking
infrastructure and thus nothing is tracking that buffer needs to be written
out to maintain fsync(2) guarantees. Normally, this gets taken care of
by .write_inode checking for WB_SYNC_ALL writeback and submitting & waiting
for the buffer in that case however if flush worker ends up writing the
inode before data integrity writeback, this mechanism is broken.

This patch series adds a way for filesystems to track metadata block number
which contains the inode metadata and then uses this information to writeout
the buffer on fsync.

								Honza

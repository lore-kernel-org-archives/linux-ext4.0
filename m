Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA313DC4C0
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699516; cv=none; b=k/jRBHBAV1wgPbwxfUL2gJS7q3fnBwR1CtfqO0QS0g3yiB5KLZ+vqvn0ONLcXyX12PaY1bKWdsuAy8aOnbrNb1nGdbD2ZX2wnFtGK3+ku7aXqA0D/gccq1v3k1WjpFwd7E8AVkUs6b5NEfAkDhHYSy1d06IL4bLhjpUGe/xe3zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699516; c=relaxed/simple;
	bh=eOH9HYQ9D2wKBiHdEEpRTmbINzQudTT+RIg4zVR5aYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uCUWKktBrysnmBIE5gp6h2bAFw0a6XX9tYfDtWkTfUsW5YbBZl7h3+Xb39C2zppzf/Eqx8/DMGTqd0yxchmcWz7ndMWBJstia1cT54rvmx2araBqO/focMoAxCRoAjaDmw7l0RJCHFP4HPbdD47B+LOAF+Lk80u4b5hSfmQznHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pWWGiM92; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OLI1Tznb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pWWGiM92; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OLI1Tznb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pWWGiM92";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OLI1Tznb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pWWGiM92";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OLI1Tznb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 261F0676FC;
	Mon, 25 May 2026 08:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779699513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XPrJ9Sd7gZb2mtSao4OrXvb42ro/IoJ+Rsc61Ogkt9A=;
	b=pWWGiM92CXwRgEq1ichhzWNd4BTZHMe5LC8Cmbw3JunVrIuAoJb1mGF/xODUY/3HTodscO
	UVFOF+fE+9Hi7b43Fx2uUqC4UVY2POXeNLKrRmQhApQf5e+pW6eeLCAgZM6IgOxG3wDjO3
	6mxBXiddvIfPtPqMk8DshpkQHhsV4jY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779699513;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XPrJ9Sd7gZb2mtSao4OrXvb42ro/IoJ+Rsc61Ogkt9A=;
	b=OLI1TznbAonoXMDQhnfTpiYkXBRHDKsX72mH+5xmPg/h0XMSO0Np1MhakkhL8IEGgu9iR1
	DfdnuMrNsQUtbPBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779699513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XPrJ9Sd7gZb2mtSao4OrXvb42ro/IoJ+Rsc61Ogkt9A=;
	b=pWWGiM92CXwRgEq1ichhzWNd4BTZHMe5LC8Cmbw3JunVrIuAoJb1mGF/xODUY/3HTodscO
	UVFOF+fE+9Hi7b43Fx2uUqC4UVY2POXeNLKrRmQhApQf5e+pW6eeLCAgZM6IgOxG3wDjO3
	6mxBXiddvIfPtPqMk8DshpkQHhsV4jY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779699513;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XPrJ9Sd7gZb2mtSao4OrXvb42ro/IoJ+Rsc61Ogkt9A=;
	b=OLI1TznbAonoXMDQhnfTpiYkXBRHDKsX72mH+5xmPg/h0XMSO0Np1MhakkhL8IEGgu9iR1
	DfdnuMrNsQUtbPBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E16C59B6E;
	Mon, 25 May 2026 08:58:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uGdSBzkPFGq0bQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ADD71A08E5; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 0/10] fs: Fix missed inode write during fsync
Date: Mon, 25 May 2026 10:58:06 +0200
Message-ID: <20260525085035.12891-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1383; i=jack@suse.cz; h=from:subject:message-id; bh=eOH9HYQ9D2wKBiHdEEpRTmbINzQudTT+RIg4zVR5aYw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqFA8dqapJ4AqPyFHi6edSSe0SFt+uBWRRF6DOO JUtenDChMWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCahQPHQAKCRCcnaoHP2RA 2Yd9CAChksKnov7zO+/4hyXl9obUrjHoHt7Lq+u4nkS2FIO68yNL2IWd+pn5i/CNdIVFauMC0nj hZ5BW0x+pqsWiU+jkSkErs19f6kAVxB2w1ngYrNvvRzgnkVmRMe+/q/X/UiGJ0oC4YTJlEBiiFz h0jdwP6JIUmjcILSM70vEirC8JBP3PoM5SKwEH5qf0fA7d7GCe4rTQ9g5zh0nqkMhitp/AkQQQL uuHmgXgSyEZPHpbBL0I+q7n/Dr54NIErltsa2iG8sLKiLiQ3k2j5Qi+5FczwpG7Ypfy94IcdPoV oKquSHu+TKyAgDugobjz4ElFnbJXMlfkl4ekT6F601HzAatP
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

Hello,

here is v2 of the patch series which fixes the possibly missing inode write
during fsync(2) for filesystems using generic metadata bh tracking. The
inherent problem is that .write_inode methods clear inode dirty bit but they
only copy inode contents into to the buffer cache. Because buffer carrying the
inode is shared among multiple inodes, it cannot be tracked by the generic
metadata bh tracking infrastructure and thus nothing is tracking that buffer
needs to be written out to maintain fsync(2) guarantees. Normally, this gets
taken care of by .write_inode checking for WB_SYNC_ALL writeback and submitting
& waiting for the buffer in that case however if flush worker ends up writing
the inode before data integrity writeback, this mechanism is broken.

This patch series adds a way for filesystems to track metadata block number
which contains the inode metadata and then uses this information to writeout
the buffer on fsync.

Changes since v1:
* Fixed freeing for ext4 dynamically allocated mmb struct
* Optimized tracking of block carrying the inode so that we don't flush it
  unnecessarily on fsync
* Add forgotten check for reclaimed bh to mmb_sync() to avoid NULL ptr deref
* Couple other smaller fixups pointed out by Sashiko

								Honza
Previous versions:
Link: http://lore.kernel.org/r/20260511115725.28441-1-jack@suse.cz # v1

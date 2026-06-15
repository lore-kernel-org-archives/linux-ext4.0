Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B373FC5BE
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781535066; cv=none; b=lMRlaiszdbQ5RjJQox0/EQM8uj5mgLp5sHCwCEHKQuohXlBFLrRuTBrvgFCGNrCyg0COGpS/fy6bXMFikbC7wz9hrx8gBrAgkVE1esUAwYZOpBaIYH0g+8qrOX0dND/+ZgOhtyPsQvi+zx6iE4awM9IH4PAa7dRAA1PABFFpdpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781535066; c=relaxed/simple;
	bh=IPTkm+YhpY6UMCKnO6ZrtfLxAIN8rKAY5iR9c6tPHP8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qnehlL16YOv5B9hWGSNAl3EVyEdglZW3h822W9czQaOgRXj1ljsdT2x7M97vOCXCaoU4BZ0b3MsitqSfqCCazmy6N9VIO8tXLzvCxwxHq36xCVAAPkaTvAxYBiSyhJEByH+ysFEXrWGO78W5mm5r1kUzv/elsAbVg3V3K73mN4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L0/OzoHr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oojR1LlQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L0/OzoHr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oojR1LlQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L0/OzoHr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oojR1LlQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L0/OzoHr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oojR1LlQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D36506AE07;
	Mon, 15 Jun 2026 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781535061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=u5pX+4kXpIEH1Es58vNjLIJ94ivgk1qs0Tq+l5JnFxQ=;
	b=L0/OzoHro6AP4ts1f+laSQnBfylKtvmV9+Nd9MfyD1wS8XoVuHKUMU3EYzXx6jC1XMsDi5
	cViHQ1e6I+z3icvpez54lXd0vE3BG5CjY4gKDaEwLzmzUyGS1r4SOwd/MY7Bb9EdqPXhKm
	AhjDOqwhiBXP4CaiSVXFZ6ShddlYENI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781535061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=u5pX+4kXpIEH1Es58vNjLIJ94ivgk1qs0Tq+l5JnFxQ=;
	b=oojR1LlQDA4YOtR5icsFRqMD8KuQ7v+gTY683Px7prsku8U1vVzKGecj5SPAQ1nTGjxx2N
	byGSFsQbyQUmT6CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="L0/OzoHr";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oojR1LlQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781535061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=u5pX+4kXpIEH1Es58vNjLIJ94ivgk1qs0Tq+l5JnFxQ=;
	b=L0/OzoHro6AP4ts1f+laSQnBfylKtvmV9+Nd9MfyD1wS8XoVuHKUMU3EYzXx6jC1XMsDi5
	cViHQ1e6I+z3icvpez54lXd0vE3BG5CjY4gKDaEwLzmzUyGS1r4SOwd/MY7Bb9EdqPXhKm
	AhjDOqwhiBXP4CaiSVXFZ6ShddlYENI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781535061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=u5pX+4kXpIEH1Es58vNjLIJ94ivgk1qs0Tq+l5JnFxQ=;
	b=oojR1LlQDA4YOtR5icsFRqMD8KuQ7v+gTY683Px7prsku8U1vVzKGecj5SPAQ1nTGjxx2N
	byGSFsQbyQUmT6CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBEF5779A7;
	Mon, 15 Jun 2026 14:51:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EJ6+MVURMGrmBAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Jun 2026 14:51:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6E233A12D2; Mon, 15 Jun 2026 16:51:01 +0200 (CEST)
Date: Mon, 15 Jun 2026 16:51:01 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] udf, isofs, ext2, quota fixes and cleanups for 7.2-rc1
Message-ID: <jpb2wjkfh7j73dpinuvwe5qddkr54px64vmvx6bclzd5ter6hk@mjwwwgohsyxy>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D36506AE07
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs_for_v7.2-rc1

to get:
  * Assorted udf & isofs fixes for maliciously formatted devices
  * Cleanups to use kmalloc() instead of __get_free_page()
  * Removal of deprecated DAX code from ext2

Top of the tree is 5163e6ee1ea7. The full shortlog is:

Ashwin Gundarapu (1):
      ext2: Remove deprecated DAX support

Bryam Vargas (3):
      isofs: bound Rock Ridge symlink components to the SL record
      udf: validate sparing table length as an entry count, not a byte count
      udf: validate VAT header length against the VAT inode size

Danila Chernetsov (1):
      ext2: fix ignored return value of generic_write_sync()

Jan Kara (1):
      udf: validate VAT inode size for old VAT format

Michael Bommarito (1):
      udf: validate free block extents against the partition length

Mike Rapoport (Microsoft) (2):
      quota: allocate dquot_hash with kmalloc()
      isofs: replace __get_free_page() with kmalloc()

The diffstat is

 fs/ext2/ext2.h   |   4 --
 fs/ext2/file.c   | 125 ++++---------------------------------------------------
 fs/ext2/inode.c  |  60 ++------------------------
 fs/ext2/super.c  |  39 ++---------------
 fs/isofs/dir.c   |   5 ++-
 fs/isofs/rock.c  |  11 +++++
 fs/quota/dquot.c |  11 +++--
 fs/udf/balloc.c  |   5 ++-
 fs/udf/super.c   |  16 ++++++-
 9 files changed, 51 insertions(+), 225 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

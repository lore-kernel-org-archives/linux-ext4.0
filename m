Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3452737F2
	for <linux-ext4@vger.kernel.org>; Mon, 16 Feb 2026 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260549; cv=none; b=H377dZGsBDEQT6Oo9KO0p5T3T6Fr5jHF+Tvg9/+2rm6F/Sk8Zzv/sWR09p1vYjwAoA388wLQk+omv/CU88ZZ/gPPmphr+VxLpKZg+cRP2kNMMXd9fIOBhhtxc0lYmk2GSnYYk1s/fY/pIyn2HpBP/ogEaAj2gTg3l+6GvIclgBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260549; c=relaxed/simple;
	bh=J81vvpePiouR4wnUUOhKh6muKUvfh0tf/k1sbUoiWYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=upA0f+J42e96RmyVcRxBfJYZCWJig040OvE4ccjF/XoL7pL5b70YSE3Sjd5JhwMeq547040ndJcuzc1ojijZP6WU/JO/hPu6S7wDCUwonRw2OcECjw4oI7c0YbRO/3pSJ0CPEgttVeD3cyh2TnokL82ysOksbdLqy9xHiPM2JUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2JAsqlqt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nI1KlkcP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2JAsqlqt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nI1KlkcP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2JAsqlqt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nI1KlkcP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2JAsqlqt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nI1KlkcP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 31E9E3E6C2;
	Mon, 16 Feb 2026 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771260546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=O/J/MHUoaxjRqQPm4wQSHi/NlttFeGLOB4ihT6H+/ao=;
	b=2JAsqlqtG7zjxM/oVZGb4xUUx12yJZsbHhFmLxiql9SAh1/I4zacqnDfOqZYGpZgvKdKk5
	gVPx2wo+LBZzhQ2+2mUCF4OAhVrTXDNAHNyBK1T47aRets4G+GASvEY6bFNhtgblYN2KJn
	P1aHo50CMve/Zpd4lfuEonnkZwKwetI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771260546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=O/J/MHUoaxjRqQPm4wQSHi/NlttFeGLOB4ihT6H+/ao=;
	b=nI1KlkcPjMX7v8Ymvykt8lb9ClGkCkxah5aUp8/9jlvflVBkWc9R1v6ir0m6oF/BdyDh/A
	5hFJfJvsPCXd30Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771260546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=O/J/MHUoaxjRqQPm4wQSHi/NlttFeGLOB4ihT6H+/ao=;
	b=2JAsqlqtG7zjxM/oVZGb4xUUx12yJZsbHhFmLxiql9SAh1/I4zacqnDfOqZYGpZgvKdKk5
	gVPx2wo+LBZzhQ2+2mUCF4OAhVrTXDNAHNyBK1T47aRets4G+GASvEY6bFNhtgblYN2KJn
	P1aHo50CMve/Zpd4lfuEonnkZwKwetI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771260546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=O/J/MHUoaxjRqQPm4wQSHi/NlttFeGLOB4ihT6H+/ao=;
	b=nI1KlkcPjMX7v8Ymvykt8lb9ClGkCkxah5aUp8/9jlvflVBkWc9R1v6ir0m6oF/BdyDh/A
	5hFJfJvsPCXd30Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D411F3EA62;
	Mon, 16 Feb 2026 16:49:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 23f1GYBKk2n2OwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Feb 2026 16:49:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8FB6CA0AA5; Mon, 16 Feb 2026 17:48:53 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
	Free Ekanayaka <free.ekanayaka@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] ext4: nojournal mode fixes
Date: Mon, 16 Feb 2026 17:48:42 +0100
Message-ID: <20260211140209.30337-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=570; i=jack@suse.cz; h=from:subject:message-id; bh=J81vvpePiouR4wnUUOhKh6muKUvfh0tf/k1sbUoiWYw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpk0pp9rKOLwoVKn1y258DhosCooTCSLvNA9mLe D31N9DZIySJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaZNKaQAKCRCcnaoHP2RA 2YxJCACpkou6ezppHldxmcpVeaqBzTTFKUf31AzK0NIw8h0FDgkciAXMwmVti9J6zaYle9iW7P4 h7XKM1MTPwcf39foKGQqyU2hcsSt1DPaWblmDbDtULvmy1oE/KlS0d9sl4ehvMJzinA3sTXhGvn Ych2bTACgYfikxPJf2PHLscCf5onhEnj/8ZMoALGC8/1tEW9TFRnylTBszdCnCt3LaNQW9X+q1U oaLFNxXGkdK9ndzJLaRcintTZDHw0Vbn0Yt1r05jXUK4a22exsM/xpTKXL9kWTrdFgi0mUxnRlr OBjx5RY5D0O8gdFxa3/DTgAIzUY5cIeWqPeSesOTePHbob28
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,suse.cz];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Flag: NO

Hello,

here are two ext4 fixes for nojournal mode. The first fix is fixing handling of
uninitialized inodes in recently_deleted() used in nojournal mode which was
leading to occasional fstests failures for me (which became much more likely
after the second patch due to timing changes). The second patch fixes a bug in
ext4_fsync() which was not properly writing out inode metadata in nojournal
mode. It is kind of a band aid but proper solution is going to be rather
intrusive and practically unbackportable so I think having it is worth it.

								Honza

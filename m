Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3043A0E88
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016483; cv=none; b=qD5ZHu0fHZjpm0gVpqQlYtM+KtzVo7u/mKQsIyhFM51FRiddU4sGu6nBBFzzZsCYVqLbIl+yLQTgNUZwsmDXNb0twGDVKRoD8ADzwFG77kRDsb4/PwjA1LiRxbFkpj7SRWkc0Ig63Ch24yftiBzFmbtbPHejCreYjpiRJ5EFRh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016483; c=relaxed/simple;
	bh=bcae+uK1f7aJaXp+aKix6aNJL9CoKrqLm/2b4knqnmk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WvBfqCUGU5LWUO7fHdWIMjBiCiECDG5N9tbvEoRcWinbsMpJX2X49QuB6SY1+oic3Wqm69PO56TFz+h02dg5tYkIKcxhDXUoeMsOPQOaUdDxEy5uU63BrdlCgw3IqwsvL+OivbBh4uD+1i1cMko5VFzXHlLRHeC9lNtYSuPqK90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ca2l3BnK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WzxQOgBg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ca2l3BnK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WzxQOgBg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ca2l3BnK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WzxQOgBg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ca2l3BnK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WzxQOgBg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8B9D2760DE;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D5dAfBU+HbTieKsHQWQmHmGKPwSaABc00K0kn7eNKzg=;
	b=ca2l3BnK7pM+5AHjeqk/nYEJNJTF0vwC2w/m/Df7obZjMDXi1BYTVGE30No7zT1p3iwAs1
	0BoUS5we6Z/YaoiUNpz+/ZQCorCkHuiPbfNndm1lHT6Shb2HSwcqnz/jmjCFo+gdzbrThX
	1+XgG1n0PXF5N5roQyMk98c0xQIKYqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D5dAfBU+HbTieKsHQWQmHmGKPwSaABc00K0kn7eNKzg=;
	b=WzxQOgBgeI2/e+0Aa5Cctlu2wqDPmWLQpFkPrJE6qDnVaY6+t7ApqCCvfxEE9WsXAumNxq
	YEqqqQRPdvhTK/Bg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D5dAfBU+HbTieKsHQWQmHmGKPwSaABc00K0kn7eNKzg=;
	b=ca2l3BnK7pM+5AHjeqk/nYEJNJTF0vwC2w/m/Df7obZjMDXi1BYTVGE30No7zT1p3iwAs1
	0BoUS5we6Z/YaoiUNpz+/ZQCorCkHuiPbfNndm1lHT6Shb2HSwcqnz/jmjCFo+gdzbrThX
	1+XgG1n0PXF5N5roQyMk98c0xQIKYqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=D5dAfBU+HbTieKsHQWQmHmGKPwSaABc00K0kn7eNKzg=;
	b=WzxQOgBgeI2/e+0Aa5Cctlu2wqDPmWLQpFkPrJE6qDnVaY6+t7ApqCCvfxEE9WsXAumNxq
	YEqqqQRPdvhTK/Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 813BC779AA;
	Thu,  2 Jul 2026 18:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gM2HHyCsRmrkFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 061DAA0AE1; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 0/19] fs: Fix missed inode write during fsync
Date: Thu,  2 Jul 2026 20:20:57 +0200
Message-ID: <20260702175436.12226-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2638; i=jack@suse.cz; h=from:subject:message-id; bh=bcae+uK1f7aJaXp+aKix6aNJL9CoKrqLm/2b4knqnmk=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGLLc1nA0L11TxcM67fQclnxJm52FuyY9Us3qOLue50NGo HPFUXX5TkZjFgZGDgZZMUWW1ZEXta/NM+raGqohAzOIlQlkCgMXpwBM5D0/+39Hmys6lnqPt+ls D0jx55/nWyMawXV4Cd9Zd7O/H88n3zrPGiHXtSBNi73b9/nDLYybQ/U9/UQvKJQe2NiuYaKtrzx Pi/OEZ2OCQ2z0rjbROpk1IQx9uvr586s9v5y5nfRkRkev3eGMHUr8edMPRs08a32h/HO2Xdi73m VqV5jXnOG8xcl2NSYj7IVOkOXKTyflvXJPPxCRjuL+0Kps8mpOgrjb26QdrhO4TcKnPtLiarEu2 ijoJdB+JEevfJnhxLykvGS+gyf+b8u1jFCPNhaJ1LW3mvfGb5NbVx8f35Vsnan8fyUjP1zMWLtn piuX0Zd9L8xd/x18ONnk7K76V7IK+299dmaRiFjEtWQ2AA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Hello,

here is v3 of the patch series which fixes the possibly missing inode write
during fsync(2) for filesystems using generic metadata bh tracking. This is
a heavily reworked version since v2 mostly based on problems Sashiko found
which prompted me to redesign the whole approach.

The series now strives to make sure sync_inode_metadata() ->
writeback_single_inode() will end up to properly persisting not only the inode
but also all metadata associated with the inode. This is beneficial for several
reasons:

1) This removes the need for separate mmb_fsync() implementations. Filesystems
can just use simple_fsync().

2) This makes sure all metadata is written for IS_SYNC / IS_DIRSYNC inodes.
Currently most filesystems just write inode itself.

3) This fixes races when multiple fsyncs race for a while where mmb_sync()
could return before all buffers were really persisted (now I_SYNC state flag
properly serializes everything).

To be able to achieve this we add new .sync_inode_metadata superblock operation
which gets called from __writeback_single_inode() and new I_METADATA_WRITEBACK
state flag (putting everything into .write_inode is possible but it looked too
ugly so I've decided for the new operation).

This scheme with I_METADATA_WRITEBACK state flag also fixes the problem that
when WB_SYNC_NONE writeback happened between write(2) and fsync(2), fsync(2)
would fail to properly persist the inode. Note that this problem isn't specific
to filesystems using the generic metadata bh tracking. This patch set doesn't
fix such filesystems as it is already big enough but the universality of this
problem among simple filesystems is another reason why I've chosen the new
superblock operation instead of trying to somehow hack up metadata bh tracking
infrastructure.

Patches passed some basic testing with fstests, more tests are still running
but I guess the patch set is good enough for people to have a look.

Changes since v2:
* redesigned the patch set to use new superblock operation
* fixed race of inode freeing with IO error processing in
  mark_buffer_write_io_error() 

Changes since v1:
* Fixed freeing for ext4 dynamically allocated mmb struct
* Optimized tracking of block carrying the inode so that we don't flush it
  unnecessarily on fsync
* Add forgotten check for reclaimed bh to mmb_sync() to avoid NULL ptr deref
* Couple other smaller fixups pointed out by Sashiko

								Honza
Previous versions:
Link: http://lore.kernel.org/r/20260511115725.28441-1-jack@suse.cz # v1
Link: http://lore.kernel.org/r/20260525085035.12891-1-jack@suse.cz # v2

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503DF376493
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 09:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773997497; cv=none; b=ROBZhA1lQbc9lWbgTJMcywhShlz0syk3Ac53ZKlCkcGdv3WdroRlVm7530lQv9Z3yi82Uo95KkXk0q6E9rRj2JXIFXByImcmNORyTTts/UMyTxaYlwKo883THx8u8XFToTqx5Wq5nwgxZ2r2aFNakwwL8pWuwV/oS9GU0hHsKPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773997497; c=relaxed/simple;
	bh=oPjLQnoGXFqSRaJelVbBh0puTVgXFDpTz2rE66XORh0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FAtaNNTA22dLLUBcOqQaaYQgnLgRa4Xp9HpaE1h14yqCQnqoNdyx15QeOle6DmesYOAdV99bQI6CpBdyYx1eTr7yyYqTaUvq/GsagoA+3ZAtzPF+cuJIdw/terq48Nw3FaOpdFdSr6ZPus81FyhYNfrNRiaZeoOX8iV/2C8vmDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F4WP61Ub; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kCcOYlWs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F4WP61Ub; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kCcOYlWs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F4WP61Ub";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kCcOYlWs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F4WP61Ub";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kCcOYlWs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 379314D22F;
	Fri, 20 Mar 2026 09:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773997493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lDuHUjaYVat/cTx5x8pECdzs5D3NYqubZeNbkRfxlfs=;
	b=F4WP61UbB1LeL+U2hvGXg4l0BgJv/r+v7S4S5SMHg3IK2lM7Am8lSgQm2chWbKj4kRvWqo
	d3h/BelgmlT84hiaPiPYgaHC+wdylJjL4uDm9BSTPysh3WCZc0aCLovdwbD2HisxjvQozS
	MMXJeilNosvo/Bs4YjMmi04sjOw2wgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773997493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lDuHUjaYVat/cTx5x8pECdzs5D3NYqubZeNbkRfxlfs=;
	b=kCcOYlWsoeqnwzQ3QeFg37nI6l3oPBdV+IaxLiTKq5BDcyDObe1BzAop8PbOdZ/kqn94xQ
	HyjaZD4AcARaDpBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773997493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lDuHUjaYVat/cTx5x8pECdzs5D3NYqubZeNbkRfxlfs=;
	b=F4WP61UbB1LeL+U2hvGXg4l0BgJv/r+v7S4S5SMHg3IK2lM7Am8lSgQm2chWbKj4kRvWqo
	d3h/BelgmlT84hiaPiPYgaHC+wdylJjL4uDm9BSTPysh3WCZc0aCLovdwbD2HisxjvQozS
	MMXJeilNosvo/Bs4YjMmi04sjOw2wgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773997493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lDuHUjaYVat/cTx5x8pECdzs5D3NYqubZeNbkRfxlfs=;
	b=kCcOYlWsoeqnwzQ3QeFg37nI6l3oPBdV+IaxLiTKq5BDcyDObe1BzAop8PbOdZ/kqn94xQ
	HyjaZD4AcARaDpBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2EB604273B;
	Fri, 20 Mar 2026 09:04:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mXpfC7UNvWkqZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 09:04:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DC024A0AFD; Fri, 20 Mar 2026 10:04:52 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
	yi1.lai@linux.intel.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
Subject: [PATCH] ext4: Fix deadlock on inode reallocation
Date: Fri, 20 Mar 2026 10:04:29 +0100
Message-ID: <20260320090428.24899-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2943; i=jack@suse.cz; h=from:subject; bh=oPjLQnoGXFqSRaJelVbBh0puTVgXFDpTz2rE66XORh0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvQ2c6EClVse9vuF6gUxwj7HB89CaK74gIvlhX 2/9rSBWmEeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab0NnAAKCRCcnaoHP2RA 2d3GB/0WqFZat6MA7FFMHyohYCEsnqY20qfsxoq40Iiy9msQ1Ur4GLNnpQ7C6jBPi8EHyCAoJN2 6M0nhtRKePkIqbnuXLNdfNPb0Tak3fo6bRMEuYbu9jF5p40So1uDCPyMu+YPj5SJBJZp5fsdF+r miGD/jbUdYljlKuuj7QyLtLWO9HUaXofMbCBYFzvUrUgSHXAzlPmGyWq28kEx+5vG9Ta5wTfFCN FkQYAmCLzFnKcqYMuFxSm8KMsQQMtvwUcy755IoDmwl5IDZn4RI7Np6Pxqpevm+CZ5qAIrG+Qsj YgP7MkE9Ps9sz7DVse9PQIeZbYnOCE3kWd236d6lcCEbuw+b
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,linux.intel.com,gmail.com,suse.cz];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Currently there is a race in ext4 when reallocating freed inode
resulting in a deadlock:

Task1					Task2
ext4_evict_inode()
  handle = ext4_journal_start();
  ...
  if (IS_SYNC(inode))
    handle->h_sync = 1;
  ext4_free_inode()
					ext4_new_inode()
					  handle = ext4_journal_start()
					  finds the bit in inode bitmap
					    already clear
					  insert_inode_locked()
					    waits for inode to be
					      removed from the hash.
  ext4_journal_stop(handle)
    jbd2_journal_stop(handle)
      jbd2_log_wait_commit(journal, tid);
        - deadlocks waiting for transaction handle Task2 holds

Fix the problem by removing inode from the hash already in
ext4_clear_inode() by which time all IO for the inode is done so reuse
is already fine but we are still before possibly blocking on transaction
commit.

Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Link: https://lore.kernel.org/all/abNvb2PcrKj1FBeC@ly-workstation
Fixes: 88ec797c4680 ("fs: make insert_inode_locked() wait for inode destruction")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Ted, this is a regression recently introduced by VFS changes in
insert_inode_locked() but I think it's best fixed in ext4. If you agree, it
would be nice to merge this so that it makes it to 7.0 release. Thanks!

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f680c750ae..b8122d24c083 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1527,6 +1527,27 @@ void ext4_clear_inode(struct inode *inode)
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
+	/*
+	 * We must remove the inode from the hash before ext4_free_inode()
+	 * clears the bit in inode bitmap as otherwise another process reusing
+	 * the inode will block in insert_inode_hash() waiting for inode
+	 * eviction to complete while holding transaction handle open, but
+	 * ext4_evict_inode() still running for that inode could block waiting
+	 * for transaction commit if the inode is marked as IS_SYNC => deadlock.
+	 *
+	 * Removing the inode from the hash here is safe. There are two cases
+	 * to consider:
+	 * 1) The inode still has references to it (i_nlink > 0). In that case
+	 * we are keeping the inode and once we remove the inode from the hash,
+	 * iget() can create the new inode structure for the same inode number
+	 * and we are fine with that as all IO on behalf of the inode is
+	 * finished.
+	 * 2) We are deleting the inode (i_nlink == 0). In that case inode
+	 * number cannot be reused until ext4_free_inode() clears the bit in
+	 * the inode bitmap, at which point all IO is done and reuse is fine
+	 * again.
+	 */
+	remove_inode_hash(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
 	dquot_drop(inode);
 	if (EXT4_I(inode)->jinode) {
-- 
2.51.0


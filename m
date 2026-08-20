Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB9042AF8C
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2026 11:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787225161; cv=none; b=R8VVmWrsbwafKB8Xoy0El2T7oyiQgj1ry7XiZfgboH2Lf98uw7/59Ls26wvPXYsSKSukr+0Bdz+kK/jbCnKoTc1jK03WMmFy32YRvSt8cCeuSGDkakB46Rv1l8qXWLKpvWvLxoJsDCtO+lhiAf9/aOxst5c4940fCeZoMDBTreU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787225161; c=relaxed/simple;
	bh=w1UiliAxmgXInJ7h1KXuptV80qojag0d4J3kJR0Ga64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eqr1qPTq74fksrqpvKshNKVbe4N+qivBxb85NwgYoed1qLowmj6lfKS/a+3v/QzuDaMXgOH+RH6oZhZsFR7IGMNI6UJfexu4qYjZmktYJwVI1WWkoChBpV95bULQwkn0SPjFITsMz0vN8PqiMUez1v9q9kVwcemuMY96Kd6HfK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qQekQNzg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UWoQvdfa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JfsFf8+X; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=25ehRyb3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qQekQNzg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UWoQvdfa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JfsFf8+X";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="25ehRyb3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 671408508A;
	Thu, 20 Aug 2026 11:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787225152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QFN+4Roh2Cvcp5trAIuVuohmu0zZXE/gk3HVMUsSHII=;
	b=qQekQNzgi0Ywk9ekfs3f+nQj8AmRmCtSQ/fclxoAcS2UjY+eJoosXuJ58s/L74M9bQRL8R
	qEvBckCpliiExxyGB0pWDo9CNUSUGAgGc1YgvcXCzIDXrm2aX1Ou19pckNgdF65o0W/cJ3
	PbHeY4CKPGGNM07QDseQSTYWsHPXo9M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787225152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QFN+4Roh2Cvcp5trAIuVuohmu0zZXE/gk3HVMUsSHII=;
	b=UWoQvdfacGWaZ+DKriWO0R+xRMZr33HnOsIjt+zcA00EDMqrn3p6Z5iDhrWKZPfplHQA/o
	8/iIu7VEIXWW+GAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787225148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QFN+4Roh2Cvcp5trAIuVuohmu0zZXE/gk3HVMUsSHII=;
	b=JfsFf8+XR5y+15RRmjxI6yZoHzRt+935ISB60EboE0jkpXzqhhrx8FlHCJ5Qtevg9d4MUH
	bZKujjWQ9c9nnPxzjBQqIUrj92tRaAcrRH4YnJKXosCdlhOk7XtGuVxtpV8GibZJwCjV9o
	WpgUs82sbUQeW7ii6YQIDP7zkR7VLAU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787225148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QFN+4Roh2Cvcp5trAIuVuohmu0zZXE/gk3HVMUsSHII=;
	b=25ehRyb3w5KrxhAvgMGK19ttT+Lfc/dm4WT+QcxMtozwWkRd8u9anUQaufmoA6G3wdvsdp
	zow6i5wqiZyQdNAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A7C927A8;
	Thu, 20 Aug 2026 11:25:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HoMSFjzkhmolOAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 20 Aug 2026 11:25:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 97B72A13B9; Thu, 20 Aug 2026 13:25:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: [PATCH RESEND] ext4: Avoid entering writeback paths during fastcommit replay
Date: Thu, 20 Aug 2026 13:25:33 +0200
Message-ID: <20260820112532.757055-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2350; i=jack@suse.cz; h=from:subject; bh=w1UiliAxmgXInJ7h1KXuptV80qojag0d4J3kJR0Ga64=; b=kA0DAAgBnJ2qBz9kQNkByyZiAGqG5CyiUIxbyukEMM5P+6V30zX+YEM+29aaqGfEHPfIm0KC0 IkBMwQAAQgAHRYhBKtZ0SvWnjKKtVUoHJydqgc/ZEDZBQJqhuQsAAoJEJydqgc/ZEDZnoAIAKuW ZW3zRKGr19gzinzE+ns0WX3bzw5iL0ZR0SPqXoKQ0e9EtK3TFfOCaIoH9BAHxopVGEcDeIBTz+J 2k6TVG2alQ7njuPDS3OTtmtVl0C+TQa+0mPcLI4I22Cq/U3/pMI43TiqYM1mTXYVjpqB6IQ4U/r d4RdVHR1/bz8j4wxrw6jAwc74pjHarvQthsogxWDW1ZNdZ9b/WkdfZ9AsDX7sw5jbtDmRXqHwiW 7QU3ZVkdo9qi1B+6QtmGfSuIjekoSNA8r/iSn74t1adsC6nIovdw9lPh9Rge8Dc1+PzviRRl6y3 7MNtF3w/uVOSEaSfa2FiC6XQn6n7qwU6iN4j3iM=
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo]

Fastcommit replay effectively happens in nojournal mode. This results in
ext4_mark_iloc_dirty() setting I_METADATA_WRITEBACK flag and as a result
we end up entering filesystem writeback functions. However during
fastcommit replay s_writepages_rwsem isn't initialized yet and hence we
crash.

Fix the problem by avoiding setting I_METADATA_WRITEBACK during
fastcommit replay. Journal replay flushes the whole block device after
replay anyway so all metadata is properly persisted and replay is faster
this way as a bonus.

Fixes: c26339e1df33 ("ext4: Fix data integrity writeout issues in nojournal mode")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Hi Ted,

this has fallen through the cracks in VFS tree, now it applies cleanly to
Linus' tree so can you perhaps pick it up and push to Linus during the second
half of the merge window? Thanks!

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7a1f961cd11c..12ff84ab5741 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6408,9 +6408,10 @@ int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
 int ext4_mark_iloc_dirty(handle_t *handle,
 			 struct inode *inode, struct ext4_iloc *iloc)
 {
+	struct super_block *sb = inode->i_sb;
 	int err = 0;
 
-	err = ext4_emergency_state(inode->i_sb);
+	err = ext4_emergency_state(sb);
 	if (unlikely(err)) {
 		put_bh(iloc->bh);
 		return err;
@@ -6425,9 +6426,13 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 	put_bh(iloc->bh);
 	/*
 	 * Mark that there's metadata writeout pending for the inode so that it
-	 * gets properly flushed on fsync(2) and similar.
+	 * gets properly flushed on fsync(2) and similar. We don't bother for
+	 * fastcommit replay as that flushes the whole bdev afterwards anyway.
+	 * It is faster this way and we avoid entering fs writeback paths which
+	 * aren't fully initialized yet.
 	 */
-	if (!EXT4_SB(inode->i_sb)->s_journal) {
+	if (!ext4_handle_valid(handle) &&
+	    !(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY)) {
 		/*
 		 * Inode didn't need to go through dirtying, make sure it is
 		 * attached to wb so that writeback can handle it.
-- 
2.51.0


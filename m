Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E304A3F4854
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149412; cv=none; b=JVZ7qkANCmeto+C6cNT/nGW/3ePEfKikzEI/CYPxkPyHO0uYWZyBYMr0LYdsKNsqC9FInnbZxANGrW8k6+FV7thNq0dk6FeZ2M1Wf5Nt6CkEZwTHMRbxeGJEQ3NpARWaM+ruYZd4MuCyTkGVsd3MenxOOGQ1cZW5cvYG5PYQ410=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149412; c=relaxed/simple;
	bh=2APkNAMylEIgi7hyt2ZLmdlP/h/D4YcRlx7UtEqQRic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXD8hisE2RDbghbvens/WFfSyxleVLEFwb+ECPtaenNolp067snvfgw/ylchp9o1bekKgl8y5RHQyFOWzIdTpHw8Kc7t8Ja8hxrdNVKOqLRpScV+LGD3/9ABVC5+amWEn3fJ+f4KCh8mAidPbsV1draR0kFJZV12hNmB9QYMQSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=frwMiZsx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fLVvsHnC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0fDefqK1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tjD29r+8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="frwMiZsx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fLVvsHnC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0fDefqK1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tjD29r+8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F2FA846AE;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTUdQb9sx6+VsYQG9jAN7edMdqk8tALnDBKqIdyEiWY=;
	b=frwMiZsxJFJQK7RIJLqn8aG2RH1zJtHB/pyEJSfJympISBHNuuK2IvLzrLsTW4Cha6gFbF
	kDr5QyTSwlGOeYzzD5gg/Qt8TE25x3gN6Jy5Oyxsnb/FMH1Viu52zHVsAcHAuoGd/M57Id
	SmMmSMwgNVNb1sQfIiRI9D/fgfRPKGE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTUdQb9sx6+VsYQG9jAN7edMdqk8tALnDBKqIdyEiWY=;
	b=fLVvsHnCJvTxCGMerFU9NQA4H35U1d37Z0OVkWbwwXz1Kh3VEy+x1hCgjE6kBcUoqDJokR
	DvQwAFUueF9Zz5Cg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTUdQb9sx6+VsYQG9jAN7edMdqk8tALnDBKqIdyEiWY=;
	b=0fDefqK1bkxZ8dDVcz85jkFq+kKIRngHM3qe5VBAM/LWOA4bLn3YqyNKkZP8FTXgXSePOO
	SlYjVRk/WWlvVqboeq1QbgFvEDaqIIfNeH/iVLDOg8s15dBDytjXbl1iMEFsHSGsYxPmz0
	54nrJeXyf4A779zdrDaxnBgcvrg55wY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTUdQb9sx6+VsYQG9jAN7edMdqk8tALnDBKqIdyEiWY=;
	b=tjD29r+8OSEzQXYBMYzBW0Znh8HVJRjDe62A3042NxmXatUj9fIlfDVq0JU4ijvxg98TKC
	nImyQFsfHEUVbXDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE3C2779CB;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3trHNcs3Z2oJawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 359AEA1321; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 03/20] fs: Fix missed inode writeback when racing with __writeback_single_inode
Date: Mon, 27 Jul 2026 12:49:21 +0200
Message-ID: <20260727104923.3828017-23-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1889; i=jack@suse.cz; h=from:subject; bh=2APkNAMylEIgi7hyt2ZLmdlP/h/D4YcRlx7UtEqQRic=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze1dsNHBNWsrQLkudjYQjRnBsdy1WUeO0MMI uL5gy4fBSuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3tQAKCRCcnaoHP2RA 2dZqB/9HiSU91f+YzlEpcIQ7mbAi6MF/CKjsp4U1prKcAfnN+HirSRpWvn3SYWJLFBFpFotp6sR Er5+J2TzcpIT7+DkPVMVOMcv2osV6qIaNpOHOgJm6/v7uNMVZRMLXfCUUkpT0jNMhCJ1OsZg2DB NfnKQFcmPflIIJb6KYjTXDiCG+1eShhTPDpjaVJoXmWuaNQXrZ5F7U5X/FUBKgitsiHRMoGNG8K rc8/HMwKc9vWtJCiJgBxJGaowt8hw17J+I4fSI6h8pOxR6phOE7PeHmINXpX0urfYch7DFPC5Zn z+LNxFLpAqefwgz0MjAZTtAHHeJeiIVwiiQwgYHLx7z0bdNX
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spam-Flag: NO
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
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

When mmb_fsync_noflush() or simple_fsync_noflush() race with another
writeback of the same inode, they can see inode dirty bits are already
clear and skip inode writeback although the racing
__writeback_single_inode() didn't yet get to writing anything. This can
result in fsync(2) returning without properly persisting the inode.

We already have I_SYNC bit for this synchronization and
writeback_single_inode() properly uses it so just fix
mmb_fsync_noflush() and simple_fsync_noflush() to take it into account
as well.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 5 +++--
 fs/libfs.c  | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index daaa6614a6d6..7e5ad9f4754d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -655,9 +655,10 @@ int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
 
 	if (mmb)
 		ret = mmb_sync(mmb);
-	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
+	if (!(inode_state_read_once(inode) & (I_DIRTY_ALL | I_SYNC)))
 		goto out;
-	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
+	if (datasync &&
+	    !(inode_state_read_once(inode) & (I_DIRTY_DATASYNC | I_SYNC)))
 		goto out;
 
 	err = sync_inode_metadata(inode, 1);
diff --git a/fs/libfs.c b/fs/libfs.c
index 5a0d276379d1..57e5971b6331 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1559,9 +1559,10 @@ int simple_fsync_noflush(struct file *file, loff_t start, loff_t end,
 	if (err)
 		return err;
 
-	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
+	if (!(inode_state_read_once(inode) & (I_DIRTY_ALL | I_SYNC)))
 		goto out;
-	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
+	if (datasync &&
+	    !(inode_state_read_once(inode) & (I_DIRTY_DATASYNC | I_SYNC)))
 		goto out;
 
 	ret = sync_inode_metadata(inode, 1);
-- 
2.51.0


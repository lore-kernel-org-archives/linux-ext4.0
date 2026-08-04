Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A48448B85
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 10:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785840114; cv=none; b=ilOye8jkCZO6obX6mJm6zKfm2ebeu2iaxUk1X6JIxln0twAe7IhUNVNEtqYOcvEQYFvFXblyM790AXrmjeoFXFsz7o3w820mpU4araIJputNcGUIpQUlCJW4CYhAzfTJcMCBacesTEYMe21EaPgw62ALWYSQdhl5dfNV2qgCzPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785840114; c=relaxed/simple;
	bh=qOXBA+ojtmt4ft8d0BMPVa5xy7WJfLW7Jjjf//dGJAI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lqaid63KE6AXHG6kzI71mbghMCOPO+kDjDAFonWCU9YfaTkgJxeqBKFiEvVBcOJsDLU39p6orHw2UTJ5UWR0ARVJJi7NrmUU+fRCp3BNr1Wxilg4YyxqjJAIDsNGygf6XPtloRNrBN93zdP4KnTMwjOAVYkrcBW2087KNxme1pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZGLWqCHX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UP1O5IGL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SDkN6uJy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4zL3O2eS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZGLWqCHX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UP1O5IGL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SDkN6uJy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4zL3O2eS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 03CA57F74D;
	Tue,  4 Aug 2026 10:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785840100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jDMHkISfyIFpKPFAtwzL3qxNNg32tIxkvBscHML+Hl0=;
	b=ZGLWqCHXTWIsWGJbcn8BOLu0hYCnGg6ZBpjk5LIbyNPDZLu5l0VEusEOFOw9SRmCkRx8Nc
	FwJQ5jmbUuMDfBsnT+mV0nDEGiHyJEYgQBkppONxmb0XluQ7Myq4Kc5p1Dyp4wj/yVbf88
	nG45IFQLbH0tpJpQ0fOd3UghAEBNLbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785840100;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jDMHkISfyIFpKPFAtwzL3qxNNg32tIxkvBscHML+Hl0=;
	b=UP1O5IGLSwhw6Tz9Nu8x21WV7YzmzB6aVCsNOZv9mHNs0VxEtoE88tFp1szjM0fqNMdhih
	d1z0NJmaWxKt6YDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785840096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jDMHkISfyIFpKPFAtwzL3qxNNg32tIxkvBscHML+Hl0=;
	b=SDkN6uJy/H9gSCD6/bHzPlawY0HVQFub8jGPraa/TsTzxUpbGjlbfszNNxzfpdtebTu1A/
	wWuxTTCkzhbq3F/BBaium34vMYDr9D84Ngiodp8Ki4A4VbvX7AWrCuPw7ZO2OfWF1as36x
	pbNpqW+17aC4JUcCTTr3IdLK6KQ+Vyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785840096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jDMHkISfyIFpKPFAtwzL3qxNNg32tIxkvBscHML+Hl0=;
	b=4zL3O2eSIZ/kDbqaYpqB+ECNsYjIC+7IrlkdKhNitTHVuf6Dk3x/YZ7u9wpKaEN//PDCoQ
	o2iGSrbf7i40SNCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7BF0C779BB;
	Tue,  4 Aug 2026 10:41:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u6JAHt3BcWo8XwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 10:41:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 59798A13A6; Tue, 04 Aug 2026 12:41:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-ext4@vger.kernel.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Avoid entering writeback paths during fastcommit replay
Date: Tue,  4 Aug 2026 12:41:13 +0200
Message-ID: <20260804104112.93202-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2218; i=jack@suse.cz; h=from:subject; bh=qOXBA+ojtmt4ft8d0BMPVa5xy7WJfLW7Jjjf//dGJAI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqccHIQXujcrUX7BKQwwHRY8NI9f/nlT8yUc5KU 7uKNEajDPWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCanHByAAKCRCcnaoHP2RA 2RD1CACEmXNrZ8Kw2VvIOPk9HVTLrxBT5cy/NHnMHFMFZ/YItKHvSOL+fPOi1n7C0gCBankJDbM jZhq9l0xET8q2W+mRtTxdaw7mtXd2OyMNNdqCDuiaqqgzaGZ755wlvJJ7HzwBqLVVl9VeqXIp3y M2uWnuoECW+AdIu4ZzsfwP10z4mrXlGGzz2kaa2h1ZaOLBmDJrw3YKiay9c095oL1oFUNoVwjN3 ifJ68ILwHxC035dWjAn1SaPn6F/qP5H8vZBY0bhUdR4M4OwtKwnonTzit3frX+/HZATuY+nnwE/ p32WLUmcx1U21g14nwAsBDf/EQQETAZfxIlPpwpxEPW81XbD
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
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

Christian, please add this fixup to my sync fixing series. Thanks!

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


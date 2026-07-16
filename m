Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C483D9DD4
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213766; cv=none; b=XhO7pJNHNf0Cxsz6b5QRoDRcTn1FORf1EFsx5H2GWicn/opPqruXMJYqWFGJf3n0CcTf/8yjL2DaWy9+U1vvtdhx3rmZtpnVYXKv2NOhzHq+qPT6lbKUFXtEW1PavJC7hlvuJls8PPIC6yiiQmdtcZUTGbNaCLPcvhFNO3s27SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213766; c=relaxed/simple;
	bh=2APkNAMylEIgi7hyt2ZLmdlP/h/D4YcRlx7UtEqQRic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q05svTuzKd0O3ngxE2ypbqFeU9bqA+Q/XGUGrtpTqBk8mHrOJKUE/tlMX+NtcKTf4EEuygSqq1gPMTStIhJ1sZZ41VpTloBuBG/38ffFpMoZAkTV25XgTEx6WYy0+1HfYfCAB/UKdpGl5Nk1Gk5BkRwU2BLRwhK+T4D+6AGNNyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WmS+X5sa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wZ1UxzIC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WmS+X5sa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wZ1UxzIC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WmS+X5sa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wZ1UxzIC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WmS+X5sa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wZ1UxzIC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 14296789CF;
	Thu, 16 Jul 2026 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTUdQb9sx6+VsYQG9jAN7edMdqk8tALnDBKqIdyEiWY=;
	b=WmS+X5sanOdLuS03uqqTaxS3JStYOPgyVAqEoKiG4fOXRH0ratoSEr824cz9EtKdh23dOj
	Zuk5BQ37ikoJvzppiPj+ghorL6CBgXHdz10ZIN57YVA3iuZiIAkLsfUZ9lMRoQRcwviV69
	Fw4QkN1AnyQtLTVjpuq8xy5dNtvkAic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTUdQb9sx6+VsYQG9jAN7edMdqk8tALnDBKqIdyEiWY=;
	b=wZ1UxzICaOQfeoiILlsG1ilPkterRQtcXkZ9QpKBm2Gk+IMX3d6hc7zYsbAAtoUj01OH5g
	8FQlpT6NIO+nKaBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTUdQb9sx6+VsYQG9jAN7edMdqk8tALnDBKqIdyEiWY=;
	b=WmS+X5sanOdLuS03uqqTaxS3JStYOPgyVAqEoKiG4fOXRH0ratoSEr824cz9EtKdh23dOj
	Zuk5BQ37ikoJvzppiPj+ghorL6CBgXHdz10ZIN57YVA3iuZiIAkLsfUZ9lMRoQRcwviV69
	Fw4QkN1AnyQtLTVjpuq8xy5dNtvkAic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTUdQb9sx6+VsYQG9jAN7edMdqk8tALnDBKqIdyEiWY=;
	b=wZ1UxzICaOQfeoiILlsG1ilPkterRQtcXkZ9QpKBm2Gk+IMX3d6hc7zYsbAAtoUj01OH5g
	8FQlpT6NIO+nKaBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0BAA6779AE;
	Thu, 16 Jul 2026 14:55:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4HzXAv3wWGriXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:55:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 63AF5A0916; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 03/21] fs: Fix missed inode writeback when racing with __writeback_single_inode
Date: Thu, 16 Jul 2026 16:55:25 +0200
Message-ID: <20260716145527.3580300-24-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1889; i=jack@suse.cz; h=from:subject; bh=2APkNAMylEIgi7hyt2ZLmdlP/h/D4YcRlx7UtEqQRic=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDhdsNHBNWsrQLkudjYQjRnBsdy1WUeO0MMI uL5gy4fBSuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw4QAKCRCcnaoHP2RA 2d4cB/9S42UvilQJOQrNqC/H1GWpc5BFDsoxmqhMNrozkhlaQnpINbIIDqY1Cy+lLpL2erm2j4y kmKBOD9SJwlzAuaXwE7RUtxiAn/VCZ5K3A8VHS3pzd6zTaxLoo3h8MxEZUq+vGpYErAN53QlF51 X63MNin4uXfCE0AI4ijHVSMwNBcRIZrPy6FhCwbrFN3KuvYaY1evueSB1pK3bGlTkml4xWPprtW 5EHZLY0ligg2zYTMit2O007NvcGFRQeYPLYQ20qkfH40bwOZAjnWK7Q0w+qJBa0lavZBFvvLTZv wqQ9AOqQkl2J+lx4aH/7/7MxCeMppHwYJvE5TD7h4NoRmM5v
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
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -5.30

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


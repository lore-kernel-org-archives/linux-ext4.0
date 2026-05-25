Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F283E4C9E
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 08:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779699541; cv=none; b=tx5Ag7NqjPh3iow/mdziuXHAzzE0u9d2HE3BsxHfItopLdXcD/3ItFHN1kNyqMSUKMCHbyW6FTBjvknMlkgZe2O2zmVkOjFQQ9BekAcHz0OTBdShimftTP+SQXW5PpocoEHz5UzlqnSlIqDjNmfaM7zdXeP7i6gf8sdDK4VAElk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779699541; c=relaxed/simple;
	bh=yTNj+WDO752bmlOGmRmRquh79l9NGx37RMe/rlw6xuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOl5RVKbrJtGRERsA4yD5JoWN4ArZ+eYzjFYaqWnbokd/OWbP+xPl5CCfBGgusAGOQ3yTs8TTw51DZ/OqhH4hWD7nKqBY6RvE6UOH8pTIQJOeYW3PjAOXrS3/ZXVh8urH067El4Mr7P+IOOl+OzAHnd+4pSaYaPpgdWi1T9eeB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Krj//6QC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tvHQFjDW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Krj//6QC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tvHQFjDW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Krj//6QC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tvHQFjDW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Krj//6QC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tvHQFjDW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 92F9964B6F;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779699517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVB/PChu+eXvcx0erE7VBrB3I4LJNjIaPc33R9y8X3A=;
	b=Krj//6QC5V/usahfM4wsY9pUcnEddgGv5cjrxQ2cbqYykKs1eMtsLMYZaBI7jz1DpcUAao
	lBn0Ss36MB4syOm2R0O0S2UGGhaORKtrKPNbjEyO+CTbiFyCfmdOsqQw3E1KiwPkXOM7Xf
	7pO3NTyI48JYRIyXL5HvktEcGCAi6hw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779699517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVB/PChu+eXvcx0erE7VBrB3I4LJNjIaPc33R9y8X3A=;
	b=tvHQFjDWhKY5jYVcVmVWAGNM2G2C/BH9OEdZEB1uIqpoe7/04QAEYQxAB2ApAvYzd9BM8i
	IEUMR2x7MD5d+xBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779699517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVB/PChu+eXvcx0erE7VBrB3I4LJNjIaPc33R9y8X3A=;
	b=Krj//6QC5V/usahfM4wsY9pUcnEddgGv5cjrxQ2cbqYykKs1eMtsLMYZaBI7jz1DpcUAao
	lBn0Ss36MB4syOm2R0O0S2UGGhaORKtrKPNbjEyO+CTbiFyCfmdOsqQw3E1KiwPkXOM7Xf
	7pO3NTyI48JYRIyXL5HvktEcGCAi6hw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779699517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVB/PChu+eXvcx0erE7VBrB3I4LJNjIaPc33R9y8X3A=;
	b=tvHQFjDWhKY5jYVcVmVWAGNM2G2C/BH9OEdZEB1uIqpoe7/04QAEYQxAB2ApAvYzd9BM8i
	IEUMR2x7MD5d+xBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A96359B70;
	Mon, 25 May 2026 08:58:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qi3VIT0PFGrMbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 08:58:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CD10DA0A1D; Mon, 25 May 2026 10:58:32 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 07/10] minix: Fix possibly missing inode write on fsync(2)
Date: Mon, 25 May 2026 10:58:13 +0200
Message-ID: <20260525085821.769119-17-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1562; i=jack@suse.cz; h=from:subject; bh=yTNj+WDO752bmlOGmRmRquh79l9NGx37RMe/rlw6xuw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqFA8zXK2TEC2ubbNgWNX+k9246pAU2i/lxT9e5 r2o9PUCmOaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCahQPMwAKCRCcnaoHP2RA 2VvlB/9iMLHz+HRLP+sfkgI0Vj1k+nVqkeicRygfQnzGETpP8j3qxaKVb88HyGoM/cT2aTBobus KjD8TCCRMBP0irgqcakWQfOWcwt+y6QNlyWjGs6fysvHHFdFNRLkjj3NOr3gliCXZol5eYStMl4 t7dBbqYhE04qasWeYtk+kRMsBIYRx7DvwBrwtAI598dmafLIOOz6v/JWfwKXAGhffXKs8cmOxPw bZsaNk2lO0l9fHVwKTpyD5shV3hOm9DTiJJ20zus5mfCA7sEdT2V7vPliOfpXPQBZLzUeBP3ONU u2a4ImD7mOiD7AyZUwZY1myRuN03/wzRGopTRC3eAwYEejnh
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
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
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Flag: NO

Use mmb inode buffer writeout infrastructure to reliably write out
inode's buffer on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/inode.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 9c6bac248907..401056fb682e 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -649,7 +649,7 @@ static struct buffer_head * V1_minix_update_inode(struct inode * inode)
 		raw_inode->i_zone[0] = old_encode_dev(inode->i_rdev);
 	else for (i = 0; i < 9; i++)
 		raw_inode->i_zone[i] = minix_inode->u.i1_data[i];
-	mark_buffer_dirty(bh);
+	mmb_mark_inode_buffer_dirty(bh, &minix_i(inode)->i_metadata_bhs);
 	return bh;
 }
 
@@ -678,7 +678,7 @@ static struct buffer_head * V2_minix_update_inode(struct inode * inode)
 		raw_inode->i_zone[0] = old_encode_dev(inode->i_rdev);
 	else for (i = 0; i < 10; i++)
 		raw_inode->i_zone[i] = minix_inode->u.i2_data[i];
-	mark_buffer_dirty(bh);
+	mmb_mark_inode_buffer_dirty(bh, &minix_i(inode)->i_metadata_bhs);
 	return bh;
 }
 
@@ -693,14 +693,6 @@ static int minix_write_inode(struct inode *inode, struct writeback_control *wbc)
 		bh = V2_minix_update_inode(inode);
 	if (!bh)
 		return -EIO;
-	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk("IO error syncing minix inode [%s:%08llx]\n",
-				inode->i_sb->s_id, inode->i_ino);
-			err = -EIO;
-		}
-	}
 	brelse (bh);
 	return err;
 }
-- 
2.51.0


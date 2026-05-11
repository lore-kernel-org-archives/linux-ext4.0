Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F013242B8
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501683; cv=none; b=ubwRslDlrkYxeMtNE7hkvQsPee6TrGVNXqgrjaNHaCDUES3Rwh41sgj5hacKaavaoESC58gQHLxu+960PFHCw6kbXjeCVFT7MDMHlWqQywo9dPASGBO19W3ySx9lX7qzkPr7nLyrkscb8Yd0tpkVntZMQcMfY0JPLIHB/20+l0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501683; c=relaxed/simple;
	bh=aQ2MwgrnlA3W7ZObSgvpT1TzHSKyuma94Dp/F2WpCLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhNNqnWOmbG3fzosBX9CIPOBFeRWFB347oKj/D8PVZrLDeLvPKhxl8EVi8YnNo7paQNLsHmJ4ZEa/w34xlg/ptxPeeY71T8b01QOHNukf/2977JwXv0GibXGM4+Tso2QgZSlSVHNrS/VFsHsQEMl1NdhuPGgemWzPiTvqHh+J0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lY3yTbKm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2iJ2GDlL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BsggxtZY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/9LfU2wm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lY3yTbKm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2iJ2GDlL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BsggxtZY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/9LfU2wm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4EFA767F62;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MdJsKg5xj4D5ePmWVLbDI+h77xPHq+7ttdlKIRveNaM=;
	b=lY3yTbKmqLYfJMMxC4ljTuy5o+cFeZw+bRAmELsj+XjbKON0tQIzDJNuM8bGJQeq8+iwV4
	IhhZwa9RTxXpk0zp+xYIJ57bGzkaf7jiDYYAD00rRFe6VPbD3VuZN4OFmq2uN3TR2MvngB
	QKgEFeYZGijxKfS3rEHF+uVpTaJdohI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MdJsKg5xj4D5ePmWVLbDI+h77xPHq+7ttdlKIRveNaM=;
	b=2iJ2GDlLWQOxzX4oNocFZ4kWo1vGtX+35uHyh75H/J3hhvRgZtbT6MG4WpNUFrreU3wb9p
	rF6UKjdWdlubBOCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BsggxtZY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/9LfU2wm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MdJsKg5xj4D5ePmWVLbDI+h77xPHq+7ttdlKIRveNaM=;
	b=BsggxtZYBF+ANwchkfeY/8k1ZYXSJkZpRxlnQJ+bG3g2Hsw+H25N2Kjvf9lwA6X1c071CH
	yepCMf9IzX/v6YLKvSNcmH2+pmUMThgvtPvs0nTeRAj2TRWjAs8kN8l1h/P3HS/uVMbXw9
	XvbS8/kcYnVxiDcDrMDtHZV0CMGAiYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MdJsKg5xj4D5ePmWVLbDI+h77xPHq+7ttdlKIRveNaM=;
	b=/9LfU2wmQ1SF094zApWd6C3zcPQUhnyoYP7Ir260W+yOa7Tr8MCvr6eE1Wa6F4enLxS+Dn
	4ufncSs1G590VcAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E3BB593AD;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IE4wDxPIAWrZWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8968BA090F; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6/9] fat: Fix possibly missing inode write on fsync(2)
Date: Mon, 11 May 2026 14:13:56 +0200
Message-ID: <20260511121356.241821-15-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=947; i=jack@suse.cz; h=from:subject; bh=aQ2MwgrnlA3W7ZObSgvpT1TzHSKyuma94Dp/F2WpCLE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqAcgIDlkSuGVBhj5uesXWOQoSdTsDMpLRY5f3t LGb1jKi92eJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCagHICAAKCRCcnaoHP2RA 2WN0B/47iqb5vXicPqonoZcL/KtkfavXnd5ARGIJ9NxS1Iq1UVx4TA6KcboG8VOgfTG3xSQ66ec qRDlRmk+aTvpFKxOoeKzjcoja25frOEVD5IakAZd3cWhDM2lly4dj6lTrb0Q/4pzqPl7SKwcvv4 9jADMTWqLFwEMy/nS7EKiiu/lQ3bli+JUEauy913kvycc3kADDiVVFlybNbJ0QVipPjhYZwQ1IS 5CxYqO055yPDqV1bAFiWdXLD/5mMKfefQ+MdJe/yWCtgpWfRsXMUqtVq+uPYwv2ioEAtidrChcm jsU4jyJOMSvAUhZ0eZhqiZFffV6ymdJqjHa3miH3C24LS3Ko
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mail.parknet.co.jp,mit.edu,vger.kernel.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email,suse.cz:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 4EFA767F62
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -1.51

Use mmb inode buffer writeout infrastructure to reliably write out
inode's buffer on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 28f78df086ef..4ca00b7a618b 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -907,6 +907,7 @@ static int __fat_write_inode(struct inode *inode, int wait)
 	}
 	spin_unlock(&sbi->inode_hash_lock);
 	mark_buffer_dirty(bh);
+	MSDOS_I(inode)->i_metadata_bhs.inode_blk = bh->b_blocknr;
 	err = 0;
 	if (wait)
 		err = sync_dirty_buffer(bh);
@@ -925,7 +926,7 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
 		err = fat_clusters_flush(sb);
 		mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	} else
-		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+		err = __fat_write_inode(inode, 0);
 
 	return err;
 }
-- 
2.51.0


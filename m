Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DD93815C2
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 12:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501695; cv=none; b=tVHa8MXhz1O09azuTzNwiy2NRtOpb/WVULYtYQ214vKWO8X53gVT5ihqc58BeLKE7bIWDAmk6PwH7fANAX+30paelS5sE559/NCWfp2cpOLnUVtTNgTfR+NadYjy1/Q8rbflkIVTNMpIEAidn9fLxvRGeZRVjtGwbf+ik1DVd3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501695; c=relaxed/simple;
	bh=HShF01tFV1Sp7EhKzJG7sSGt9NcpFUAnXkEKhUdKL2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrwJOIH3YSanh8T8OrP54N/OOy3ULnBDTeNZRCn3R9fpYoBmFZjPFpXJPZzN978iSqiKDAmqt7ZBNCBV4SdDhHTHw0/Q0cSHJEDrnhNKOUXFuttTQs9HDw/5d+4jeAnjtQiWU7dlVjoVrKF7fWFB4YFtIdD/jlbR8ic5+ePG2m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wDkO+jFj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nbPQKyey; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wDkO+jFj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nbPQKyey; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wDkO+jFj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nbPQKyey";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wDkO+jFj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nbPQKyey"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1BAA267F5D;
	Mon, 11 May 2026 12:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VeJfFmTMGndBnuNB7u8h6fItPTyDNzLq1gHe0j0nR40=;
	b=wDkO+jFjzGKIRf2I+dJvipXunwRynTN23GgJUk5EZ/GDrpmNMZrQVbnmOe5qe9Hftl4X2v
	/h02ArXMi39mXLLnyYz/tG9h0h9at2WJ5Dydy9jPL9jPPzvQ7KXA7gAcx2s9Rqm9pjI8vG
	v3bsrcWqHam5H04I8dbDXpa+ln08wXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VeJfFmTMGndBnuNB7u8h6fItPTyDNzLq1gHe0j0nR40=;
	b=nbPQKyeytoV8hlKjg7J1N0Aelqjj+2FD0bsgZvlQ1upxEdmaPRqoOCWKVSVFv7DBbWFMyK
	3vRemLyF5vujEICg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wDkO+jFj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nbPQKyey
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778501655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VeJfFmTMGndBnuNB7u8h6fItPTyDNzLq1gHe0j0nR40=;
	b=wDkO+jFjzGKIRf2I+dJvipXunwRynTN23GgJUk5EZ/GDrpmNMZrQVbnmOe5qe9Hftl4X2v
	/h02ArXMi39mXLLnyYz/tG9h0h9at2WJ5Dydy9jPL9jPPzvQ7KXA7gAcx2s9Rqm9pjI8vG
	v3bsrcWqHam5H04I8dbDXpa+ln08wXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778501655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VeJfFmTMGndBnuNB7u8h6fItPTyDNzLq1gHe0j0nR40=;
	b=nbPQKyeytoV8hlKjg7J1N0Aelqjj+2FD0bsgZvlQ1upxEdmaPRqoOCWKVSVFv7DBbWFMyK
	3vRemLyF5vujEICg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DA80593AF;
	Mon, 11 May 2026 12:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XHPaFhPIAWrgWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 12:14:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 92EECA093B; Mon, 11 May 2026 14:14:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 8/9] bfs: Fix possibly missing inode write on fsync(2)
Date: Mon, 11 May 2026 14:13:58 +0200
Message-ID: <20260511121356.241821-17-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260511115725.28441-1-jack@suse.cz>
References: <20260511115725.28441-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=831; i=jack@suse.cz; h=from:subject; bh=HShF01tFV1Sp7EhKzJG7sSGt9NcpFUAnXkEKhUdKL2I=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqAcgKwCyl5ndzHB/xM5z0of21Lhdzg1KMVKWXm dXsnnZ+UqqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCagHICgAKCRCcnaoHP2RA 2bcOB/4qsXdRTUUHWsyrdHBe0ArqAvhotXVylCyusRvlUYjgwnHD1ipqY5X1IHslXxIGAfQAm9R cIukWzejvIfUdHaKByIwy0l60D/MACmo6c/UIgrs8RMyLtkIc3DusuqLAwbG6QvIQv/yurg6/xm kpQbh7e+T9ixUabkuuLAEy/38Ru/S/EOiWcCVOm7f2mAGHNh/IJ+okL2VITWncL/8MJm0lt9rZB Q3AlYrSoyL8f6eyL7PPDa1B8Zt/xOcplSYCihF2ovIEk2HTCaJnoHSAtJTRosS6eLCU3+IkDdHg CqqlqXRsHTCGChfZwvB1mZ9orLitSHtFTCz79zVFVaCMVRI+
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 1BAA267F5D
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -1.51

Use mmb inode buffer writeout infrastructure to reliably write out
inode's buffer on fsync(2).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/inode.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 19e49c8cf750..16d351b2f122 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -165,11 +165,7 @@ static int bfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	di->i_eoffset = cpu_to_le32(i_sblock * BFS_BSIZE + inode->i_size - 1);
 
 	mark_buffer_dirty(bh);
-	if (wbc->sync_mode == WB_SYNC_ALL) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh))
-			err = -EIO;
-	}
+	BFS_I(inode)->i_metadata_bhs.inode_blk = bh->b_blocknr;
 	brelse(bh);
 	mutex_unlock(&info->bfs_lock);
 	return err;
-- 
2.51.0


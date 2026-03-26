Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D263B8D7E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518952; cv=none; b=gpgXDyKeYnAiPO4GClnPA6O2zJvIpCHxDMNTomX67YN3YDw7Rg2BqyEdRAYZTAP8SWDiOh4w4GAu2xy2KFyrVkbeUyOXtrPoqzTcVDNdB3Xtm1gN+gegt2NHkuXfLbowF/rwSpOg5NONCllsHXOAItPvMkxHZ2ux9F45TTn/2zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518952; c=relaxed/simple;
	bh=U+QxL7wMLUiVGEqv4r+69y8nwApPUSkF7ragwmMCpxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tq7mo84HygUklPaOeBuHJH5oyyukUD4nH6cJEGE0o/IIsQ50TIUh1OG0RA+c5mWXQyqR4BU0yrhlwOZgIUvvDdxTMFL5Zgre3TBTeQE6O8PEGZSxLVufG/0fchKxr5dpIQvPtuSaAOGLBmoOSCeRWhAN/Jyt+hO/SU4Co+gHytw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=b9zz6GRf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ACJq3f/y; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=b9zz6GRf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ACJq3f/y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="b9zz6GRf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ACJq3f/y";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="b9zz6GRf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ACJq3f/y"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2AE8E4D27E;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuAv70IzoIwl3thvp6KMoYw8dXkhn3UUTAzx9sxMqM4=;
	b=b9zz6GRfVCNVqQGAYY7IBdLkHWhziCBTDByTqiIj4068J1wlAxo+xAXa80SVqqnVrxJnl5
	FjO9VzT/DtPukVelpwLsVKqZFu6LSIuBldvbHMiRaa9IRF/0nKEJoafs8bXMpuN2B1TGwz
	1laAbPyuqYGtB00ubyZh75tRSQUX/BA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuAv70IzoIwl3thvp6KMoYw8dXkhn3UUTAzx9sxMqM4=;
	b=ACJq3f/yLxALp47vcAd3MVVEb09Z9xMYOND0AgBiJSGCqS7mXdecs7bWVqz61suo6j/Jhd
	KnXJxKmm1kuKIyDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b9zz6GRf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ACJq3f/y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuAv70IzoIwl3thvp6KMoYw8dXkhn3UUTAzx9sxMqM4=;
	b=b9zz6GRfVCNVqQGAYY7IBdLkHWhziCBTDByTqiIj4068J1wlAxo+xAXa80SVqqnVrxJnl5
	FjO9VzT/DtPukVelpwLsVKqZFu6LSIuBldvbHMiRaa9IRF/0nKEJoafs8bXMpuN2B1TGwz
	1laAbPyuqYGtB00ubyZh75tRSQUX/BA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuAv70IzoIwl3thvp6KMoYw8dXkhn3UUTAzx9sxMqM4=;
	b=ACJq3f/yLxALp47vcAd3MVVEb09Z9xMYOND0AgBiJSGCqS7mXdecs7bWVqz61suo6j/Jhd
	KnXJxKmm1kuKIyDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 208534A0AD;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5EvuB3ECxWnCYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D2D6FA0B93; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 12/42] fat: Switch to generic_buffers_fsync_noflush()
Date: Thu, 26 Mar 2026 10:54:06 +0100
Message-ID: <20260326095354.16340-54-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=791; i=jack@suse.cz; h=from:subject; bh=U+QxL7wMLUiVGEqv4r+69y8nwApPUSkF7ragwmMCpxc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI83OE2n0S6FtaeH8MKk0RkmPh3Lrjg5K+f/ cKvhEmuGmuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCPAAKCRCcnaoHP2RA 2ZsbCADarW7XvadGiIAZYSWa8IZjt98iS79mXZEfh0M6NqRgcuEznw5jt20L/ith6GTrN/h8ols 7inIXn/VOOXKWA1f4Tkj0GPTzua8OfsA2042BV3urwdTILeaq6NkXzblC85p7MXp7HYhDG0h8Ya GMH2rrIrnTlnieRt9ycfTfD5qpeNO/gxw1LHMEHIPABmiZQAsRRdnDWF2BO7yNJ9ZyJjTQ7vegt DjgqUoZq89prIUTnTCFiXMap5T1DHvn5Si1OpgyQOxf2Pu662rU9URkm2xGu4US3/3Y2w8pm/13 AvkJzXFpLT2fftbY+g1gEpmz1xKsGB3Iqcn1drupcIdK8VUL
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 2AE8E4D27E
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

FAT uses a list of metadata bhs attached to an inode. Switch it to use
generic_buffers_fsync_noflush() instead of __generic_file_fsync() as
we'll be removing metadata bh handling from __generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 124d9c5431c8..1551065a7964 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -188,7 +188,7 @@ int fat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	struct inode *inode = filp->f_mapping->host;
 	int err;
 
-	err = __generic_file_fsync(filp, start, end, datasync);
+	err = generic_buffers_fsync_noflush(filp, start, end, datasync);
 	if (err)
 		return err;
 
-- 
2.51.0


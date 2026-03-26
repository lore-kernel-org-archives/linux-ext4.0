Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6A63BED55
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518956; cv=none; b=Y9wLxqUPXBBsy1VVSnuYzn39h6+G/1BL+6Fq0d7uEdxkv9+XyB+tHhpiM2DsK5rzACBPYMiC8/7Rb8PJVq7RlqtyuyHvpm5J+HaLvFm2oAtIfsHb0ACOqUTf6tVTyqSbvpcphRmZj9VhMCcaHLq1rHojbAf41IWhjxneg6KLyuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518956; c=relaxed/simple;
	bh=qxEFhoc5TAxgK8o7QW5olFNXyUnNyDJBoNqezgZzJxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OThS72xbSo5LGfNOx8tDcFGbzc7Y16vcRyEf+/cb3iEVXkbV6oUdg6Mg6lk3J/1tXYIFeKaS9XRMC1OVboXWmFLpporUjvGMFQKBAy2mrVk4kbErbqCS3MKgJ1Mxai1K3ewOge385TeVhYWZr6SCEkM9qp+AQvdzvxMUM+JEwZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ekgi8iaX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kIjMpLlh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ekgi8iaX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kIjMpLlh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ekgi8iaX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kIjMpLlh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ekgi8iaX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kIjMpLlh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2318A5BD99;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O2hOfIJxdHypvTlkHcC8GuEkHhnn2OiboPg9whgdEs=;
	b=Ekgi8iaXS4N/Pxa5Iq0DQeS3r/N2w8ecGZ6fCfpb9zsrV68BHeIMKgrtUgrT20Q3wMDqz4
	Iq9iGTKjXpwUw8mkGzDfwTX9C+VP0iOn24LXgXpq5csShPDEZSesXjTdJALtemq5P/ehol
	U6r9KUwJNfBTu3IxsCMudXn+ZvjKwK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O2hOfIJxdHypvTlkHcC8GuEkHhnn2OiboPg9whgdEs=;
	b=kIjMpLlh2UeW21LnFRQ9ygX2+XWEb36ITfeEd0QPNo0eX09jAg2yfOl1s9Uw4grM9jUo1R
	+u2oHKtCtgVu9iCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ekgi8iaX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kIjMpLlh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O2hOfIJxdHypvTlkHcC8GuEkHhnn2OiboPg9whgdEs=;
	b=Ekgi8iaXS4N/Pxa5Iq0DQeS3r/N2w8ecGZ6fCfpb9zsrV68BHeIMKgrtUgrT20Q3wMDqz4
	Iq9iGTKjXpwUw8mkGzDfwTX9C+VP0iOn24LXgXpq5csShPDEZSesXjTdJALtemq5P/ehol
	U6r9KUwJNfBTu3IxsCMudXn+ZvjKwK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O2hOfIJxdHypvTlkHcC8GuEkHhnn2OiboPg9whgdEs=;
	b=kIjMpLlh2UeW21LnFRQ9ygX2+XWEb36ITfeEd0QPNo0eX09jAg2yfOl1s9Uw4grM9jUo1R
	+u2oHKtCtgVu9iCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 189E64A0A8;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NS8CBnECxWm/YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C3282A0B7B; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 10/42] minix: Switch to generic_buffers_fsync()
Date: Thu, 26 Mar 2026 10:54:04 +0100
Message-ID: <20260326095354.16340-52-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=jack@suse.cz; h=from:subject; bh=qxEFhoc5TAxgK8o7QW5olFNXyUnNyDJBoNqezgZzJxE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI6wtYz/MQZTdQ2oMuDSu4hXpUpF+I5J9WT7 LwV26ndyxKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCOgAKCRCcnaoHP2RA 2UtcB/0bYO5+Iss3mhVKnA+bmXVSBsYshUvvaqq2vOOYDAEZpYwIuLzzjIbN3Z5+uXIrOhOLHir xEtn+3TJNK6jvs+1Bv3rHM8MKMZiIXmSwTuzzolgPqmcuFBSDO2fkG5PnOm47dkukb1lHHGyo/G hzMYF4bgpgZcXWCs7BFwyVUZsS2O2NXAZwYV3uEjKKBDfK9bgMnbnj6RfGP5pblj9q+JNM8VTQT yc02SjMa1lC+ot6Bqal+o6nvDM3soi1QEgCi27iN54RC8p3tJ3Tc3MA28xCIBDkXS9gmrZvWMGH 3p+QoMwzHe5798zOvzlGrUk0iwufdipBniRdcWxVTk28WeCG
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
X-Rspamd-Queue-Id: 2318A5BD99
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

Minix uses list of metadata bhs attached to an inode. Switch it to
generic_buffers_fsync() instead of generic_file_fsync() as we'll be
removing metadata bh handling from generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/dir.c  | 2 +-
 fs/minix/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 19052fc47e9e..a74d000327fa 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -23,7 +23,7 @@ const struct file_operations minix_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= minix_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 };
 
 /*
diff --git a/fs/minix/file.c b/fs/minix/file.c
index dca7ac71f049..282b3cd1fea3 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -18,7 +18,7 @@ const struct file_operations minix_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 	.splice_read	= filemap_splice_read,
 };
 
-- 
2.51.0


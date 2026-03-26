Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0D335F18D
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518926; cv=none; b=diMu5xomBnwmG4FSlehopqeX7nodyWr6R//HfSUSvuVG6Q6YqY5TTnQPYXOtpUQwXlSUx+s8RA9zdrOvruylQqL5iBcf5qTIaAHPGwGcowIEkpAR3p03rBxjinr1lnDhM31U9KlK4yoTSbS7mUDl4NW/mt/NOvE0ytRGUTWYB60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518926; c=relaxed/simple;
	bh=IUvivkOnXAhLrZoa3cIuK0skAh9kHyc1wR94Cs3zoW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2WuXlddy95TWcgUP+tX9RdGPWReFoz6tYmUxN/gM8jSwbPrVIukVj4GEk78y/kGiXSSfQcmhvZn489L7/oI/Ctw11BuniPH6ZGX6Z/QiDrkrkN956ITtse6dWJR/y6sWQNdjrRc/ZT2LDLsAefCOUizTF2/6Ihhk7PVsI42nU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jIR4MHGa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6zGQ8NMd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jIR4MHGa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6zGQ8NMd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jIR4MHGa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6zGQ8NMd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jIR4MHGa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6zGQ8NMd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 08F995BD87;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=jIR4MHGaryEs5OBSN+AANCv2mQUlSnOH6fjsfTY1sDJmFCEE3Pqx49a6kapa2QgXNV8Jv9
	CeEOhORkSiS08jZoY5BGcKGc4zSZHOfiSoIVaO2TnUqPz6oHgwuD9iRkIkX8hxcbRQh87K
	ri5+MoApkVPwfJyrCtCzBDHRWmI6b0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=6zGQ8NMdjs5ino5W4MfukyLwtK1UQgz+2XsEUiJV7ccKp+lDb3fqIa4ltx8hezyexmycA+
	JHWe0djyKehejYAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jIR4MHGa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6zGQ8NMd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=jIR4MHGaryEs5OBSN+AANCv2mQUlSnOH6fjsfTY1sDJmFCEE3Pqx49a6kapa2QgXNV8Jv9
	CeEOhORkSiS08jZoY5BGcKGc4zSZHOfiSoIVaO2TnUqPz6oHgwuD9iRkIkX8hxcbRQh87K
	ri5+MoApkVPwfJyrCtCzBDHRWmI6b0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=6zGQ8NMdjs5ino5W4MfukyLwtK1UQgz+2XsEUiJV7ccKp+lDb3fqIa4ltx8hezyexmycA+
	JHWe0djyKehejYAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3CC94A0A3;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m+uEO3ACxWmvYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 92E5CA0B61; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 05/42] bdev: Drop pointless invalidate_inode_buffers() call
Date: Thu, 26 Mar 2026 10:53:59 +0100
Message-ID: <20260326095354.16340-47-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1163; i=jack@suse.cz; h=from:subject; bh=IUvivkOnXAhLrZoa3cIuK0skAh9kHyc1wR94Cs3zoW8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI2vaEp5j2MB1rJFDbEn2Uwsbyoww6f0jWoa Faizb2hUY6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNgAKCRCcnaoHP2RA 2fcYB/4zbot9xZ6lVkLaB3KT2IRCbCO6SZXIRgljgsx0/rbnEVxPrU4wpPASP3aZb6Cp3PB8gHE YL6+zwAXF4JXbFEHlx4ikephuEAOZK2KZFjAawikmpmuYgvqe017x9GBbeJOqdWywGGu0kNtiJm yZf+pE4/WO5fyHba6zReezxB5xXGl7wJTKHCpLWOX88Jg/+mQrNBLwUUa8GR7xpR0Y59s9zYu0r EskYuVKix1uXPaVLMAaY1/opwCKqR8E3r2n6N0vk8OYoT8f7drscA22ueg59Lpc8BcTIGUalyJx 8+Knno0wgPxQGZzDp3w+KG6j1wPqcS1bCop+Y1+g8deiilGy
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 08F995BD87

Nobody is calling mark_buffer_dirty_inode() with internal bdev inode and
it doesn't make sense for internal bdev inode to have any metadata
buffer heads. Just drop the pointless invalidate_inode_buffers() call
and consequently the whole bdev_evict_inode() because generic code takes
care of the rest.

CC: linux-block@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bdev.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index ed022f8c48c7..bb0ffa3bb4df 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -417,19 +417,11 @@ static void init_once(void *data)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static void bdev_evict_inode(struct inode *inode)
-{
-	truncate_inode_pages_final(&inode->i_data);
-	invalidate_inode_buffers(inode); /* is it needed here? */
-	clear_inode(inode);
-}
-
 static const struct super_operations bdev_sops = {
 	.statfs = simple_statfs,
 	.alloc_inode = bdev_alloc_inode,
 	.free_inode = bdev_free_inode,
 	.drop_inode = inode_just_drop,
-	.evict_inode = bdev_evict_inode,
 };
 
 static int bd_init_fs_context(struct fs_context *fc)
-- 
2.51.0


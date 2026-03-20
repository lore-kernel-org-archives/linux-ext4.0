Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5D8298CB2
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014138; cv=none; b=q6nNwI3f3M87/0oROaTxftSelLoe2J3UNGRRSObrBLttXA/VQqO0snU/qrWce3N/GXIEdmu0HpNoR96OACzyeFRZZGLerPytqUgZ3lmAP/R6/DD1KY5TFF5LDqYssR2vCi2qA6OaYltUhrFWRHuGi8NHcy6dpX3pO1L3hx9l9Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014138; c=relaxed/simple;
	bh=IUvivkOnXAhLrZoa3cIuK0skAh9kHyc1wR94Cs3zoW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkjAhmizoK15lWq4VCQ5JURH+iCjidFe5O+E6Xf+Wx1qnQyyCUYGJ+Y3LA8NL1qb7AfFQmkzubGWmviNBVIaSWByUBF/YlJD1QeXxiUm7oNkAxUSAPMnv9Axxyx5dSKCIOsHRe2+x+vgPhMpwSsaPdHMnQEbcPgGAHGYYMR6a98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=U4ZaHwu/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CB0T4VgP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=U4ZaHwu/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CB0T4VgP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="U4ZaHwu/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CB0T4VgP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="U4ZaHwu/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CB0T4VgP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F38195BDF7;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=U4ZaHwu/dP3oVpEULEtXd1cqvyIn3yApqSOz9TMxl/tZ/L9fLwA85vXfzEehTHnz5pifyK
	/ruhuigaJR/dwGLayXs8nCQZ8GKF03GMVQBt4i5mFmcyCETnpe0QU+mvEl6CEiJvquS6fA
	axkqt7LJWD7JEfbg04azYWN9jQtiAgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=CB0T4VgP8JRmQAAeBpmvzC9Y2ARMbeVTzqWgn2c17L0RE30OwvX6Trjp3TeWO7Hwu5w0hP
	Rwprii258XX5aZDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=U4ZaHwu/dP3oVpEULEtXd1cqvyIn3yApqSOz9TMxl/tZ/L9fLwA85vXfzEehTHnz5pifyK
	/ruhuigaJR/dwGLayXs8nCQZ8GKF03GMVQBt4i5mFmcyCETnpe0QU+mvEl6CEiJvquS6fA
	axkqt7LJWD7JEfbg04azYWN9jQtiAgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=CB0T4VgP8JRmQAAeBpmvzC9Y2ARMbeVTzqWgn2c17L0RE30OwvX6Trjp3TeWO7Hwu5w0hP
	Rwprii258XX5aZDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E84A442817;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8ou/OJhOvWlUCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7993BA0B3C; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 05/41] bdev: Drop pointless invalidate_inode_buffers() call
Date: Fri, 20 Mar 2026 14:41:00 +0100
Message-ID: <20260320134100.20731-46-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1163; i=jack@suse.cz; h=from:subject; bh=IUvivkOnXAhLrZoa3cIuK0skAh9kHyc1wR94Cs3zoW8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5wvaEp5j2MB1rJFDbEn2Uwsbyoww6f0jWoa Faizb2hUY6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcAAKCRCcnaoHP2RA 2dh2B/9xB+CjcqghZSzN3eCyJyrzBXd7TJt+D2eXsF0P1iy9KZIU2VkQ+nbzKNEX7H2QcweU5E/ KyFUQEwn/IE9wUZ2xi6/7gBNlwMGOt+Qdksuo3DaJDxu9i0xFKu8Uii6WnboFBSnRRZcadd+zF9 CqaEjtsjh0NzkydOwwwc+gixsY+WSTcRTOktMcI609P+AyRcnUxuSURBU9xJZUasYHnlQrFc2j3 +dZ7RfkDrlJ92pPfK5RJlGJYHqje/7r8hKqPIo7QQZ3YeRE1vYwRXRR5DNvrAZWKhYVW5nS57dK n7mvmyhJS/jEc7l5YBYabvZY13PkiTo62Z8UYWhUTNxge7Qj
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spam-Level: 
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

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


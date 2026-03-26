Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA2B3BF665
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518906; cv=none; b=E7Bb8xBID12IRzddeYTB9Uov5+oNjY6I3J3ie52edxYZJPM494O2GCoo/JDyZg+KyPRCnLlzXBZHeR+SHuiGispcG7/RDco6DCEBuhkrlW/6JZd3F2Ik7Uf8Bhe6O7IFBfrYIfe58e6X3+Gxw3CNQ0/hUUV5RgsVbuBR5ltlu0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518906; c=relaxed/simple;
	bh=7NK1Luw5u3sFPoI2MABzxVh/UFbS1BdfliomKZSEhSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQTabTPdQB3ub2BvUh6pzVJS+87JBnn0UY/RVAyK9zcfnnF+bTx8ufZUqrutrEpVMg1NOakxSnhNqMuQ7g6WxF0iIVe/a0bB8fwQJwODmOjC65J4nv6nWQyIUTyuF0VbRsrRvIyUfuNuQAWTCyW+A5wN237ROfS1063ddQurwls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=j1W3Lwj+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zLp9BDkb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=j1W3Lwj+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zLp9BDkb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="j1W3Lwj+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zLp9BDkb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="j1W3Lwj+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zLp9BDkb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B7C2B4D262;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=j1W3Lwj+uEoS8aFrKeTVDJPYW72hkRf2vJn5hP1v8DJRKXyPA/DGKSQZrgq2NvkdbVTbbD
	5ESD2AguXcKfvWXc6T2v7RPcyUeA2G8aILDWcIG16IsgVJ6cJNfnUXUKj9b+pvb004Npix
	1gd48bfXQKWcaGY5bBI+fIK0Ia5XO6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=zLp9BDkby0P/CPnv8vfM0qp2HOKlcED2HspXzwmc+GSh3oHLojR5MxCbnA76CXYJ4IoDUx
	IX8LGkCjL1D7tDBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=j1W3Lwj+uEoS8aFrKeTVDJPYW72hkRf2vJn5hP1v8DJRKXyPA/DGKSQZrgq2NvkdbVTbbD
	5ESD2AguXcKfvWXc6T2v7RPcyUeA2G8aILDWcIG16IsgVJ6cJNfnUXUKj9b+pvb004Npix
	1gd48bfXQKWcaGY5bBI+fIK0Ia5XO6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=zLp9BDkby0P/CPnv8vfM0qp2HOKlcED2HspXzwmc+GSh3oHLojR5MxCbnA76CXYJ4IoDUx
	IX8LGkCjL1D7tDBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD5A94A0A3;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id khhIKnACxWmbYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 70AB7A07B2; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 01/42] ext4: Use inode_has_buffers()
Date: Thu, 26 Mar 2026 10:53:55 +0100
Message-ID: <20260326095354.16340-43-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1573; i=jack@suse.cz; h=from:subject; bh=7NK1Luw5u3sFPoI2MABzxVh/UFbS1BdfliomKZSEhSc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQIy322tQJD1bTpLOCCusW8JNc9TXDdWifJtU FNx1ADgBgGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCMgAKCRCcnaoHP2RA 2RT/CACYvdN3lGJhBVD/JiAhbPkyZucipsmsOLf44AneuLqHJM4Wl9XFzG8f1KtIvt7/zHgTG98 jIQ0mVhMwcYPk5SQcdl996xUwcEQ+rZJKPfdEJRMc4HH7f6bdWAgR2Se8xf3QUDFyhtk7JH5RIf A+B70fDJuJyEaiV2N88PDM9uHrLgSSEAJY0L6wcsvHzU1l35Pwe4guAYJwFsVf8R08qnVDIG5CZ FwxT6/WqAu9WbIUcZlhTIfsY+yrFEXAqnuQE31XgPg4eARSbVsNvjHRLZtwbrOAAxvqwXvtHsKc YYkM0KkUHCXLhiSfNL08tOis9FxZg3jUQrhCCUqSQayiAdxo
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

Instead of checking i_private_list directly use appropriate wrapper
inode_has_buffers(). Also delete stale comment.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c     | 1 +
 fs/ext4/inode.c | 5 +----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 22b43642ba57..1bc0f22f3cc2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -524,6 +524,7 @@ int inode_has_buffers(struct inode *inode)
 {
 	return !list_empty(&inode->i_data.i_private_list);
 }
+EXPORT_SYMBOL_GPL(inode_has_buffers);
 
 /*
  * osync is designed to support O_SYNC io.  It waits synchronously for
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 396dc3a5d16b..d18d94acddcc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1420,9 +1420,6 @@ static int write_end_fn(handle_t *handle, struct inode *inode,
 /*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `iocb` can be NULL - eg, when called from page_symlink().
- *
- * ext4 never places buffers on inode->i_mapping->i_private_list.  metadata
- * buffers are managed internally.
  */
 static int ext4_write_end(const struct kiocb *iocb,
 			  struct address_space *mapping,
@@ -3437,7 +3434,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (!list_empty(&inode->i_mapping->i_private_list))
+	if (inode_has_buffers(inode))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
-- 
2.51.0


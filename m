Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96852BD030
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014133; cv=none; b=o3D/faG8RRCwOsiTcxr+QDOd9zplTtEVwGLzsqVZTsfrGcbjW1AVhUV6/oI14HhcHEFP5ZJ1utKrccra2/kVXHRK7PaNz333Zl9x3FOEi8YL9bNtqbqWW+mkPQ38lUdQVHLUZ9UYUDU6IxHFRiTOog2dh9UY69EZvtR+RD3BQHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014133; c=relaxed/simple;
	bh=IYTZqBCm1tD1PPP3s+ylo8XGzMtfmmwAB1tK/qvuPJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kv1BAXW3HyhK4lCV0LZtedGTAoUK5IoNx+D2pP46SSrvs2PKUfUHq8Kw5Baq+esys5LsIHRfr+jLxRn9Ztgd1h0nAgzqYOUr+dejGDOVz7VRN060ufa1if79tlv9owOjCFkJ0TuqgVvsS7ioCnIqoyg7s1wD7+hcs2EHxlRphOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iT6rQM84; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cYJ+XKDg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iT6rQM84; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cYJ+XKDg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iT6rQM84";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cYJ+XKDg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iT6rQM84";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cYJ+XKDg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 11AD84D27B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdEtE8Oyvh+CNSYSgrJqlRwYXjIS8z0UXo1g7uFEF70=;
	b=iT6rQM84oA8Kt+9lJ9PF/nR7dpCMfysudtXkJXkbSURj0eNb/fEBHUtmKj4EMmXao3HcAS
	dAbdK18J8wGXAkM2u8QT4CuXP+/NMTHnBK0cBijNE8QxPr5q71FM3bnee8NOrbTy8lmBh5
	dZuOV0fGEMlgjNEwkaonmPfHd3AkD9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdEtE8Oyvh+CNSYSgrJqlRwYXjIS8z0UXo1g7uFEF70=;
	b=cYJ+XKDgdV6v3QxrjZOOrVZYa3kJFb7oEIKlM5re2j+ruMiWf5OZ74/p0UQ19ANJwRYH+/
	2TFbIu7ZZU75pTDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdEtE8Oyvh+CNSYSgrJqlRwYXjIS8z0UXo1g7uFEF70=;
	b=iT6rQM84oA8Kt+9lJ9PF/nR7dpCMfysudtXkJXkbSURj0eNb/fEBHUtmKj4EMmXao3HcAS
	dAbdK18J8wGXAkM2u8QT4CuXP+/NMTHnBK0cBijNE8QxPr5q71FM3bnee8NOrbTy8lmBh5
	dZuOV0fGEMlgjNEwkaonmPfHd3AkD9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NdEtE8Oyvh+CNSYSgrJqlRwYXjIS8z0UXo1g7uFEF70=;
	b=cYJ+XKDgdV6v3QxrjZOOrVZYa3kJFb7oEIKlM5re2j+ruMiWf5OZ74/p0UQ19ANJwRYH+/
	2TFbIu7ZZU75pTDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06F334281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sYWwAZlOvWleCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AA43DA0870; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 11/41] fat: Switch to generic_buffers_fsync_noflush()
Date: Fri, 20 Mar 2026 14:41:06 +0100
Message-ID: <20260320134100.20731-52-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=720; i=jack@suse.cz; h=from:subject; bh=IYTZqBCm1tD1PPP3s+ylo8XGzMtfmmwAB1tK/qvuPJ8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU51JlOGIVmZB5084E+ZmxrpHuXL0d/KarR0R KWhQH8o2UuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OdQAKCRCcnaoHP2RA 2eFqB/0YT4QyZZ/TN3MCJ4XAocwfwh4SC9cJ/LvBXonCJnq2L09ipDxhJ7ikK2axQ3mKQ2Onhqy 5GKjBsIHa+I8bFE/mzOrffGwIgxNZo2u0MQeJJdP28TCgfvqLM0OYuavyBhYmsb+SrE5hnbOOhk 6hO+aZy8r/xKWEZOD7OXlhsCQe5rRKvcLIjkIrQoHQBakTJMyRrXXqzwJpPLwvFmIeqHAIlU7BW SKsRgwSxtrqTEUaQYUk7Xlh9KzeL0p7YKA6TM08e+ahd1+BvxTLlh5W5sWqFN9QPKaL7gX+0p7k hjy5dDJRyrp0Qj/7Q+TcMHjTBaG3XkO3H5cqoy9l02tgUZyD
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

FAT uses a list of metadata bhs attached to an inode. Switch it to use
generic_buffers_fsync_noflush() instead of __generic_file_fsync().

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


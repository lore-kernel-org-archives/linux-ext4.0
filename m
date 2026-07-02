Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB88B3A6F04
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016490; cv=none; b=pmvoICHUhUuNoOHj4MQYneRDfR3YKj5+C16Ycj3Xf6CJ9E/uO8O++9jhRflmndGDRVT1UQiewURNvFvfkksPKajovz/vvubI+3Zvh3UOz6zDn6RD+tysHrZNbLcEM0kXDFCb0aZcGRrArz9GrOJtQg8juXbgJuGaRSX3Uq5ZWds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016490; c=relaxed/simple;
	bh=Cl6Y1zQ1UgfQu+fZVmV4rO4Ml1E0uiQ6sjZQ09h97uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4rAMjMvbwl0H/4Brv+D2a/vDo1wpsX/Rd/cNgQ4DfxXjzaN+UjFqj9BK2PL9d7zz3AiWaKRx03e+BlPBn688/j2KkZ/v0gm6U8zQowaxx4OvKHxhJ/ZB2VDWJVT5CnkNN34NM4gYAWvIe4LLz2BC3x2Kn1ibtycVXaKYhhPXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wxjSd6wI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZBGVP9nY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wxjSd6wI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZBGVP9nY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wxjSd6wI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZBGVP9nY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wxjSd6wI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZBGVP9nY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 37C9A7435E;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=wxjSd6wItRlHqPn04wSe33ofuYZZ3s33m053Wd9/fMBZsuwkMK3FUD8ep/LW06tTylJem6
	/Zu3BYh7bCvIZwus8KbNz+nvI+F5IMcIl0wODyxw67ULAYGpzLivqDncXxPYf+TTSLzpod
	bbNrfByWZC6fuCNKzVDGWsoHf2l+MPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=ZBGVP9nYngxbIxzd30kpBie/k2J1ghZ3Bu2LzNsQ86lwTdF99ChjcPpFo98QLLBhLcH+Ty
	IKZI4OHyjGlVb6AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=wxjSd6wItRlHqPn04wSe33ofuYZZ3s33m053Wd9/fMBZsuwkMK3FUD8ep/LW06tTylJem6
	/Zu3BYh7bCvIZwus8KbNz+nvI+F5IMcIl0wODyxw67ULAYGpzLivqDncXxPYf+TTSLzpod
	bbNrfByWZC6fuCNKzVDGWsoHf2l+MPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=ZBGVP9nYngxbIxzd30kpBie/k2J1ghZ3Bu2LzNsQ86lwTdF99ChjcPpFo98QLLBhLcH+Ty
	IKZI4OHyjGlVb6AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BDCB779AD;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0O6zCiGsRmoBGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 39034A10AC; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 10/19] udf: Use sync_inode_metadata() to writeout IS_SYNC inode
Date: Thu,  2 Jul 2026 20:21:07 +0200
Message-ID: <20260702182057.2832980-29-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1238; i=jack@suse.cz; h=from:subject; bh=Cl6Y1zQ1UgfQu+fZVmV4rO4Ml1E0uiQ6sjZQ09h97uQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwRZ0FmX5jJUv6nWOQmFvXkYPNn8NOJ0Spee 2OpBIjZoP6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasEQAKCRCcnaoHP2RA 2cB/CADxpi4GlC9mC1NbIzDoQb/X34Ml4Ypqb6d23xM8sFgByk5P/67R02Gh6dcUcC0YEJ4bJvC 3RPvmAYt9GcK8vlgwzl5eHNU39/8xdAnhH3cATYVbcyGaMAoSlfegNc0HbOrXO6rw+upN3McW7h 6W61kaKf7UVzehGJx9g8sR14qHnY80PmJHId3KoFobz/k9FEBhGnfur7KGQ0OLvR6xbDsebsJ0Y 7hhBItkqRBDNAodW8KZV9VHSiu+/DCbugjNLQSBixpV2hPoJSHPbWhsLFi4ZBPo0w1LzdoF9vMr 5gZP0ETEX8ZGuzuxHcTzdDFx87/hRK8ALFRPqCQYdDu4YbEY
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
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -5.30

When setting inode size we directly writeout inode in udf_setsize().
This misses proper writeout of other inode related metadata. Use
sync_inode_metadata() instead and move the flushing to udf_setattr() to
avoid it for udf_evict_inode() where it would be pointless.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/file.c  | 2 ++
 fs/udf/inode.c | 5 +----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 0748cc965117..57d11606a2a7 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -246,6 +246,8 @@ static int udf_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 	setattr_copy(&nop_mnt_idmap, inode, attr);
 	mark_inode_dirty(inode);
+	if (IS_SYNC(inode))
+		sync_inode_metadata(inode, 1);
 	return 0;
 }
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 05e61a65478c..600705f5edf9 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1328,10 +1328,7 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 	}
 update_time:
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
-	if (IS_SYNC(inode))
-		udf_sync_inode(inode);
-	else
-		mark_inode_dirty(inode);
+	mark_inode_dirty(inode);
 	return err;
 }
 
-- 
2.51.0


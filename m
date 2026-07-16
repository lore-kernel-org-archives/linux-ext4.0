Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D11A3101A9
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213789; cv=none; b=SLP4sN7Ij920e+qcF6gnpzYY6wDhSfYuEBXf3l4LmztshOMQq51247Ua2ma7L5nc3t3soMmlRMv7Lvb1RgXUfa0/K0fm3iyrvbptA/sacE08/L40Grj/uSZDojrrsEE4G6+rjpNBYb5qjvjAvdbmYnyYdPKfzZq7kBnbO6Z1Tvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213789; c=relaxed/simple;
	bh=Cl6Y1zQ1UgfQu+fZVmV4rO4Ml1E0uiQ6sjZQ09h97uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhW1uGHXqM8RErO3yG8fIMRANI7mWvSvVWYc5Y54sBbLuK6blOWoarpno1xWVQER49khf+kghj552U9vOt1yCoyAohUmHYEfwTjXsVz+ArgOAguG4m5PbjHyaIHuGW57yVUz2m8RkQcYJdUkLIF2oyv9oRLzEXrzuy2OURGQRGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hAO+BCb3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RdffkB2g; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hAO+BCb3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RdffkB2g; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hAO+BCb3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RdffkB2g";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hAO+BCb3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RdffkB2g"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C8DD789D2;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=hAO+BCb3eWz2zce2L7r6MdBGoMQ4sfXs9TeK3PkWbTMM65WZSSOsuxzYQq+yNF5S5aWHlm
	34iISPPfstXPZkaMki8YxZt0S5xp4FEI4CeMDNuEMvIdvIH+ziE4BML9O/oJsGUuGorWq8
	1wrFbRSmYLNb57jso9LV7wXZqqNtlbc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=RdffkB2gkdjaVIraV7KF4pKCojJP6Ozp6MZnAD3V9I7SrN164GWqFOiR2NhQPSEYR5nzyI
	zMptpuwBLR1fHJAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=hAO+BCb3eWz2zce2L7r6MdBGoMQ4sfXs9TeK3PkWbTMM65WZSSOsuxzYQq+yNF5S5aWHlm
	34iISPPfstXPZkaMki8YxZt0S5xp4FEI4CeMDNuEMvIdvIH+ziE4BML9O/oJsGUuGorWq8
	1wrFbRSmYLNb57jso9LV7wXZqqNtlbc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=RdffkB2gkdjaVIraV7KF4pKCojJP6Ozp6MZnAD3V9I7SrN164GWqFOiR2NhQPSEYR5nzyI
	zMptpuwBLR1fHJAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9492B779AE;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9OdEJAXxWGoAXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8BB99A0ADE; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 11/21] udf: Use sync_inode_metadata() to writeout IS_SYNC inode
Date: Thu, 16 Jul 2026 16:55:33 +0200
Message-ID: <20260716145527.3580300-32-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1238; i=jack@suse.cz; h=from:subject; bh=Cl6Y1zQ1UgfQu+fZVmV4rO4Ml1E0uiQ6sjZQ09h97uQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDoZ0FmX5jJUv6nWOQmFvXkYPNn8NOJ0Spee 2OpBIjZoP6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw6AAKCRCcnaoHP2RA 2eicCACtuOeu5UxRkdmwZcfoVPNU09fUjT4kMfIoPUHkZ2alx8XCxwLNS2nkaHmYQogVcW58bPI 9tfWhGyqksPnZHLvvN8Bdtsy3YGnui9F2EqB0blAxd23nw+YA6ulNP+lMgVEHk3ESfaynB/a3fC G1mHaLIHG4X2/etYRdP0wBmg1dGDLRgsnM3/5ciJqLibQECiU+AEyBMRzghAhX3pfeZOK13FmBJ dBncZltOjYUzCOD3FTBmYZLaAyPpq1800FmTgpBpezGAfD43xfcb/MQS/uN8IM4D2KXoMIUyPac gxvZM4JtaE3833JjfLMDawWcUGPXO+spO5whxTWMJ6SGjqGz
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
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


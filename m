Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC3542D753
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 15:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785944194; cv=none; b=mPFwkNbn+iInpRt/GpaDubo+bgQ1yD5aKDPsEqpwLC6BwJHA2zuvRJ4oFmdqM6jfSX2A97fHaUSJ7OXMHEPtpPPrgg9+kAjOwRlJGyZvK5lj9dbrQdg/zBDk/i9Siex5uD2XCGKCjfxZHxxQ6SQ4b7hqDUOXZ01cok86WTNqFkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785944194; c=relaxed/simple;
	bh=W0XSN1aTbUArKeBebPusRc/9Eh2ko13E/JS3nFf3VQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKRQGba47w+8DhPoX+8Dqb/bMYgP0CJgXtSunrJbDaotpb7ZWVX/27R0E7DRjrqAM8O//Pjw3F9/Z8zjWt6bGUksGHf33loHu6bJrptnevKF6BICxOzLRQb3dJwOvRJdsi/wDnbybG74HoFOLHy6pgVQwxJToED6D4zVSHcFuwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KViB5dZL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kGu6lFSg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KViB5dZL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kGu6lFSg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D22247F256;
	Wed,  5 Aug 2026 15:36:18 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785944178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzVKplfIZxWcHsn0m2jLkQcm7pfnkkBAnXcfEb49J4g=;
	b=KViB5dZLoiSLcH9usSVNcCSy5nphGRLG2eisGZIrujW+wkNp0FLcPIGBQ7Wwp8rtIiDbTc
	u9Fio0A7T8OCawZWZiRDZTgAUqM0qcTPXOLwJaIhSu/Zu/uJOXxxvzNgGa/MVc6xgTQrmr
	EzMhyF5aVFWEnYr0S9df9LY2vOB6aoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785944178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZzVKplfIZxWcHsn0m2jLkQcm7pfnkkBAnXcfEb49J4g=;
	b=kGu6lFSglnr024oQWAUD/1dx9/HlwCFxWEnTtewFb1tOOgJ6UEnTSmOBxMf3I6wu1FD04K
	RD20YHocWtIe6WBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4C1B779EC;
	Wed,  5 Aug 2026 15:36:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VyEEMHJYc2oCMAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Aug 2026 15:36:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 62205A13B3; Wed, 05 Aug 2026 17:36:18 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] ext4: Fix estimate extent index blocks in ext4_ext_index_trans_blocks()
Date: Wed,  5 Aug 2026 17:35:49 +0200
Message-ID: <20260805153605.166545-6-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260805153202.29814-1-jack@suse.cz>
References: <20260805153202.29814-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1156; i=jack@suse.cz; h=from:subject; bh=W0XSN1aTbUArKeBebPusRc/9Eh2ko13E/JS3nFf3VQo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqc1hn4NP/2K4mfCn/l/Iwaw5aeZQJdNlGG2L8N tjVizebzqyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCanNYZwAKCRCcnaoHP2RA 2ZGvB/wLAxba+8E6G8sJohSAWpODeNCiLwu+Dmd7qb8pWxKpMAjvWNswb7CPdyZiskSJyK8qktA Mu4I+3KcopYa7J7SyB+NS2EO4Uwg/I8n0geZbLZGYkciJ9iaEZbpT4XZOi/TLv8v37Mn301//Pn 2nO5QbjqVrf7WqDsFSGb6XWPXxSvA28zF4Rau29QJTmjt13iEOQtRrXc9TG+YVV7J4D2+CHHmFB DcGYUGsJBWxnjBk20M5GYmaYs4sUXCQP/GzHOhwzdbeewrZj3mXXbbpKDOcP2NTKtsVzAfH8GRb 61gb6Gh7PLMzZyRKs//dzjMsT1xy4N3EmNTER+ZNqhb7aqg0
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Queue-Id: D22247F256
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Action: no action

The estimate of the number of impacted extent tree index blocks could be
one-too-low. If we modify say 2 extents, already two leaf index blocks
could be impacted, not just one the current estimate counts with. Fix
the estimate.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 44ab246a3176..713b2c098af5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2427,9 +2427,17 @@ int ext4_ext_index_trans_blocks(struct inode *inode, int extents)
 	 */
 	if (extents <= 1)
 		index = (EXT4_MAX_EXTENT_DEPTH * 2) + extents;
-	else
-		index = (EXT4_MAX_EXTENT_DEPTH * 3) +
-			DIV_ROUND_UP(extents, ext4_ext_space_block(inode, 0));
+	else {
+		int ext_max = ext4_ext_space_block(inode, 0);
+
+		index = EXT4_MAX_EXTENT_DEPTH * 3;
+		/*
+		 * Modified extents need not start at the beginning of the
+		 * leaf. Already two extents may need two leaf block
+		 * modifications...
+		 */
+		index += DIV_ROUND_UP(extents + ext_max - 1, ext_max);
+	}
 
 	return index;
 }
-- 
2.51.0


Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893DA394498
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016495; cv=none; b=u7W4RSt6opxZu9GpMgBrqFrG8QRKmTxBF7vxvMgEll9nx3malMep855uYgZEozEg9n9X5+nn5b0FfXZtPgr1MlIFunFvO3DFW1xM501xaM6NUGHVTvoT9x2rlE56z9UX6Ku1vOH1lYOber8t/f5wLOxzkIwHA1108uf6C11RD5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016495; c=relaxed/simple;
	bh=2c8BVcZA/EPlKjnaeWd9jYCRiZaeXyt6Zg3HihfU3Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/T3vqm49vEZQlt2kcIVd3dXmcHcsSnbvpCPAcPc3j0wpo6/Q+Rqi6O4YRmVR68H50wJ4AQ9IlKOdK9C84+iCeoLsBkAeUyxnIPp0VVLDuB46ekJKQ8jbLlVjhO8I+2xIXJdpAkfYM4holuMabMwsrHQOpeKyhKr9SPmYHIKooY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SuK/CvTl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CsGvXcsz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SuK/CvTl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CsGvXcsz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SuK/CvTl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CsGvXcsz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SuK/CvTl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CsGvXcsz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4C51C7435F;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rC9hmEF437MFTeZo9o8MxESUTEUlfXTe3ifIMkHUlBI=;
	b=SuK/CvTlHDUL/zORYmxs+TEpcwdRj5oGHLIZM+EQtT80+y0OB0xTMdcU4gCqpuEDpq8ObN
	JyBnX+3/g9hpqxvxprdu4SLq1Ay25VOtgP7mi20o1KLJXDlcNuOIwR/hu2q59vnIk6/y+G
	Stcbeo0Hnsrrx47WXMMhoo74zTourug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rC9hmEF437MFTeZo9o8MxESUTEUlfXTe3ifIMkHUlBI=;
	b=CsGvXcsz8p+KPNbj6UZ960WSv+6IYRfD5pSl+G/aHw4mVcAmShLLB38XXcb5jiq7U772GT
	65bDc2jb82rTaTDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783016481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rC9hmEF437MFTeZo9o8MxESUTEUlfXTe3ifIMkHUlBI=;
	b=SuK/CvTlHDUL/zORYmxs+TEpcwdRj5oGHLIZM+EQtT80+y0OB0xTMdcU4gCqpuEDpq8ObN
	JyBnX+3/g9hpqxvxprdu4SLq1Ay25VOtgP7mi20o1KLJXDlcNuOIwR/hu2q59vnIk6/y+G
	Stcbeo0Hnsrrx47WXMMhoo74zTourug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783016481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rC9hmEF437MFTeZo9o8MxESUTEUlfXTe3ifIMkHUlBI=;
	b=CsGvXcsz8p+KPNbj6UZ960WSv+6IYRfD5pSl+G/aHw4mVcAmShLLB38XXcb5jiq7U772GT
	65bDc2jb82rTaTDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42FBB779AC;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6K1YECGsRmoDGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3E94BA10AD; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 11/19] udf: Write all metadata for IS_SYNC inodes
Date: Thu,  2 Jul 2026 20:21:08 +0200
Message-ID: <20260702182057.2832980-30-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1624; i=jack@suse.cz; h=from:subject; bh=2c8BVcZA/EPlKjnaeWd9jYCRiZaeXyt6Zg3HihfU3Qk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwSCrBVoL7LWOzcxbupWQur2+1poa32BHoM6 nYR6hm0cSeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasEgAKCRCcnaoHP2RA 2ZtyB/4rMTUwqDm2usEUg0mZ/unLVHi+Zfg8McwtBFSTcGRYzQVQMq2ePrcp3VQvHlPXIc01usW 2Lan4a3uxuygdVxGtNLX8N5LFJh3OgxnEBHUMPHAlqkRWdEmQwY15t7PX2WMnR47/gOfVKGfYq2 lU/05CDPmGPrzgblzdeID3W0akW2wO6nT39ZxNGhBcCyFtxhqF8qsLmAfCNC9/FKvZZhTZCkZFo Q9vMDoPwUPZzs7oiUYC+eHE1LgcI6L7dqGiS1JCIT6IyxwIQfpdTc98EBICFUxe1bbKLhZDw44B yKeWgKh/a8Qm5qB3yJ8nIOMsJ1vveAtgimQVtwvglLmbJ7p9
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -5.30

Currently udf_getblk() didn't write all inode related metadata for
IS_SYNC inodes. Fix the problem by calling udf_sync_inode_metadata() and
remove now unused udf_sync_inode().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 600705f5edf9..d5396d42df18 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -52,7 +52,6 @@ struct udf_map_rq;
 
 static umode_t udf_convert_permissions(struct fileEntry *);
 static int udf_update_inode(struct inode *, int);
-static int udf_sync_inode(struct inode *inode);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static int inode_getblk(struct inode *inode, struct udf_map_rq *map);
 static int udf_insert_aext(struct inode *, struct extent_position,
@@ -938,9 +937,10 @@ static int inode_getblk(struct inode *inode, struct udf_map_rq *map)
 	iinfo->i_next_alloc_goal = newblocknum + 1;
 	inode_set_ctime_current(inode);
 
-	if (IS_SYNC(inode))
-		udf_sync_inode(inode);
-	else
+	if (IS_SYNC(inode)) {
+		udf_update_inode(inode, 0);
+		udf_sync_inode_metadata(inode, NULL);
+	} else
 		mark_inode_dirty(inode);
 	ret = 0;
 out_free:
@@ -1733,11 +1733,6 @@ int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 	return err;
 }
 
-static int udf_sync_inode(struct inode *inode)
-{
-	return udf_update_inode(inode, 1);
-}
-
 static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time)
 {
 	if (iinfo->i_crtime.tv_sec > time.tv_sec ||
-- 
2.51.0


Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E9D1FC110
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785253673; cv=none; b=QpBclGTF69lEe5jsOXKukq0I9DWty+uXfS3yCMITgcOAiONGxCCY3lLYB3THGMQgVQjMT2ps2t/W1H0Wd6pYp4t+NU8bjRXP/REZ27PqCLB2GXhaKvifJRxcxgKc6OsBQmyrm0EktigPl4muJaNCUeWPRURY2JIjTErQmi2afF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785253673; c=relaxed/simple;
	bh=9MighwDBmVEkz+BSrzNZ3686YhC2cCGhQcTG4OcT/ws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s6udswtoFA8lX9EhrZx3ByVqqhMEgNGX79f3eLU0+1Q506FryEa5MK8ByBAsYWoVLVWREck8fWqpatVDc0Df0Mx14/wZh6ElD07u+7YFVSjbynzFSslAC7dUCY86DEQQrDxPvWI3/U5/TcADiMRrmvRFgm+iYmk/aTfU+qtTPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g9/mnICD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0HwmPXol; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hQU00c4n; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cwAN38Fk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g9/mnICD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0HwmPXol";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hQU00c4n";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cwAN38Fk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A65BC3E3A;
	Tue, 28 Jul 2026 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785253665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mzkse0k6ovFlmDfhr/Ci86Atq3wWcLnoIuyO0AKKiPU=;
	b=g9/mnICDTL5kolfnNAGP1CqQCSrU8H2FM4AyuIoxq6yqeqK4gx+/7bCGST8HpaWqk7vOCp
	HxuzMhv0Jko/u8uvML8ORsV0rWEFpwTIZC5ypN/+f4mgkrCZsJUU1/0c5UGaCsjqRSe9z9
	3H+qI/L3aoOOAsOnLPNJUo+36QwKeGU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785253665;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mzkse0k6ovFlmDfhr/Ci86Atq3wWcLnoIuyO0AKKiPU=;
	b=0HwmPXolu4i5LRir2xeBS2KXi4Ni634ZZ0PuDOVPqVrJXv3pP8kTP185r1MidbdjPxds/W
	m4ra4tPS4op9+QDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hQU00c4n;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cwAN38Fk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785253661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mzkse0k6ovFlmDfhr/Ci86Atq3wWcLnoIuyO0AKKiPU=;
	b=hQU00c4n4wjPDDHBk7seziGbTO1OFoPzGEpU7m0kVMWTu8X+GQguqQuT8tBfqtx3kBDTuB
	K+Z+JahFI094PamcVztbKEWMerhcUBNeQO7kw313VjOyfw3dr32eTTIO0KmRSqg5F8Pbrf
	uGmqE3kUPSKFz8WoDtirf1GwrruG8ig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785253661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mzkse0k6ovFlmDfhr/Ci86Atq3wWcLnoIuyO0AKKiPU=;
	b=cwAN38FkOt69EGQ4ZszAcPBKVIlaSJLoz10NR88ST+ah+zmwstIGdpm6VswX3+4hc8aIBp
	ZxaqTVq2druljhBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 967AC779B1;
	Tue, 28 Jul 2026 15:47:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1V5GJB3PaGpIYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Jul 2026 15:47:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3FD90A10B6; Tue, 28 Jul 2026 17:47:33 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-ext4@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Simplify error handling of IO error when adding xattr
Date: Tue, 28 Jul 2026 17:47:25 +0200
Message-ID: <20260728154724.3934977-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1571; i=jack@suse.cz; h=from:subject; bh=9MighwDBmVEkz+BSrzNZ3686YhC2cCGhQcTG4OcT/ws=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqaM8M+buluxh9pzTJUe2HzMYD0Ul9wZWGtP7io 0yovbVXzdOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamjPDAAKCRCcnaoHP2RA 2TSGB/44BxyWR0vOuh/xOj+fyXEpAu8Vv0T9IaVlW6rcLwhCZOebCvSeD7dbjzJtY4KBK2ottyf LTPHG0MLxUZi5MbKuetpYGuo7UQ/ipC5EaSehvQhYZ/mLx/5WI1OaMEx55xihqNbMWGV3NuJ9XK lXP/3stu7nuLVYgSenMKQ0VoxWC79Zc/IvtNCxUPa86hj5hxgbKxSFvOKwviyqpMyNMSlyBzVxD 0vTWDg2RpectA/3+ndPogz5+PlBt+CD4i7GpPDgh7d9WkhVU6/456ciYViDSDmcXfF72CQlSP1o uhGjc73FBYcba1y2aXkjI/zuOVwOwVrwehN3sGwOlZfbEX4U
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A65BC3E3A
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

When we fail to write out inode when adding new xattr block, we backed
out some changes (like quota modifications) but left others (like block
allocation or inode xattr block modification). Just leave the inode
intact in this case because we can hardly reach a consistent state and
defer fixing to e2fsck. Also remove outdated comment and special data
handling since sync_inode_metadata() does not write out any data.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/xattr.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

The inconsistency was notice by unrelated Sashiko review. I plan to merge this
through my tree.

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index e55d16abf422..5f49ec4afc36 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -779,16 +779,12 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 	inode_set_ctime_current(inode);
 	if (IS_SYNC(inode)) {
 		error = sync_inode_metadata(inode, 1);
-		/* In case sync failed due to ENOSPC the inode was actually
-		 * written (only some dirty data were not) so we just proceed
-		 * as if nothing happened and cleanup the unused block */
-		if (error && error != -ENOSPC) {
-			if (new_bh && new_bh != old_bh) {
-				dquot_free_block_nodirty(inode, 1);
-				mark_inode_dirty(inode);
-			}
+		/*
+		 * Inode writeout failed. Backing everything out is complex so
+		 * let's just leave it for e2fsck to cleanup the mess.
+		 */
+		if (error)
 			goto cleanup;
-		}
 	} else
 		mark_inode_dirty(inode);
 
-- 
2.51.0


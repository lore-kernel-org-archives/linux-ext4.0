Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F962EA75E
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772871; cv=none; b=kJGRocfsqg4li57Q4WizVQyJ7Mm8Ysg5Z9KZuFLLp0L+orjFmfM5jV7WqmqYipWT+4sWtabl4mKueFDhBQYAhXA6RBg9Lw0t5VhvJ0Fz6B8NCnXnMHZoc/noUUTMg1M5F/PfHsIV5Kwqfh0B8UfnEglA5CXWcFdaQem1hLi9PdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772871; c=relaxed/simple;
	bh=sekHJHB9BLsvILv81Z+FgnAW7bUWb7meHSSn3BVjeEw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ftlVb4wqFRNIB+HMgNMQMDdW/A7Mm+ffiiycGHVK1DgBr5rRuwN1u1Z2PvHcDupWyZDlrL0Bf7WY8SMATBHXImRchknf1VLLAnttYfIgM7tX9aqIxQI37913YzA6IDXZq30zdQOudTzwfgzfr/3uQQ5CBBWLwCbwH1sA20tyG64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bRrSYNmt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dsW/1JOU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Pxt7rDmu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MnugpAP4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bRrSYNmt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dsW/1JOU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Pxt7rDmu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MnugpAP4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9BDD03F22;
	Mon,  3 Aug 2026 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785772863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XwE4Qby+Tuk9c2iqJ86lM13ujyNjaqSXiVznp+Kt8/U=;
	b=bRrSYNmtA1wKFFfhK9YSfXtisER10qxQ2V0Tmgbgx6ouoomaGCyl6CxuTDAMNXj+RXczJ9
	QM7unSqa7dQo8qPCZnRrNS8zkBvBehJ76edBfJviD5eE5/nmCGQSP5sUqkzHO1jGMDd0Ux
	a5YuBV/Kqczb47dotYR3bo1RPDoZrjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785772863;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XwE4Qby+Tuk9c2iqJ86lM13ujyNjaqSXiVznp+Kt8/U=;
	b=dsW/1JOUnwHVx1geEqBM2czfFpXKLPiGFQ5WlCvmFE9HnWUIxQ86HxZG9AwoLsXzkiHxOA
	lT+srQimuCPL4cCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pxt7rDmu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MnugpAP4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785772859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XwE4Qby+Tuk9c2iqJ86lM13ujyNjaqSXiVznp+Kt8/U=;
	b=Pxt7rDmuHsj+WYYejPs2ASzzZ58oUCbr4owmezQKz9pQKd9GCqfWFW2BKUgRj/Hp/0edkJ
	v1hF91/qUb4+OaOtZlxP17dzW695g3G37kAt58ecZSZ9veS1EmDATQCVL9VSnEu5xBGfFG
	zBZDrHtI9hAj4xq1hflDeIj6YULgtpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785772859;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XwE4Qby+Tuk9c2iqJ86lM13ujyNjaqSXiVznp+Kt8/U=;
	b=MnugpAP4ZOCwn/rrN8fMszsJkr2bIBXBEnAbLYKayvnHTVC2q8CpKGiTXbsjjskWloibGM
	v5n41LFebdOHo9Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FB51779A1;
	Mon,  3 Aug 2026 16:00:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TVYRIzu7cGrCHgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 16:00:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2600DA13A4; Mon, 03 Aug 2026 18:00:59 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
	Tigran Aivazian <aivazian.tigran@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix spurious message about orphan cleanup on RO fs
Date: Mon,  3 Aug 2026 18:00:38 +0200
Message-ID: <20260803160037.64285-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1203; i=jack@suse.cz; h=from:subject; bh=sekHJHB9BLsvILv81Z+FgnAW7bUWb7meHSSn3BVjeEw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqcLslhRo8X56bKbmU15JCqAXQJr2b3nOsRkCEx RDyNF0k7auJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCanC7JQAKCRCcnaoHP2RA 2YELCAC2W9+zayBM6MWF49szF1AXg96L890XfJH+mH0y11Qvc1UO9yrCtqBzfv6whxvlMRf4ptX cp0Jo4VNy7wVMJRLbWgyr4JFR3VXxyqoO9q9w3cHycIOYB25U+I6Np8ai/xpHTFTlI4Vqxk/aQk dp+CRuRjjkjySR6MiaKtFtMG8P0bXo2U7mM8HJxB49LwahDE2Fb1B8L3tMqlamhpfqexHyhqk9/ RcrRVTfdPVsLpI7dZ38esM6D0PgJwZfYorkWqIhS3CiWIn2nKIks1iBwQkoWFzVyvwOvSN/m+gC R+jNbssp6JyjK5LSA6LvwFG5CGaTmPlB/YF48HQznQH3uBH1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9BDD03F22
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:mid,suse.cz:email,suse.cz:dkim];
	RCVD_COUNT_THREE(0.00)[3];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

When orphan_file feature is enabled, ext4_orphan_cleanup() was always
walking through the orphan file looking for orphan inodes. This is
mostly harmless but for read-only filesystem it results in spurious
"orphan cleanup on readonly fs" message and in other cornercases it
could result in similar somewhat misleading messages. Skip orphan
cleanup if the orphan file is empty to avoid confusing messages.

Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
Reported-by: Tigran Aivazian <aivazian.tigran@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/orphan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 64ea47624233..2a44998a6c2e 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -388,7 +388,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 	struct ext4_orphan_info *oi = &EXT4_SB(sb)->s_orphan_info;
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 
-	if (!es->s_last_orphan && !oi->of_blocks) {
+	if (!es->s_last_orphan && ext4_orphan_file_empty(sb)) {
 		ext4_debug("no orphan inodes to clean up\n");
 		return;
 	}
-- 
2.51.0


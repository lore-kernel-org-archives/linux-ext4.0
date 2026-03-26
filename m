Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054BB3BF677
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518944; cv=none; b=MlHkar0lx+s4IYofkaqUJO95g6tRdQaMXONqw5gXfEL8CTNEfhclZB9uXP94+EGoOkJgS/Oaf8RXpADNxW0QPAt1efL8yaxC2v01XFbeVEghmfS6G7jIbZ+hGscFI+uzZXTKqEF3jSJm22bYuSDOdHATAo12mcCn9lTPss7C94w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518944; c=relaxed/simple;
	bh=SmSUMyHwm0K50cHCdMR4KDamoJmEJMkF3+TUKO5XXw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYHZyWPGTi7n6pwL/O5k+/VL7+pgeKLIuVsFrN6EziiMAFaL13UGVYgADlF1lSfL3N+SSo9Pt5d0U+MLjgj2XsjDdkXsHAycXywVGJJiolqyulWMOfoYq+DrvE5VzXC3qG5aynzVYLgkkmNj/YCMoshtm46Upj33F/jcGN+SD1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=auK1kjzn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5H3HM+XA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=auK1kjzn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5H3HM+XA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="auK1kjzn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5H3HM+XA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="auK1kjzn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5H3HM+XA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 287044D27D;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WZrCR/hrplAz7CrGGN1pyhuwAsW6VsYXtl7pMQKKRw=;
	b=auK1kjznc8woJpI/n1LKgos6QwI1I6y0MERfu6eLryJUXVAS124LSfTUWiKLYubLzycEBb
	2jMjsnTHhRDGpKF8DmHyt7+Ljje3jVKGSpJcbPuC8tt70StMXHHRq7XyJqXsG7rtje1wf6
	67sA8T7d7Eyi1eFexVywXA0wcDwc+ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WZrCR/hrplAz7CrGGN1pyhuwAsW6VsYXtl7pMQKKRw=;
	b=5H3HM+XAu7TWqcD89+9dRZxM2u/Ku6EXFTRqEIUa2Nfsy5msTGcrycCJMF6lavtEtUmf+t
	ok9PcFHa72SxyTBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=auK1kjzn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5H3HM+XA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WZrCR/hrplAz7CrGGN1pyhuwAsW6VsYXtl7pMQKKRw=;
	b=auK1kjznc8woJpI/n1LKgos6QwI1I6y0MERfu6eLryJUXVAS124LSfTUWiKLYubLzycEBb
	2jMjsnTHhRDGpKF8DmHyt7+Ljje3jVKGSpJcbPuC8tt70StMXHHRq7XyJqXsG7rtje1wf6
	67sA8T7d7Eyi1eFexVywXA0wcDwc+ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WZrCR/hrplAz7CrGGN1pyhuwAsW6VsYXtl7pMQKKRw=;
	b=5H3HM+XAu7TWqcD89+9dRZxM2u/Ku6EXFTRqEIUa2Nfsy5msTGcrycCJMF6lavtEtUmf+t
	ok9PcFHa72SxyTBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 198254A0A9;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YF85BnECxWm9YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DC155A0B99; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 13/42] fs: Drop sync_mapping_buffers() from __generic_file_fsync()
Date: Thu, 26 Mar 2026 10:54:07 +0100
Message-ID: <20260326095354.16340-55-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1452; i=jack@suse.cz; h=from:subject; bh=SmSUMyHwm0K50cHCdMR4KDamoJmEJMkF3+TUKO5XXw4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI9kheGDEUE8Z4bg0Qcp/ntGv/hibVmPm3jL c7I6LLeBhuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCPQAKCRCcnaoHP2RA 2eBxCADEaMdSYA4l5xrhxMIj9bv0RkgmP5xWyow8IlNUpzdPlJZNknDMp+bQFC7PrZPd51YrSfx bnumNmF6zOsfs6YEaB6QAmg/PdRy+qvkjxyzr+6qKVrLWxeHm6HOvcVSmUPklnyh52tYvaowSS/ AL32Z6DUEfinD3ZJzIaeH97p09oAr7SlUTNBHs1u6DKNeKBSocDmHRAlyr4boaegHi72x0WROFJ VTOXNurjK3Ho7Ddw/mPoJqcLbQ2EgqkczK94Oulhgu/b3rmKFmMg7a9MTUVzcWcO69bSV8clW26 AMe8xZ3pQVSvll+FZYpQQKq/nW9UB39vZXjlKwMDVv9O2hyy
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
X-Rspamd-Queue-Id: 287044D27D

No filesystem calling __generic_file_fsync() uses metadata bh tracking.
Drop sync_mapping_buffers() call from __generic_file_fsync() as it's
pointless now which untangles buffer head handling from fs/libfs.c.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/libfs.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index ed7242d614fe..e67e43c6509a 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -18,7 +18,6 @@
 #include <linux/exportfs.h>
 #include <linux/iversion.h>
 #include <linux/writeback.h>
-#include <linux/buffer_head.h> /* sync_mapping_buffers */
 #include <linux/fs_context.h>
 #include <linux/pseudo_fs.h>
 #include <linux/fsnotify.h>
@@ -1555,22 +1554,18 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
-	int ret;
+	int ret = 0;
 
 	err = file_write_and_wait_range(file, start, end);
 	if (err)
 		return err;
 
-	ret = sync_mapping_buffers(inode->i_mapping);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
 		goto out;
 	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
 		goto out;
 
-	err = sync_inode_metadata(inode, 1);
-	if (ret == 0)
-		ret = err;
-
+	ret = sync_inode_metadata(inode, 1);
 out:
 	/* check and advance again to catch errors after syncing out buffers */
 	err = file_check_and_advance_wb_err(file);
-- 
2.51.0


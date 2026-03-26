Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93763BF695
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518918; cv=none; b=lusOthoHORdaDBmnn5ZkwaZG8YJjg4QfF87LA6k14yFOAi2WlHMfTf6jaENk1cBMfZdis5W7/m/do6/avdj8k5MhzByzM9wP/qUxdgCWfIxy5jngH97uBzmcGWcnrjRKJFS9zgPWueO5HlZ/KnJo8rMXh3cwffkUPFnUG4viyEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518918; c=relaxed/simple;
	bh=6btBYXD3CG8Zu0REp7+lJBoMAR4l7z61k8aJXBh/SdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsuKs4fALEJ4rQ9dDBWROSgJp3rKv+rgGpFOCcsBrLnVWskOiogoS3ehg0iLaQBmp7xqQEJhT7+QNYyiwr1K9IVAGdbCWq3eafX4Bee7uejmumUkO1PBsX8W2PuF/9hBCNA/UGg8zzD6IlcJY9RQrBKK3EugXwzRUiWScmjI2+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rh5Eaj77; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YSIeS9QD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rh5Eaj77; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YSIeS9QD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rh5Eaj77";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YSIeS9QD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rh5Eaj77";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YSIeS9QD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1DD2E4D27B;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3XYcErHwHg/PksF4q5SSaXTE0T6XapUIZBm1jCNY+g=;
	b=rh5Eaj77oQMPRiCLJ27mNVcvqUb37MkyHlC4EAMpSUdiblxNrs/QUGj2c5/bWGDj+HCWi0
	DFLoLc0s3JY0fp76QJ2Mn3p6ua5Hr26i5+ACKpHaODucvmA1fiTnYon1vIvCttZPShywdN
	EvQC6SnRzKgm4fztTgCKCsMcGfs3mlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3XYcErHwHg/PksF4q5SSaXTE0T6XapUIZBm1jCNY+g=;
	b=YSIeS9QDstfnr9EM6xN2LdfYnda8RgQRKcnWfVqYRxhxdPxMGfULB/G5JR9BBPuIP/JDYm
	7pniZbkkzYhSZyAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rh5Eaj77;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YSIeS9QD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3XYcErHwHg/PksF4q5SSaXTE0T6XapUIZBm1jCNY+g=;
	b=rh5Eaj77oQMPRiCLJ27mNVcvqUb37MkyHlC4EAMpSUdiblxNrs/QUGj2c5/bWGDj+HCWi0
	DFLoLc0s3JY0fp76QJ2Mn3p6ua5Hr26i5+ACKpHaODucvmA1fiTnYon1vIvCttZPShywdN
	EvQC6SnRzKgm4fztTgCKCsMcGfs3mlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3XYcErHwHg/PksF4q5SSaXTE0T6XapUIZBm1jCNY+g=;
	b=YSIeS9QDstfnr9EM6xN2LdfYnda8RgQRKcnWfVqYRxhxdPxMGfULB/G5JR9BBPuIP/JDYm
	7pniZbkkzYhSZyAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B9334A0AA;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ruXTAnECxWm2YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AF625A0B6A; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 08/42] fs: Remove inode lock from __generic_file_fsync()
Date: Thu, 26 Mar 2026 10:54:02 +0100
Message-ID: <20260326095354.16340-50-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1587; i=jack@suse.cz; h=from:subject; bh=6btBYXD3CG8Zu0REp7+lJBoMAR4l7z61k8aJXBh/SdI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI4aXoWg6sS4/RklZ4gga8GPc3ktWNdpYKXn klIuUDC3cqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCOAAKCRCcnaoHP2RA 2fJiB/9Qd50NWkp9GGrCACr+k41/RaoDpO8qA8DdAMYeUWbk85BUas6rlqOAJOtSjVoc4DKmuD8 E0d7wAHaX+xEnMhfXMFYCgpKvNTWMSNPAyKmw1DwiBZ8119AR0Z2qzXmA6/qUHFYuqZ1pr9wB/C 9zmvOyT0O7ChITVb7sRzBEl19tOLbrQJL2JWjucy2DEQ0bFahd8nXH4nhn4BVyiRhegMIyaaBsI /xkreng6fLOrvK0uGR6O58gPYfe/ly9cWfuDXW8WVwoqnI5O4/ldEzkRlXYRLiAWEkQmk/oeqen l1c6vinH7j/3ohOVzxVrcyErD8PO/TxCEeW/p+2a3636aqEG
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
X-Rspamd-Queue-Id: 1DD2E4D27B
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

Inode lock in __generic_file_fsync() protects sync_mapping_buffers() and
sync_inode_metadata() calls. Neither sync_mapping_buffers() nor
sync_inode_metadata() themselves need the protection by inode_lock and
both metadata buffer head writeback and inode writeback can happen
without inode lock (either in case of background writeback or sync(2)
calls). The only protection inode_lock can possibly provide is that
write(2) or other inode modifying calls cannot happen in the middle of
bh+inode writeout and thus result in writeout of inconsistent metadata.
However if writes and fsyncs race, background writeback can submit
inconsistent metadata just after fsync completed even with inode_lock
protecting fsync so this seems moot as well. So let's remove the
apparently pointless inode_lock protection.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/libfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 74134ba2e8d1..ed7242d614fe 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1561,7 +1561,6 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 	if (err)
 		return err;
 
-	inode_lock(inode);
 	ret = sync_mapping_buffers(inode->i_mapping);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
 		goto out;
@@ -1573,7 +1572,6 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 		ret = err;
 
 out:
-	inode_unlock(inode);
 	/* check and advance again to catch errors after syncing out buffers */
 	err = file_check_and_advance_wb_err(file);
 	if (ret == 0)
-- 
2.51.0


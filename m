Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C8F388384
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518989; cv=none; b=pkJdXl4I6bWIF55p/TQ1bMyi5Lx5epsDLGXB81vCEmyekPPDrG+IApzz7/ND3FAcp4SxqVkkmPgEOd0gtsEFMXe4YroRxm5MARyN/aZnLNRqFr0wxM6w6xGW/zgQX2N9BUmTYMqNMd7cx/Aja+itdXOFG+tiyJYnE16FSebyFsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518989; c=relaxed/simple;
	bh=g9XgltzhqZEAFeB2kTfq2H5zg7Kg1FLbfHn4nC/1sQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ6QxlxDQa0sgf1IuN6VQjAF2DFN/7xIVxZS/JULMHpvgFC+m8hb45SCW3Ioy8sZyWrcTJQsnfeV0Ya/9v7dadWf1Q2Mf9JCIT5TFg0fKnL4NadyDmjMV3X/z0SN0owneaD3vZ0DJ5J12ch8/rUdAaUWF2aK52HZCmbFV20Q/Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=b08ZOEfJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pShrlopN; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=b08ZOEfJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pShrlopN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="b08ZOEfJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pShrlopN";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="b08ZOEfJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pShrlopN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5E82D4D282;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqluYAMrm+dlJHnbDot2ZiSjiPqYlwY3anHC6KE3E/0=;
	b=b08ZOEfJtM2Ynt1u5G1/GAbwjMwgKPUxST1wMsTKKpdcjD2NhN5EBV29T+ReboLfn+MmGL
	ZMxyS5iQg+/k52/6RQL05KRL1liFfFYFYexTTvl1PUutVDhlPNdG79umPVg9JQSNDNI80/
	G4y7nRrXpMt8XlrXkh56jkt96/FoOmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqluYAMrm+dlJHnbDot2ZiSjiPqYlwY3anHC6KE3E/0=;
	b=pShrlopN7+EXYPlUD6CGFrvOK+DfsalAJqLpwNhE9jvBQprSz5I8bxfdPeZwtXEzz6000j
	Z9EJrP0bzadH50Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqluYAMrm+dlJHnbDot2ZiSjiPqYlwY3anHC6KE3E/0=;
	b=b08ZOEfJtM2Ynt1u5G1/GAbwjMwgKPUxST1wMsTKKpdcjD2NhN5EBV29T+ReboLfn+MmGL
	ZMxyS5iQg+/k52/6RQL05KRL1liFfFYFYexTTvl1PUutVDhlPNdG79umPVg9JQSNDNI80/
	G4y7nRrXpMt8XlrXkh56jkt96/FoOmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqluYAMrm+dlJHnbDot2ZiSjiPqYlwY3anHC6KE3E/0=;
	b=pShrlopN7+EXYPlUD6CGFrvOK+DfsalAJqLpwNhE9jvBQprSz5I8bxfdPeZwtXEzz6000j
	Z9EJrP0bzadH50Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53C934A0A9;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S+RzFHUCxWncYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4319CA0C6A; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/42] fs: Stop using i_private_data for metadata bh tracking
Date: Thu, 26 Mar 2026 10:54:17 +0100
Message-ID: <20260326095354.16340-65-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1907; i=jack@suse.cz; h=from:subject; bh=g9XgltzhqZEAFeB2kTfq2H5zg7Kg1FLbfHn4nC/1sQ0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJFlCxxMASB9vH5ojG/AQXJTk5+dWsWbkKGk Hlm4JCwJcGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRQAKCRCcnaoHP2RA 2WDdCADNYweIxmM0eVGSwoohilwPuv2PxZEG08lAogRGbzNRzWGerA4Mb3r3SIaVaN6KXstCic+ RDMoS444Vyc09q/RiYPAqF3c9bOmL+ZCB63WVEcjlbi8T3+va2aOS5qTLGuySE5eJPrXtidm9z9 CIovP2aCrQp583wrhwlhLnOvLiUFJtljPh2LPhFqc3z4I2kPIrksXMze7nXnSdxToqoBZmSNtGq LVHpniSiQlAKoe8r2sFl+lwKHkSLndQKMkmMk4XST1yIU/ZdFPbuszGqy6gHnJbPo8WV/H/zISo PMoXZpIihwTQfvnOnwoAamOEUXbGz4ZzoydP3mzKoPSXVbLZ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz,lst.de];
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9),to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

All filesystem using generic metadata bh tracking are using bdev mapping
as a backing for these bhs. Stop using i_private_data for it and get to
bdev mapping directly.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index bd48644e1bf8..c85ccfb1a4ec 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -574,9 +574,10 @@ static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
-	struct address_space *buffer_mapping = mapping->i_private_data;
+	struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
-	if (buffer_mapping == NULL || list_empty(&mapping->i_private_list))
+	if (list_empty(&mapping->i_private_list))
 		return 0;
 
 	return fsync_buffers_list(&buffer_mapping->i_private_lock,
@@ -679,11 +680,6 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 	struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 	mark_buffer_dirty(bh);
-	if (!mapping->i_private_data) {
-		mapping->i_private_data = buffer_mapping;
-	} else {
-		BUG_ON(mapping->i_private_data != buffer_mapping);
-	}
 	if (!bh->b_assoc_map) {
 		spin_lock(&buffer_mapping->i_private_lock);
 		list_move_tail(&bh->b_assoc_buffers,
@@ -868,7 +864,8 @@ void invalidate_inode_buffers(struct inode *inode)
 	if (inode_has_buffers(inode)) {
 		struct address_space *mapping = &inode->i_data;
 		struct list_head *list = &mapping->i_private_list;
-		struct address_space *buffer_mapping = mapping->i_private_data;
+		struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
 		spin_lock(&buffer_mapping->i_private_lock);
 		while (!list_empty(list))
-- 
2.51.0


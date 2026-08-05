Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400AA2E6CC0
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785944198; cv=none; b=LjhZWNzIOBMvwrRsloo5Nj/m3TYZqjDfkCaTFNGb1MzG4W/vsnCWouPMMW9ZB4Ug/9ubz/45Jy+Zhd4xIxbl8EyP8lENDfvRaNVMfCDpRTzBGnA0wU2//u7FAoTHXGFJ5PShCqc545I6nJcZwCryolAqV1g0bm2UbQ/GTxVB3Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785944198; c=relaxed/simple;
	bh=rePuVksYGfP74JghnHsdbP/upRwuzpsxp7Eg33RmGpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNkmvrpCvfAczNf4vPUebL7zUjeRSsP2XQ49BmaKGCgbUxmQs71nRX5lkSluT/RmAcO23STG/2kLVN/xwIIQS3b1cPg+x7+r+nJONylsSGlfo0MRY148D3WVQIFTgFZtseI46bE+FVr2i6yKkc/Qyqr0j2dqks78xbaoOxuMxww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T/otDaw5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9wvvpBmQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T/otDaw5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9wvvpBmQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B6C873DFA;
	Wed,  5 Aug 2026 15:36:18 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785944178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A6VqGK18NLDzM6T7bqsSS/TlzOd204eKWAPhCuroDzM=;
	b=T/otDaw5+Deq09f7M/2p87oNu1oR8wucaEumEj1m9lMqGWgcavalruH+vBo/HrfHKzXn35
	HcLg+uxUR33MuJB5A/vB/WCAq709ig/eIfeKnphJdXXp7xwrMRcrtR56nY+qinuwj+KTxS
	MjXMA+zFhwzn6mpZKpnSJsESGDbr4mg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785944178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A6VqGK18NLDzM6T7bqsSS/TlzOd204eKWAPhCuroDzM=;
	b=9wvvpBmQymxFHS1PBqGyeDanzvylWheKT+npUo2y00EVmRcv/0ez7HeXrwHNSw4UyRplDZ
	nEIU272BkdCC2YBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A9FC0779EB;
	Wed,  5 Aug 2026 15:36:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9LZ8KXJYc2r7LwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Aug 2026 15:36:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5D4BAA13B2; Wed, 05 Aug 2026 17:36:18 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] ext4: Fix transaction overflow during writeback
Date: Wed,  5 Aug 2026 17:35:48 +0200
Message-ID: <20260805153605.166545-5-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260805153202.29814-1-jack@suse.cz>
References: <20260805153202.29814-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1702; i=jack@suse.cz; h=from:subject; bh=rePuVksYGfP74JghnHsdbP/upRwuzpsxp7Eg33RmGpU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqc1hmDw6LASdlInNlIJDDNXQaXsm+Wiu6hZ+Ab 7pUlEk5zZ6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCanNYZgAKCRCcnaoHP2RA 2SQ9B/9TrAVcS1j9oNp4zUccPzpa3ySeqX/mZBBoEuAzlk4hTUDqTQPp0aX+TqNVjSI2t7RH4vZ 21Rzax8Z+3Ztplrhy8/Op4irg70EXLqqKmx4xbuLCo84YkKyKBNbBUs80i032ItTe+Xq11GsQlC IP3JaKpaYkgy19ixZXdb6BULO6zuTbKmIysFV0R3LS6QtJCHSmTC2y0WpFhrJ6G6Jrpj2ul+qFN +qpLxDj996bSxiCsd7Qeel5X2jLhPqOvRNL2UzX9L9/RkO6AbmzJ+FkhWjDGB50aBJUZOXQELtm /fdwMvcWn+rc8jWPSKbFYOFh5NRqQ9KPJbdd4Xy+LKQQTmUv
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: B6C873DFA
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Commit 95ad8ee45cdb ("ext4: correct the reserved credits for extent
conversion") was correct to note that we need to reserve enough credits
for all extents possibly underlying a large folio. However it was too
eager to reduce the number of reserved credits. Extent conversion may
not only need to touch several leaf extent blocks, it may also need to
split extents - for example a single large unwritten extent may need to
be split into many small written ones in case of sparse folio dirtying.
This can thus result not only in extent leaf modifications but also in a
need to allocate new extent tree nodes. As a result the reserved
transaction credits were not sufficient in some corner cases. Use
ext4_meta_trans_blocks() for correct upper bound credit estimate.

Fixes: 95ad8ee45cdb ("ext4: correct the reserved credits for extent conversion")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f324a54f1dae..ddce319e53c5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2852,10 +2852,10 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	if (ext4_should_dioread_nolock(inode)) {
 		int bpf = ext4_journal_blocks_per_folio(inode);
 		/*
-		 * We may need to convert up to one extent per block in
-		 * the folio and we may dirty the inode.
+		 * We may need to convert up to one extent per block in the
+		 * folio.
 		 */
-		rsv_blocks = 1 + ext4_ext_index_trans_blocks(inode, bpf);
+		rsv_blocks = ext4_meta_trans_blocks(inode, bpf, bpf, 0);
 	}
 
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-- 
2.51.0


Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF32947B403
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 15:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785944194; cv=none; b=E0RL6xOL9lX3EFrXazgVJWfhuXpfZfNHecDrs5Y6vDSZwpr/ONz9l0263/3lf9EUAIeZIqAvOTSZXmTRnPkih9duR/hRqBMd3k70+edBp3hevqqEuJ6JuMs3Ho0S2vs4yloDDw9dFDR/pntSNAiuKxGOkkldCFXLCjW34LGA2vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785944194; c=relaxed/simple;
	bh=YvDikl1HW4httYH1bCJ3V1lTzvjC3o/yQOfJ/ld/DGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bo0Lyqo+s30d1mAQmLAWYxo5g6Jnnzq67OHIYhl7FF9eKjILqDHbZ0ueC532nZrZ6MOTrqr6rG3QuT6BUoWDbB2PTU6PHRZqom/8b24p7buzhDXt6v4V3AQUreAVLNvXe6B1pI1nf5VpagC2zO1k2KIfseTW9RccXKBMDFg8Rxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=g0c/WQqX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iwAskJ3U; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=b+vYJb4J; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+DHqWiqy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="g0c/WQqX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iwAskJ3U";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="b+vYJb4J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+DHqWiqy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E40707F251;
	Wed,  5 Aug 2026 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785944181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9lCEypuTyvaLbhLHYWPDCap6Ip2GqSuw7yIMneX0VrQ=;
	b=g0c/WQqXzuCmbLaxnXQFYSD4J+GypCzNvNQZCEAY5SGDFM1k3sYnasVoxGxdt8POrPBW77
	snnZdQJ19+WqWB4nTzAkx4WpqDFeXlD5c2qlpaklt6MDiclaLgpa4r+n1WnbOxQM3UaF05
	QU+2x/MterwuRVWUSlE1OkAcEOIabDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785944181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9lCEypuTyvaLbhLHYWPDCap6Ip2GqSuw7yIMneX0VrQ=;
	b=iwAskJ3UDsxCsmjMlN6HcAA+OlLyq6KwNfPs5w58n1BQs0q8wjCnTqik4xZ/IHvGHO9E5K
	V2SS7c0Qh4qMZwDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785944176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9lCEypuTyvaLbhLHYWPDCap6Ip2GqSuw7yIMneX0VrQ=;
	b=b+vYJb4JlwMHmXbbApHcsarUct2oJwIgNLFxqd3+W4ZxdMVkpQWkALM2wJtfbvgpePLzUm
	d//06OnI+AGf9A9pTMnMgjfChWcN/UlQnzo6CdEDDdc9cWKULuL2/XWLSw7Ij40fxTSYNz
	mBoybWQVhYXh3louciU0cywPGfCJqBQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785944176;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9lCEypuTyvaLbhLHYWPDCap6Ip2GqSuw7yIMneX0VrQ=;
	b=+DHqWiqyJ3OP7GuUo6duab/lfZFPyoTz5MCe6eMaPmwgIZoTq0/BJA4XcJRNQtMRsBmhS8
	PtxWzlNytlGXkWBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6ACC779C2;
	Wed,  5 Aug 2026 15:36:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sM77M3BYc2rwLwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Aug 2026 15:36:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7A2A6A13B1; Wed, 05 Aug 2026 17:36:12 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] ext4: Fix credit estimates for extent tree modifications
Date: Wed,  5 Aug 2026 17:35:46 +0200
Message-ID: <20260805153202.29814-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=313; i=jack@suse.cz; h=from:subject:message-id; bh=YvDikl1HW4httYH1bCJ3V1lTzvjC3o/yQOfJ/ld/DGg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqc1hRawewkchh8/WkgqMRZu6R5RKHektF3mxd6 x8M72WBE8iJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCanNYUQAKCRCcnaoHP2RA 2T2WB/9i+t9ETrMP/fcdwLulYcnxrd8Y/UqxLVFT0Joliig6LjGbDejBD6irQO1njEJbkudW1Ag /7EUdNB/q/G0jl4hLSwNKWYciWvH8Hn3219N9qgVH4RyFXqz5McTv/1DEtOUIL7A7MBPWbLIG1k iOLigW6Lh7lFhbfE9S4D/BfFKtchQjrL56UGw+eotg3pX/HJZM3MQrn9JcXlxPq9ADS1QCrtsAp hB9UpPueNQsdaK+5Z/ff2zB18ZTamTlYrfgYUV0ihAhmmnBTYOZjWImPktUngqndaFB2BrJhuzJ T5nGxbnA1ztGdELbXk4sZU5beUx/+UaiWGhyBYlbSw6Fq4pY
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,linux.alibaba.com,huawei.com,linux.ibm.com,gmail.com,suse.cz];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

Hello!

This patch set fixes credit estimates for extent tree modification during
convertion of unwritten extents on writeback completion. Otherwise we are
occasionally seeing assertion failures during extent conversion in end io
completion callback due to insufficient transation credits.

								Honza

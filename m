Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BC43C8706
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519001; cv=none; b=QW/9xwnSAA6sCEOpID9bwEJH5ilaH62i47FLKxaYqVoyqXnS0/1Ds7PSEdvMoLeVbraYjrMyAcwkMIcmYzTdklIcOUADhxjrGG8Nk7J1/gmDIx+FeF712xA2Ai2CY5Aq4MJCuKJpaEkhC0Bc53vkYhaEH8k2xkYV7OU+aI/6Y8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519001; c=relaxed/simple;
	bh=K9wrCKmeO7BfHLYf4wsyZtDcyuSx9fmOTys9wQHOC9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jflESy8CW2hFB0HIoy/YknEqeDoPi81HQK++TwdgQCE6SAAEVlTkBQEMIvO7GzHbA1AcTHBH0rqykdqITNJYO6HACsppA3Ch2OP9pXIPZj07LsZSfpctMbvPo6glPcbnjdlgTw/hQ/P/z8T+UbhHVqhUbAdtxsSyhiCKNWdUPSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p8iOQ7pB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Owqv/JHZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p8iOQ7pB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Owqv/JHZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p8iOQ7pB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Owqv/JHZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p8iOQ7pB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Owqv/JHZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 573685BDAB;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=p8iOQ7pBdqUwGQ3YL+/ilzkYqAZP1tciG2nSXxQneodu2vKfuEFU3SqAomesv+Yg6oxbq+
	mHri18JeHvFJxOn1Ex6fzQ+hMHoFiUSZ7fv1TssM/mkKHqBY1IzdCpcHqYUylZLyY/cCAH
	ViEONCyMZGbFe5LgQzXywun6as961z0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=Owqv/JHZgMzVHrKwPqZT35c7f8TzxqNw4AgUsRZVZX43xOsVz+WuOriHtSsLEGrxNliiWE
	CuiwCjrYdQSEEFDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=p8iOQ7pBdqUwGQ3YL+/ilzkYqAZP1tciG2nSXxQneodu2vKfuEFU3SqAomesv+Yg6oxbq+
	mHri18JeHvFJxOn1Ex6fzQ+hMHoFiUSZ7fv1TssM/mkKHqBY1IzdCpcHqYUylZLyY/cCAH
	ViEONCyMZGbFe5LgQzXywun6as961z0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=Owqv/JHZgMzVHrKwPqZT35c7f8TzxqNw4AgUsRZVZX43xOsVz+WuOriHtSsLEGrxNliiWE
	CuiwCjrYdQSEEFDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C3864A0A6;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OomaEnUCxWnWYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 27EBEA0C67; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 20/42] bfs: Sync and invalidate metadata buffers from bfs_evict_inode()
Date: Thu, 26 Mar 2026 10:54:14 +0100
Message-ID: <20260326095354.16340-62-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=801; i=jack@suse.cz; h=from:subject; bh=K9wrCKmeO7BfHLYf4wsyZtDcyuSx9fmOTys9wQHOC9M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJDZOEr4SoMR6litD6xJZ9vyOu7Qv8MRlaIP MceIDomSlWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCQwAKCRCcnaoHP2RA 2YZXB/42YP7Y55EaDpqaaAXkNNjVhOyVgYsq2ctbzL0o9Pgx3rLeyxhvdd85tPf8dQ6MjO9YTrr rq8Zgxdyui1EW9n01iDbRmAnMnjA09nr6PVXbxxke1Swac4mH9vDoDvrQ80sqblQ98Qw+nEENol Fes3tvRdPPWkwXNPBbzgzCobjFsM9UkEGMcf0e9Ea2q0vGwG/afqblVYXG3A4k0C+rqvs2Jsfqt JcvzGFTKfkPIToKEbOQT3NZ4z79rx8Q+yE0fUTg129GAvwJxQamhFDN2rXLdUKRI3vcZb0DOuAI QQkQK/aLCUAGZeYARe4fs+JcaPgRiUpUoH384lvdKOhq0joI
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it),to(RLpnp1psq57oqao6ocwdpbxen9)];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 9da02f5cb6cd..e0e50a9dbe9c 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -187,6 +187,8 @@ static void bfs_evict_inode(struct inode *inode)
 	dprintf("ino=%08lx\n", ino);
 
 	truncate_inode_pages_final(&inode->i_data);
+	if (inode->i_nlink)
+		sync_mapping_buffers(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
-- 
2.51.0


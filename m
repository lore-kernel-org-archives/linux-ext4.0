Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94653BFE3F
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519068; cv=none; b=P/6QUlPIt79d5rJ12ZmM0A2Tvc4DW17qHlTfnFbQDcBFvj6CCyF0gbGWxGMA82zUIyFt+xTDezR3cN9Ww4XboXnucrtG2NmLnyZlxcKJpvtJxAg6hm1HAc5eLeG91+CSRri6OSI6JiDofsr20rWtZRgdUDhYaQNwAEW2r0csakM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519068; c=relaxed/simple;
	bh=PNVVxb1C9U1PtR2RSzXX9wc57lK5fwMeMK3Vldbiae8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4sTYgilldQqPFVQsdFjjU/P2iL6CFGOMHthY7jiMI8UfbzhBgb0Jg51NbmclnhJAAZEbTHgUewcoAwxDjiHoyOufR9l37ik+VzFf1CQ12Lme7l0Iv+2iRWDmZKBVpaMgFVrXtTUAzgHVaEAi4TqoOUccbi/fVi2azT3e0BradI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zSP+paXw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vuXdFpKj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zSP+paXw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vuXdFpKj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zSP+paXw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vuXdFpKj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zSP+paXw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vuXdFpKj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B3F075BDCE;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mWtwh20v8xZ3gLOb8YfzfttWRltZG2tHqVQmdVNSOw=;
	b=zSP+paXwYwAcsf9TxzoyaEiWW1Krka5GS4Z/pbRIhNLXpbeZqt6wB5erabVO9KlHjE2DgM
	aoZsqvK+PHSxCFujntgLK7GV0sEqiifE7EJQ12mYJlnFR5yZh0OWNVGrmhJ4+p0EBqa3vE
	+nR69/Ggssr53TsWWnKqPl7dW3M84fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mWtwh20v8xZ3gLOb8YfzfttWRltZG2tHqVQmdVNSOw=;
	b=vuXdFpKjrt72htYVcph8w7j2TTI3PVvEDnmsh2992ubSFkc972D0efdLeJsGssTvBFDlFw
	7XxCq+Jk4GRy79Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mWtwh20v8xZ3gLOb8YfzfttWRltZG2tHqVQmdVNSOw=;
	b=zSP+paXwYwAcsf9TxzoyaEiWW1Krka5GS4Z/pbRIhNLXpbeZqt6wB5erabVO9KlHjE2DgM
	aoZsqvK+PHSxCFujntgLK7GV0sEqiifE7EJQ12mYJlnFR5yZh0OWNVGrmhJ4+p0EBqa3vE
	+nR69/Ggssr53TsWWnKqPl7dW3M84fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mWtwh20v8xZ3gLOb8YfzfttWRltZG2tHqVQmdVNSOw=;
	b=vuXdFpKjrt72htYVcph8w7j2TTI3PVvEDnmsh2992ubSFkc972D0efdLeJsGssTvBFDlFw
	7XxCq+Jk4GRy79Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A90484A0AC;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CwNCKXUCxWkHYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F3D92A0C82; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 42/42] fs: Drop i_private_list from address_space
Date: Thu, 26 Mar 2026 10:54:36 +0100
Message-ID: <20260326095354.16340-84-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755; i=jack@suse.cz; h=from:subject; bh=PNVVxb1C9U1PtR2RSzXX9wc57lK5fwMeMK3Vldbiae8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJWOFtW5g5HcqcBN8D1+JdIPOkjg+6XGAmLb 2D2HdluOYSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCVgAKCRCcnaoHP2RA 2QpuCACoMS7QR2pp4YSgollxC/sRjTSpyLNVupKMGWEUcYZSjBBpBAxJoy65jMMVsbVJzFkaj2J bDNsgYNvuZF4vnbNSU6s4znQVK0cUfz6aQs6Cfg7HvY/G1TPl0REgglH7nr5ImLCuR78pmLPml8 CNUihOX4S0fE6F2XHptn8AK/ECtT24BA7vdnjuQ7kF10dK/Lfi7C7LZ8B9gvISVSj5xeWLeFRZ7 ZNmbd5YPQzQoz2dPJkX8eWZqp0HuWVhVzUUoyrPnmH819Ftp/z5YEZ3rLMuYFo4MJQEFop9UJTc ZQnhhoGzEF2ibPNdJXDmBE9zgPKEhPRwZaHueLFPyXcKa+sP
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
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
	RCPT_COUNT_TWELVE(0.00)[16];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to(RLpnp1psq57oqao6ocwdpbxen9),to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

Nobody is using i_private_list anymore. Remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 2 --
 include/linux/fs.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d5774e627a9c..a8f019078fab 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -481,7 +481,6 @@ static void __address_space_init_once(struct address_space *mapping)
 {
 	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
 	init_rwsem(&mapping->i_mmap_rwsem);
-	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
 	mapping->i_mmap = RB_ROOT_CACHED;
 }
@@ -795,7 +794,6 @@ void clear_inode(struct inode *inode)
 	 * nor even WARN_ON(!mapping_empty).
 	 */
 	xa_unlock_irq(&inode->i_data.i_pages);
-	BUG_ON(!list_empty(&inode->i_data.i_private_list));
 	BUG_ON(!(inode_state_read_once(inode) & I_FREEING));
 	BUG_ON(inode_state_read_once(inode) & I_CLEAR);
 	BUG_ON(!list_empty(&inode->i_wb_list));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ccfa696253c8..a3bed26d066d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -471,7 +471,6 @@ struct mapping_metadata_bhs {
  * @flags: Error bits and flags (AS_*).
  * @wb_err: The most recent error which has occurred.
  * @i_private_lock: For use by the owner of the address_space.
- * @i_private_list: For use by the owner of the address_space.
  */
 struct address_space {
 	struct inode		*host;
@@ -490,7 +489,6 @@ struct address_space {
 	unsigned long		flags;
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
-	struct list_head	i_private_list;
 	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
-- 
2.51.0


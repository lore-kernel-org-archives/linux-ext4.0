Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A873C3C13
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518982; cv=none; b=es28v/1aUtu8cZMnSKBRiiBSU38Xbsjmq8/9Uqq3EClJAtzrB5o80Jzjrt6yNquPpjrMffUO8ZmAAbpaTfyFUwBzhSpgQZ/yagnFjI4qPQbgrz43nhsfLXVykyratkGSy/3agtjHI0zMRNYP+hQ2NcsW1hILwQ1vG/3JUdIK7U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518982; c=relaxed/simple;
	bh=S1BAqXV/Jqi4FmJijCh+slBc7/Xi7wKphfEUon5Scy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNRpzoEJ5icnNJkuXsJRZxOuuFPCTMD5H5AskZM3Bw4qEgQ65h0aiUAemFAHpo3HgbamOGOCtzRN15NRfWiUtJw/EroqSRGffJNoBZeD5eoNkuNrlFRG2Rv9d5Ij3nGzoMWqxoIOREqRD5X1gWLJi/WFfQtqFDpLFApPt58pCmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1ohE+/+i; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yWbswddA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1ohE+/+i; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yWbswddA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1ohE+/+i";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yWbswddA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1ohE+/+i";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yWbswddA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4E2B15BDA7;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=1ohE+/+i/xI+ZskyUv4EraTVvaP+8Cjj0qm477ZOZiHRc0dCwpKq13EBod8DcAiY7oqPJ2
	f7AQIoAy7s+GdxLzZDn+qvl8/8QmG0BTP+3zxTCOktV/BlQqzvJ+pmwbUhFySKgckZJ5L1
	QIUEKg5cRbt8M4kmIRL4QUAcklNuDlY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=yWbswddAYIxQUSFHwvF4fQlh5m0e2ajdTafaEUrMfuigAL6k24RHUCB8HqdCAeqjtb9elE
	mzpG1fDtmU9M3PBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=1ohE+/+i/xI+ZskyUv4EraTVvaP+8Cjj0qm477ZOZiHRc0dCwpKq13EBod8DcAiY7oqPJ2
	f7AQIoAy7s+GdxLzZDn+qvl8/8QmG0BTP+3zxTCOktV/BlQqzvJ+pmwbUhFySKgckZJ5L1
	QIUEKg5cRbt8M4kmIRL4QUAcklNuDlY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVxrfcguPtdd7IFlG2je9aVAhodhyZEE5rzXzcTNmTg=;
	b=yWbswddAYIxQUSFHwvF4fQlh5m0e2ajdTafaEUrMfuigAL6k24RHUCB8HqdCAeqjtb9elE
	mzpG1fDtmU9M3PBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43A564A0A7;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QEOGEHECxWnMYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0D883A0C5D; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 17/42] minix: Sync and invalidate metadata buffers from minix_evict_inode()
Date: Thu, 26 Mar 2026 10:54:11 +0100
Message-ID: <20260326095354.16340-59-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=796; i=jack@suse.cz; h=from:subject; bh=S1BAqXV/Jqi4FmJijCh+slBc7/Xi7wKphfEUon5Scy0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJA8bYqxZ3+JTUWtvnp18qagzJO877Mdw6cB sfHYzZzTaWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCQAAKCRCcnaoHP2RA 2TLYB/9xXXjlaa9QiiyDHdW4cz1emasnfHuX/cDFhXlHKgGMqEsSXRN3dc4h3zlXv2nAjeYWlns Gfgv7SzMVNqgS1HRUCFEDV05oZu4CEZSKE+YnzGHQyM2AuXJimH/kUOWqmbI7W/CieZnC7lR8DL nWKa47GOpOxpJPJzCXN1ukTqP5DCQ5vB2qhclQtQ7rcTLdyg8HtYUayX7J5K735fCjpegQ2x8FS 6PdXVrbXwDpf9wq2rUu/qe9SR5pOhEQpmuhBmlQxsE9kNUgklbt/OqcbdDjoVm//8bOLeUbZJmZ uXgBv5BKQC0h9wvCDUt1Q0zZLI0X1oUY1NU4V461WW2drIIl
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
X-Spam-Score: -1.30
X-Spam-Level: 

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 99541c6a5bbf..ab7c06efb139 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -48,6 +48,8 @@ static void minix_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		minix_truncate(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-- 
2.51.0


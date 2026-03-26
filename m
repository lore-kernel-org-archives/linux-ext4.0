Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417F53C13F8
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518937; cv=none; b=VDXnFwXotrlO6Biisf25bfYEetJvvq1GN0wQ0TGEdigHbbdH4XceyLGMpIq3V1mTVZbW2XlEweBuTycgkjC4vFVjrN2hZvp6OWoNPEJOnrXRkGqkG/fIbQUvNemyStALCdfwjV0SPpRx5QVfva5Z1FSKoAK+D6BEIQv3vXuIZJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518937; c=relaxed/simple;
	bh=syz4UVfUfj7dzDzM1I8lGwv0Y0mqGA7yHeFyjxEPh1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfkgjEnMhz8I/ZNi5jkF8xWqDpb6r7IVapFf0BDMBO5zLKS4ePEtI38rrpbu3YEAATHqzbRzxCRppdgBF91fDB8QWCPdjoXPvxZvt4aLUd59/rCWOz6OHWAVU4iliPwuEZPfCOzk4lKAKp3aC2pTbSrzBa42zXPTDZCOLQDZ94I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N0OAqSIj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=T8dt/Zvh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N0OAqSIj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=T8dt/Zvh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N0OAqSIj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="T8dt/Zvh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N0OAqSIj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="T8dt/Zvh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B9725BD98;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8LPpwAx32CRtbBt40P1A/4NgZQbZLc3wlX0s17fsmY=;
	b=N0OAqSIjdFzEqXC+OArpJOITpEDu3I4Yq5v/Mj9Dsv7NijrZFjVWuy1W6BKkQKrR1ZuHy2
	vFHPiV9UEUzzKtjZihw08c8Q0NdLfxGmI9x+iwFtG4OLy70cf0X9qDCtDNR0RS2z+HQ7nG
	rkx/CjpbmtrAp+kjzJ9Ap5FMxrpkU4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8LPpwAx32CRtbBt40P1A/4NgZQbZLc3wlX0s17fsmY=;
	b=T8dt/ZvhZUG+W7AYzD3LA4elccJpBdbaYWvf+wT0b0xjNYqvJlgE/J97Ry0RoHTWv2iiYZ
	CjLt8mG55IKJHSCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8LPpwAx32CRtbBt40P1A/4NgZQbZLc3wlX0s17fsmY=;
	b=N0OAqSIjdFzEqXC+OArpJOITpEDu3I4Yq5v/Mj9Dsv7NijrZFjVWuy1W6BKkQKrR1ZuHy2
	vFHPiV9UEUzzKtjZihw08c8Q0NdLfxGmI9x+iwFtG4OLy70cf0X9qDCtDNR0RS2z+HQ7nG
	rkx/CjpbmtrAp+kjzJ9Ap5FMxrpkU4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8LPpwAx32CRtbBt40P1A/4NgZQbZLc3wlX0s17fsmY=;
	b=T8dt/ZvhZUG+W7AYzD3LA4elccJpBdbaYWvf+wT0b0xjNYqvJlgE/J97Ry0RoHTWv2iiYZ
	CjLt8mG55IKJHSCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12CE54A0AC;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZjSXBHECxWm7YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CAFCAA0B7F; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 11/42] bfs: Switch to generic_buffers_fsync()
Date: Thu, 26 Mar 2026 10:54:05 +0100
Message-ID: <20260326095354.16340-53-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=765; i=jack@suse.cz; h=from:subject; bh=syz4UVfUfj7dzDzM1I8lGwv0Y0mqGA7yHeFyjxEPh1s=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI7je/bj6YX7efCg+wsg0034sVH6QEOHR9SO bf6Z06jxkGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCOwAKCRCcnaoHP2RA 2VGzCACxL4eJ7nSpgilarxwU3cMOnKYrG7QvQsgn+PasNfI+o/TAStfL7sXvIW5PbYug9mB4A6A plwOtuZKB6JEsSmv9U/R3I0QtTzen0/6Qxz+k1u6wcFAGRfVjpFtrWJF4HiBQFxqd/jOJbK4M93 qSv5XlIJsGHsM9shTSprIDRBbWlAa5BpetQ4YCtwcugz/vqTA1NcxQdtnE10i6dy+hzJrP5fPvZ 2mcUR56iW1FHAhZPAmqUl5mSrQ5U8vs3chfWHNCVOYc34olIfKnt3vFH2kWs+RKmuWThz15BzM4 jtt4w71qyZMg/sPPndKs3hIDTc7fVtcyqDl6MFU/y1F2smtR
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
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

BFS uses list of metadata bhs attached to an inode. Switch it to use
generic_buffers_fsync() instead of generic_file_fsync() as we'll be
removing metadata bh handling from generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index c375e22c4c0c..1b140981dbf3 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -71,7 +71,7 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 const struct file_operations bfs_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= bfs_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 	.llseek		= generic_file_llseek,
 };
 
-- 
2.51.0


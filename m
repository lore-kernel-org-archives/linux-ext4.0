Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083F43BFE25
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518924; cv=none; b=mqOhmb/GlSC9ASNgUyzdSay5d8zR0HWPhp+F/cDfA2WXZUi4Z78lYdYtYxXxHkQUluWXXPis6wZODpxcWwD/Oi1k9I7OgIyC9/MfYoDWIWjxrIvehs7bN/7D043k77X4x3U6lgkS8q15CGZDhTXbxpqQnn07tW1xVmRqMi0nxhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518924; c=relaxed/simple;
	bh=wPJ9zVJ4lqUpVYC5Ni5nLLn32cvu5QyHuHetHoyfP48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdYAMeksq1beJMDpk3+0JY1exOf9kKCbQIN3uQ/w4XEHnmaOKug3c1c9GIEFe+1XMuN/LTHwIJXRK/flN5c9GYB3HfnzDBgTgHSOTYxb6zDRyow+wDuobxT3mbMATSYWjegYUOFOsCLyFokz/o1lNDrh6JpX8NmiZb2CBi0MU+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RKAYyvE8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MUY2AvQC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RKAYyvE8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MUY2AvQC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RKAYyvE8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MUY2AvQC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RKAYyvE8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MUY2AvQC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1AD4D4D27A;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+17yxWIPn6CuZn9atnS4u2W8d1qElD0J/x0UJG76tOI=;
	b=RKAYyvE8f4rg/xqehe+0qMO8q96iHmEjacdvA5xfQxeG6OoDugtqnd+nk83HsWXLJYdSFW
	aQEaBqv+T7cqE1qLrNMByVNP5OHaEZ7oQ7667RfJ7P/8YTgLDyBFjKC99X4WAUYRY6ba/Z
	+IraS9pP6I7VsmJC0xiMTgZnd++iuHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+17yxWIPn6CuZn9atnS4u2W8d1qElD0J/x0UJG76tOI=;
	b=MUY2AvQCtqIM9oSeXHbXt8K1YIsq3z7FNM23k3EeGt3UEm/Kk7qC/hCA/Ox2FI21aSDQcQ
	o7MbgRwCbMxQFqCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RKAYyvE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MUY2AvQC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+17yxWIPn6CuZn9atnS4u2W8d1qElD0J/x0UJG76tOI=;
	b=RKAYyvE8f4rg/xqehe+0qMO8q96iHmEjacdvA5xfQxeG6OoDugtqnd+nk83HsWXLJYdSFW
	aQEaBqv+T7cqE1qLrNMByVNP5OHaEZ7oQ7667RfJ7P/8YTgLDyBFjKC99X4WAUYRY6ba/Z
	+IraS9pP6I7VsmJC0xiMTgZnd++iuHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+17yxWIPn6CuZn9atnS4u2W8d1qElD0J/x0UJG76tOI=;
	b=MUY2AvQCtqIM9oSeXHbXt8K1YIsq3z7FNM23k3EeGt3UEm/Kk7qC/hCA/Ox2FI21aSDQcQ
	o7MbgRwCbMxQFqCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E41E4A0AB;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1Gt5A3ECxWm3YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B8B85A0B6C; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 09/42] udf: Switch to generic_buffers_fsync()
Date: Thu, 26 Mar 2026 10:54:03 +0100
Message-ID: <20260326095354.16340-51-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1242; i=jack@suse.cz; h=from:subject; bh=wPJ9zVJ4lqUpVYC5Ni5nLLn32cvu5QyHuHetHoyfP48=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI5xxrhitQ8Q7p/SWVFyx65EWrf4RlTbHdVU N0+Km8nwOOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCOQAKCRCcnaoHP2RA 2dbUB/94BEZI5325tW+32n40xA8r9pbA84uXKhxYWGc4KSRwy1oU3pQ7ix2Ccou7tPo0oNFst/r 92A+QmB3LrqQKmKEQLWTz6INJ8w+lOGJWIsGr5nu/P/90KixvGNewBCeyGW4foOdlohHzfdskZt CCWa5tTW9VB41hqMQZPDkJoXJeZHvu1eeoXwVTzif9qrXTjrqyR7OBLW+T6SsalFUfbUfbHCqIh 7G1hbwIx9udjV1a4HMMkOTP6XG8usJ82XWVNU0Ix2RnYbFP5iY9DW/J7CtNJmMYDHuY6AE6bHwj S2dUY9xxcsIL1jPSojV/APkX1Q4Z/ylX8E/eg+yax+BXShz9
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1AD4D4D27A

UDF uses metadata bh list attached to inode. Switch it to
generic_buffers_fsync() instead of generic_file_fsync() as we'll be
removing metadata bh handling from generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c  | 2 +-
 fs/udf/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 5bf75638f352..a1705aedac46 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -157,6 +157,6 @@ const struct file_operations udf_dir_operations = {
 	.read			= generic_read_dir,
 	.iterate_shared		= udf_readdir,
 	.unlocked_ioctl		= udf_ioctl,
-	.fsync			= generic_file_fsync,
+	.fsync			= generic_buffers_fsync,
 	.setlease		= generic_setlease,
 };
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 32ae7cfd72c5..627b07320d06 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -205,7 +205,7 @@ const struct file_operations udf_file_operations = {
 	.mmap			= udf_file_mmap,
 	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
-	.fsync			= generic_file_fsync,
+	.fsync			= generic_buffers_fsync,
 	.splice_read		= filemap_splice_read,
 	.splice_write		= iter_file_splice_write,
 	.llseek			= generic_file_llseek,
-- 
2.51.0


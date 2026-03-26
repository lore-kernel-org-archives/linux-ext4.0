Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF333C1996
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518960; cv=none; b=Ah5Igr5XKoXDfWutcgqKvEAFmQntv5l5U+mL+vxr5iceIke66UR7lwuZqIewlv6FOLxVPMFUQpw8qXdIfFNOOwZamCxkMxzg2B3LfUU3/0ysjusaFc79LkFPUST0BsuIHw8UdgxYGp6JcaZs2qXm5JVrH12n4R9IkKoVDu/sKlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518960; c=relaxed/simple;
	bh=NDPLTZYpyB8AvjWnfTi4NCpTDfiFBgirFbbT2/Tf5G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/XV64RlLX08dZvSoECElH/sRdAI4+UdvvHb7PswF8RHYqQNv49VqS0tNOJ9YVi6fmkgLOKMA5Lvaq/OX0ABnUow7gUP0rTA+ZWe//pMaUBdlveWh2gV1Ebn7p0L6exD8Hpx98oCo5FQZK6kakdyO3Ipoq0jCerqLwBWdA3/EPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bFVqqd3m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FvmZjun4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bFVqqd3m; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FvmZjun4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bFVqqd3m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FvmZjun4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bFVqqd3m";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FvmZjun4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A4A74D281;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=bFVqqd3mkS6TZCNUqKZdUvzX3XT3sIaPQZMZbQWrDb+R/PAz4IXPQWQLcbdwvvXWLaVOQz
	V93+9DHQtqcYF/OsHpmcO2fiYdL+BjcHSPTI2EFPmMZPzjBRnGtf8zGIWnwkl6rxxVzyhi
	hUfxnwSkZoow8Qk3i6bZZmtoQ+8MM7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=FvmZjun4bFJWQL+mJCBAsy1Q1FHakdV/cPo5WudGC5RfwFl3uN8vFDPWVQCHqH3WNE8bRy
	n1vYKJBBBk/te3Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=bFVqqd3mkS6TZCNUqKZdUvzX3XT3sIaPQZMZbQWrDb+R/PAz4IXPQWQLcbdwvvXWLaVOQz
	V93+9DHQtqcYF/OsHpmcO2fiYdL+BjcHSPTI2EFPmMZPzjBRnGtf8zGIWnwkl6rxxVzyhi
	hUfxnwSkZoow8Qk3i6bZZmtoQ+8MM7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=FvmZjun4bFJWQL+mJCBAsy1Q1FHakdV/cPo5WudGC5RfwFl3uN8vFDPWVQCHqH3WNE8bRy
	n1vYKJBBBk/te3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FDBA4A0A8;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YN1+E3UCxWnaYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 317FDA0C68; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 21/42] affs: Sync and invalidate metadata buffers from affs_evict_inode()
Date: Thu, 26 Mar 2026 10:54:15 +0100
Message-ID: <20260326095354.16340-63-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=759; i=jack@suse.cz; h=from:subject; bh=NDPLTZYpyB8AvjWnfTi4NCpTDfiFBgirFbbT2/Tf5G4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJE8HckfhJ1pkI9JwuC2AULW5aPa2lEuXAbV pQDis2S6F+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRAAKCRCcnaoHP2RA 2VbiB/95ZCE1f94Wxq6b164+/iIziO9sxIt004YEAXDSJ0w9PkuWxPMoH1hNLurneLBFu8bn3S4 VYbLZXklHTXzFWG/UoinssGOpBYqNKqmaN9CoXii0HYEahTNvy5zi1m0zftk/mLpUv2xwpb1gZ4 XPpuYfkc6lUxEhGXUM/kClXomGhqjl0nAywL/npEuBRHSf1jp11i0JqXsh74jSV0mUW1WAzaa7H iy8apwn4cFJj2YQw+bgkHsoZXNMPOas1E77mHN9gnULHP1bpgfykJRn0AMndI1S3FxESc3DlJ7W YYIY6ZvnOjdAyD5myabRLXxesPqeGckMzX8UK5b74y9/CiEF
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
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/affs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 0bfc7d151dcd..84afa862f220 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -267,6 +267,8 @@ affs_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		affs_truncate(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
 
 	invalidate_inode_buffers(inode);
-- 
2.51.0


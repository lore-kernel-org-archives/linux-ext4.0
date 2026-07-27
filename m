Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A323B3F3286
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149425; cv=none; b=ioqEzbng6w3p7xcasEbom6MI2/SIZ/OhS9mJV12IfNL6giMY1xl4OYOJoaVJE0PKuptQlpALJJQPNmlTl7H8V8nVbFjhU3Ejxwuzh3iVrt7n1oPzMkepx/J99zhS2pYqFZXq87ISWGB2edia3gYQSxx0f4iApPnzVieoFylUKLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149425; c=relaxed/simple;
	bh=16sWDSi/VWJmOFlPlOiauotvWsW/d/G5R+jGo4oTm0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecOkdBiizhU4aq2ztKXoQFZEcJlOLurCFCtLC3srFOVcImrS9TU8s5uz7XIXexdL2hDUv6RvOjDoq9/1sxquSmS7tg/vSEl9PnrqEcnyDvz78i6vy47Vt5gghf8pDrDiDHz/DZkUIw6rxVpWYY3+0Tt7ZrDmbd0efVYVy+rqJt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HPK0B+dW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OG+tl0j2; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ScyCNolY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=c/Z/yYA4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HPK0B+dW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OG+tl0j2";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ScyCNolY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="c/Z/yYA4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 568F07DAE5;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uoZGmkuVD/xraHLbLVqtviPV5+xnMtLa4OWV32Wk3+A=;
	b=HPK0B+dWXgufWefNdwN4ttrJheC/PzXKEIfbPGjadGF2r8x3JGweBtW5SZLalz66XNtJAG
	DIrVVn4rPzzArlew2T93gAQHxWmlAykuffV/oNGT1XDtbUHfAxCE4q0qo1sIh31kSvLEAd
	shj4+oKpC7xuoiqX5ObkYKuZzTVk0KM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uoZGmkuVD/xraHLbLVqtviPV5+xnMtLa4OWV32Wk3+A=;
	b=OG+tl0j2FQYTfcW0KjLIc4zxJ8mLrNsqCzs75/XhpSvWLB4IvevpbGeAani6fLGFTJUUbl
	yK56v0KnNsJ1a4Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uoZGmkuVD/xraHLbLVqtviPV5+xnMtLa4OWV32Wk3+A=;
	b=ScyCNolYli9RBSXW5yWXonrVUSeRk4YU7oPVIqaa54dZJZlEIaecExpGZCnTJWZmG7YQ+e
	rqsokZCzY1NTpk1CzSd7x5LQl9BJCDszx8OwJ/pHryM8I6OQnKFjdZViRL+ahScJYeiyGm
	PuEQyC/XTTpW4wgsXmNJvvJ6HSJuClE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uoZGmkuVD/xraHLbLVqtviPV5+xnMtLa4OWV32Wk3+A=;
	b=c/Z/yYA4mLytTwcFkfuIv+5xkoWDRdCg6EdxIwfbRkwQZ/Yf3EsYriR22EPVpjWtMCilId
	cR/6UmnifpkN06BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A15F779D6;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GbkAFsw3Z2ohawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 690B0A1339; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 13/20] udf: Use sync_inode_metadata() in udf_evict_inode()
Date: Mon, 27 Jul 2026 12:49:31 +0200
Message-ID: <20260727104923.3828017-33-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=759; i=jack@suse.cz; h=from:subject; bh=16sWDSi/VWJmOFlPlOiauotvWsW/d/G5R+jGo4oTm0Q=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze9GHuNQwLrQWWdMYuy1N/uc8W9lM3ZZHw3Y TyRC7PuesiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3vQAKCRCcnaoHP2RA 2UdxCACYTKpeF8Tfqqf7BBdj6jB9QHpNtczrEC3lafAMSjy+DTGGr2pjFJTjukVgYH9cxDb8hT6 1aB5YnXhW6hGJZAdKdTO0GmSR/UqyzfL2vLacZG5/lH2H3yRLqpXjNk5F+JN4jGzpRWYrM3/nIY lfBcNyl5rD6YSDiKqo1qQkNlzMLDvoneKc33+oHQuUXYjGZHtzVM6QScGVyw58Y0LIq7JSnVleT kfTKOLymOdw+1InMc6DxPnv5oOdHlilKC0FMIEpKG2aNWP2yHIANY6a6TZXrOH8riD+JRrTg2xZ ol0OhVa6owUjTY+L2NeVgCi7pxv5OKiDLVte5JIAVcMuhAf0
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

Instead of opencoding inode update in udf_evict_inode() just use
sync_inode_metadata().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index c751a02d865c..8cf0562f34bb 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -141,9 +141,7 @@ void udf_evict_inode(struct inode *inode)
 		if (!inode->i_nlink) {
 			want_delete = 1;
 			udf_setsize(inode, 0);
-			udf_update_inode(inode, 0);
-			if (IS_SYNC(inode))
-				udf_sync_inode_metadata(inode, NULL);
+			sync_inode_metadata(inode, IS_SYNC(inode));
 		}
 		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
 		    inode->i_size != iinfo->i_lenExtents) {
-- 
2.51.0


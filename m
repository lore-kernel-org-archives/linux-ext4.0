Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CD942BC5D
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213821; cv=none; b=rMLuOpuV9XI1c+GHnHImemaUe0L1s2tIZSBDhEyjdJKMG537dK2FcDiX6sA4cWltXDYC1XN+0rIiRLCWqVAULpRD1X0K5wkllodUJCucGJTPYqJJzL+aqp32g0f6lShqAj5ir1SHsEVtQ7/LIYKx/wAIAAD1zJD7/nQuxgoMk2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213821; c=relaxed/simple;
	bh=16sWDSi/VWJmOFlPlOiauotvWsW/d/G5R+jGo4oTm0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/c0j/cS5WTQIddglzxnum40pli0Py8T237wjPQLzZOr+UepunmE9kaTa2opsfOc5VhyL4PglTce0MkfKRTsmPSBysJ+cmCZCRXUKjimg0i1UWKBFakqmC3gn9Yq+aYYzfc+VXLCa3Q75XLh7+xRPicgHTQ1lOc52Med3Pu8jwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wwp5SF/4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3YnJO98O; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wwp5SF/4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3YnJO98O; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wwp5SF/4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3YnJO98O";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wwp5SF/4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3YnJO98O"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C1DF5789D7;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uoZGmkuVD/xraHLbLVqtviPV5+xnMtLa4OWV32Wk3+A=;
	b=wwp5SF/4T3n70OL566iK/JbMaaZuZtHexGdSnvM916HC7a0m+jT+DWhnghCDoDBSOLVTp6
	zj7JsI1uCyWjqVvtr74HdDn4ZYvfWRqGMu9JoHFtb9pDz/II3M1lGHjDlQqgcAqf9r9FQN
	06Z+E0QxJohy8R1/3cWleymgzHm/pZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uoZGmkuVD/xraHLbLVqtviPV5+xnMtLa4OWV32Wk3+A=;
	b=3YnJO98OdqC87lhwW02DqME96BpHJpAtJRRTWvBySRkaUeBkHo9Js4KcdGLdVFFYiZlTkC
	4wLrBhvK+X3Z4oCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uoZGmkuVD/xraHLbLVqtviPV5+xnMtLa4OWV32Wk3+A=;
	b=wwp5SF/4T3n70OL566iK/JbMaaZuZtHexGdSnvM916HC7a0m+jT+DWhnghCDoDBSOLVTp6
	zj7JsI1uCyWjqVvtr74HdDn4ZYvfWRqGMu9JoHFtb9pDz/II3M1lGHjDlQqgcAqf9r9FQN
	06Z+E0QxJohy8R1/3cWleymgzHm/pZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uoZGmkuVD/xraHLbLVqtviPV5+xnMtLa4OWV32Wk3+A=;
	b=3YnJO98OdqC87lhwW02DqME96BpHJpAtJRRTWvBySRkaUeBkHo9Js4KcdGLdVFFYiZlTkC
	4wLrBhvK+X3Z4oCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9E75779B2;
	Thu, 16 Jul 2026 14:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HjBJLQXxWGoRXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:56:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 94C09A0B9F; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 13/21] udf: Use sync_inode_metadata() in udf_evict_inode()
Date: Thu, 16 Jul 2026 16:55:35 +0200
Message-ID: <20260716145527.3580300-34-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=759; i=jack@suse.cz; h=from:subject; bh=16sWDSi/VWJmOFlPlOiauotvWsW/d/G5R+jGo4oTm0Q=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDqGHuNQwLrQWWdMYuy1N/uc8W9lM3ZZHw3Y TyRC7PuesiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw6gAKCRCcnaoHP2RA 2cEyB/0QenK59WzRYlt2HNKaDqXtXOmH877Fg7EIJa/YCUTxNNghrB+WN0QiFxuEn2KYaKNIdgz YqXr6rzJnWqmQdQc8pO1cfQZFcRqaOo40eGW4+eJ1RZW1hySGEPPvqik+edRF+Epx5qRkef+sRq 0bmzal+1fazyw6iCFFSjGnX02DPQ+4SRLsapMvQi99kqkNcq51aVpIA71yLeSDpRu+5RZb16ALs KGkalJXIZ4AanuaOPjLlMJ4ni+4K6YkWWEbk+Kawi0n+QtPTfua4WRBh+Pm4gl5iNJrDG3debFw mp8dGQiUM9q8yYmKGCXAhvcKeL1ZnFTBYcV0ixnEhz+rpykg
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

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


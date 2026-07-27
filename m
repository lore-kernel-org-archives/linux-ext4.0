Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BA33F4831
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149439; cv=none; b=Rew8NLvzs5rszeJXN/xduy1y9w2pem0OxdqlYtTdGWo1nc7IHsUy2HC8pTf3lAJnUt2Dc6btB0rc1HF6/YT1E5CqH/seK2jJ3AZEnIOUFzFt8dJzdHtLp7m22xoIqckfK/2pexgzHZ5ZNfSX3Wiy7suekjP7Z0IF1oNRhDUdbiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149439; c=relaxed/simple;
	bh=Cl6Y1zQ1UgfQu+fZVmV4rO4Ml1E0uiQ6sjZQ09h97uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuMDZ4OBFXcDhoKLldYTRanPmQ0k6enkYcnvXTS8qzW0FkqNCe7iInjeQ4D/56OOxFS9gI1o4G9BIM6eT/KkwTF3kxFSRS3QiBeetAVgt6vDLzvh1yxcQ3ZjkyZAOjcGgPqwMofO8gpf7KPEllSoqtiCT5zojG4CkmTXDcgr0IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H+XPlGTr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NA6hLzsU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UqxByUd9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z+eWkVD4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H+XPlGTr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NA6hLzsU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UqxByUd9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z+eWkVD4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 261E25233;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=H+XPlGTrTpC4xUhb2K/ZukN2Mgyz9o0P6MQ5bh186iH5bRMYOtfUI/mdZd+lHMiPAnW6+n
	GWbT4dNA9pz8J+JKZZTgx5w2aP5acUWeSDtteHcTHLzy5qwywX0n5FbNsPdswr2QHy/pc+
	YNCY+QC8gg9TR1CfqvKApI3eIZs7JjU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=NA6hLzsUfIJuGpS32m2zFWNkIWKH6PAQVm1T+nEPNFfk/4xMON+pB6urZOH1xxHA1/hsiA
	I8DyWN9LoekPXkCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UqxByUd9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z+eWkVD4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=UqxByUd9p+36l4x0fRHIfCLqb0YPrD+dcespY03PyqWolMYKOjiP12aXXrPK859HQJzxPv
	ZFFRPCizrmLNr+IGCm6pyOmCqTL9wdVsxxv/tduRHoY+15i0N7ZaR6K5a8HoZnUDWmrFaU
	l3JYOm7EGoESIs9YC4P6uYIyUKSQGcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b55oEK86QTuPJ3eWWKPS31+H9g9O/gHDkdUtdwXS2hg=;
	b=z+eWkVD4DW8gn+7zA7WQZeNygafQorrzpBvVvBFsQ+kjimvISSvu0aIsgD2p4QBunu2oEx
	dkyt5vCPxCoFWYBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 430AC779D3;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CL5dEMw3Z2ocawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 60109A1335; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 11/20] udf: Use sync_inode_metadata() to writeout IS_SYNC inode
Date: Mon, 27 Jul 2026 12:49:29 +0200
Message-ID: <20260727104923.3828017-31-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1238; i=jack@suse.cz; h=from:subject; bh=Cl6Y1zQ1UgfQu+fZVmV4rO4Ml1E0uiQ6sjZQ09h97uQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze7Z0FmX5jJUv6nWOQmFvXkYPNn8NOJ0Spee 2OpBIjZoP6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3uwAKCRCcnaoHP2RA 2dy4CADSgfD2o8NLPMXnEtRI0DVw6LhBVjNqYyG5G76ctTmblWq4t4qtFGbvjum1wI2Rpax4o/j 6rJcXQ1Xr1okuLVuLZhQDTI+didpy5eFzxt3lHsWLxRBp60kR1Im+t3xJ1fHIAwd9lk6PNX7Je5 4ejoWAX+LWqpy6Kec010kQ8Jd/QBFtcBaTMfUdlHFcfNX87wxfYP63T13IqFgRAS37PrQt+HNdG iq2Cxtqob6L+38EQ1waviM0i/gst45hWFWHiaTbyzXBvh+TCsQ6r7m6XlaSA3WHnGKnDeod+EXo cO0ZXvz+vOsX9CXA4CDE4hWkHVLFHEvbxHc2gathUZJsYF8A
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
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:mid,suse.cz:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 261E25233
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

When setting inode size we directly writeout inode in udf_setsize().
This misses proper writeout of other inode related metadata. Use
sync_inode_metadata() instead and move the flushing to udf_setattr() to
avoid it for udf_evict_inode() where it would be pointless.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/file.c  | 2 ++
 fs/udf/inode.c | 5 +----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 0748cc965117..57d11606a2a7 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -246,6 +246,8 @@ static int udf_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 	setattr_copy(&nop_mnt_idmap, inode, attr);
 	mark_inode_dirty(inode);
+	if (IS_SYNC(inode))
+		sync_inode_metadata(inode, 1);
 	return 0;
 }
 
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 05e61a65478c..600705f5edf9 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1328,10 +1328,7 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 	}
 update_time:
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
-	if (IS_SYNC(inode))
-		udf_sync_inode(inode);
-	else
-		mark_inode_dirty(inode);
+	mark_inode_dirty(inode);
 	return err;
 }
 
-- 
2.51.0


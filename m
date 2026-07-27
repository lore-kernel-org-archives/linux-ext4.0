Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875A13F9F3D
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149454; cv=none; b=eMoJxLbPQcbo+Vqg/Bv1f5JePRInQNM3B2wYRs+gKiuFbrMFbh8y2Md0HIYpOGKPGr+iMMv9aET6534Ua3lEp8V4tNcxrHx/1G9lfEA70j559kBO7qC7KZwpLKCAAY1aoxlzWql2Ifo+GqtrAVhiS0nWgcMvaPtk53z12upk9cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149454; c=relaxed/simple;
	bh=xAARkvzY7PQPpzB6mjGtZVRMuXm5tBZNG5zqyTpkuAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8PzTOn802G3AxdZl8MBU6CauKUcu4R60L558FWI6TW+NhZoQ3F7UwDp3k89IRe4h3S1RD/glt/6WGYniScuu26D4upkTarbr8uFP0F11xtYP7PNs4/wYWFzueolNRvrjAOD5OUxxsY1QTcxnyYnHZ2E3tJ8qgB5CedcXLH6czs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DPYLA+53; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A3bDpckX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1e6vxHR4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yxO6VXPB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DPYLA+53";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A3bDpckX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1e6vxHR4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yxO6VXPB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5001A523C;
	Mon, 27 Jul 2026 10:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=meIo1vfJhh2P2LHjLRkevWmyTJSodfHog8fYvAGVry8=;
	b=DPYLA+53Gf/8GXkMyQ7Hh3eq++kdcE9qR94VZAa8b8KpUxizNccSQCPOOOFuKcbhtCq2tX
	hUpvLCL3frkS72UshHiKFRQkn0pdqP11toqRc0kL8sV+YjMD5MTBVGwvR3cZns2t0XLmbz
	Bo/h08d/v/919PX5nxypTALuZGbVWNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=meIo1vfJhh2P2LHjLRkevWmyTJSodfHog8fYvAGVry8=;
	b=A3bDpckXqEb7GEwMEk5H76tZE4hMIs5mIAfxB2D2PcQ8/q9cnlhquWkMMGcUV+spEQPThT
	heYS4CA10axg+qBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=meIo1vfJhh2P2LHjLRkevWmyTJSodfHog8fYvAGVry8=;
	b=1e6vxHR4INFLzhcoUSyjG2QFVuhacJ0TWmT5syBMKbfNTUlXAjhzPt/UONsoFGw9fp3w87
	5v74+/XvvPdDxts8mW9aTO6Wj/nSwEMPVapFCl4YF+0QSykmUPG3vlzlJd/KYYMsnijFg5
	dOJeDUSB6CqiKgZ+GAADXzcSuaaZskE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=meIo1vfJhh2P2LHjLRkevWmyTJSodfHog8fYvAGVry8=;
	b=yxO6VXPBWxmIrS0aX5S/hOI8TKoinrXVW4jhuyy+108kQJwC7+apGUsZtK2nAzTtMzqIoY
	cFynftsjZhcdyZCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FCE9779D4;
	Mon, 27 Jul 2026 10:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ClB8E8w3Z2oeawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 64D1FA1338; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 12/20] udf: Drop udf_sync_inode()
Date: Mon, 27 Jul 2026 12:49:30 +0200
Message-ID: <20260727104923.3828017-32-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1944; i=jack@suse.cz; h=from:subject; bh=xAARkvzY7PQPpzB6mjGtZVRMuXm5tBZNG5zqyTpkuAw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZze8mYSqx2h7bpqMyOUdYEBJ/T+rdYpeU4TWI dbNy5/kXQmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3vAAKCRCcnaoHP2RA 2c/fCACAFWWfzfChSebPwed3NSbFC/bRRuKefJ43PDF9hAFsTHt94uIPM87YVcJUUs5qfjZlsJ8 WDAw6/AWJWYymJL7b5peRli/4P/53f0GyO7LrLSr8Q7v/YPfwPYmSVdOgE4waRAuDIaudL3xgdr bqgyiUG8g1Npaee5NGajKe5IL0y15VWPTeUPQcB5DF8tjLxiB21oYXgSEiD6DzlDW3Eb2BhAwBP NXmf6gdc/tqFZduQFcPZ1OYxDCo8ANBlF9cffctAzegm8FZNvheyLwxM+Kqzee/lLLIZWDF8511 pMeO0R1W+JkXvO00/z3RUwxfSSa4xpsFF4cOkvs+WXXndCD9
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,prev_epos.bh:url,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

The only place using udf_sync_inode() is now inode_getblk() for flushing
IS_SYNC inodes after write and page_mkwrite allocating blocks. For write
the flushing is actually taken care of by generic_write_sync() so it
isn't needed here. For page_mkwrite it does have effect however none of
the other filesystems seem to bother with flushing IS_SYNC inode on page
fault and properly synchronizing such writeback with standard inode
writeback would be slightly complex due to locking constraints. So just
drop IS_SYNC inode handling from inode_getblk().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 600705f5edf9..c751a02d865c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -52,7 +52,6 @@ struct udf_map_rq;
 
 static umode_t udf_convert_permissions(struct fileEntry *);
 static int udf_update_inode(struct inode *, int);
-static int udf_sync_inode(struct inode *inode);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static int inode_getblk(struct inode *inode, struct udf_map_rq *map);
 static int udf_insert_aext(struct inode *, struct extent_position,
@@ -938,10 +937,7 @@ static int inode_getblk(struct inode *inode, struct udf_map_rq *map)
 	iinfo->i_next_alloc_goal = newblocknum + 1;
 	inode_set_ctime_current(inode);
 
-	if (IS_SYNC(inode))
-		udf_sync_inode(inode);
-	else
-		mark_inode_dirty(inode);
+	mark_inode_dirty(inode);
 	ret = 0;
 out_free:
 	brelse(prev_epos.bh);
@@ -1733,11 +1729,6 @@ int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 	return err;
 }
 
-static int udf_sync_inode(struct inode *inode)
-{
-	return udf_update_inode(inode, 1);
-}
-
 static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time)
 {
 	if (iinfo->i_crtime.tv_sec > time.tv_sec ||
-- 
2.51.0


Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2383B19CA
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014173; cv=none; b=nsMTgY+APzC0PkSa4tpqPbTX0BFr9KnP/jzcALDqB37rtZ2NT7inOwVHTjVXPYcTvxhJET+widrJuOrXuu0/mz3PvoOVg3v8hJLpKkOzlTiDLrYBF9p7AT0oIWZBMxALwsXyq97ylakIaFeVwXs7DjgyR+tsAYVE/0xn3Le7aX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014173; c=relaxed/simple;
	bh=NDPLTZYpyB8AvjWnfTi4NCpTDfiFBgirFbbT2/Tf5G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lvqa2fiRN7mDn5rp5NJ7QQce2cfUxGkSXnFLwdRrzFq3ER8tSpgok8CJ5qNV3vbps8SQUXjhgewHCgqO/rqaeitwozOloichVcF1NAoDddhITLgt39Q5YADpC1DDvioINeME7arvv/2Pz/Vtxls8AYWIvJPVib/rG6hIEsZOekA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=M9gGu3aD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nSk0RBup; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=M9gGu3aD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nSk0RBup; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="M9gGu3aD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nSk0RBup";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="M9gGu3aD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nSk0RBup"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 648435BE0C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=M9gGu3aDJyhewDfcx2p+4+NebAYSCJrZ7c5uWFCX8FJLrppFqxlt9dj/a1ZOETh99UM8z4
	m03oStBYdXsG60pvQYOtJ4Hwczavjch0+kdJdSgzwWr1utqC+4896BmtJnA8PNLaiz7tdR
	XkvAOGNSCws9Cdfbt/69o6KhjuaZoT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=nSk0RBupajTRGfRCv3ivRYdFhzDC7g/Vf+MS3lMStXGx4Ccf/Dl+xvUM/aVxJCyETtBI+7
	CnGZ1th4KJ/8mMBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=M9gGu3aDJyhewDfcx2p+4+NebAYSCJrZ7c5uWFCX8FJLrppFqxlt9dj/a1ZOETh99UM8z4
	m03oStBYdXsG60pvQYOtJ4Hwczavjch0+kdJdSgzwWr1utqC+4896BmtJnA8PNLaiz7tdR
	XkvAOGNSCws9Cdfbt/69o6KhjuaZoT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QO8o5He/MgdurPMedhqMOBFnFjvpq9ujrQ5sKzQcc7U=;
	b=nSk0RBupajTRGfRCv3ivRYdFhzDC7g/Vf+MS3lMStXGx4Ccf/Dl+xvUM/aVxJCyETtBI+7
	CnGZ1th4KJ/8mMBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 599CF42819;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tR3dFZlOvWl1CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EB3EBA0B58; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 19/41] affs: Sync and invalidate metadata buffers from affs_evict_inode()
Date: Fri, 20 Mar 2026 14:41:14 +0100
Message-ID: <20260320134100.20731-60-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=759; i=jack@suse.cz; h=from:subject; bh=NDPLTZYpyB8AvjWnfTi4NCpTDfiFBgirFbbT2/Tf5G4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU588HckfhJ1pkI9JwuC2AULW5aPa2lEuXAbV pQDis2S6F+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OfAAKCRCcnaoHP2RA 2WDzCADfC4fa+IJVDAAwMJjeuztdgooJjRRn4iY4Qee74Y6iUHpMBDwDTNHYBne018cMAQy53ga UD5bRfWOFexpcLGqWDxt1t5SE0hv8U04vtudLBj2zFiiVsbmGrHX7NdVtzYqEdW6fT+kvoOXn0w 9dXYmy0chBimaNkO4m2WNZCsRtOMwgKv0yzJhxkQAXKbA5QZ/ZeHDr6UcDLjEvSQycdl8/veQer eePo4OVJNLaKp5zJV2AoRzPxh5PHk5Vuak6mBLV9ryzg7Vc3A9SnqauQXPrq4lHL74/fT0TmroE tLD6aCePkAdk152o78qSkMU46PAz313VABsLemTV3C9kn6za
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spam-Level: 
X-Spamd-Result: default: False [-5.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
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


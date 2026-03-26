Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055BD3BED36
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518907; cv=none; b=VVVjySYAhxX53Ie0VbRzt/lNsYWWEdnf0Z+baOidCxObVMi+mllCw4IskknaA1HHPS636Wc+gYYHhZ6UDGV5+36p7VkPJ7Emi3++6yj9+Y0EeUbMGfo8eA91lHLauwIbxNtgo/Vq1+GBZ5quIvaF9FqeiYcoVke1cRPotAN4rvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518907; c=relaxed/simple;
	bh=ud/28G3xYrWf6hhDA8l9j5Yn2n0f8oX/rNwQdYapQHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFGfk98Frfrzxwvtsuy7tz2VTdScAFfsUtoucHlBllfEHQip3aSu3C1O51dcRa4WhRelnUQ/TjdVBCWUnzmL5u1IqgotJcqy6b/ou2S40K7QfNM6VnO21VWQPreERgBZ0GboXnWJbPTS6wSNrxxjfchJfTYxChXh5avG8H+rSgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c+cMJMvp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GQomBLxF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Py17vQlN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fLaUT1KZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c+cMJMvp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GQomBLxF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Py17vQlN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fLaUT1KZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D27985BD84;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=c+cMJMvpGByx1iW2hTahLGiSpkQoYs/4VsfCVYIlR3E718dvQ60Fb7RH53QrWA7mafTF5Y
	4vvrF6pEy+TfU0/28w3aWWvMT5HUbSRRYPtQOs5nMj/lQbiCUHo6rTQyOzdLjRexbu4EFz
	vLUKeM1RpGRoURUNyC2S7vumo6CX2xs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=GQomBLxFRAxnMGsteK32nYlnQTBloEMFHxvKoyLwC9mONnkuhxC/d/Z8O+ItYwiht2FaZq
	oBp/QpwLp1dX3mBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Py17vQlN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fLaUT1KZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=Py17vQlNcFSaitp4h/Viay7TLFzPFdqhV8gt+t9mYQEAFe0nSL/FtKNh7HPD+2tRT0tv37
	MsxTorNBoyBWHPwCd6OAgcK5AkFYzogVTlMma0SfoS40Tr5ZgDmHAaF7OIBdNBQMggt7Hr
	qbNzuoTcSIfAC3GdSA67/hFU03Gz4q0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=fLaUT1KZ+dx3F2JfHukhWOsbs2wbqHrxqV+s1Pw+kQ1dbX3Pz8Yg3WG+/Em08dho8oVDBf
	bmg2l13Su20g0jCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C50C14A0A9;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SJOXL3ACxWmmYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8A3EFA0B5F; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH 04/42] ocfs2: Drop pointless sync_mapping_buffers() calls
Date: Thu, 26 Mar 2026 10:53:58 +0100
Message-ID: <20260326095354.16340-46-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1308; i=jack@suse.cz; h=from:subject; bh=ud/28G3xYrWf6hhDA8l9j5Yn2n0f8oX/rNwQdYapQHM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI1Rii9H+t97Y2LO0i9U30mEMXFAbwMkKJma eYyaJh30hyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNQAKCRCcnaoHP2RA 2Q2lB/40rrtNeH5a/OcwRV5GW7AHRKWOY7F5o1rK8q6l6iwgWTciefwamUkaZrSfxF8E0qbwuC+ zNfVIBOCy/tDvLbvqovNOMG3MQFx5iEVAL4J2bfEVpf3OB7pQZ667VRSh+EyKUITNlWFJNVQHgW ewKd3AAUqyLVHicVrJ5wXhvjTjzmu26LANTr0iBn9Fs2fuqntosK0mdBUYGM8T3jxDAJg+RJ2nJ J3O9sYBqkgE47rVWNc6yrNTkuFWiwjs3LOseeKZmnKfepWvPTxELcZSUGs4KgnyJqCPke6W3CBw mxLE8hEFHjOoiQ/zXsZb7RCr1PHYXK+kxDR8Xzl+gwpa5Dry
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,linux.dev:email];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz,evilplan.org,linux.alibaba.com,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: D27985BD84
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

ocfs2 never calls mark_buffer_dirty_inode() and thus its metadata
buffers list is always empty. Drop the pointless sync_mapping_buffers()
calls.

CC: Joel Becker <jlbec@evilplan.org>
CC: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: ocfs2-devel@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dlmglue.c | 1 -
 fs/ocfs2/namei.c   | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index bd2ddb7d841d..7283bb2c5a31 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3971,7 +3971,6 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		mlog(ML_ERROR, "Could not sync inode %llu for downconvert!",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 	}
-	sync_mapping_buffers(mapping);
 	if (blocking == DLM_LOCK_EX) {
 		truncate_inode_pages(mapping, 0);
 	} else {
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 268b79339a51..1277666c77cd 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1683,9 +1683,6 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 	if (rename_lock)
 		ocfs2_rename_unlock(osb);
 
-	if (new_inode)
-		sync_mapping_buffers(old_inode->i_mapping);
-
 	iput(new_inode);
 
 	ocfs2_free_dir_lookup_result(&target_lookup_res);
-- 
2.51.0


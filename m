Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338B2346E41
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014114; cv=none; b=Qz+lBrS+JyCBhqdTHRzLxpYNPI27Glz4cEQid7hRGJMW6Xo05aZ0GWCZmZ65ciT2oS3yp7iSBZ+qm/jtM2dcGymmnqDq2MPJTLWPFk0JmzELAk+XFE/i63BRn0L9f+S7x/x3mkyCwk7GAngABpJmzlIv31yhgx7pF774jXUcx9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014114; c=relaxed/simple;
	bh=ud/28G3xYrWf6hhDA8l9j5Yn2n0f8oX/rNwQdYapQHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYFICnbVnajS7C76TeJncXvGXQauyG5smaBI+twLdj9A6SN+qjdMfAm/wx1mWCVT5umTFV6nzG16niBfUhfFm7aydqtFr13f+1oBZZT2xWrA5swUBoGZaBSja3layeU4Al8DpGBc+vQ+fXpL+zG7jxg5A1uAorn6e0IVGf/Mu1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DAPLLtye; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ld8iMnlB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DAPLLtye";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ld8iMnlB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB6524D1FF;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=DAPLLtyeGj8Mj4FG2qMIGu514EcEy0/oF8jWLsy8i1UZCVIwaI6nF0Ty9ARBCIkpNmxdVD
	UeJEAz7uc7FaIsjCZhNpt9/uQzMsSyeiuRVBiO53J6jLqnkjh3HzspmVY1cTWiIGIKu1q1
	BPfB7ZEskuYcsKCR9/RLz+Y4cZ+xEnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=ld8iMnlB1gNKrPDtQADook5ngMlyzUuLnA3OOR5NiwzcFvq0b3IiJ/Jjlsoc4wXdatJuyr
	67YemWKgp5EJW/Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B32A44281C;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id POG3K5hOvWlHCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 719B3A0B39; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 04/41] ocfs2: Drop pointless sync_mapping_buffers() calls
Date: Fri, 20 Mar 2026 14:40:59 +0100
Message-ID: <20260320134100.20731-45-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1308; i=jack@suse.cz; h=from:subject; bh=ud/28G3xYrWf6hhDA8l9j5Yn2n0f8oX/rNwQdYapQHM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5vRii9H+t97Y2LO0i9U30mEMXFAbwMkKJma eYyaJh30hyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1ObwAKCRCcnaoHP2RA 2U72CAClYJt4Vp3rWQy+nuN5XC33Sf0SKvdnx/nZehF9DNrggjtZwXkB4YsJjrAnWGUsCGFF/f3 YlQANF2+LWsoMsyadCF+47yP6lp02w/qkM5CIEK3Cr11d+sJmijZvBHd2InvMAS/fiS38kL2ly/ Xx5xJml/gFauzSj7XhjW/G7aHBPA9HxXgpSOBgNx8IcQvXgYBPF8ZIIwEC3gfZadi/Pwdq3OJF9 Sjs897pgik/+X4KIFXex1RazII9Qijsh5u7RBf91D+jQ8hS6MjfUmDtalSVmETNlYdHkRtkHMhD gQ1B+JmY63Jw5VmFHLElivbTdNzPYbruznMB3TYRKmxtXbS/
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: CB6524D1FF
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
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


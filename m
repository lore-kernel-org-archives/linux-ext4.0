Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153142E9730
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014114; cv=none; b=unAM/DYy5FLyOQnFSbj4QmanAgL+mFNGCNaybd+NDg2Lkzm2Ul5FStH7aBJcYQ0ZcNIpiRNQLAmq8hVJtJ+N18MGWjFmhYdfVrvsJ1LJieZbY86HVpnmUzIK3bJUvagcQLkU+jydhxQYC+mwaSbpbB4Xvs0zAbBZ8PBKXzT7i+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014114; c=relaxed/simple;
	bh=7NK1Luw5u3sFPoI2MABzxVh/UFbS1BdfliomKZSEhSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDtDC5jWjGZ5pUx+qngQfjfvHrIsOMu5TEZsZRU+dOiwoNiUSY5hm6oIB46JpnK43dQ+ds5RLTO3sysVpvcfIEv3pizf4UWODkALalW/eQ7twQZWQ24a4KHrZ93k3/r3WcZdOhWjIGafY2A61/Gwr7UhDB2HMqpyIelel9Liv44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u8Anhbfu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S8cu8Tep; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u8Anhbfu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S8cu8Tep"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B5E785BDE9;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=u8AnhbfuzqLhVKau9qx+8eDNwvrQ5rSY9piTMxDabUPxvJEFQCU9AeoET2gcn3zvwppID8
	1GVr80UzG2Fi01pAEJOls/aESvXCFBjGywPBf7auv4IcaqSoariGExH42WEqA3qmJ2UvJx
	mMBEtqUpfsgk2PANvpWXy95LJRe81Ec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=S8cu8TepoEIGSxlC3bSUpW7KejMTQ8/JVe2pkdbGhxnLOoVBnRrcXOrA5LKLs1nFggvzgl
	OzL1KD3hac/ZChDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A061D42817;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bce0JphOvWk6CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 57CFDA0870; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 01/41] ext4: Use inode_has_buffers()
Date: Fri, 20 Mar 2026 14:40:56 +0100
Message-ID: <20260320134100.20731-42-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1573; i=jack@suse.cz; h=from:subject; bh=7NK1Luw5u3sFPoI2MABzxVh/UFbS1BdfliomKZSEhSc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5s322tQJD1bTpLOCCusW8JNc9TXDdWifJtU FNx1ADgBgGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1ObAAKCRCcnaoHP2RA 2ey1CADnac5lZB92Hc+MkO/O63gQ3LLWF64hM0CuCoQ05PeJDa6i0EfB5/MxacHwpKXdbtInvlA pVu26IKbkiGo5XfbiJiwqeCZ/jQOfc9AVSg8fg7SqT7F5nbHLZQ6z+kswDT19yUgNAbo7G8M45O mSJaSSZlsuV54S+X7mO2AcbSr9mmcjYII2cSWsqda1VNIh+FhuLCi07vMvert7l4MEF9Rw6RAMD dZj7mNpUFO5WLgKK0YERld197olJGf8tublm3EHaCGDudFEUJ2kyPEZ27VJI86AqYmv4wn1fq3M dHepXVrH7uLnwaAVvqsSBQEiE07BPYUfHj6SvHZ4KKbqu6ok
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5E785BDE9
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Instead of checking i_private_list directly use appropriate wrapper
inode_has_buffers(). Also delete stale comment.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c     | 1 +
 fs/ext4/inode.c | 5 +----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 22b43642ba57..1bc0f22f3cc2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -524,6 +524,7 @@ int inode_has_buffers(struct inode *inode)
 {
 	return !list_empty(&inode->i_data.i_private_list);
 }
+EXPORT_SYMBOL_GPL(inode_has_buffers);
 
 /*
  * osync is designed to support O_SYNC io.  It waits synchronously for
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 396dc3a5d16b..d18d94acddcc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1420,9 +1420,6 @@ static int write_end_fn(handle_t *handle, struct inode *inode,
 /*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `iocb` can be NULL - eg, when called from page_symlink().
- *
- * ext4 never places buffers on inode->i_mapping->i_private_list.  metadata
- * buffers are managed internally.
  */
 static int ext4_write_end(const struct kiocb *iocb,
 			  struct address_space *mapping,
@@ -3437,7 +3434,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (!list_empty(&inode->i_mapping->i_private_list))
+	if (inode_has_buffers(inode))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
-- 
2.51.0


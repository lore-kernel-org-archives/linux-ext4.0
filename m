Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE28B39B4AD
	for <linux-ext4@vger.kernel.org>; Tue,  3 Mar 2026 10:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772534101; cv=none; b=nMUVagRqxS7LFo0maVyiHqwgztUM+1a8Za0OkMvqbtdtTDI+AsKjtVLMiVB2jrrnvFKS8E//YwBfhpNQ0/tV1bwj68WwQrDxvRF6Tz4CKQAhHRE60oE3oTFqhOIL/Ac3+0Nle/SjwdcmBwLHcl5N4g5BH/2/z78wuIT/HYPebcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772534101; c=relaxed/simple;
	bh=NSocyVgO/kQGAErs8cha/4S5lFQVkvyp5VDOz50TMvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu5SRVl5ptp7Nf0dMJSpIHc+uVfXz40aMgqU/Yb8bl/hVY9MKXMselS3th7ih+Bmw3tnuM+U3pC/zGecCKsmvWQOFVBa+JNi2eiI/1tl8uB9BN4wSULC4HgpA6+f3wa6m6OIKVkyRopxvTWob0pW0/qOGopZuOMn7HiGPlO5AN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E498C5BDF3;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D91923EA6C;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SG0ANUS5pmljFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 770BAA0AFF; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
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
Subject: [PATCH 06/32] ext4: Use inode_has_buffers()
Date: Tue,  3 Mar 2026 11:33:55 +0100
Message-ID: <20260303103406.4355-38-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1532; i=jack@suse.cz; h=from:subject; bh=NSocyVgO/kQGAErs8cha/4S5lFQVkvyp5VDOz50TMvM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkjDcPjRe968iOjtyTk4+S02xDNjEq4RENFS zbxRWwejuiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5IwAKCRCcnaoHP2RA 2QhkCACpRJHTWCgp3UVShmcjh3k1jfzIfqAWQr1o6ZxLfxYJPnN2AThktcbpTOawdqDzL8zNAF7 TPKXNMDZwSJ62WeoErOrqaZkd8I++A/Aed6Zptq4hY0qEUDYnW6DTw5jKyOwDIAih1w/EP1l4DA qWg7/PuX3cHPXX4FNRnBpnRQwfnGvN2qAEDR7Jn7X4tL2wltRxpcJyBuQYk5vwLLQnB45B44d3j SQAS12MqhIvj8PhOFpJV+6B/9DPL8lDLWvj1AniE9WlrsLtl+SiJBsplxP17ZztDbbVTfZppE5w KWfFd/pvRhppjHcrxes4jlejCtzwSOEMzyw48JePwQ1aXBuU
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: E498C5BDF3
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
index c2692b9c7123..6f892abef003 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1422,9 +1422,6 @@ static int write_end_fn(handle_t *handle, struct inode *inode,
 /*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `iocb` can be NULL - eg, when called from page_symlink().
- *
- * ext4 never places buffers on inode->i_mapping->i_private_list.  metadata
- * buffers are managed internally.
  */
 static int ext4_write_end(const struct kiocb *iocb,
 			  struct address_space *mapping,
@@ -3439,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (!list_empty(&inode->i_mapping->i_private_list))
+	if (inode_has_buffers(inode))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
-- 
2.51.0


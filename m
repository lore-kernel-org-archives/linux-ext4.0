Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3721C37187C
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014149; cv=none; b=uM92SEhzuVnu1zclBOFOgQ3i8XwZsDbhqx9dWXxr68v4MSrDvhhbK/5XkY58bZ+3AQzyLiwAW0u7PGSx+qa8IQrYrEP4RWn1aU4Yj5m5w8t0zk8WCDlc5+9zvTJXcrBwjiwnnEnqZiFkbNObfPwUHPuWZVbZJ5p4/naHLRwzsrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014149; c=relaxed/simple;
	bh=YpwlY9gANXCHPNbAIVrmfcTj04CmV1BsSIb2drOA8QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A94LbwNEOSmu+NZ/X3vXauTlELFz8Y3Gxs5qq5WuJLbwk+mwccOlyLhixer+GapBi0aWBtvwiXOTR4WIPNCvNztHe0hMlitfqoaQ7kyQgy5aFyrt1P2Ve0H2ckYDSQd7taZqw9oJVBATj8F586jz6d1COukGtPttWSwoU0rDD2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 320905BE08;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 113F74281B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N/4yBJlOvWllCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B3726A0A9E; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 12/41] fs: Drop sync_mapping_buffers() from __generic_file_fsync()
Date: Fri, 20 Mar 2026 14:41:07 +0100
Message-ID: <20260320134100.20731-53-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1135; i=jack@suse.cz; h=from:subject; bh=YpwlY9gANXCHPNbAIVrmfcTj04CmV1BsSIb2drOA8QM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU52sjR+o4oxbnG9aLagbbudeDN06j+Jq4fhR fjZyg4nS6qJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OdgAKCRCcnaoHP2RA 2a9CB/92F1jsJ3pb11l0aKofBm0Zt/jJjH/fyYCQ5Ttu8zNndGAc1uCOl1EfZdu4wCPY56J6qpT IuHSNDYA+5pelUesuQAxDvEQu4F3gLUKknjg0kLT02ahHvrv2eRBIgctjclBTqbfZUAXbg1vrjE anSm0g5dysaM5JTBnNxD49RNzIEi90xTw7vkRnUy5IZ7PAUqEr2b5nQEOr6rpLyEKh+UWolfvxy 0PQtTkKn4WsGr4tRG4nSX0zbpNKxAGuHMfI4eye0NYi2tZLebr16KDpwVnWRaTE+dSHonwGSdlJ 6OQS+CHCJT2p10Dpz1PJVZJADOV5efY8uzTWx4cvz8x71EYs
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 320905BE08
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

No filesystem calling __generic_file_fsync() uses metadata bh tracking.
Drop sync_mapping_buffers() call from __generic_file_fsync() as it's
pointless now.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/libfs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 74134ba2e8d1..548e119668df 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1555,23 +1555,19 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
-	int ret;
+	int ret = 0;
 
 	err = file_write_and_wait_range(file, start, end);
 	if (err)
 		return err;
 
 	inode_lock(inode);
-	ret = sync_mapping_buffers(inode->i_mapping);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
 		goto out;
 	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
 		goto out;
 
-	err = sync_inode_metadata(inode, 1);
-	if (ret == 0)
-		ret = err;
-
+	ret = sync_inode_metadata(inode, 1);
 out:
 	inode_unlock(inode);
 	/* check and advance again to catch errors after syncing out buffers */
-- 
2.51.0


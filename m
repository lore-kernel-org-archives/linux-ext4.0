Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1337437BE95
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014127; cv=none; b=vBNBiJfIZ/RMwcwkFbFnF54mtkp9BaTJGkYmWVng7Vu7ZiAnoSuwaFpVjPCIrw3sPoJ47d3x50J5NcmMA6oUcEy3S97NxTQ/+67CttajWO8RBlLmO7n6G4HamZ7GR7PPVFEhhGFEdQQ9RrYkHael8udOTHncvO6t38p1ZlkZTlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014127; c=relaxed/simple;
	bh=beao/EQDuzv4ZgO4qf+fvb6RxeVSXsvs/lpSC/KX04E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG1lKiRy9SnzYUTJRsPqmwTRQoqRNRXeVdvuXeSAJ6U9LSv/0/mavTykaim9mC8NgkB5620YMXv2AygSCWkSFtPUycL1OwKBkxZMrijar3QFriewQXjmy+SzsZwSxvea8bGVt75+MxedNaSua96JEIxCePGyGkJTK1lS0HfQh6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 19A774D283;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B88F42819;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RYWjAplOvWlhCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9A466A0B51; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 09/41] minix: Switch to generic_buffers_fsync()
Date: Fri, 20 Mar 2026 14:41:04 +0100
Message-ID: <20260320134100.20731-50-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1129; i=jack@suse.cz; h=from:subject; bh=beao/EQDuzv4ZgO4qf+fvb6RxeVSXsvs/lpSC/KX04E=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5zll2aMdMKGEBu1la1q7D7+GVZBmHAWorp8 HB/ahbbPdyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcwAKCRCcnaoHP2RA 2XBGCADcx8JSeA6kqqWEFGGtLfqPM0lpVz6MmX3FbSnDoUQJiTcPh4Y87rHfPcIcNIigHR0W1fE jyLCEvhn3zZHc9M7T6O+QgdML6ZGvs29IPZ5UOUFS2nJPsngwQ7zSeLOaKv9kzpY76S9/a+yQs4 p3qpHASif3rGi3+vtrde4I/wuLJeCAgwjcF0RyLSqY933/kAbv3vDk1fhQRDRaFFJIr7sfm5IFD I5jIBFxwhCKoGGgFezAG9Rq0cGslIPKwJhrOF+W6AKv8H/W2HRWPYa6rqKARx7S+ALvdcLs44OF VcmIctWNMAIuu9VoERJPcgd6GNIKzpQDc/bXed2HqRlESb9B
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 19A774D283
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

Minix uses list of metadata bhs attached to an inode. Switch it to
generic_buffers_fsync() instead of generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/dir.c  | 2 +-
 fs/minix/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 19052fc47e9e..a74d000327fa 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -23,7 +23,7 @@ const struct file_operations minix_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= minix_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 };
 
 /*
diff --git a/fs/minix/file.c b/fs/minix/file.c
index dca7ac71f049..282b3cd1fea3 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -18,7 +18,7 @@ const struct file_operations minix_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 	.splice_read	= filemap_splice_read,
 };
 
-- 
2.51.0


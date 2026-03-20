Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4C437B024
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014149; cv=none; b=nRcfXlpE5xGhD19t7RPJSHdsamlhk1Tf11h2kdOrnXUo14xd2rVgvI2qKkFu3mmq4hUMML26fgFuXbNDK12pdzTVYAnYhwKMbg8DlbyrA/2dDXc7zvXvolpVxIU3Hz3uV2kI7G8TIIhTHdUZA8T8YBgNkxjr2AlgVmbH/MN60Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014149; c=relaxed/simple;
	bh=S1BAqXV/Jqi4FmJijCh+slBc7/Xi7wKphfEUon5Scy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLXpu/3IHtfBdWOVlLY3vz77cpmTSHb443qF81T5w23iKSmfkk57xQmvp63K2Dg380TVuKb4RpWANRroDi2c6f7WUuao7CHsriu4015zTtei/TXUXaeP9wiflFh7uSc0D5xQMnxd/esAmVrykqfLNI2fQgppladx33cAK5lD4gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 534CC4D286;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 480504281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qOySEZlOvWluCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C9A0AA0B39; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 15/41] minix: Sync and invalidate metadata buffers from minix_evict_inode()
Date: Fri, 20 Mar 2026 14:41:10 +0100
Message-ID: <20260320134100.20731-56-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=796; i=jack@suse.cz; h=from:subject; bh=S1BAqXV/Jqi4FmJijCh+slBc7/Xi7wKphfEUon5Scy0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU558bYqxZ3+JTUWtvnp18qagzJO877Mdw6cB sfHYzZzTaWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OeQAKCRCcnaoHP2RA 2RWYB/9lvcI3m1d1cVF9w+HK3/HDWcztscAHT9bzHrltK9PnXyeRONw758AHBO5w7z/Eepmtl1K HhXl2TI7v7tgnkfEQB/ZhGMVWEcoFmWb3GFNv5+tNbzOkTvW7/SosNhz6CSR02NHCL8Bgs4K0Fw 5+gm/W3fTj8rAJBQv0462vVUqNtvJCIw/fXd82CHjU8HkBcsyHLvwRLGKciF1dFTDeWGXT8JnsQ Me+2RzzESp9AEWtTYQaZ/raRhupU0872yztiDsqeNpCCWq2QQDizbjOZuPUJrYQBhq6G75hFku+ PzxzHw5wkKxIVnsDw7DWlgkgtQ9SaVTAottPfd5MAcdoYBNK
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Queue-Id: 534CC4D286
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 99541c6a5bbf..ab7c06efb139 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -48,6 +48,8 @@ static void minix_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		minix_truncate(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-- 
2.51.0


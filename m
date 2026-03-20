Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC842F360A
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014139; cv=none; b=FdEQ3F8D+zw4bgaNe5k/yxeK/WSu+tS7XE/l6tZPjOgb5UbcTqsqsJhRq8GsU36ElG6IRebSj/gEROyjVroY0JsX/AUbbweqko+XJOerPuirth9XBCTZH1wk74WZizkAAU8/+iwn/a+kpO6vu14Koq5wP1uP0bIrEjaa2C8dYaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014139; c=relaxed/simple;
	bh=mkQehyIZTRqI2My1mwA67UAiWijrKIFYPNFYBKrsS7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOtOte67KgRzPgc2DjN5Yfh9ZGiaVD+tseLSbDgfMeOOyop5sP3jH7WP7vn/BiDI+mFNJK/tgdQnA2TXuSVKwwmlAS3j9LV5zBWi6YYfCGRKAXshjneKyLTzfrt5+TKUxgeKeBonCkefdEVuyuQDjeCtYSH3bY9SeoXuaeACH8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZQauWmFi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=thFV+0oG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZQauWmFi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=thFV+0oG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZQauWmFi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="thFV+0oG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZQauWmFi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="thFV+0oG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 138AF4D282;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDMzNkIKFRwME49O96e1E/DlzdsPjtIa2wUBLqd434=;
	b=ZQauWmFiwqpUdfPdNvTjQZO6GcSfzBe52AZA75vz5j/W8BjqiD7b1mGxb+61EH8HJWHJQc
	SM0n21r+lyBzTCB07aimu+UNWsHEF1C6NmqAPhPcYNrwnJX96XL6uelLEf5mqcWw7ykp1o
	WHlli41i3W/fTl6adrGzL7XC8xIFYfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDMzNkIKFRwME49O96e1E/DlzdsPjtIa2wUBLqd434=;
	b=thFV+0oGTSG/t8eIOl2hO73S8N6xUdTUxJpBfUHzoUt7fShuPk+OsxVklupbQRGtTQKGM/
	09qhr0+9iq+2HcCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDMzNkIKFRwME49O96e1E/DlzdsPjtIa2wUBLqd434=;
	b=ZQauWmFiwqpUdfPdNvTjQZO6GcSfzBe52AZA75vz5j/W8BjqiD7b1mGxb+61EH8HJWHJQc
	SM0n21r+lyBzTCB07aimu+UNWsHEF1C6NmqAPhPcYNrwnJX96XL6uelLEf5mqcWw7ykp1o
	WHlli41i3W/fTl6adrGzL7XC8xIFYfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFDMzNkIKFRwME49O96e1E/DlzdsPjtIa2wUBLqd434=;
	b=thFV+0oGTSG/t8eIOl2hO73S8N6xUdTUxJpBfUHzoUt7fShuPk+OsxVklupbQRGtTQKGM/
	09qhr0+9iq+2HcCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 09E624281C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0kRpAplOvWlgCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A3FB4A0B52; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 10/41] bfs: Switch to generic_buffers_fsync()
Date: Fri, 20 Mar 2026 14:41:05 +0100
Message-ID: <20260320134100.20731-51-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=696; i=jack@suse.cz; h=from:subject; bh=mkQehyIZTRqI2My1mwA67UAiWijrKIFYPNFYBKrsS7A=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU502XSBQHbfk5JrAF1ElRgQTVpaRO/gFy4mD AWVgYQpnxWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OdAAKCRCcnaoHP2RA 2c4pCACyRJeP0BH7vip1BL8HeZwhZtsJSQUSxFbR0YKmJlCY4ZRo2/aUBJrBT4op54JDd7CAe8O siGb20WcA0iOzZ+/K+/udwoMlEcDMvKv3CgLLESWqbZv83kKuGATgYfr3VfQeJuJUPwCLbtMR3t OFaONtf+ewkx6tpTMJaD58uNZRLSzalU+R6YVWpAuk3sLPZ3wkmz7ehWUz3zFQYi8zWWUM3K5S6 eERoU2tpADafXUXCm5FWvAT7Wum+0AJyO+2svyjur5frp1u67FhK8aa6bB9nXEviJ7Ff+qBzKRb ZbR8VdcKhVi5b5J0M9rmJgTB996GLHMFrhtSd+LE3sAHXToa
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -5.30
X-Spam-Level: 

BFS uses list of metadata bhs attached to an inode. Switch it to use
generic_buffers_fsync() instead of generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index c375e22c4c0c..1b140981dbf3 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -71,7 +71,7 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 const struct file_operations bfs_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= bfs_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 	.llseek		= generic_file_llseek,
 };
 
-- 
2.51.0


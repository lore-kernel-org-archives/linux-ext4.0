Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF583BE65F
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518899; cv=none; b=gvXrD/zvsjCt3MqZvBVRolE5yejXJvNVD2bYz8POOIu7VtRjucXsod2iyOIv4CvvnLkUMEGr4KsYSPGlAqTTHTDXGGvv5tuN0s865xxZ2zUKRPjaKKhlvmZPURTzjPXmxosMni9e+yYxj8/eyuBeY2UE/Wyf5LMRuO1Z7WOLEFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518899; c=relaxed/simple;
	bh=zt6HPqIyrGTBlI6V+0Dr/XGCbljb9VrDeuE5lHdQnrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOKdp4VmSLYoJJc1vmJFP22AeOz2dvbyFeyXjLnQGRjsloGTfXA6faapgKoNJLlOlV94di9s1IRTTpGfzK/udiWJuQlbGA3qWiBjnNbon02Ppa1101kHaQ8/vJgmBUdPDVug2JO5FNVGcgybYHGF+3e/RO/w76dKU6cino+acn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ikIZO/va; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H/A1kzg6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ikIZO/va; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H/A1kzg6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ikIZO/va";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H/A1kzg6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ikIZO/va";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H/A1kzg6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C11645BCD5;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=ikIZO/vaU57PVncq9onK+AWlFRxS2Wllql55sHJuoKgxScAbjAiFTsw1D6cyAI0NOImVGB
	Ak98wk8ZPMqSiRuSeDu8eqxVL1qNcqID5gF3m2kvaZOWi5d80vtxboDRiFZP5WuopVVfE7
	iGcOMrm5JZszWQuYIzDGC9JqUj4Eu6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=H/A1kzg6niMWw63cLdurH1mVR8nYMYDANZnrwBKcPVcZEXFBF3TLrrkVFC/PZEwWp+fpZA
	qC8b8sx1+rk7FAAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=ikIZO/vaU57PVncq9onK+AWlFRxS2Wllql55sHJuoKgxScAbjAiFTsw1D6cyAI0NOImVGB
	Ak98wk8ZPMqSiRuSeDu8eqxVL1qNcqID5gF3m2kvaZOWi5d80vtxboDRiFZP5WuopVVfE7
	iGcOMrm5JZszWQuYIzDGC9JqUj4Eu6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5SiiLeqr0tRzr8xKFqCzZIUP/hbhDlDHk608R0+nc4=;
	b=H/A1kzg6niMWw63cLdurH1mVR8nYMYDANZnrwBKcPVcZEXFBF3TLrrkVFC/PZEwWp+fpZA
	qC8b8sx1+rk7FAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B86B34A0A7;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YPkBLXACxWmhYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7B594A0B58; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
	Andreas Gruenbacher <agruenba@redhat.com>,
	gfs2@lists.linux.dev
Subject: [PATCH 02/42] gfs2: Don't zero i_private_data
Date: Thu, 26 Mar 2026 10:53:56 +0100
Message-ID: <20260326095354.16340-44-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=757; i=jack@suse.cz; h=from:subject; bh=zt6HPqIyrGTBlI6V+0Dr/XGCbljb9VrDeuE5lHdQnrA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQIz9QDNvNUEpIhcooLLBbuSbDnT3nLUxpPES BJ6DFZlrM2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCMwAKCRCcnaoHP2RA 2Y1TCACgJjs/Rj5FUUtM8EfC8lTypcZwH8QH0u36IVm3yNSUP4LRuXWlbat6aqsYI7G7Xs7Mi0y XwlcOAbtxAWgP0xhT8MhWCSlbm1TBxma1C7+oXNtNN0Qyz94GBDelwZqbh8gokEAXH/T6q3ooP6 6Qbuug3VzwIn8W0bppX1q9Af7oQDl+OHDiycH1uNmgJTIAeicGumUA6OG5RpwVK/vxzSHQU8zEX Kd6LC4g2HAUlishCR2r/8aNGq/v3t7sb3WlrMNhiP0ZHdzSB5akmdDh9+guOCppxX+6noHqOAUa rvqhzBHansYERqqkK1Q4VBKoaYBhRdD0KDRjD/c+b5mi/aRy
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
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz,redhat.com,lists.linux.dev];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

Remove the explicit zeroing of mapping->i_private_data since this
field is no longer used.

CC: Andreas Gruenbacher <agruenba@redhat.com>
CC: gfs2@lists.linux.dev
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/glock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 2acbabccc8ad..b8a144d3a73b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1149,7 +1149,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		mapping->flags = 0;
 		gfp_mask = mapping_gfp_mask(sdp->sd_inode->i_mapping);
 		mapping_set_gfp_mask(mapping, gfp_mask);
-		mapping->i_private_data = NULL;
 		mapping->writeback_index = 0;
 	}
 
-- 
2.51.0


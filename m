Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3600E3BFE4D
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519018; cv=none; b=B8X+rEFfmr80V2sBUXuj2QadbqJerxozf4QYNDHYn1VBgkUY37PBv9zjuR+5hzYcOD9uLFOklrLXVHQZjbciDrnuUfQb9DirB1Jja5piog7kTQdWCh6f3pTMXqCEnZCy882cexV+bMLQaQQSZ+Pdrt4Jw6hFtSn6KkNHzj9Bke0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519018; c=relaxed/simple;
	bh=8BltPTgRrYXS74k/jRdBXdCWWkCHR1h2kZanq93z8Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0WADvyja1jKjGxB+FK5CptUWitSqD8Iv/WLG8RR1X/7GLWXyfPr1ZAxVdEhDLIjVhYCTQY1evQoFJWSCqCllWkYgHmIZxFOa2HEiBGfZNQf4yWmLus7GfK5Q8+0TRz0TdSoD2fJU6gUCw5+sURmdO3xcJARZTfLQM6RWdElMxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fScM982w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B6RG94pn; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fScM982w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B6RG94pn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fScM982w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B6RG94pn";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fScM982w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B6RG94pn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 728AB5BDAF;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MomJ//0oEOiFuI1ilZROD9J75KQ9oPOeV2ufT1YvQwo=;
	b=fScM982wQUhdU44H8+ReTLKRpECzZSS4xPf3Tp88zk5uQjq/lapx7GTCfM5Flj65fwqzWX
	Y1JbqAh2s1kAiieEObSRHgvVb8EsTeMoVkWdYf+MjezkamAYRUyFnnTwOFtFyVToSJCqqh
	YbwDX23uBx4Ge59RJG7URZMn1SNT+MY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MomJ//0oEOiFuI1ilZROD9J75KQ9oPOeV2ufT1YvQwo=;
	b=B6RG94pn8Rnaav8lvSUMP2AqtmYja5d0B/dK9n6+rRqkIRmBOSsWnPvsuczaS4kYKH8Hl0
	7mL8LKKeURmv7FCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fScM982w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B6RG94pn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MomJ//0oEOiFuI1ilZROD9J75KQ9oPOeV2ufT1YvQwo=;
	b=fScM982wQUhdU44H8+ReTLKRpECzZSS4xPf3Tp88zk5uQjq/lapx7GTCfM5Flj65fwqzWX
	Y1JbqAh2s1kAiieEObSRHgvVb8EsTeMoVkWdYf+MjezkamAYRUyFnnTwOFtFyVToSJCqqh
	YbwDX23uBx4Ge59RJG7URZMn1SNT+MY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MomJ//0oEOiFuI1ilZROD9J75KQ9oPOeV2ufT1YvQwo=;
	b=B6RG94pn8Rnaav8lvSUMP2AqtmYja5d0B/dK9n6+rRqkIRmBOSsWnPvsuczaS4kYKH8Hl0
	7mL8LKKeURmv7FCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 666274A0A3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 62cKGXUCxWnkYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 68366A0C71; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 27/42] kvm: Use private inode list instead of i_private_list
Date: Thu, 26 Mar 2026 10:54:21 +0100
Message-ID: <20260326095354.16340-69-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2244; i=jack@suse.cz; h=from:subject; bh=8BltPTgRrYXS74k/jRdBXdCWWkCHR1h2kZanq93z8Js=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJJMyHuU/3ELVIudu1rF0GGX7ypYh6CAVU2g NgW+LKl4xiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCSQAKCRCcnaoHP2RA 2aduB/9Jwc/U1s4qbiVmV4BfMyZLi02tfp5luwGvNuxAPtN0u0xT+6Z3YsHsIiwR7NUdsVwGd6e rcry5sQjYJJO8IB8+L3A28rPif3tndKm4DrWEjaLYNzJbfk2nY12VLSzIgApxw9pf3Es2vubl0d T0fnoy12qDN7D75ASstI0WO8lXP3ogab4Q3VAFi/TLyDMmP6lozAMlF74ecvAnl/DjBDzFAVS0I nyLkdUVPaUsVlhufM3J/I3S2kLKimCRVEfho7FP1MtAy81+LIx06rLrH27swvyRa98FfkdCFHBr L10qT7jYDA/adaIUnTHkIqPKqN4msKrQuHiFY4p5QLE6B0/R
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
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
	R_RATELIMIT(0.00)[to_ip_from(RLhafujjw6m7bafrsz8p45s31g),to(RLpnp1psq57oqao6ocwdpbxen9)];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz,redhat.com,lst.de];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Queue-Id: 728AB5BDAF
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

Instead of using mapping->i_private_list use a list in private part of
the inode.

CC: kvm@vger.kernel.org
CC: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 virt/kvm/guest_memfd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 017d84a7adf3..42b237491c4e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -30,6 +30,7 @@ struct gmem_file {
 struct gmem_inode {
 	struct shared_policy policy;
 	struct inode vfs_inode;
+	struct list_head gmem_file_list;
 
 	u64 flags;
 };
@@ -39,8 +40,8 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
 	return container_of(inode, struct gmem_inode, vfs_inode);
 }
 
-#define kvm_gmem_for_each_file(f, mapping) \
-	list_for_each_entry(f, &(mapping)->i_private_list, entry)
+#define kvm_gmem_for_each_file(f, inode) \
+	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
 
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
@@ -202,7 +203,7 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 
 	attr_filter = kvm_gmem_get_invalidate_filter(inode);
 
-	kvm_gmem_for_each_file(f, inode->i_mapping)
+	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
 }
 
@@ -223,7 +224,7 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 {
 	struct gmem_file *f;
 
-	kvm_gmem_for_each_file(f, inode->i_mapping)
+	kvm_gmem_for_each_file(f, inode)
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
@@ -609,7 +610,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	kvm_get_kvm(kvm);
 	f->kvm = kvm;
 	xa_init(&f->bindings);
-	list_add(&f->entry, &inode->i_mapping->i_private_list);
+	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
 
 	fd_install(fd, file);
 	return fd;
@@ -945,6 +946,7 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	mpol_shared_policy_init(&gi->policy, NULL);
 
 	gi->flags = 0;
+	INIT_LIST_HEAD(&gi->gmem_file_list);
 	return &gi->vfs_inode;
 }
 
-- 
2.51.0


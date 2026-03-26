Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5AE3BE65C
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518919; cv=none; b=AXwjHEg9cBGWn8NGEzHM2MLltLeh77kq8ksp+j3sYhWeRbsEvzxp/6uhYtYVQk+iQyMFwrB/sLc//PUG8TME+bhMTHKLu65UbyNkBrF7Lyts7IlAar3XtDQ35DWOwKiA1BWsRy6s/mW73Zvc8Ear0MXYr9v4lokExBsV7nrNT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518919; c=relaxed/simple;
	bh=RkkBpF3L87rXPRrGMrmQZXeEBfTEFrhE0WIyjhBNgtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIOzJRcqGkIWJxOM+D8ofPPdb9rFjA3MRCHqCMwis0dYjhohQgM2Ud2lQdJ1UHsGPucqxGZG6qHu0T/fTblZan4YL3ePNXW7MqnyrJV+yGyaoBVbzffmEo962nkVR8ekTkUigNGHuQvUeFuhr1OZ59GO8w17V1SgQGj6HwgaIvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FP0IFOVL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BmTYABnQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FP0IFOVL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BmTYABnQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FP0IFOVL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BmTYABnQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FP0IFOVL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BmTYABnQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C49E5BD8A;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=FP0IFOVLysghcpqVbJ03MdX6UHraRclKDo3dlVL1UFh8G6/BbnR71znq4V05rL1CfNpjvl
	0rqQOnijioZD5b8+J3ZmHcvF/8kKjTbGoZU7O4GNM0CL48bJkfTJSP2mO0MWZia+f1CKbR
	IvjdtnIOkZ6DdTR9bTvu9Oc2amsQg2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=BmTYABnQ95hB3DqtwiWJ0l4pzqyRfE8C6ZKjEVy7eCjj7bHeAr5UwAoolgptjYwzKFscX1
	DdERTvCfF5PONRDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=FP0IFOVLysghcpqVbJ03MdX6UHraRclKDo3dlVL1UFh8G6/BbnR71znq4V05rL1CfNpjvl
	0rqQOnijioZD5b8+J3ZmHcvF/8kKjTbGoZU7O4GNM0CL48bJkfTJSP2mO0MWZia+f1CKbR
	IvjdtnIOkZ6DdTR9bTvu9Oc2amsQg2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKch3cA360fq6oe1hSv7172yeidWMBNx7GuKOSTC8+c=;
	b=BmTYABnQ95hB3DqtwiWJ0l4pzqyRfE8C6ZKjEVy7eCjj7bHeAr5UwAoolgptjYwzKFscX1
	DdERTvCfF5PONRDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 034824A0A6;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6IvLAHECxWmyYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9BEA6A0B63; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 06/42] ufs: Drop pointless invalidate_mapping_buffers() call
Date: Thu, 26 Mar 2026 10:54:00 +0100
Message-ID: <20260326095354.16340-48-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=595; i=jack@suse.cz; h=from:subject; bh=RkkBpF3L87rXPRrGMrmQZXeEBfTEFrhE0WIyjhBNgtA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI31WeqiG0jNa0YkM8N4dWqoWPubtNi4LGzk SOQHx+qqECJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNwAKCRCcnaoHP2RA 2UfKB/9DDO+b9sLudpGGjgiD2JAI03bZrlps0G27v4opMDq49NWLPuD0MGyMo58IrZj79u3Vr9j UDgz7kBwQj7J5sdNzmUQs3BgQOtRV5VqWak/r/DNnWYtASVZnIsKc2o85PdBR1a7myJuBamquJh xEoaUu8rAh48Sd/3d/bTPHtVpTfpgx57KSBwuLBTeMwv0j2ROLNGSqjOBk1F1JJLV6K7i8XPQF7 4BGfq8UYL3RDrjL+STwQSRl5GqfPTF15xYnU+778k6o7XklGuIjUeKf7Pu10RiUp6o9hHcKHr/B N+L0I+LYymR6f0g9C/bgDKRreCpF1IYMjXFv97na0cMbkdzY
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
	RCPT_COUNT_TWELVE(0.00)[16];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	R_RATELIMIT(0.00)[to_ip_from(RLck8brw5hxmszoarioc7838it)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

UFS doesn't call mark_buffer_dirty_inode() and thus
invalidate_mapping_buffers() never has anything to drop. Remove the
pointless call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ufs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index e2b0a35de2a7..77617a31d517 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -853,7 +853,6 @@ void ufs_evict_inode(struct inode * inode)
 		ufs_update_inode(inode, inode_needs_sync(inode));
 	}
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
 	if (want_delete)
-- 
2.51.0


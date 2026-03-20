Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961DB37B006
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014126; cv=none; b=pprQMvaeJ23bMXmPeYChE5D4WGPNToH4JVdc58lINWnXPBPtduaiEaCGKXCQLXhdttTb36X/kK139jeumeLJ1tVZOtVQI2eaj7F/IisdBCYMO+ms3n9Q9fFAi/Ndp2Yye7uRVx5b0KsMPs+dGq9Uw5pa4XJuyDGzpyws0HLY3W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014126; c=relaxed/simple;
	bh=RkkBpF3L87rXPRrGMrmQZXeEBfTEFrhE0WIyjhBNgtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYRrZGUc72VH849Rn0wMb8xT02IcqTX7hPDerMZnYgyRgzpjK7gdN1qzHDuJ+1meDBrGgVQ6DbVaUfL+JZ0ODkakNwfNzVuIMzHP+CIOFt2u5g84fbUkKKeUooEGcVlaqsv3Duv8VRcRVs7hjTsr+e1pXvA81gJlhpzuyYpZ/ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0464F5BDF9;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC89C42819;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6za/OZhOvWlWCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 81C92A0B4A; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 06/41] ufs: Drop pointless invalidate_mapping_buffers() call
Date: Fri, 20 Mar 2026 14:41:01 +0100
Message-ID: <20260320134100.20731-47-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=595; i=jack@suse.cz; h=from:subject; bh=RkkBpF3L87rXPRrGMrmQZXeEBfTEFrhE0WIyjhBNgtA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5x1WeqiG0jNa0YkM8N4dWqoWPubtNi4LGzk SOQHx+qqECJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcQAKCRCcnaoHP2RA 2am1CADHew0GopYyiq30ItPAhV+oZoPkZPa9CPzEQKSw4r4HN+iVRkJp3k3Q3ik4UIxQzC7hD37 Vb/61LnMaqwohPFzoteJ/pvw8TwKEid13EcbJ4kYM6jg58ZE9DROj4xBsiH8XJeyI7l1Ac7qvwg F6taZ628Locbt04Hp4gBQFB/u7b6pm5I+4zb555RJ5jHcrQMBDZlJt0u1X9WbEsJjkAAwPEf2Qq 5xI5qBVskv3riuTGkLuP+r/5jLVwODXPkVAtxSSEfAfNHnUcK2sBEovCfvW8jT+UAZYt4/Vmhub bWXbwrAfcLW1o+CUTXG/hlAtuMsHM7WZStmfM5JjWCYXoNCS
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 0464F5BDF9
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


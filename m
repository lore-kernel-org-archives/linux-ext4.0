Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE432E06E4;
	Fri,  2 Oct 2026 11:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790941866; cv=none; b=rLuxgV3oNy7Ers/RMh2fsJFFEraE2xoKH4jpgOxQoOUsoTAWH7RYJ0J++omBvosj6P+8JLv0ym+Ya+v+Xq6cxfNmo/oTjJednjPA9qldVNZ5CXfBM22GCKMCpxVKNy+uFdpjHqGe93JJ06Dnol/YEI3ETmxh7mwPEaUsaTKf5d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790941866; c=relaxed/simple;
	bh=5v5nV5CXTGS03tKeZOqnmXukUs7gxewYzY6JwixY9NI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kRzZ4bhoDN5Sc84reVJpVlvUE1YRz+vL4AEc6xmyKxnBn6XOd2xjfwCnJ/eavmwcIRU8xahE74bcwABroHmjwGMdav+YZ3ZWigyKwdU7uoV+bWk/hYIR7a5U3p8w35mYpcxKQHn0MBQwxTRmwJor044LxEqjl1nbk4dIHbuQVDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UakcAbpS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=adneOX1O; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BTE5EBAH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mZ99kwrP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UakcAbpS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="adneOX1O";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BTE5EBAH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mZ99kwrP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4EEF21FE52;
	Fri,  2 Oct 2026 11:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790941858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=T7vHxEB5bH07fzrhdtfir1Kd0rp4/3v+4LHsc2Z8TVQ=;
	b=UakcAbpS1DP5tg2gmj/cOD2aOc09sWM8xmVPNZpNInoh6UShsPVEIYRpiLwEknvyK4IcgR
	Jc+STiZTr9E+Pd4laaCuWqeSFAHjbZKYVscoJrvxG/mb648qvIpzQkxZ4CEHf9p3YX6wHc
	xy4SbqdZ4WzzilU4mbqyzOi6ZT7QFUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790941858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=T7vHxEB5bH07fzrhdtfir1Kd0rp4/3v+4LHsc2Z8TVQ=;
	b=adneOX1OnTF4tqG1l5rkmQCcxmDV+BimBEtEKQ/KZPrcJrdZuENXoI6cWdv4jkidoNsPBP
	+4fghq/NU9OR69BA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BTE5EBAH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mZ99kwrP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790941854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=T7vHxEB5bH07fzrhdtfir1Kd0rp4/3v+4LHsc2Z8TVQ=;
	b=BTE5EBAH6UNv98F4lDpNXkda8bGNjww9+7ob1qEFyr2aOHu5GWehMIoAKlWs48z1VQxyNB
	tadLSoFZneQZSxgLBy5GJCDBzC5ey3C7HA/jfqLZuvUDOdEKSYZDTdFAWEzpiV99OXgUvR
	6pg+mOd8L5TiEg/yu2KkC+SicecmIUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790941854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=T7vHxEB5bH07fzrhdtfir1Kd0rp4/3v+4LHsc2Z8TVQ=;
	b=mZ99kwrPU+DSYorfA3vGHMUw02z5X59rvG3o/0Qv3epRa9YEO5VnS0jRmk4lucg+oxowzt
	SFGJqoyJzXQ2PEDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2155813C08;
	Fri,  2 Oct 2026 11:50:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a1MsAJ6av2raFgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 02 Oct 2026 11:50:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A0986A13C2; Fri, 02 Oct 2026 13:50:53 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
Subject: [PATCH] ext4: Fix maximum orphan file size check
Date: Fri,  2 Oct 2026 13:50:41 +0200
Message-ID: <20261002115040.2783654-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1945; i=jack@suse.cz; h=from:subject; bh=5v5nV5CXTGS03tKeZOqnmXukUs7gxewYzY6JwixY9NI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqv5qQWtxk7pUwXxFdwyTQwuXjoPDnSd31kas+4 vYCUR3TkwKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCar+akAAKCRCcnaoHP2RA 2ROGCACsZa7Du76XR///Q64bsqqq7qTSH4QHlTUqGa9X2CfF5n77ujHFDvBIjWa4RZYsO42/OSq pKYoxvtyRa6DzOtdvflNBtva1FNlAn+F3gWUVrPZ2x91jZSMY9yZMjvBn60owaREwxSezvX0K3T pwQVgMjcjor1LcKtZEKDLydA6HHwJ5LyAZk8QtegHWYGg3KwthiY7Lg2PAEGHs08DHx6Bn+PEqy iZSEt6MJOqM6tR6CtM8I35+iyltyN7YNEDhnpuUoHVoMUjaRJrwGfvmmex1bVZAfrpumNHjq+I9 Feak5hGMS93ugd8zMY9rR12fDHpio2Q9Apq/uJHv43+XMqjP
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4EEF21FE52
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,redhat.com,huawei.com,linux.ibm.com,gmail.com,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 

Mikulas reported that e2fsprogs 1.47.4 with 1k fs blocksize by default
creates orphan file of the size the kernel rejects. This is because that
version of e2fsprogs creates 2MB file by default regardless of the block
size and with 1k blocks that's more than the limit of 512 fs blocks.
Fix the check to make kernel accept any file upto those 2MB regardless
of the number of blocks.

Fixes: 7c11c56eb32e ("ext4: align max orphan file size with e2fsprogs limit")
CC: stable@vger.kernel.org
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Link: https://lore.kernel.org/all/e65cdbfe-3ff9-4638-fbd3-4d8f8880966f@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/orphan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index b4675aa7ea96..7394d04e0fd9 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -576,6 +576,7 @@ int ext4_init_orphan_info(struct super_block *sb)
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 	struct ext4_orphan_block_tail *ot;
 	ino_t orphan_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_orphan_file_inum);
+	loff_t max_size;
 
 	if (!ext4_has_feature_orphan_file(sb))
 		return 0;
@@ -589,8 +590,13 @@ int ext4_init_orphan_info(struct super_block *sb)
 	 * This is just an artificial limit to prevent corrupted fs from
 	 * consuming absurd amounts of memory when pinning blocks of orphan
 	 * file in memory.
+	 *
+	 * e2fsprogs 1.47.4 produces 2MB orphan files by default regardless
+	 * of the number of blocks so that's where the second limit comes from.
 	 */
-	if (inode->i_size > (EXT4_MAX_ORPHAN_FILE_BLOCKS << inode->i_blkbits)) {
+	max_size = max(EXT4_MAX_ORPHAN_FILE_BLOCKS << inode->i_blkbits,
+		       2 << 20);
+	if (inode->i_size > max_size) {
 		ext4_msg(sb, KERN_ERR, "orphan file too big: %llu",
 			 (unsigned long long)inode->i_size);
 		ret = -EFSCORRUPTED;
-- 
2.51.0


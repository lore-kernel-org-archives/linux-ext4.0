Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43183F39D7
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149399; cv=none; b=Uh1Jllafy7IteANbhBcrAVr06eATVNhzi4G7MYaA8gS19RGv5Tsd9WMwCh9SHZfu2Tzkz3vpdHYg/CO2j+teZ1sWAO4RQGYs1NDU9dD9VRK9uc5nFPNZXwncIzM0v4Uc/8pnhAOTxM6hC7n3/mI0nF+5ruoV00R/GmvFT62W1yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149399; c=relaxed/simple;
	bh=ICn5WauvFDxAnZy5ltXxwWbxvcBEunJElp8QDBAjttM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MI+YcEtEsgyjhfjfhW8L/vN6cr371jbCVlfQbOX8Y3fp0IFnxDPXZYfKZSvQFFyBxwbk3lESOU+g7aqaeY/9FDQv1UeuyA+4uAeJ1fzfKcDzsXq1knOQMwAj9Zf/VD25xgSwq4HX5eJmL7Ns7rY6w87T1fe2Z/489IDvgQx9t80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=B1euzMGi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0LqS53DG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2C0AfjNy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z+StxjTY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="B1euzMGi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0LqS53DG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2C0AfjNy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z+StxjTY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A46A7DADF;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OI8wftFuSvSdj59X1mDioZdnGMKEttzx1FKZh0TJsAA=;
	b=B1euzMGiFOfhwtlhziJGOPvmqHj+NDwcJCD+yLYgbLi/n/kBGuAjLdtQJizO/Zl3KV3icC
	SHY00RrXTPMzBjTo2CkJHvDCfqfup13cdd88vcE+Uj4LZ7hJxCTivJv7eaF35CM1USBgBp
	mklFpDG8o8K9ztLZBXTP4JCjmKjC6DE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OI8wftFuSvSdj59X1mDioZdnGMKEttzx1FKZh0TJsAA=;
	b=0LqS53DGO2nhx5ZDn3XH2O18iYcE6V0C2cDGDggXXmnFMnwym/GaIUKkWrZEzIxCAt55oQ
	1SBbiBx5OYauwwBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2C0AfjNy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Z+StxjTY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785149387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OI8wftFuSvSdj59X1mDioZdnGMKEttzx1FKZh0TJsAA=;
	b=2C0AfjNyk7C29fCVu5d6pYjTdST9K5uw2ONSfoO2l/OvDGxvHITtnHcxIbkau61Fx1UXZQ
	hQK0FTkkrhJi4yFlei8N2dJ2Owt92pkU4iR4Q8wuM6LE3W28N6/kjp/TNV35pmmkRcW28l
	IVN2CpXe+xrcsHKUJ2bwmyIfi+9r1tA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785149387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OI8wftFuSvSdj59X1mDioZdnGMKEttzx1FKZh0TJsAA=;
	b=Z+StxjTYrUTbl23O7Hj2o3d/4lNaCX/jj0pAINSG6N1isNAO/R5pQesCYsnvJ7P25ARtE8
	dJItrKQR9VsSQsAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B544779B9;
	Mon, 27 Jul 2026 10:49:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ibpHIcs3Z2r6agAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:49:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 27AC2A0BA1; Mon, 27 Jul 2026 12:49:47 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v5 0/20] fs: Fix missed inode write during fsync
Date: Mon, 27 Jul 2026 12:49:18 +0200
Message-ID: <20260727101509.21667-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4320; i=jack@suse.cz; h=from:subject:message-id; bh=ICn5WauvFDxAnZy5ltXxwWbxvcBEunJElp8QDBAjttM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqZzetmDokw8N341EAwBle0ypNkmhryiyPkW/Tl xhqds67iR+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCamc3rQAKCRCcnaoHP2RA 2SitCACK2CiuSUg3nk8ckgYcOxNReJzvqIqfzz2UaJO7oRn7dI74Qfms2PnFM81YKYEiuqYJfbc 3dX7i43XUZK5j+GC6xns7DypPAbAMqHahI5GA/aoTVWQkUUSJqOXVwDw/HwY4OqXZ69puEVU01H pWmQDfKERVbyNc57Mri6ZFdHeyk2P42Dc93Lu6NYNpS31VCJbFfDKZR841REvovd+fenGATRKVY M7V0Y2QY5V/oT5h6fRn4wESnRclVywcWVPby+og7pyFmiRcRikT/xBxN74u/qa/RcfDF3AxfkBk 4n7BSsB234n9ItwOfk0cvZgBF4fPoMW2oy9vuZT86zP/kFA4
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 9A46A7DADF
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Hello,

here is v5 of the patch series which fixes the possibly missing inode write
during fsync(2) for filesystems using generic metadata bh tracking. This
revision contains mostly small fixes and improvements since v3, neither
Sashiko nor Christian found fundamental issues with this approach.

Patches have survived some testing with fstests so they should be reasonably
sound. I'd just like Ogawa to have a look at FAT changes as they are not
completely trivial (although I've opted for a less cleanups than in v4).

Changes since v4:
* Fixed where ext4 calls set_inode_metadata_writeback() so that metadata
  staged directly with ext4_mark_inode_dirty() gets properly tracked for
  writeout with fsync(2)
* Added __GFP_ACCOUNT for ext4 mapping_metadata_bh struct allocation to match
  how memory was tracked when embedded in the inode
* Removed cleanup patch removing sync_dirty_buffers() calls from FAT. The
  error handling would need more work and things get too complicated for
  this series.
* Improved error reporting for ext2
* Fixed typo in bfs leading to compilation failure

Changes since v3:
* Add a fix for ext2 lost inode updates for IS_SYNC inodes (independent issue
  found during testing)
* Check I_METADATA_WRITEBACK in simple_fsync_noflush() to avoid skipping inodes
  with pending bh writeout
* Reorder buffer writeback in to first write out metadata blocks and only then
  inodes. It should lead to a more consistent filesystem in case of a crash.
* Added handling of IO errors from metadata writeback for IS_SYNC inodes for
  FAT
* Fix inode writeout during eviction for ext2
* Fix conversion of ext4_nfs_commit_metadata() to work for filesystems with
  a journal
* Fix races when handling of IS_SYNC inodes for UDF by using
  sync_inode_metadata()
* Add ext4 helper for accessing i_metadata_bhs
* Fix some bisectability hazards
* Removed some dead branches after FAT conversion

Changes since v2:
* redesigned the patch set to use new superblock operation
* fixed race of inode freeing with IO error processing in
  mark_buffer_write_io_error() 

Changes since v1:
* Fixed freeing for ext4 dynamically allocated mmb struct
* Optimized tracking of block carrying the inode so that we don't flush it
  unnecessarily on fsync
* Add forgotten check for reclaimed bh to mmb_sync() to avoid NULL ptr deref
* Couple other smaller fixups pointed out by Sashiko

								Honza

Original design explanation:

The series strives to make sure sync_inode_metadata() ->
writeback_single_inode() will end up to properly persisting not only the inode
but also all metadata associated with the inode.  This is beneficial for
several reasons:

1) This removes the need for separate mmb_fsync() implementations. Filesystems
can just use simple_fsync().

2) This makes sure all metadata is written for IS_SYNC / IS_DIRSYNC inodes.
Currently most filesystems just write inode itself.

3) This fixes races when multiple fsyncs race for a while where mmb_sync()
could return before all buffers were really persisted (now I_SYNC state flag
properly serializes everything).

To be able to achieve this we add new .sync_inode_metadata superblock operation
which gets called from __writeback_single_inode() and new I_METADATA_WRITEBACK
state flag (putting everything into .write_inode is possible but it looked too
ugly so I've decided for the new operation).

This scheme with I_METADATA_WRITEBACK state flag also fixes the problem that
when WB_SYNC_NONE writeback happened between write(2) and fsync(2), fsync(2)
would fail to properly persist the inode. Note that this problem isn't specific
to filesystems using the generic metadata bh tracking. This patch set doesn't
fix such filesystems as it is already big enough but the universality of this
problem among simple filesystems is another reason why I've chosen the new
superblock operation instead of trying to somehow hack up metadata bh tracking
infrastructure.

Previous versions:
Link: http://lore.kernel.org/r/20260511115725.28441-1-jack@suse.cz # v1
Link: http://lore.kernel.org/r/20260525085035.12891-1-jack@suse.cz # v2
Link: http://lore.kernel.org/r/20260702175436.12226-1-jack@suse.cz # v3
Link: http://lore.kernel.org/r/20260716145359.28639-1-jack@suse.cz # v4

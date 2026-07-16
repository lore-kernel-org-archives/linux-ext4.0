Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A980A324B2C
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213760; cv=none; b=sJtxOBlO9/h1eHkXJRvw/h9Flvca6dUsgoLsWxthWTRXittBNeFj6dACEmACOoA4J5X66FHtdNWovzsWZVeuFAmg3c9tEOKIi3V/c2rO522A+Ny9gb24BMHUDjhph7Qt154HJ9UuJytDP5kk8/WCqiLgBIcO9YNR9JBK4CCcmb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213760; c=relaxed/simple;
	bh=v1DxIAFyQGoe5WcbH4xQt4L2Kv0e71L9D8i3VSm1Fko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N6iU9hM5ElzVgvGVqZed03KEfpqkkhFID2d9qw11nh4K0y+COEOSj/F81B5E6vd6bC/ulWuJ54Gh5t2cq47eUCdOUIDaR1bKWlExmyvvmTYyoVrW6MPYlZkzskMaU8s+HomWUbSjcgx3sVFsiFCCa3Hc35KaEcNDZLinmCBvqx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mIXCpzMI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vkKRX9XG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mIXCpzMI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vkKRX9XG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mIXCpzMI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vkKRX9XG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mIXCpzMI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vkKRX9XG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C53113E2F;
	Thu, 16 Jul 2026 14:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IpGwXEiUia+oRm+wFSOiksVcRc6nAmpvu+DCHvBWSvA=;
	b=mIXCpzMIZ5D9p0wBfc8c0lHtOyiF+cAM8JqDwJW6WggRDB38E52buyrdk+RLvop21Eef7X
	fQ+ebMMbrLyb+JFzmf74VV4iQbo4WkjEWAR6+0dJRUlbWx9SP1Qp92TBEYhVy8LHu2a72G
	9gXauyMxngj9Vfvk+Mbdb3NjCQcOIMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213756;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IpGwXEiUia+oRm+wFSOiksVcRc6nAmpvu+DCHvBWSvA=;
	b=vkKRX9XGMjhxoi+vX2HREImd1/mmrRNJJFc0o3iVzEbhzbZji7+JWYufxtNEwRCms792eg
	fftewxZVnRR+pQDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784213756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IpGwXEiUia+oRm+wFSOiksVcRc6nAmpvu+DCHvBWSvA=;
	b=mIXCpzMIZ5D9p0wBfc8c0lHtOyiF+cAM8JqDwJW6WggRDB38E52buyrdk+RLvop21Eef7X
	fQ+ebMMbrLyb+JFzmf74VV4iQbo4WkjEWAR6+0dJRUlbWx9SP1Qp92TBEYhVy8LHu2a72G
	9gXauyMxngj9Vfvk+Mbdb3NjCQcOIMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784213756;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IpGwXEiUia+oRm+wFSOiksVcRc6nAmpvu+DCHvBWSvA=;
	b=vkKRX9XGMjhxoi+vX2HREImd1/mmrRNJJFc0o3iVzEbhzbZji7+JWYufxtNEwRCms792eg
	fftewxZVnRR+pQDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA8B7779AD;
	Thu, 16 Jul 2026 14:55:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1yKDLfzwWGrcXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Jul 2026 14:55:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5512FA0855; Thu, 16 Jul 2026 16:55:52 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v4 0/21] fs: Fix missed inode write during fsync
Date: Thu, 16 Jul 2026 16:55:22 +0200
Message-ID: <20260716145359.28639-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3856; i=jack@suse.cz; h=from:subject:message-id; bh=v1DxIAFyQGoe5WcbH4xQt4L2Kv0e71L9D8i3VSm1Fko=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqWPDZlDMh6RnWrE2VPE3ykwOhvAMKe1jy93Osf Mp89OdA+PKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaljw2QAKCRCcnaoHP2RA 2f46B/9AkvXdSwzXeUG5PRDGGZBQDdt99l/Nzej52kRzoYRpei0GzzejJlEwSJGYVRTEPwPvUuo 1bTv12GRFD5kqP6iZU3g3zMLudfrukGLyCoE3BP27hN/Cpic4G3Wj+6JYUqBzZDP58uDhBuJg1K ElUt+GMigSeIpEJrsxUDBUO2tURage8LnzKuxTVRrS4+nvGE+AJ3i0MFnJW+qEUuL71wQ16cLph 3imNiBomMxwd7RIzJIk1i84C1jzrLZtlcUTzgs551S/aDWU71HL5h6Vy6fX9xFMyzSmrKGPSujg MkfM+exIO7WSh0ctpJwyRs5UCZfW1yL26Qnaq1tCeB8gE5pf
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -1.30

Hello,

here is v4 of the patch series which fixes the possibly missing inode write
during fsync(2) for filesystems using generic metadata bh tracking. This
revision contains mostly small fixes and improvements since v3, neither
Sashiko nor Christian found fundamental issues with this approach.

Patches have survived some testing with fstests so they should be reasonably
sound. I'd just like Ogawa to have a look at FAT changes. Similarly as for
other filesystems I've included some cleanups and simplifications these changes
enabled but it would be good to get a confirmation from the maintainer this is
what they want. I could also limit FAT changes to a bare minimum fixing the
data integrity issues.

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

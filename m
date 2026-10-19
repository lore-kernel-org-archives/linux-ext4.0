Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B674E29E116;
	Mon, 19 Oct 2026 12:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792412630; cv=none; b=f57aFyzT+yy+cM9++GPqDzAC39n86fRisgYDvHuMFM2to0XDqzzuItLG7O1kiBjE5TxxoNvf4EuexcKNKVSh/oQNbWdU/jsAXtdW0m5wVumYfmtG7PVTsaKYfLR8CgrYJk/qc+fkmEig3v84RKq0qmZpVaUdVydHRz48KGGPRmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792412630; c=relaxed/simple;
	bh=5Vl8ZAm1zM0uo9oiwZYU7nsVe57PMVpCLz9UeM4L5ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=F/bpwDvy+ey17oXSoZiVQ86m6/nPBcw+l3QzRY75Bl35foCPYh01lJMghr4xMo7RqSEWGMlwF/tEvj+uOBTq4GWHqZcwodSLTgJhTViRdQdPQVL6gDvrhlOGeuCpdL7dHz24O73BBMWxAy4ZnEeIdd5TGSHP8sXex3CXBQn+0kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mE/gvtSH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AZDDgCoT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mE/gvtSH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AZDDgCoT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mE/gvtSH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AZDDgCoT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mE/gvtSH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AZDDgCoT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 91A7021BE1;
	Mon, 19 Oct 2026 12:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792412621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=3+ut8eXAYbsypS2l6kFJneD6EGkPbt4WNBn29upBWbM=;
	b=mE/gvtSH6yfoSV7sYAA2sTN+AuqGwPioTvWW0olshePcUYrIwJv4ncSyDbbR0vRArqGpUi
	z3JvQpaXY8nwVTweMl6shKAouUxgywmuwkqpc2c0JiR10lGw3lMvl8Rqi7R+AqSxTfvKDQ
	pNZemxRgyFVRyrKpFy1wifRpETZCkcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792412621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=3+ut8eXAYbsypS2l6kFJneD6EGkPbt4WNBn29upBWbM=;
	b=AZDDgCoThpT34HBPG4jdRMVG4NcJ5BG1rGW2u9wVOz5NMIYXY3TYWE6DwN743bEQAqAmRE
	Ou6/2BwBaT3GPMAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="mE/gvtSH";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AZDDgCoT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792412621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=3+ut8eXAYbsypS2l6kFJneD6EGkPbt4WNBn29upBWbM=;
	b=mE/gvtSH6yfoSV7sYAA2sTN+AuqGwPioTvWW0olshePcUYrIwJv4ncSyDbbR0vRArqGpUi
	z3JvQpaXY8nwVTweMl6shKAouUxgywmuwkqpc2c0JiR10lGw3lMvl8Rqi7R+AqSxTfvKDQ
	pNZemxRgyFVRyrKpFy1wifRpETZCkcw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792412621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=3+ut8eXAYbsypS2l6kFJneD6EGkPbt4WNBn29upBWbM=;
	b=AZDDgCoThpT34HBPG4jdRMVG4NcJ5BG1rGW2u9wVOz5NMIYXY3TYWE6DwN743bEQAqAmRE
	Ou6/2BwBaT3GPMAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A96C136CC;
	Mon, 19 Oct 2026 12:23:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QCsFEs0L1mosYwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 12:23:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ED3BEA1413; Mon, 19 Oct 2026 14:23:40 +0200 (CEST)
Date: Mon, 19 Oct 2026 14:23:40 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext2, isofs, udf and quota changes for 7.4-rc1
Message-ID: <7hq6kyrxt57gmxrdrqzgnkwh7ae3vhffao4m6elvxaqygeosxt@3d4qvzwsthgj>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: 91A7021BE1
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fs_for_v7.4-rc1

this time a larger pull (at least for standards of this branch :). The
changes are:

* ext2 changes to support clang context tracking
* multiple isofs hardenings and cleanups
* several udf hardening fixes
* block use of fs-specific quota formats with incorrect filesystem

Top of the tree is 0f242ca08788. The full shortlog is:

Baolin Liu (1):
      isofs: fix Rock Ridge CE extent validation on multisession media

Giorgi Kobakhia (1):
      udf: fix return value for non-recorded-allocated extents in udf_map_block()

Jan Kara (6):
      udf: Make sure there's enough space for LVID implementation use field
      udf: Avoid confusion of missing and corrupted extended attributes
      ocfs2: Refuse to enable ocfs2 format for another filesystem
      shmem: Refuse to enable tmpfs format for another filesystem
      Merge tag 'clang-fixes-once_lite-for-7.4' of https://git.kernel.org/pub/scm/linux/kernel/git/nathan/linux
      isofs: Simplify isofs_read_level3_size()

Jiale Yao (1):
      ext2: drain in-flight DIO before buffered write fallback

Marco Elver (1):
      once_lite: Simplify condition handling and fix context analysis

Matthias Goergens (6):
      isofs: validate directory records in isofs_read_level3_size()
      isofs: bound empty directory blocks in isofs_read_level3_size()
      isofs: return long Joliet names whole
      isofs: report the Joliet name length in statfs
      isofs: pass the name buffer size to get_rock_ridge_filename()
      isofs: shrink the name conversion buffer

Qiliang Yuan (1):
      quota: fix shrinker scan budget accounting in dqcache_shrink_scan()

Tal Zussman (1):
      isofs: convert the zisofs read path to use folios

Timothy Day (8):
      ext2: mark s_next_generation as guarded by s_next_gen_lock
      ext2: annotate ext2_update_dynamic_rev() as requiring s_lock
      ext2: mark statfs overhead cache as guarded by s_lock
      ext2: mark s_mount_state as guarded by s_lock
      ext2: annotate ext2_init_block_alloc_info() as requiring truncate_mutex
      ext2: annotate block-mapping helpers as requiring truncate_mutex
      ext2: annotate s_rsv_window_root as requiring s_rsv_window_lock
      ext2: enable context analysis support for ext2 filesystem

Yunpeng Tian (1):
      udf: validate the device specification EA before using it

The diffstat is

 fs/ext2/Makefile          |  2 ++
 fs/ext2/balloc.c          |  4 +++
 fs/ext2/ext2.h            | 19 +++++++-----
 fs/ext2/file.c            |  7 +++++
 fs/ext2/inode.c           |  7 +++++
 fs/ext2/super.c           | 33 +++++++++++---------
 fs/isofs/compress.c       | 77 ++++++++++++++++++++++++++---------------------
 fs/isofs/dir.c            | 14 +++++++--
 fs/isofs/inode.c          | 70 +++++++++++++++++-------------------------
 fs/isofs/isofs.h          | 16 ++++++++--
 fs/isofs/joliet.c         | 27 ++++++++++++-----
 fs/isofs/namei.c          |  8 +++--
 fs/isofs/rock.c           | 19 +++++++++---
 fs/ocfs2/quota_local.c    |  4 +++
 fs/quota/dquot.c          | 16 ++++++++++
 fs/udf/inode.c            | 54 +++++++++++++++++++++++++++++----
 fs/udf/misc.c             | 15 ++++-----
 fs/udf/super.c            |  5 ++-
 include/linux/once_lite.h |  8 +++--
 mm/shmem_quota.c          |  5 +++
 20 files changed, 276 insertions(+), 134 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

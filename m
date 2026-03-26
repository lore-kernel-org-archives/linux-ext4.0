Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6893BE630
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 09:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518912; cv=none; b=L2IViiEZA0RISWe8duKIim0301TXtzpKvqkLF+RoOGtXNoqD/6Dw9j7gjXTtueZE3j1A8kJyCM9AFXBplZqi5P7o6l2+hF3+rCMLMAvobtn+AzSVjEtvk02krk4uKAB+AZ5xfLtBQxpR3v/bmEOh9q9r21SV2Uo7HqGusYCHk00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518912; c=relaxed/simple;
	bh=OcbPNXnG/ezx6KsPDRBMMef9MCYy/KlpWJbDBHz3UEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F34NYzn6FW8ZocAzdxu9yrTW3+cHYYT+poidVHM71jGNAwQV7r9jJP302utW6kVTuSE0OB+3XjFEBfZHJ1XroTGQJSp1dtopP7Rnl8JSV++yeOfPhaN4EUlQGLM6gMqiaXDBKaXTfX28mHlMTZE2VklkDNcUqTOCBPO+vx51ac4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mMw9FFYi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mxnNgLTD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mMw9FFYi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mxnNgLTD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mMw9FFYi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mxnNgLTD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mMw9FFYi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mxnNgLTD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D268A4D279;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aRkR63p1jpFA0esSQKuE1SlJEZWNddmmmMLZ5RvIZyY=;
	b=mMw9FFYiJgTxvm2jOoucSvEKz2U7CWOrgzoVrYMEGvgYO0FGfAB2yFocxUaY+FxiEi4+sm
	fiNUs6Vwt3Yf25EW3iASny5GWdj+U/7+jMxHQxUIincKucdzTko0bFAcmnNJ8fP8Enhsb9
	yYtmoNsJNWG1SfV6u+1nH/K2lxYQ+Wo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aRkR63p1jpFA0esSQKuE1SlJEZWNddmmmMLZ5RvIZyY=;
	b=mxnNgLTDh78L6iaUILUrTIWzmlO0FdM/XohW5IMysSSlwlXT+3PbizvPRt0y30KMYRyFzS
	audeizPvgreVrhAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mMw9FFYi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mxnNgLTD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aRkR63p1jpFA0esSQKuE1SlJEZWNddmmmMLZ5RvIZyY=;
	b=mMw9FFYiJgTxvm2jOoucSvEKz2U7CWOrgzoVrYMEGvgYO0FGfAB2yFocxUaY+FxiEi4+sm
	fiNUs6Vwt3Yf25EW3iASny5GWdj+U/7+jMxHQxUIincKucdzTko0bFAcmnNJ8fP8Enhsb9
	yYtmoNsJNWG1SfV6u+1nH/K2lxYQ+Wo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aRkR63p1jpFA0esSQKuE1SlJEZWNddmmmMLZ5RvIZyY=;
	b=mxnNgLTDh78L6iaUILUrTIWzmlO0FdM/XohW5IMysSSlwlXT+3PbizvPRt0y30KMYRyFzS
	audeizPvgreVrhAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B39D94A0A6;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P54yK3ACxWmeYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6A209A0976; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH v3 0/42] fs: Move metadata bh tracking from address_space
Date: Thu, 26 Mar 2026 10:53:54 +0100
Message-ID: <20260326082428.31660-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4261; i=jack@suse.cz; h=from:subject:message-id; bh=OcbPNXnG/ezx6KsPDRBMMef9MCYy/KlpWJbDBHz3UEY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQIxTA34/xtU7IgqXiNrsxzCFcUYmjrIjwuOu RDjeyFNXc6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCMQAKCRCcnaoHP2RA 2flRCADUBXWyzZCdBg87axquExTTc4wlsGjblaPAMJfU3zifFLDeVwWmLLmik7Pj8xaFEGkNv5c 7NcDloLN9y1e16RUdr3IuzqynO9S5A0uYJo6eXgwpuhZPSlqFBmpTwTCuPPQ1xzrctDqN/mUqc9 w6L1SNBE+z+S4V3uxEtqURRIo08bTJqMh0K7XajYSiscBEVomuwoFqhHlTzN6utd6Vee57pZBRU 1EQUCunm6C7HIkc5q63JnTAZnFz60X5t1BwDoxjkebaad2qFmmf1hIRpFn0/zB8u2Yxw5IdNCWN 9OLAVCh8JXchU1pisDLogFOi+h50+5jyFV+M3wstbDEipslp
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.cz:+];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -1.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D268A4D279

Hello,

here is a next revision of the patchset cleaning up buffer head metadata
tracking and use of address_space's private_list and private_lock. Functionally
this should be identical to v2, most of the changes were in improving
changelogs, patch ordering, function names, etc. The patches have survived some
testing with fstests and ltp however I didn't test AFFS and KVM guest_memfd
changes so a help with testing those would be very welcome.  Thanks.

Changes since v2:
* Added Reviewed-by tags from Christoph
* Dropped the patch unifying fsync implementation in fs/libfs.c and fs/buffer.c
* Put fsync locking change into a separate commit
* Reordered series to place all fsync path modifications close together
* Improved some changelogs
* Renamed some functions based on Christoph's feedback

Changes since v1:
* Fixed hugetlbfs handling of root directory
* Reworked mapping_metadata_bhs handling functions to get the tracking
  structure as an argument so we now don't need iops method to fetch the struct
  from the inode
* Reordered patches into more sensible order
* Added patch to merge two mostly duplicate generic fsync implementations
* Added Reviewed-by tags
* Couple more minor changes that were requested during review

Original cover letter:

this patch series cleans up the mess that has accumulated over the years in
metadata buffer_head tracking for inodes, moves the tracking into dedicated
structure in filesystem-private part of the inode (so that we don't use
private_list, private_data, and private_lock in struct address_space), and also
moves couple other users of private_data and private_list so these are removed
from struct address_space saving 3 longs in struct inode for 99% of inodes.  I
would like to get rid of private_lock in struct address_space as well however
the locking changes for buffer_heads are non-trivial there and the patch series
is long enough as is. So let's leave that for another time.

 block/bdev.c                |    1 
 fs/affs/affs.h              |    2 
 fs/affs/dir.c               |    1 
 fs/affs/file.c              |    1 
 fs/affs/inode.c             |    2 
 fs/affs/super.c             |    6 
 fs/affs/symlink.c           |    1 
 fs/aio.c                    |   78 +++++++-
 fs/bfs/bfs.h                |    2 
 fs/bfs/dir.c                |    1 
 fs/bfs/file.c               |    4 
 fs/bfs/inode.c              |    9 +
 fs/buffer.c                 |  387 +++++++++++++++++---------------------------
 fs/ext2/ext2.h              |    2 
 fs/ext2/file.c              |    1 
 fs/ext2/inode.c             |    3 
 fs/ext2/namei.c             |    2 
 fs/ext2/super.c             |    6 
 fs/ext2/symlink.c           |    2 
 fs/ext4/ext4.h              |    4 
 fs/ext4/file.c              |    1 
 fs/ext4/inode.c             |    9 -
 fs/ext4/namei.c             |    2 
 fs/ext4/super.c             |    9 -
 fs/ext4/symlink.c           |    3 
 fs/fat/fat.h                |    2 
 fs/fat/file.c               |    1 
 fs/fat/inode.c              |   16 +
 fs/fat/namei_msdos.c        |    1 
 fs/fat/namei_vfat.c         |    1 
 fs/gfs2/glock.c             |    1 
 fs/hugetlbfs/inode.c        |   10 -
 fs/inode.c                  |   24 +-
 fs/minix/file.c             |    1 
 fs/minix/inode.c            |   10 +
 fs/minix/minix.h            |    2 
 fs/minix/namei.c            |    1 
 fs/ntfs3/file.c             |    3 
 fs/ocfs2/dlmglue.c          |    1 
 fs/ocfs2/namei.c            |    3 
 fs/udf/file.c               |    1 
 fs/udf/inode.c              |    2 
 fs/udf/namei.c              |    1 
 fs/udf/super.c              |    6 
 fs/udf/symlink.c            |    1 
 fs/udf/udf_i.h              |    1 
 fs/udf/udfdecl.h            |    1 
 include/linux/buffer_head.h |    6 
 include/linux/fs.h          |   11 -
 include/linux/hugetlb.h     |    1 
 mm/hugetlb.c                |   10 -
 virt/kvm/guest_memfd.c      |   12 -
 52 files changed, 360 insertions(+), 309 deletions(-)

								Honza

Previous versions:
Link: http://lore.kernel.org/r/20260303101717.27224-1-jack@suse.cz # v1
Link: http://lore.kernel.org/r/20260320131728.6449-1-jack@suse.cz # v2

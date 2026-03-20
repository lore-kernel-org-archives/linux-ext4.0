Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DF02BE05F
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 13:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014108; cv=none; b=btZxx/ggDpHznfjbvuN380qL+UccWMq7dSmbIc6XXgDE6WU30BLNhG3fKJoaFTkgS0IW0vVdpL2/JCIAUyNo3i23by5lxaMAQ6aQocMkAJM9dvdyvebDhykQVYOep3VVSebL8ORhmOMZJaoU/4q26i2R1M8rhn0wCjwMpnDQJA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014108; c=relaxed/simple;
	bh=y6WPXhW4cDJwB9kwDgAQyXGA/gUvqttY8DQs+1VHgDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZgHnHXUhkJU4HL9N8B+u5mzicLF/iu+OIuBxxEt4I4t4fFkpWjFdto9dA5MijDN8ZH9A+4a3ithozuo0cNkbDzShK145VyVAHKUChFeVCjd6Nq8G6gAUSA9i4+d+ImjJlqPaK+aMN/fmsDFw49TtpTEBCO7FeUmJD0Ql++b/4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gmnOpu/5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7EEUisOI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gmnOpu/5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7EEUisOI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gmnOpu/5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7EEUisOI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gmnOpu/5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7EEUisOI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BBE765BDEF;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OyM48/22ZVuruDJ69nmr7bHs73Kh7MfWTw+h4KYSv5w=;
	b=gmnOpu/5wdK6Qs8QbtvbcYDj86UssvLTCXCLdxFDNWepjRtnobFty6SiLwjGYtty9BapWh
	QHMBCXgf8IulnHir0YVAA+rOALLAOdikQCrC0fSxvHio0Pmhev9rXvLfCnWrFeWml+LQm2
	UJhjDX34BM1c0Hy3F1b8IqodCq7S6aM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OyM48/22ZVuruDJ69nmr7bHs73Kh7MfWTw+h4KYSv5w=;
	b=7EEUisOIHKhMaJAAlWHak2MHaKe8yHCnH6OyCJJQ7zX+wY2j2ra88EDKcPIHbCvDehXD6S
	WMYQBiUT7XByKFCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OyM48/22ZVuruDJ69nmr7bHs73Kh7MfWTw+h4KYSv5w=;
	b=gmnOpu/5wdK6Qs8QbtvbcYDj86UssvLTCXCLdxFDNWepjRtnobFty6SiLwjGYtty9BapWh
	QHMBCXgf8IulnHir0YVAA+rOALLAOdikQCrC0fSxvHio0Pmhev9rXvLfCnWrFeWml+LQm2
	UJhjDX34BM1c0Hy3F1b8IqodCq7S6aM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OyM48/22ZVuruDJ69nmr7bHs73Kh7MfWTw+h4KYSv5w=;
	b=7EEUisOIHKhMaJAAlWHak2MHaKe8yHCnH6OyCJJQ7zX+wY2j2ra88EDKcPIHbCvDehXD6S
	WMYQBiUT7XByKFCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8EE742819;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qchCKZhOvWk8CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54360A0A81; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH v2 0/41] fs: Move metadata bh tracking from address_space
Date: Fri, 20 Mar 2026 14:40:55 +0100
Message-ID: <20260320131728.6449-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3705; i=jack@suse.cz; h=from:subject:message-id; bh=y6WPXhW4cDJwB9kwDgAQyXGA/gUvqttY8DQs+1VHgDU=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGDL3+qUxbG63YdnZY3I2/8ukT1OLL3KdmtUmWbxfy3Ou+ zEXw1+lnYzGLAyMHAyyYoosqyMval+bZ9S1NVRDBmYQKxPYFC5OAbiIOwfDDTaD6HZ9hcvZqnsZ ZDTtopo9beJSL0UyWs9x1H/6klVH/bLzspPbN1q9OnV7BnOvZZwYK6dj4VKePTW/3/hd/rXy0tc fR+cnl4ak1SukvpwwLaIj2J/htOfH8LlK3HNET+0J+zAt/HL5p1ie70uWMafxyXPPCzny9oym+V nXzwsKA12cGLfdWXZA5JrG+8qfNms++BVP7vR2+X55TUmonuTL+p7Lp/RqD7E0GibKXjirUnxSn 6lU6V3XiZMmKobXuGo/5glY3XYLPyIz2WniPu+DWzwjnyUZfbs02eBRnFCF3zI2z7g0ye5jn82O Oc7YeXzy2eXH3ZYZi9w9tfGjzrxJJg7LdBWD75VNbi4AAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,ZenIV.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,suse.cz];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spam-Level: 

Hello,

here is a next revision of the patchset cleaning up buffer head metadata
tracking and use of address_space's private_list and private_lock.  The patches
have survived some testing with fstests and ltp however I didn't test AFFS and
KVM guest_memfd changes so a help with testing those would be very welcome.
Thanks.

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

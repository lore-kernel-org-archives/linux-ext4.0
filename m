Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794893297;
	b=lbJzLf9kHK/2g+EMToVb7qWClbY3S7sAszSP7QOnuFZbwycT9VKnooS+j3pq5kumUHnv
	 +YxcDVyN6og/BqWFjSebI9qWa+MQsk3B7rM2i19rfxbGoMt1oCzeu63JRysbbVm/AYXy+
	 KiSrch4qd6pp1ITvfx37ErCZ6lSBATwA8ic7FEwAFrvqkpWItMfG5NZq4pQz3yEJ8r8V7
	 8yRhhJQq9cKlyynyCcz/bkOFHBVhTJ7PecqygwiFO3ZN0Y7H5lBpxGnGicFldSx4UiRMo
	 sKuLvUvvwD1emEClmrglFBZkQM/VYLMOypOKsUKrBznb815Jau9Qrp4IQzQLyup0iMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794893297;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=AkC4HRcXZ3W10cE0ifydpWzh6k0gIsLh+NHRXImZUpY=;
	b=UWTOMe23gSG8+62vypX3pxTieSql2E33fDRd0NAWIyRNRXjouciVN3S+byKFc0Xkb4TA
	 D7h5ZB2SWbWiolHCpGnk00UJWuWkHB+QZxJMJD0LwFZTD/86bQRemOs+spWp8d2ZvWdpz
	 gHmv5lPRKTPkCIu5e+KcE+zJkcyfg+cxb5WQYqHpNDa4+fkSA+a/4KI4UlZJhS36eSCgl
	 UX7/uwDThwj1G2QkblIZehD2GJnjBAbmCymfoSG3FAXsT5opMIjESm7Kr1k/X6gS22VIT
	 T762W826JPa8kUt77dulmBhfX/XDvAFiBjRsAcLqvrbcHn0HxTkGFJWJJEdGGUG2A6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=logarcheon.com;
	spf=pass smtp.mailfrom=logarcheon.com;
	dkim=pass header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b=fYo5NLLx;
	arc=none smtp.remote-ip=185.70.43.97
Received: from mail-4397.protonmail.ch (mail-4397.protonmail.ch [185.70.43.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D768F606A883
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 05:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D768F606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=logarcheon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=logarcheon.com header.i=@logarcheon.com header.a=rsa-sha256 header.s=protonmail3 header.b=fYo5NLLx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=logarcheon.com;
	s=protonmail3; t=1794893294; x=1795152494;
	bh=AkC4HRcXZ3W10cE0ifydpWzh6k0gIsLh+NHRXImZUpY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=fYo5NLLxu6r8lXr3L+K1QWmRkAvqGQaTtp9iL6nLhYkB4KarVlLzI/akmj9IKKbRH
	 DrJnMFpcolXLpqZuH2qcVdkOH4EhUxKoZW4X92d2iEkAPLcWe5xDxUFHtbRDDTVkpI
	 TkvAiH8V+0dmTnHwNEnh3wAP1Xe2EfDoJ5ODva/D6nS26j3vWWfgJXHUHBq6+A5jvv
	 8L0HRg6X0BnsO+lySsc7Hf9JATXVlJtQomDqBFNgM6FvrT0TNv4kN8Z1PE0uDYrigm
	 tNlULmsNG2aIflqL0HcVeiE7l3CH1ZsjcbvKj/R/aPPmEXMtC5pFtZrGZjalTYLFFV
	 yrCscSB9EZcPg==
Date: Tue, 17 Nov 2026 05:28:11 +0000
To: Theodore Ts'o <tytso@mit.edu>
From: William Chuang <founder@logarcheon.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: [PATCH 2/2] ext4: reserve an orphan credit for inline data writes
Message-ID: <20261117052750.2955-3-founder@logarcheon.com>
In-Reply-To: <20261117052750.2955-1-founder@logarcheon.com>
References: <20261117052750.2955-1-founder@logarcheon.com>
Feedback-ID: 145408520:user:proton
X-Pm-Message-ID: 13114dd70f3842f1980d8350a31e840042d5a1f6
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

ext4_generic_write_inline_data() starts its handle with one credit.
ext4_prepare_inline_data() uses it when it creates or grows the inline
data xattr and dirties the inode table block.

If the copy from user space then comes up short, write_end calls
ext4_write_inline_data_end(), which sees pos + len > i_size and calls
ext4_orphan_add() under the same handle.  That dirties a second block,
the orphan file block or the superblock, and the handle has no credit
left for it:

  WARNING: fs/jbd2/transaction.c:1598 at jbd2_journal_dirty_metadata
  Call Trace:
   __ext4_handle_dirty_metadata
   ext4_orphan_file_add
   ext4_orphan_add
   ext4_write_inline_data_end
   generic_perform_write
   ext4_buffered_write_iter
   ext4_file_write_iter

jbd2 returns -ENOSPC, the journal is aborted and write() fails with
ENOSPC.  An unprivileged user who can write to a file on such a
filesystem can trigger this.  The inode table block must not already
be dirty in the running transaction, which is the case with lazytime,
or when the write is the first change to that block since the last
commit.  The block write path already reserves an extra credit for
this case in ext4_write_begin().

Start the inline handle with two credits.

Tested on UML with filesystems made by "mke2fs -O inline_data", with
and without orphan_file, mounted with lazytime: a write to a new file
whose user buffer runs into an unmapped page after 10 of 21 bytes.
Without this patch the WARN fires ("credits 2/0") and write() fails
with ENOSPC, also when run as uid 65534; with it there is no warning,
write() returns 10, and e2fsck -fn is clean.

Fixes: f19d5870cbf7 ("ext4: add normal write support for inline data")
Reported-by: syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3De8180f5590685cbc9037
Signed-off-by: William Chuang <founder@logarcheon.com>
---
 fs/ext4/inline.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66..a1ae23888 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -709,7 +709,12 @@ int ext4_generic_write_inline_data(struct address_spac=
e *mapping,
 =09=09return ret;
=20
 retry_journal:
-=09handle =3D ext4_journal_start(inode, EXT4_HT_INODE, 1);
+=09/*
+=09 * One credit for the inode table block, plus one for the orphan
+=09 * file block or superblock that ext4_write_inline_data_end() may
+=09 * dirty via ext4_orphan_add() after a short copy.
+=09 */
+=09handle =3D ext4_journal_start(inode, EXT4_HT_INODE, 2);
 =09if (IS_ERR(handle)) {
 =09=09ret =3D PTR_ERR(handle);
 =09=09goto out_release_bh;
--=20
2.43.0



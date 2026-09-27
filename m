Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B19346E70;
	Sun, 27 Sep 2026 07:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790492545; cv=none; b=D9VTlwXvZkZJO4yfs7wHSlTqmFxuFucDHCRQ2UkZZwQ2cGIjSCTx7VIQtEDjfgDPfsNwt76++1SCQcIgBoXG5YsyBaOE2nMUT5TDwgZIMfv44k47fhrqNNfSjBzOc10LpzQXce0LyiaMyG3lzV1js+ubdf6Di3pi9k7e9CL4hko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790492545; c=relaxed/simple;
	bh=4GJ13IWcPjWaUXa8jMggP9BDJTRfHjF4AEkLaUqiH4c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aFhI5OoMgTyeu6sxRM1gxMNsFXURm4Cb9JsqfST1miwtqlzPfGSIQ2Vw+7B6bSQnlZhrlqxPUcPppQmuml/MtXP0SDYjnr5nSS98LoCjBKi4NLBepirl3qhEKp+o1NtHukR7HfF55jPe3dq+IMTInoQdfLdwBUWOyIkfC36bVgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iI6pHoUl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JDDZOnHn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ROf4rYh+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CLC3IQzb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iI6pHoUl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JDDZOnHn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ROf4rYh+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CLC3IQzb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E402021E71;
	Sun, 27 Sep 2026 07:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790492532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5BIpyzpFhUTjXE4iGhZKarMO0HJAxtBWhlrJwRgsjRw=;
	b=iI6pHoUlEws+GNp6AKWDB3CN0w4gZVIu/4onumaT1baG8dPh4ojciex5JdAzhZ0+9LMRx7
	Akiq3eren4C2O5jUFoCJ1o8qXZ5pfzmwzlvsU0REzv6MeaU3cOLLSPFTn2Hp3UCvJubi/h
	BbYL/jtizXeqGfs86CqYJWXiRyzEfWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790492532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5BIpyzpFhUTjXE4iGhZKarMO0HJAxtBWhlrJwRgsjRw=;
	b=JDDZOnHn/iFwT41w7oqMvvG1FRjvtDiviOTVxap2/TvqaPK4B+AfJ6YzSAdzZzsiHxBZQZ
	E3fotKVM5nfRjtAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ROf4rYh+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CLC3IQzb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790492527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5BIpyzpFhUTjXE4iGhZKarMO0HJAxtBWhlrJwRgsjRw=;
	b=ROf4rYh+/9GYig2Da3M5Iu4/q/F99fP+RsWMlc+iVksKdSM6GVoSorYP7y8NneeJkZBdIA
	U6u3lKd510eKe73IzPvnaZGcJQWWWyc405+Mozk7Prz20Vpc1JpBQr3CwQPxWzRuvfkKoD
	v7jtxUqc2op/tikUhvQ2NM7yCsWm0z0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790492527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5BIpyzpFhUTjXE4iGhZKarMO0HJAxtBWhlrJwRgsjRw=;
	b=CLC3IQzbgPlclo821E13H6iT3OClrKWxp9Warc8aOSZ7Vp/wCY6TEiQ+y6UPh88ghV4q1k
	WQxmwkUiDPdJzXBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CC9B133F1;
	Sun, 27 Sep 2026 07:02:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iL1nC2+/uGo/dgAAD6G6ig
	(envelope-from <krisman@suse.de>); Sun, 27 Sep 2026 07:02:07 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Daniel Tang <danielzgtg.opensource@gmail.com>, =?utf-8?Q?Andr=C3=A9?=
 Almeida
 <andrealmeid@igalia.com>, Christian Brauner <brauner@kernel.org>,
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 smcv@collabora.com, kernel-dev@igalia.com, linux-kernel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [BUG] Is casefold unreported in /proc/mounts?
In-Reply-To: <5193732.31r3eYUQgx@daniel-desktop3>
Organization: SUSE
References: <5193732.31r3eYUQgx@daniel-desktop3>
Date: Sun, 27 Sep 2026 03:02:01 -0400
Message-ID: <877bk7yy6u.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E402021E71
X-Spamd-Result: default: False [-2.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	SUBJECT_ENDS_QUESTION(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,igalia.com,kernel.org,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -2.01

--=-=-=
Content-Type: text/plain

Daniel Tang <danielzgtg.opensource@gmail.com> writes:

> Upon successfully mounting via `sudo mount -t tmpfs -o casefold test /mnt`, I
> cannot find a read-only way to determine whether this option is enabled.
> `mount`, `cat /proc/mounts`, and `cat /proc/mountinfo` only display "rw",
> "relatime", and "inode64", never "casefold" for both with and without
> `-o casefold`. The only way on 7.0.0-34-generic to test I found is
> `mkdir test ; chattr +F test ; echo $?`, but that isn't atomic. Which command
> can determine, without writing anything, whether someone or some program
> specified `-o casefold`? If absent, I suggest adding the missing info to
> `/proc/mounts`, likely `mm/shmem.c:shmem_show_options`.

Yeah.  For device-backed filesystems it is not a mount parameter, but it
is for shmem/ovl and should show in /proc/mounts.

Either way, there are two ways to check:

1) Parse dmesg after the mount. It is easily overwritten and probably
worse than just trying;

2) better way: do FS_IOC_SETFLAGS on the mountpoint (with chattr
+F).  If casefold is supported, you'll get -ENOTEMPTY, otherwise you get
-EOPNOTSUPP.  Since it is the root of the filesystem and a single
syscall, unless its remounted from under you (in which case /proc/mounts
doesn't help either), you are safe.

It is worth mentioning you can check kernel support with
/sys/fs/*/features/casefold.  We probably should add the same for
/sys/fs/ext4/<disk>/.

This fixes /proc/mounts for shmem: 


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-shmem-Report-casefold-setting-in-mount-options.patch

From c4b198424fac49e10e32553b223b7615febc6513 Mon Sep 17 00:00:00 2001
From: Gabriel Krisman Bertazi <krisman@suse.de>
Date: Sun, 27 Sep 2026 02:49:26 -0400
Subject: [PATCH] shmem: Report casefold setting in mount options

For not device-backed filesystems, casefolding is a mount option.
Report the current encoding and casefolding flags in /proc/mounts so
userspace can easily check if casefolding is supported.

Reported-by: Daniel Tang <danielzgtg.opensource@gmail.com>
Link: https://lore.kernel.org/linux-fsdevel/5193732.31r3eYUQgx@daniel-desktop3/#R
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 mm/shmem.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..2b93fcbf5127 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4916,6 +4916,17 @@ static int shmem_show_options(struct seq_file *seq, struct dentry *root)
 	if (sbinfo->qlimits.grpquota_ihardlimit)
 		seq_printf(seq, ",grpquota_inode_hardlimit=%lld",
 			   sbinfo->qlimits.grpquota_ihardlimit);
+#endif
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (root->d_sb->s_encoding) {
+		unsigned int version = root->d_sb->s_encoding->version;
+
+		seq_printf(seq, ",casefold=utf8-%u.%u.%u",
+			   unicode_major(version), unicode_minor(version),
+			   unicode_rev(version));
+		if (sb_has_strict_encoding(root->d_sb))
+			seq_puts(seq, ",strict_encoding");
+	}
 #endif
 	return 0;
 }
-- 
2.55.0


--=-=-=--

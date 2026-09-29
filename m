Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A73343D86
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2026 00:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641141; cv=none; b=V6HNx+42QxUTTlVke9hTMoAxF/hvOYrZsvTHMVIynQEwysDE6GD2pVe3maCtQ1UgAb7oY4rHodkqhjpfd/0A9ZM98pxF5O7IRiTzj12icrJMHH450VxfpNTsOOoUeSfYz3Lg8xk1feLTEUTDOenjvJScLGSHePh1HFsvHuxF5jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641141; c=relaxed/simple;
	bh=IZmvuJ/cB2Ukwi0Ed0PQxNxoWM3wlUYZa4MwiOaqkw8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PelIOJ99StRjI/SCINrbM03ssET/YFHQdq+oeCCcpdFnre34nSOwkhETP/1TlqRrJ/Ee/bs8jX1Uwg56sKVBCaQazWBdzXl1yYT59Zzu2w2P6La+Vhy6csrvYnaTdVbj5zceLhAc5JdDHKRuCRSSB/DfTNEyqtKkgUncOMua1JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b+IELGtn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Tvu7wUXP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0uDpQJ/L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8Rjx6FdF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b+IELGtn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Tvu7wUXP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0uDpQJ/L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8Rjx6FdF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 561281F793;
	Tue, 29 Sep 2026 00:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790641132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OY7PKLcapT3BnjwNrptJ242k7jAeI/f1YFmK8jfY0yA=;
	b=b+IELGtnIxJo6nUI6hmcfC2prMx9b8iGYeuP9OQRE4awMysy9RVZSS7LH/O69mNDmJifjC
	c7Hqx6zIqMKnnhGFvjFAO4dvrgOdkzaR+7qnoERZCmtOe/F7lxw64+h8OQLEGyhULp1HsD
	9QgN9V3fnDTYBIKS6pEll26eDWZUxqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790641132;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OY7PKLcapT3BnjwNrptJ242k7jAeI/f1YFmK8jfY0yA=;
	b=Tvu7wUXP4mg+wQCG/wSu0IX/XWo9s5hosLUxQ1m2s/YASMW4ReIRk1fSWcbbkS0z84J0Pm
	k9prq+SMVBsfujAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0uDpQJ/L";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8Rjx6FdF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790641128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OY7PKLcapT3BnjwNrptJ242k7jAeI/f1YFmK8jfY0yA=;
	b=0uDpQJ/L2giZ19Rr669DiITiXuqRDT4NxGWzsqdI9WcF3uQHi/WcA1j4qH+i+2UHM4je7i
	dgisAhPKv9qPAnPr+FOVREJ1DlpFfyaSbiwMi1kMOO9RUUG3nBJ3ZOrMu4aiv/AEAyfCiT
	hUBtTzIy7tcFZS89rCdK8cKxgIhkMMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790641128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OY7PKLcapT3BnjwNrptJ242k7jAeI/f1YFmK8jfY0yA=;
	b=8Rjx6FdFvtQXxMyYMsnDpATA8kPOuA7PYOh0eC+3zLIAeAyG9GW6VRJhUFQHAO9jG9njVG
	t/uG3KQO+BE1HjAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ECFBE133F1;
	Tue, 29 Sep 2026 00:18:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TuLPK+cDu2rGWgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 29 Sep 2026 00:18:47 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: sashiko-reviews@lists.linux.dev
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/4] ext4: Expose the filesystem encoding through sysfs
In-Reply-To: <20260928214542.2DFDC1F000FF@smtp.kernel.org>
Organization: SUSE
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-3-krisman@suse.de>
 <20260928214542.2DFDC1F000FF@smtp.kernel.org>
Date: Mon, 28 Sep 2026 20:18:46 -0400
Message-ID: <87se2syknt.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 561281F793
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	MISSING_XM_UA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] ext4: NULL pointer deref in encoding_show() via dynamic casefold
> --
>
> commit c325498f77eea14582e06218baa713f49fde001a
> Author: Gabriel Krisman Bertazi <krisman@suse.de>
>
> ext4: Expose the filesystem encoding through sysfs
>
> This commit introduces new sysfs attributes in ext4 to display the active
> filesystem encoding and encoding flags. This provides users with a direct
> interface to check casefold support without relying on dmesg parsing.
>
>> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
>> index 923b375e017fa..bc1c59d67eed8 100644
>> --- a/fs/ext4/sysfs.c
>> +++ b/fs/ext4/sysfs.c
> [ ... ]
>> @@ -161,6 +163,25 @@ static ssize_t err_report_sec_store(struct ext4_sb_=
info *sbi,
>>  	return count;
>>  }
>>=20=20
>> +static ssize_t encoding_show(struct ext4_sb_info *sbi, char *buf)
>> +{
>> +#if IS_ENABLED(CONFIG_UNICODE)
>> +	struct super_block *sb =3D sbi->s_sb;
>> +
>> +	if (ext4_has_feature_casefold(sb))
>> +		return sysfs_emit(buf, "UTF-8 (%d.%d.%d)\n",
>> +				  unicode_major(sb->s_encoding->version),
>> +				  unicode_minor(sb->s_encoding->version),
>> +				  unicode_rev(sb->s_encoding->version));
>
> [Severity: High]
> Does this introduce a regression where reading the sysfs attribute causes=
 a
> NULL pointer dereference if casefold is enabled dynamically?
>
> If a privileged user dynamically enables EXT4_FEATURE_INCOMPAT_CASEFOLD on
> an online filesystem via the EXT4_IOC_SET_TUNE_SB_PARAM ioctl, it updates
> the in-memory on-disk superblock representation but does not load the
> unicode map into the VFS superblock:
>
> fs/ext4/ioctl.c:ext4_ioctl_set_tune_sb() {
>     ...
>     if ((params.set_feature_incompat_mask &
>          EXT4_FEATURE_INCOMPAT_CASEFOLD)) {
>         enabling_casefold =3D 1;
>     ...
> }
>
> In this state, ext4_has_feature_casefold(sb) evaluates to true, but
> sb->s_encoding remains NULL. If the sysfs attribute is read,
> encoding_show() will unconditionally dereference sb->s_encoding->version,
> resulting in a system crash.

Uh...

If we flip EXT4_FEATURE_INCOMPAT_CASEFOLD without loading the casefold
table, I'm surprised the current code doesn't blow up already.  I
completely missed the introduction of EXT4_IOC_SET_TUNE_SB_PARAM, so I'm
missing context if there is a use case to actually do an online flip of
feat_casefold.  It seems the ioctl actually can set this bit, but I
don't see any provision to load the table.  I'm a bit confused now.  I
can work around it for /sys/fs, but is anyone actually enabling casefold
without a remount?

>
>> +#endif
>> +	return sysfs_emit(buf, "(none)\n");
>> +}
>> +
> [ ... ]
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928213155.26=
12039-1-krisman@suse.de?part=3D2

--=20
Gabriel Krisman Bertazi

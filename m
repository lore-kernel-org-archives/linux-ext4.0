Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE7A481A82
	for <linux-ext4@vger.kernel.org>; Fri,  2 Oct 2026 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790940552; cv=none; b=dYxUKL7etxQvzyHlGrbzw+KDkHFkrTZWgxBZEsV6Vvr1XvHZnmEitNoJtmv+dXrpU74Ja2pC/OFzsyR+PBK6ooTNgFui8PmPJuq8FnCWK+tL7pOLiZf0u9Zdxbx7lOua9rzNiMup+dvnMjuE/PjOLM2zcWFqlAaLYXAA+QOSZP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790940552; c=relaxed/simple;
	bh=jNhHAptubavNqT8rwEft1+N+XoeT+6gntwBeGHhci5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+/nfkiF3LNLD/mSnOkAegx/26+xUTAWQIK9WOpaF18PeGRBXLXl4kYNztPAIF4Jzw/NXrjN3as6NVkEMGKCbtdPsqgQEPsvWB7iQZRZtZhORn2uu2EYAnL/mELiBmKApu/CEtI7eJWYF7Ntq8PRk0eehVhPjAez96gdqqhaqYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OrtCUSEu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q2/WkBJb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F9v6Ouvq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3r7cAXhC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OrtCUSEu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q2/WkBJb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F9v6Ouvq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3r7cAXhC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8CBDB1FE55;
	Fri,  2 Oct 2026 11:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790940544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooQXZcANDK9ppx08gicOeYoli2x67LvTQ64id6aGvAk=;
	b=OrtCUSEuvh7Ik+87qjHxLBxTZVaMJfQ916Goa1S4PqtlGWWEp/aWPszrK0tfD4PrAcKTMB
	JKOA8KHLxpMVMXZykt95OQB6zD3Afas0VXZ2qIcgEbO2sET6KKylj+A3ESOmnVxXqkdjvx
	rmr98SCln4nSLzZFnGDTGO9zD5ku/D8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790940544;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooQXZcANDK9ppx08gicOeYoli2x67LvTQ64id6aGvAk=;
	b=Q2/WkBJbxkw3hpbm+3nnXHlah5tKsmgQ8GUtW9JVr4C7SyLHCXomCkCk1I/k1A0YeENwec
	zbJLhLPmRfh/C3BQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F9v6Ouvq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3r7cAXhC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790940540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooQXZcANDK9ppx08gicOeYoli2x67LvTQ64id6aGvAk=;
	b=F9v6OuvqhKxqYWRQBYYYhgRBPo/aD1dBV9MVyWn6JtEQ01T6snbxMb502awGPUyl386eeP
	fLxJlihLOuVe5Cp4Em6UTmYuXbskIonY0fyqSyZS55XYpuKdbMchBN+gcbES/nu+gdDXdR
	jtSV8YXh5tVz/iygpAck+7OdjDUhXMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790940540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooQXZcANDK9ppx08gicOeYoli2x67LvTQ64id6aGvAk=;
	b=3r7cAXhCOnIjdzFXmKHMSMfVbTxysk1xKV/HVY2x3T/bRgTfjjhg23PpkfBpkUlKZhAICK
	AFQpruWeOn69CTDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63EC413C5B;
	Fri,  2 Oct 2026 11:29:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +YTdD3yVv2rCfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 02 Oct 2026 11:29:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E4B64A13C2; Fri, 02 Oct 2026 13:28:44 +0200 (CEST)
Date: Fri, 2 Oct 2026 13:28:44 +0200
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Baokun Li <libaokun1@huawei.com>, Jan Kara <jack@suse.cz>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: regression - ext4 fails to mount a filesystem due to large
 orphan file
Message-ID: <n74ng2j4aq6zhilbbomncxis2afytwqa57sz4dzrylkxf45yub@47iywdxjgsn5>
References: <e65cdbfe-3ff9-4638-fbd3-4d8f8880966f@redhat.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e65cdbfe-3ff9-4638-fbd3-4d8f8880966f@redhat.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[huawei.com,suse.cz,mit.edu,dilger.ca,linux.ibm.com,gmail.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8CBDB1FE55
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Hi!

On Tue 29-09-26 19:48:29, Mikulas Patocka wrote:
> I report a bug in the commit 7c11c56eb32eae96893eebafdbe3decadefe88ad. 
> The commit introduces a regression into the ext4 filesystem:

Thanks for report!

> # truncate -s 1GiB ext4.test
> # mkfs.ext4 -b 1024 ext4.test
> mke2fs 1.47.4 (6-Mar-2025)
> Discarding device blocks: done
> Creating filesystem with 1048576 1k blocks and 65536 inodes
> Filesystem UUID: 246857e4-85e8-4393-b3c7-d52a92b999e9
> Superblock backups stored on blocks:
>         8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553,
>         1024001
> 
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (16384 blocks): done
> Writing superblocks and filesystem accounting information: done
> 
> # mount -o loop ext4.test /mnt/test
> mount: /mnt/test: volání fsconfig() selhalo: Struktura potřebuje opravu.
>        dmesg(1) může obsahovat více údajů o selhaném připojení.
> # dmesg |tail
> [ 2325.547222] EXT4-fs (loop0): mounted filesystem 3af6fb51-f5c5-44af-84f1-d94e098f66d0 r/w with ordered data mode. Quota mode: none.
> [ 2325.549968] EXT4-fs (loop0): unmounting filesystem 3af6fb51-f5c5-44af-84f1-d94e098f66d0.
> [ 2325.585469] loop0: detected capacity change from 0 to 134217728
> [ 2325.589344] EXT4-fs (loop0): mounted filesystem f6d86dae-c171-45ea-9e52-7d0de64d449c r/w with ordered data mode. Quota mode: none.
> [ 2325.592672] EXT4-fs (loop0): unmounting filesystem f6d86dae-c171-45ea-9e52-7d0de64d449c.
> [ 2374.988529] EXT4-fs (dm-0): unmounting filesystem 794eeb51-98fb-4d5c-b511-e4a56817ee6c.
> [ 2376.433633] brd: module unloaded
> [ 2906.044816] loop0: detected capacity change from 0 to 2097152
> [ 2906.052278] EXT4-fs (loop0): orphan file too big: 1048576
> [ 2906.052388] EXT4-fs (loop0): mount failed
> # mkfs.ext4 -V
> mke2fs 1.47.4 (6-Mar-2025)
>         Using EXT2FS Library version 1.47.4
> 
> (the limit 512 blocks seems to be enforced in mke2fs in git, but 
> distributions still use the last released version 1.47.4, which can 
> produce filesystems with larger orphan list)

Well, we could produce larger orphan files since the beginning (in the past
you could specify arbitrary number of blocks as a parameter) but what you
show is that a released e2fsprogs version will produce such filesystems *by
default* and that's indeed a bigger issue. I'll send a fix for the kernel.
Thanks again!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

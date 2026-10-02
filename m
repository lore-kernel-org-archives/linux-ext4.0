Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A905471410;
	Fri,  2 Oct 2026 12:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790945165; cv=none; b=eL8I2R1Q9t9NH61E2ZmwVXYW5acGYkwR8QO1YDZW5jWwmxylGFYeh5yc2aWCYDDQjLBGIo4mARJ4hYHH8JO/2QWPYi8ZX0M9p56O+LXqWghN9hkYfrl9vrJ3fG1FB+msdH2Cab18ydTktudr2hp8sUdzJUAL4HnFfZWqgmQOldk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790945165; c=relaxed/simple;
	bh=y/5qNTY3gi1pdf3VAhXQmxVMwN1BC9VnwtTYM8QIL5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crN0s5dklwr0IrlR6hIet7B8szK2rr7t5mcPbuBZ1R0Bgz+YcHLF5cJLRe6ETk2hfQuVpwghhlAd6jI/bdrwubz1wb5Jjp8CsM3HXw82ld2URSWH+4jQo2zrmGEPNa5NrOf9GJurNfkA328QUbcg9vQEe/Gch2EZaAo2QA7sez4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y0Uhqhib; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cR7j1UN+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nAzGVghz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KprUFIVe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y0Uhqhib";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cR7j1UN+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nAzGVghz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KprUFIVe"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78A9E21E5B;
	Fri,  2 Oct 2026 12:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790945114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JL48vtFnHAkTFcU3Jpa+lK2hy/s/M2uCud3mS5RbsDo=;
	b=Y0UhqhibtRHmUJ+e/xKZJxkuDF2a9HO44UEMoD6ECktEuiRer6j3Qms6Chy/zptjrjYCIP
	/0p6UGfYG4Slnom+0A2HhgAFgag0aa5oISMSuUGRQFY0ff+nvjX0KvkzlfHtH3ZTaRRMR4
	QCmCBBn2nxNQpn5rgey+8dk7guQUZI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790945114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JL48vtFnHAkTFcU3Jpa+lK2hy/s/M2uCud3mS5RbsDo=;
	b=cR7j1UN+Udf9ZMxyhQzGNFyQr0cd1ljkOQ/Xo2Quw8lpPH8TN2wx3LqvRW843GRLzOvV6/
	0tCp4iRYykuy47BA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nAzGVghz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KprUFIVe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790945110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JL48vtFnHAkTFcU3Jpa+lK2hy/s/M2uCud3mS5RbsDo=;
	b=nAzGVghzM80zG2Zu0ewcrri6xzOAmw6X0zeKSMQigu6iYfrOfnoZ7QsoG4DcW3sySUKBFj
	feQLjsx0t99qv25PgRT4v+1Cm7efPqo5GODyzLJPCcUYVsBWUJJX3r8a49xEJwH/69Vots
	V+vaSLrMdIbwIWv3Rj6/4E66dK2xxIc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790945110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JL48vtFnHAkTFcU3Jpa+lK2hy/s/M2uCud3mS5RbsDo=;
	b=KprUFIVeypvNIMM8l9Z+lA6ZzKjdM9g5Ybkk4QVzjnIN2y+A/P4ZQcBw7Z9BPZPGiEvwik
	BYubQP1qrswe27Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DD6713C9A;
	Fri,  2 Oct 2026 12:45:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yB6zGVCnv2r1TwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 02 Oct 2026 12:45:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 15F04A13C2; Fri, 02 Oct 2026 14:44:49 +0200 (CEST)
Date: Fri, 2 Oct 2026 14:44:49 +0200
From: Jan Kara <jack@suse.cz>
To: Adriano Cordova <adrianox@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: wipe moved dirents with their real length
Message-ID: <4zi7wmvjhwe7xph3hxawcuhlocifrnv56545tlxbs4u2r7lto3@kbusw76tettq>
References: <20261002004127.1332310-1-adrianox@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002004127.1332310-1-adrianox@gmail.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 78A9E21E5B
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,syzkaller.appspotmail.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[09bec78ee77613a3efdd];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Thu 01-10-26 21:41:27, Adriano Cordova wrote:
> After copying a dirent to the new block, dx_move_dirents() wipes the
> source entry using the on-disk rec_len.  Use the length already
> computed for the copy instead because the on-disk rec_len is untrusted
> and a corrupt value makes the memset() run out of bounds.
> 
> Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
> Tested-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> Signed-off-by: Adriano Cordova <adrianox@gmail.com>

Not that this would be wrong per se but the explanation doesn't really
satisfy me :) If the rec_len on disk is wrong, we have a larger problem
with corrupted source directory and we shouldn't have reached
dx_move_dirents() in the first place. So how come directory entry
validation in dx_make_map() didn't catch the corruption? Did syzkaller
somehow managed to corrupt the directory entry between dx_make_map() and
dx_move_dirents()? If yes, that is the bug that needs fixing, not trying to
suck up corrupted directory entries in dx_move_dirents()...

								Honza

> ---
>  fs/ext4/namei.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a6386c1d237f..71e9e7c9a7fd 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1860,10 +1860,8 @@ dx_move_dirents(struct inode *dir, char *from, char *to,
>  
>  		/* wipe dir_entry excluding the rec_len field */
>  		de->inode = 0;
> -		memset(&de->name_len, 0, ext4_rec_len_from_disk(de->rec_len,
> -								blocksize) -
> -					 offsetof(struct ext4_dir_entry_2,
> -								name_len));
> +		memset(&de->name_len, 0, rec_len -
> +		       offsetof(struct ext4_dir_entry_2, name_len));
>  
>  		map++;
>  		to += rec_len;
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B3B3B774F
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 11:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777288644; cv=none; b=VxugpwMAO3pjTiJRkstCtMgt7eq3AsljQHi/1Sy7nUiiI5o5+VPqknlH1CHOvYDKLux4Lly9fIOamiGHI54xK0Y+ABFdwbeANo/9OwLF9MnfsvuJ3DFSAOemdkAMJm1T/i6z3vLEwwYIcI1+HSzq0DlD7v6Fz2PbYvuckft2+cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777288644; c=relaxed/simple;
	bh=KH1OEnwYC9N8rL7qYsljubA7LqBib2m5QtOtXpTgQ7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iiVX1qPZCcqRnYATjncF6fmZc9hKF4bG6DBxgBqnOh/EPzf5ZOXgAQC/YGr41n468uwRCR9kfRdlKcek+pO4jozaZHTYCpMksyjq87fIctEysyqFV5Pufqy9JeSbRBqqS5DevkHIcLYD3xZ2pgpc7PAQAqyCNzTgbfotxVBbh+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zh0Kl9V6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=x8QbtI/g; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zh0Kl9V6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=x8QbtI/g; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zh0Kl9V6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="x8QbtI/g";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zh0Kl9V6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="x8QbtI/g"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C16F76A8EA;
	Mon, 27 Apr 2026 11:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777288641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o/aHEXwmUiLmMfzArj7m3DrqK9QsTa+n8aR8JtA/nCU=;
	b=zh0Kl9V65eWnxttsDAh1Udgr/tkEpyr7lVpRPN48XNI0NLLT6uGJTD9CKSK9quAA12Hf8s
	8y0loJioKf680X5VX1uQAXKpv46wX2CZaEOKCsuE3DCvTdMJAH9nPkYZcE+sXYIVf5NIDp
	QY1hzjvgTGplx06c1Yl1YrkcGgMH0t0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777288641;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o/aHEXwmUiLmMfzArj7m3DrqK9QsTa+n8aR8JtA/nCU=;
	b=x8QbtI/gnA5gTgPITpOt9RsyJ9ZNIXxLamecDKC1hITGy98kSseS5dzA+N0UGbGzVpnTmb
	6600u8j9syDXNLBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777288641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o/aHEXwmUiLmMfzArj7m3DrqK9QsTa+n8aR8JtA/nCU=;
	b=zh0Kl9V65eWnxttsDAh1Udgr/tkEpyr7lVpRPN48XNI0NLLT6uGJTD9CKSK9quAA12Hf8s
	8y0loJioKf680X5VX1uQAXKpv46wX2CZaEOKCsuE3DCvTdMJAH9nPkYZcE+sXYIVf5NIDp
	QY1hzjvgTGplx06c1Yl1YrkcGgMH0t0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777288641;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o/aHEXwmUiLmMfzArj7m3DrqK9QsTa+n8aR8JtA/nCU=;
	b=x8QbtI/gnA5gTgPITpOt9RsyJ9ZNIXxLamecDKC1hITGy98kSseS5dzA+N0UGbGzVpnTmb
	6600u8j9syDXNLBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B6793593B2;
	Mon, 27 Apr 2026 11:17:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id obWHLMFF72lsTwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Apr 2026 11:17:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 73F62A0AFF; Mon, 27 Apr 2026 13:17:17 +0200 (CEST)
Date: Mon, 27 Apr 2026 13:17:17 +0200
From: Jan Kara <jack@suse.cz>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Zw Tang <shicenci@gmail.com>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [BUG] ext4: BUG_ON in ext4_write_inline_data
 (fs/ext4/inline.c:240)
Message-ID: <4h2bstimz6ludsekfenxpuswqwweosowo3pelr7wujmqr7sjvu@yhhduatqpapy>
References: <CAPHJ_VJeBAL_fk+P79guYTABZgW1hkcAz8t=c_nVK1mbn3_FYw@mail.gmail.com>
 <20260421122059.GA86221@macsyma.local>
 <4e76eb68-862d-4b9f-8242-e6aced2704ee@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e76eb68-862d-4b9f-8242-e6aced2704ee@gmail.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,gmail.com,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,vger.kernel.org,huawei.com,googlegroups.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Sat 25-04-26 14:00:23, Demi Marie Obenour wrote:
> On 4/21/26 08:20, Theodore Tso wrote:
> > On Tue, Apr 21, 2026 at 07:32:43PM +0800, Zw Tang wrote:
> >> This looks like an ext4 inline-data boundary/state inconsistency triggered
> >> while writing to an ext4 image crafted by syzkaller. The later
> >> KASAN: slab-use-after-free in rwsem_down_write_slowpath() appears to be a
> >> secondary effect after the primary ext4 BUG, likely during teardown/unlink
> >> after the filesystem failure.
> > 
> > Writing to a mounted image is not something that we consider a valid
> > threat model.  If you can write to a mounted image, there are a
> > zillion different ways that you can creash the kernel, or you can
> > create a setuid shell, etc.
> > 
> > The upstream syzkaller bot makes sure that CONFIG_BLK_DEV_WRITE_MOUNTED
> > is not defined to avoid syzkaller noise.
> 
> CONFIG_BLK_DEV_WRITE_MOUNTED only blocks writing via the specific block
> device that is mounted.  It doesn't block writing via other methods.
> If I recall correctly, its purpose was to prevent writing to the
> buffer cache used by the filesystem driver.

Correct. This a kind of corruption that's impossible to address only at fs
level.

> Changing block devices that are mounted is also reachable via USB.
> Yes, some distros may disable automount, but users who have stuff to
> get done will mount USB devices anyway.  Telling users "don't do this"
> very rarely works in practice.
> 
> I asked a distro maintainer about using libguestfs by default and
> they refused, citing poor performance.  Unfortunately, there is no
> way at the OS level to distinguish "trusted device used for backups"
> and "untrusted USB stick".

Well, people *are* seriously looking into mounting hotpluggable devices with
FUSE (or other userspace means) - e.g. openSUSE has experimental packages
doing just that for a few months. Darrick Wong is also working on making
FUSE more performant so the plan is to eventually get there.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

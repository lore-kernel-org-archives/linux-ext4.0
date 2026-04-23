Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321E23E5EE2
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2026 09:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776937605; cv=none; b=cGsWEumZ26QJIrM5XpZaJxNwW1gL4oO3ByJqcPI+HUMUI4ojPSAttm/Qvz7Timrtn/VqYwreEM9BvlKvPKBsGPjYOVTZ2KiVYDidiFmFMMbXKdNPtK4X5xqUSb6uFWSeCLR8m7AOudXsGapkEIHEqT7a0AsuMZnmSZjEmRuMOko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776937605; c=relaxed/simple;
	bh=PcQm1B6kfZNG++VDr5K4Vg/79dkZ1DflivRmr0/efxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnPb/wTRhJhPBafu7J6qYkupdYySrG93UDw4O0y487YUFXuP5cMux2a71LKCrAfUgrb+vO7H+rVaDS+i7MOm5FVH1BNFuJYpt9o2ZE8r6m4BT6b6CTYCAbMP3GyJReQ48JNHdTcmSnDmc9PQwqI08/bNZLHkjJmkXljLOAWdvbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bH7uu592; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7Q+nno7y; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bH7uu592; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7Q+nno7y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bH7uu592";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7Q+nno7y";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bH7uu592";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7Q+nno7y"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 23CE56A7CA;
	Thu, 23 Apr 2026 09:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776937601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XqRR9BlSad+srezuM804RmmPIyv0E8jMDsRxCNOd7K8=;
	b=bH7uu592JdJmkqseT9n7HGh2Ulyp8v57V2q53EwmiT4dC+r3SUvlLy70mKvIMF2iP0Vqty
	8MEiMM4y01+8dPKAkraaau3+BjmO9E0p1A9GGMvXFPkBBQiXtrgUUgk6TNgMYiNGx7p+7L
	uQsJHDWJjOBdercKbK9wcrIs7NWrsqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776937601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XqRR9BlSad+srezuM804RmmPIyv0E8jMDsRxCNOd7K8=;
	b=7Q+nno7y2cv1e415C51j1mmCjFraR8jE9DmkAMYRww09Dcb6l2Dry/RVNdQY3gTApnaj7/
	FZfoJeL9y1zQf/BA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776937601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XqRR9BlSad+srezuM804RmmPIyv0E8jMDsRxCNOd7K8=;
	b=bH7uu592JdJmkqseT9n7HGh2Ulyp8v57V2q53EwmiT4dC+r3SUvlLy70mKvIMF2iP0Vqty
	8MEiMM4y01+8dPKAkraaau3+BjmO9E0p1A9GGMvXFPkBBQiXtrgUUgk6TNgMYiNGx7p+7L
	uQsJHDWJjOBdercKbK9wcrIs7NWrsqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776937601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XqRR9BlSad+srezuM804RmmPIyv0E8jMDsRxCNOd7K8=;
	b=7Q+nno7y2cv1e415C51j1mmCjFraR8jE9DmkAMYRww09Dcb6l2Dry/RVNdQY3gTApnaj7/
	FZfoJeL9y1zQf/BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18AC7593A3;
	Thu, 23 Apr 2026 09:46:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HkP/BYHq6WnYRAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 23 Apr 2026 09:46:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D7928A0A2D; Thu, 23 Apr 2026 11:46:32 +0200 (CEST)
Date: Thu, 23 Apr 2026 11:46:32 +0200
From: Jan Kara <jack@suse.cz>
To: Junjie Cao <junjie.cao@intel.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, syzbot+26c4a8cab92d0cda3e3b@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: prevent out-of-bounds read in
 ext4_read_inline_data()
Message-ID: <jedkdkwm57tnq6xvdhtwkaqydwuizmxtwzko4i5p3v5gqjxrop@crjk5kvksub7>
References: <20260421093138.906266-1-junjie.cao@intel.com>
 <ulfo7ut5ziqvrjy24besb4jtobijunycglvmqki7cwfzsancwi@5ycrwypubh56>
 <20260423170527.129423-1-junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423170527.129423-1-junjie.cao@intel.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[26c4a8cab92d0cda3e3b];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,syzkaller.appspotmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Fri 24-04-26 01:05:26, Junjie Cao wrote:
> Thanks for the review, Jan.
> 
> You're right that v1 failed to identify why the buffer changes.  I dug
> into the syzbot reproducer ??? the corruption path is:
> 
>   1. Mount a crafted ext4 image on a loop device
>   2. Bind-mount the loop device, open + mmap it MAP_SHARED|PROT_WRITE
>   3. Write through the mapping ??? this overwrites the inline xattr
>      entry directly in the bdev page cache

Ah, interesting. I had a look at the syzbot bug and all the reproductions
are actually only on quite old Android kernel (5.15). That kernel doesn't
have infrastructure to block writes to mounted devices - in newer kernels
syzbot sets

CONFIG_BLK_DEV_WRITE_MOUNTED=n

which blocks reproducers like this one.

> The inode buffer_head stays uptodate throughout, so no re-validation
> ever triggers ??? xattr_check_inode() at iget time is thorough but only
> runs once, leaving subsequent in-place corruption of the page cache
> undetected.

Yes, writing to buffer cache through the mapping is equivalent to poking
to your memory. You can do a lot of damage if you are not careful.
Filesystems have no sensible way to protect against such things and in
general it is root-restricted corruption vector so not really interesting
from security perspective.

> However, ext4_xattr_ibody_get() already guards against this with a
> bounds check before its memcpy (xattr.c:674).  ext4_read_inline_data()
> lacks the same check because it indexes via the cached i_inline_off,
> bypassing xattr_find_entry() entirely.  I think aligning the two paths
> is worthwhile, and it would also clear this syzbot report.
> 
> Would a v2 with this framing be acceptable to you?

No, I don't think there a problem to fix. The additional checks will
complicate the code, will be racy anyway, and will cost some performance.
There is no good reason to have them to protect from sysadmin doing stupid
stuff...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1365357D01
	for <linux-ext4@vger.kernel.org>; Tue,  2 Jun 2026 07:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780384962; cv=none; b=fEUC3Qraya0JmMN3DzFiFnfuYIwocYX4c2NH3G4SZdeOdojBXu8RxYGGP4JgU5EfVez36R7R3NOoGqMIW4u3kKXaEnk2mnDdkIaH0gfRgHEyKiVaAmwa7bkw/w4biuj4ISYC0ohdLG2/p+X8FoDUzRL/Cuz+e+kGCKWnye1fh/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780384962; c=relaxed/simple;
	bh=c5jEInMRpeI80yly3x3kU/i2KignyqH4gB3zKajS2Ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSTx6kNXx7C9fsKX/8AHFuWahTc7U3LibywiBre3God2AftliNDk5/LTj36uKy1yFj7T+pd5Uh0t8c0/NsK5aZUrd58hhN4HxeeMNsX+tGOuk1H/AfQfM/5j2Nr0TLzsKHuNurpJPEqxHtrPJ12COzEDJYsAEdaHxtN5+C/t/P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d6bCPTc/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X1GOHG+1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d6bCPTc/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X1GOHG+1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d6bCPTc/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X1GOHG+1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d6bCPTc/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X1GOHG+1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 632C0689B2;
	Tue,  2 Jun 2026 07:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780384959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XrhjommOd6peEEaK23OhHqseWgrWIFbHPd46J58lq4s=;
	b=d6bCPTc/fEllbTJmOQsa3R8ssKeVYTAnMnroJecKUWlIfqBBuGLgE2sX6cBYtcGiQACnyd
	5tCN9CmlPvDhkJcVRbV3LCMIpZojfgAXxvERA+eiOCWNa8L0Ixew3yvr5BuqSlgsaxn+f8
	LAL8hKsi4szEchNFxZ9Eddn5uklX2+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780384959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XrhjommOd6peEEaK23OhHqseWgrWIFbHPd46J58lq4s=;
	b=X1GOHG+1/+7kwMLlvpI0hdRMrW6JL+KZTU3rDv2L0X/XIc+nzrMuPymR0az1//SzWbu5qI
	4z0jv4Jxw8rSalDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780384959; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XrhjommOd6peEEaK23OhHqseWgrWIFbHPd46J58lq4s=;
	b=d6bCPTc/fEllbTJmOQsa3R8ssKeVYTAnMnroJecKUWlIfqBBuGLgE2sX6cBYtcGiQACnyd
	5tCN9CmlPvDhkJcVRbV3LCMIpZojfgAXxvERA+eiOCWNa8L0Ixew3yvr5BuqSlgsaxn+f8
	LAL8hKsi4szEchNFxZ9Eddn5uklX2+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780384959;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XrhjommOd6peEEaK23OhHqseWgrWIFbHPd46J58lq4s=;
	b=X1GOHG+1/+7kwMLlvpI0hdRMrW6JL+KZTU3rDv2L0X/XIc+nzrMuPymR0az1//SzWbu5qI
	4z0jv4Jxw8rSalDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AD68779A7;
	Tue,  2 Jun 2026 07:22:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cBEoFr+EHmopUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 02 Jun 2026 07:22:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EEB5AA0EC1; Tue, 02 Jun 2026 09:22:34 +0200 (CEST)
Date: Tue, 2 Jun 2026 09:22:34 +0200
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>, aivazian.tigran@gmail.com, 
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 0/10] fs: Fix missed inode write during fsync
Message-ID: <7b54r6zj74tfhnyw3eajraantq3m4wxtsnnycofc6hmrue2skr@sy4cftizcinj>
References: <20260525085035.12891-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525085035.12891-1-jack@suse.cz>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,mit.edu,vger.kernel.org,mail.parknet.co.jp,suse.cz];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

Hello!

On Mon 25-05-26 10:58:06, Jan Kara wrote:
> here is v2 of the patch series which fixes the possibly missing inode write
> during fsync(2) for filesystems using generic metadata bh tracking. The
> inherent problem is that .write_inode methods clear inode dirty bit but they
> only copy inode contents into to the buffer cache. Because buffer carrying the
> inode is shared among multiple inodes, it cannot be tracked by the generic
> metadata bh tracking infrastructure and thus nothing is tracking that buffer
> needs to be written out to maintain fsync(2) guarantees. Normally, this gets
> taken care of by .write_inode checking for WB_SYNC_ALL writeback and submitting
> & waiting for the buffer in that case however if flush worker ends up writing
> the inode before data integrity writeback, this mechanism is broken.
> 
> This patch series adds a way for filesystems to track metadata block number
> which contains the inode metadata and then uses this information to writeout
> the buffer on fsync.

FWIW I went through Sashiko review comments. Lot of them are hallucinated
but there are actually three good finds:

1) FAT implementation of inode tracking is broken when fsync races with
rename.

2) ext2 & minix inode tracking makes handling of dirsync even more broken
than it already is (current handling is already broken because we don't
flush any directory indirect blocks but my changes also stop flushing the
inode buffer).

3) mmb_sync() flushing of inode buffer is racy for multiple parallel
fsyncs.

So I'll be addressing these. Please don't waste time with the series as is.

								Honza

> 
> Changes since v1:
> * Fixed freeing for ext4 dynamically allocated mmb struct
> * Optimized tracking of block carrying the inode so that we don't flush it
>   unnecessarily on fsync
> * Add forgotten check for reclaimed bh to mmb_sync() to avoid NULL ptr deref
> * Couple other smaller fixups pointed out by Sashiko
> 
> 								Honza
> Previous versions:
> Link: http://lore.kernel.org/r/20260511115725.28441-1-jack@suse.cz # v1
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

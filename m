Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14956377559
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785758390; cv=none; b=iw7+lt+3Itg6l9kLDZezvTd1pOeNFCH1hWWbV7d/jR2g80lPGG2dGDEnEpfYYf6Dmh0w84tRKjxbutCrI3/7OueA3TeFXH2UbKtxok+VLiQTD5Kdd+rZNDs69hBRmdxayrIgq+PK+ByM8SryOArqceZwtXCFu24ogGb5LcaI95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785758390; c=relaxed/simple;
	bh=f0xo72uDhR/2UWK82kWye91GR7XtaT4Xuh0Ml9dOtSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBZc8CDrW2WLM+FlPcc0L+PDHVXR4Ez8oAVgLYcHP18HaKuV6AswduF324AS2Sqoa3HM2OUu9pkIzWbGJcIVI5mBSSDkl/3qlSI+KbUKJvErHG2SFHQqXiNTumt0pQpRpFX+SsiXLMvVV9b5DbLD637/N/fkAJrjM64lI1IrhF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m2a+GdkH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZNedLb0A; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rO6nOLVK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xer3NVmY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m2a+GdkH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZNedLb0A";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rO6nOLVK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xer3NVmY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E9FDE3F14;
	Mon,  3 Aug 2026 11:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RR62/KLrjEzCknCytandeKIA4hxjrCLQTEUkKItTfag=;
	b=m2a+GdkH5JOyk9g7b/S2OaOED0bCL1O7wHrKV3DDUNnvOkRqgxYjhWWGRY91FOMwKgg1Px
	QeI3VRJ0EiFKctXrf3utupz/DIFFdb/p6DOGYK1R3wMwWbejWneW+BIL0FK2NTU9mgmcnA
	0IHVNnlDOtJY9StM53MvMn/XyDwpk4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758383;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RR62/KLrjEzCknCytandeKIA4hxjrCLQTEUkKItTfag=;
	b=ZNedLb0AsCU3F52JBOgNFeQkcBc6n+pdKVMDLJ5YrQpHA01zIebWeHMbLToZFkTzTLhaS6
	nb/tCWy5ZAT0kSDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rO6nOLVK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xer3NVmY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RR62/KLrjEzCknCytandeKIA4hxjrCLQTEUkKItTfag=;
	b=rO6nOLVKsDH8azj3rzzkxfcuK4l5XC3cms17GvM5vteqIgBOxXOb6uCH7ZvOSeMud72i8H
	UXt9RAAtQU8C1WGajasIo7FEzLa4tYSeu1T/PqvxI+DaQ23tDOkHdJvaj4R8MphH9RBZYO
	GO4+UMH8ba49Z7AdAr6Jx4VzpUUusY4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RR62/KLrjEzCknCytandeKIA4hxjrCLQTEUkKItTfag=;
	b=xer3NVmYq158bMUCLllXiuedEVIFHddBHfX1ryy1VHsM/N2NYs9QtZCL7Oap5fU8EqfpS2
	V2tGwcrq1IfeYQAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8AAB779A1;
	Mon,  3 Aug 2026 11:59:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1azeNKqCcGrULgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 11:59:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7D218A13A4; Mon, 03 Aug 2026 13:59:34 +0200 (CEST)
Date: Mon, 3 Aug 2026 13:59:34 +0200
From: Jan Kara <jack@suse.cz>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Tigran Aivazian <aivazian.tigran@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, Linux Filesystems Development <linux-fsdevel@vger.kernel.org>, 
	Linux ext4 <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>
Subject: Re: ext4: spurious "orphan cleanup on readonly fs" due to remount,ro
 failing to reset orphan_file structures
Message-ID: <fmdp3k4efrv44yqjmukk47ifa3rxrjvj2ndfin5lu6c3x5b5lh@5vv2yblzxy7b>
References: <CAK+_RLmWU-GjYu9Z+AWnoKd__AiaWZUt=zOkx3jr2-a4Hv3KHg@mail.gmail.com>
 <am_gplyBEyvbuHM_@archie.me>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <am_gplyBEyvbuHM_@archie.me>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,huawei.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: E9FDE3F14
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Mon 03-08-26 07:28:30, Bagas Sanjaya wrote:
> [Cc'ing ext4 folks with full reply context]

Thanks for CC.
 
> On Sun, Aug 02, 2026 at 11:18:39PM +0100, Tigran Aivazian wrote:
> > Hello,
> > 
> > I have been experimenting with optimising rootfs for custom builds of
> > Ubuntu 26 with various options like fast_commit, sparse_super2,
> > orphan_file, inline_data, metadata_csum_seed, etc. And I noticed
> > something strange: if my root filesystem is made with "orphan_file"
> > feature then on every reboot I get this message:
> > 
> > EXT4-fs (sda): orphan cleanup on readonly fs
> > 
> > (tested with SSD, NVMe and even old HDD -- because initially I thought
> > that maybe it was NVMe controller failing to flush its volatile DRAM
> > cache to the NAND flash, but no, it wasn't the reason)
> > 
> > I think what happens here is that when a filesystem with the
> > "orphan_file" feature is fully unmounted, ext4_put_super()
> > successfully clears the "orphan_present" superblock flag AND properly
> > collapses/resets the physical orphan file headers. However, during a
> > read-only remount (which systemd must do for / in order to halt the
> > system) ext4_reconfigure() clears the "orphan_present" superblock flag
> > but skips resetting the physical orphan file structures. Consequently,
> > on the next boot (which starts with a read-only mount of /),
> > ext4_fill_super() observes that while the superblock flag is clear,
> > the orphan file itself appears non-empty. This unconditionally
> > triggers ext4_orphan_cleanup(), which prints the spurious warning,
> > scans the file, finds 0 orphans, and completes silently.
> > 
> > Let's test this theory on the kernel 7.0.0-28-generic of Ubuntu 26:
> 
> Can you also confirm this on latest mainline (7.2-rc6)?

No need to, the behavior didn't change for a long time. In fact, any
read-only mount with orphan_file feature enabled will result in the
spurious "orphan cleanup on readonly fs" message. I've just checked that.
It is only a cosmetic problem but nobody noticed so far.

> > # 1. Create a filesystem with the orphan_file feature
> > mkfs.ext4 -O orphan_file /dev/sda
> > 
> > # 2. Mount read-write
> > mount -o rw /dev/sda /mnt
> > 
> > # 3. Remount read-only (Simulating systemd shutdown)
> > # This clears the orphan_present flag in the superblock, but leaves
> > the orphan file structures intact.
> > mount -o remount,ro /mnt
> > 
> > # 4. Unmount and mount read-only (Simulating the next boot)
> > umount /mnt
> > mount -o ro /dev/sda /mnt
> > 
> > Expected result in dmesg: nothing (well, except the usual
> > mount/remount messages about ordered data mode, etc).
> > 
> > Actual result in dmesg:
> > 
> > EXT4-fs (sda): orphan cleanup on readonly fs
> > 
> > Since this affects the default shutdown path for any modern Linux
> > distribution using systemd and ext4 with the "orphan_file" feature, it
> > would be great to get the remount,ro teardown path aligned with the
> > full unmount teardown path in this aspect.

The problem really isn't that the remount,ro path would be doing something
differently. Even after standard unmount I get the spurious message if I
mount the fs read only. What we need is to improve ext4_orphan_cleanup() to
really skip orphan recovery if there are no orphans. It will just require
some tweaks to the mount path.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

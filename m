Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0314411FA5
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785770081; cv=none; b=GxMmjfQf6/gmpL5abMf+NdOXV2eltg51YuHkKodpa1SWgbmzLg/2/7xicIawoXODj9/VhIFCsUocPxTsdN0XhYHviWOfSjVOT3rd9JyNxR5mwMQOOwSLP4UBtE9Ja9Vmbx5kceGdeTbzBPl3eLm13+1r2OnmgPWzF3WX1BSE8YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785770081; c=relaxed/simple;
	bh=YHKWdFXEZgiNsrjLh74otqn42EYVlAFnvBCfXPOZl74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFxzOnsgl6OW5lN9qQvthTGShOvN+Q548vVyD0OnNtKpJ1DU2Bvg8wJSM1rQ05I0iF2P/XndHJGLDUQALQ6cbFuUUz2favXjs1wTUxRsV98vveDM4SdJLRhmVL9xsCORRlruilb9nlsTjjy5hYzibMa3zhLQGplD8scXMnS4A8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GFk3stLl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ycld4mOy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=o9YNPEsE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AAr/ORL5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GFk3stLl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ycld4mOy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="o9YNPEsE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AAr/ORL5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B51897F168;
	Mon,  3 Aug 2026 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785770073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+LIq3DttxS8J5n/t1BC58ym4Oa9PoEAA58OYuz4dlw=;
	b=GFk3stLlKdvtDKmPnm67ZVv4tnps2OtRuMMEGedqSI85iGXmuSfeBfxXfFJf/0Pavr0qSs
	aVUMLMdiH+J5t3uHLQowTXy4dHmqxyu7+3WTJYSshlNIeP7Rkm1b+jtiWau/QnAJEcMM62
	walEl8mLvn3fK20cUCyj073TG8hX+GE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785770073;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+LIq3DttxS8J5n/t1BC58ym4Oa9PoEAA58OYuz4dlw=;
	b=ycld4mOydU/WKpgpC+W74IuVPfyZClhHtj0uCeX+Tboo63tGP9t6ODDbUZORvrarQ1axlW
	F21BeuLzchYVEGDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785770069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+LIq3DttxS8J5n/t1BC58ym4Oa9PoEAA58OYuz4dlw=;
	b=o9YNPEsEugFxFhC+nrdHG7UGWcMKYtDrj8BAK4FqjxS4IMFMf731/oXj8zM5FFaYZoAL5V
	PdW2lGSytl6qgq5MMnkn4YTap+WqDfMP0Y6HgUtyAZmPpieYNtiGV9NhLas/fxxxySJHPJ
	7Ohr2AwLH294tw4rQGcqob+tUJprU+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785770069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+LIq3DttxS8J5n/t1BC58ym4Oa9PoEAA58OYuz4dlw=;
	b=AAr/ORL5p/sQTadbPzskGZpiUENhXXl1oBIefgPl3KX/YQ66gBhGnxcFYwUHtIoaBne/an
	4oifa+2YLjLOTUCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9FEF3779D3;
	Mon,  3 Aug 2026 15:14:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VTUFJ1WwcGqtbwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 15:14:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3F397A13A4; Mon, 03 Aug 2026 17:14:29 +0200 (CEST)
Date: Mon, 3 Aug 2026 17:14:29 +0200
From: Jan Kara <jack@suse.cz>
To: Tigran Aivazian <aivazian.tigran@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, Linux Filesystems Development <linux-fsdevel@vger.kernel.org>, 
	Linux ext4 <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>
Subject: Re: ext4: spurious "orphan cleanup on readonly fs" due to remount,ro
 failing to reset orphan_file structures
Message-ID: <g7fk4a4rsokzzficx63yqcjwbyneq7ipfhshvi5xhylihetjrd@d6sv5y6kwnzs>
References: <CAK+_RLmWU-GjYu9Z+AWnoKd__AiaWZUt=zOkx3jr2-a4Hv3KHg@mail.gmail.com>
 <am_gplyBEyvbuHM_@archie.me>
 <fmdp3k4efrv44yqjmukk47ifa3rxrjvj2ndfin5lu6c3x5b5lh@5vv2yblzxy7b>
 <CAK+_RLkvc3b0vC7SHygRv+4xdk_mC-362T60NbtQT4Zmpp6fxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK+_RLkvc3b0vC7SHygRv+4xdk_mC-362T60NbtQT4Zmpp6fxg@mail.gmail.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,gmail.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]

On Mon 03-08-26 13:57:55, Tigran Aivazian wrote:
> Hi,
> 
> On Mon, 3 Aug 2026 at 13:36, Jan Kara <jack@suse.cz> wrote:
> > No need to, the behavior didn't change for a long time. In fact, any
> > read-only mount with orphan_file feature enabled will result in the
> > spurious "orphan cleanup on readonly fs" message. I've just checked that.
> > It is only a cosmetic problem but nobody noticed so far.
> 
> You say it is a cosmetic problem, but here I somewhat disagree.
> Logically, seeing "orphan cleanup on readonly fs" implies an unclean
> shutdown that caused those orphans. Consequently, I spent time
> debugging it by instrumenting scripts in
> /usr/lib/systemd/system-shutdown/ and even suspecting the NVMe
> controller caches, etc. Any sysadmin who doesn't like leaving
> "mysteries" on their Linux host would have done the same.

Fair point and to be clear I think this needs to fixed. I can see how this
"cosmetic problem" misled you and you have wasted time debugging that. I'm
sorry for that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

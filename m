Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6C9331EA6;
	Thu,  8 Oct 2026 11:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791457945; cv=none; b=fbrWwkEl8yU+TfvmZhDeF/QLlwqZgjQeg7FjxBrSbmCnAu6Gc+OYIP5S1xUK9LI4RwIB5VoD5IcDt+t2ov5Z+t1UWwCA9/PvgTXf3MF3nSmzsO/QsuaCBsX+4HGOF8Ru8wGXxMClJhhfmuiZmq8sOsTy4s33FS8bYNDWI30PruE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791457945; c=relaxed/simple;
	bh=DY/V5HQR17fWczR7oDtjkH+4sveqOzFE8Apc9GtJGbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kq1tuV9i5uAQgwbammFle0VCFZwm5XUZb/Gshj6YoYYKBRka0T5+0NXaL2SSA4DpPEUeKsaJC3uzqe23epR/g5rexzFyROwHHwC6HnDqmvFy9yQQ1aU3iIU5P2gd43saU6CXtKUEXoycWyjWjYJzhXYft+Ulmg/bSUX+Uz5vHW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bfvODNUJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8u2npHDC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bfvODNUJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8u2npHDC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 43AFC1F441;
	Thu,  8 Oct 2026 11:12:22 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791457942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y7gPk0+L//0Z5xz94SO/gdOgfT6tS6UdhupvOkepRzo=;
	b=bfvODNUJzrSYs0vgrmcYBDETrj9D+ccojnB7OJ5Ffy/3dRKtmbaqzFvkBKAk/VuxV0fYyo
	VbusN2rHF/Ex2mrVzQtwhlb+GEPmzRMGk1Lg2WYq97SnfjukZ+cCm8Bj9TjwB+tiJ52R8a
	GeC9LIzDeVDMxfkKrj8LA8TRx77/hwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791457942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y7gPk0+L//0Z5xz94SO/gdOgfT6tS6UdhupvOkepRzo=;
	b=8u2npHDCmZp/xsqqcpvHC++LK9gkAoPlyrIoKml2sMCMAjSdMeRr+JsYL90YM/LREr0Hga
	x4QeSguGBLYr3ICA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C42013354;
	Thu,  8 Oct 2026 11:12:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id K4SSOpV6x2qSbwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Oct 2026 11:12:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B6E2DA13FC; Thu, 08 Oct 2026 13:12:13 +0200 (CEST)
Date: Thu, 8 Oct 2026 13:12:13 +0200
From: Jan Kara <jack@suse.cz>
To: Daejun Park <daejun7.park@samsung.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, 
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Harshad Shirwadkar <harshadshirwadkar@gmail.com>, 
	Li Chen <me@linux.beauty>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: (2) [PATCH v2 2/2] ext4: track zeroed out blocks of unwritten
 extents for fast commit
Message-ID: <mz3siqf62cyeetspllcm4bqbtp3djhtej2w53o4cnd6wcwobq5@f6u7zotee3cd>
References: <2lgtlg7ydx4qeau2nvv5wkcuc2jkvwdcrav7gbxmxdieptkwl4@emgyfuxuskiu>
 <20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com>
 <20261008-ext4-fc-zeroout-v2-2-55cab1e24fa3@samsung.com>
 <CGME20261008095512epcas2p243a0deff110c0cc75da1ae049b4bbb8b@epcms2p2>
 <20261008102615epcms2p2858ca95d96bd2b090f2e406aa1bad63c@epcms2p2>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008102615epcms2p2858ca95d96bd2b090f2e406aa1bad63c@epcms2p2>
X-Spamd-Result: default: False [0.00 / 50.00];
	TAGGED_RCPT(0.00)[]
X-Spam-Score: 0.00
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason

On Thu 08-10-26 19:26:15, Daejun Park wrote:
> On Thu, Oct 08, 2026 at 11:55:02 +0200, Jan Kara wrote:
> > Just one note: I agree with you ext4_alloc_file_blocks() is actually handled
> > correctly. But OTOH tracking a range twice isn't really an issue (only tiny
> > performance overhead compared to the extent tree operations and zeroing
> > itself). So I just wouldn't special-case ext4_alloc_file_blocks() and
> > always pass a proper handle to ext4_issue_zeroout(). That keeps the logic
> > slightly simpler: kernel zeroes out blocks => kernel tracks the range. But
> > I don't really insist, it's just a suggestion.
> 
> Thanks for the review. I wasn't sure I should do that in
> ext4_alloc_file_blocks(): f4265b8d32c4 ("ext4: add
> FALLOC_FL_WRITE_ZEROES support") issues the zeroout outside of the
> running transaction on purpose, and passing a handle there would put it
> under the conversion handle, so I left it as it is.

Ah, I see. OK, makes sense. Thanks for having a look!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

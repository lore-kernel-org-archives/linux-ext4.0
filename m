Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428AF364930
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2026 11:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772190887; cv=none; b=R+SHYuEG0wdtNmUYCX59xG3E8JH9DyUfKovEH5sROipPHrnP4yWhcVIeK2LoI6diJQShiOyRUgq8AOhB2OtAkDZ9kaJDPDzdOq8ff+CmO0gf1nh2GZOyxcUePL3+PDr9hALzrY3T79WsQy3KEJzxrJrLrj6QnVqxRKhaN+/hWXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772190887; c=relaxed/simple;
	bh=s6sCSBV49ovC74i41tQMyDlmVfBYNW7CDesGQrCvRDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAQFUKIc8AclZe2a64dcijHkMbNtlsYm6Ymjx4rrjTxhovgjtMUyj2CAZizvLYWnmISJ/HUxTuJTdhO1zKeqG6g5kuJxqpKPdnh2lchy7mMG0k7byyWzrClCacLEskX0B3GFqtxCKOqdKZBeZAU3iLGC/yzzSN0HYKqN60kqhdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=znJAYj/v; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tXB1nyg7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=znJAYj/v; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tXB1nyg7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="znJAYj/v";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tXB1nyg7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="znJAYj/v";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tXB1nyg7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4DB8E3F879;
	Fri, 27 Feb 2026 11:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772190879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+b2oRQOAXcuHGDYW5b/e0+CdI02teuNEgFC4vqZ++E=;
	b=znJAYj/vZeg5AghyJ365rzkZt79orkBU/babPS+JVGxWL/5hRalXgcr8hcDxa4Oe02SaRd
	WlauBS9d7beXZ7MyvxZeU4/IDIaKGe8Q/DDX3d0d4yvak40YJB2NbyL9Pfv/NVwI4mPoOP
	2aJyVTXRzwTWMPF6MPUu+I1QDFfn0WQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772190879;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+b2oRQOAXcuHGDYW5b/e0+CdI02teuNEgFC4vqZ++E=;
	b=tXB1nyg7yDArn2GM4SzK/AtCmnev9LsO59LDKOEiMAF3Mznawz0nWNSP30/U4JQ/awimua
	OI6GySPMkKwOX5Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772190879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+b2oRQOAXcuHGDYW5b/e0+CdI02teuNEgFC4vqZ++E=;
	b=znJAYj/vZeg5AghyJ365rzkZt79orkBU/babPS+JVGxWL/5hRalXgcr8hcDxa4Oe02SaRd
	WlauBS9d7beXZ7MyvxZeU4/IDIaKGe8Q/DDX3d0d4yvak40YJB2NbyL9Pfv/NVwI4mPoOP
	2aJyVTXRzwTWMPF6MPUu+I1QDFfn0WQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772190879;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+b2oRQOAXcuHGDYW5b/e0+CdI02teuNEgFC4vqZ++E=;
	b=tXB1nyg7yDArn2GM4SzK/AtCmnev9LsO59LDKOEiMAF3Mznawz0nWNSP30/U4JQ/awimua
	OI6GySPMkKwOX5Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 451D53EA69;
	Fri, 27 Feb 2026 11:14:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GOLZEJ98oWnNGQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 11:14:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ED859A06D4; Fri, 27 Feb 2026 12:14:38 +0100 (CET)
Date: Fri, 27 Feb 2026 12:14:38 +0100
From: Jan Kara <jack@suse.cz>
To: Milos Nikic <nikic.milos@gmail.com>
Cc: jack@suse.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: remove stale TODO about kmap
Message-ID: <e7gpv5hhg4rwwwedjziocmlr3kplbnlhhlpwimmsmqex2zu4hv@2mdbcy3ik2cw>
References: <20260207002908.176933-1-nikic.milos@gmail.com>
 <20260227050934.16189-1-nikic.milos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227050934.16189-1-nikic.milos@gmail.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

Hi!

On Thu 26-02-26 21:09:34, Milos Nikic wrote:
> Just a friendly ping on this patch now that a few weeks have passed.
> Let me know if you need any changes!

Thanks for reminder. I usually merge only important fixes while the merge
window is open (as I want to base a branch with non-critical stuff on top
of rc1 or later). But now is the right time so I've picked up this patch to
my tree. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

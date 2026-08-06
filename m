Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5378631F98F
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786028840; cv=none; b=C+SLmSsrYoZIcOwT7fkzRp4zhnXQ+IoX3kIU1FHlhhMlXojisqbe/8Sxs6aOrJ7qMAw4OK145WkNG5BRA4dF8JbDmd/ZMoiwHfh+vy5U4ED0V1QV1ZdzBjzMKvpBQGU/MOZ63H68u0UMccAfrn6Ffr7gYu+aQM+ngLitS2DFE3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786028840; c=relaxed/simple;
	bh=YQwVpH3HQoRszcw3ssE7zafWmAeoSvXl06qJ6FkivlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vCRkdvnuhN6tGmdiIDO7aMH3ZW6ZE5uQRnmDacp6BlBnrIL5q7kIPAOPj0cBWaKsqqPmbiNld+1Iw1GddnUG7jFRChmk0qRGCcdWpUAsDHk2nAgbBZ1WCQeyxzsGLL1pE69SrEhmHuZVVW2IOOR+2eUGotV4x9SAtatIGxBhtaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HKlOdHL6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=03yazhy7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fUV0g/K+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lFxm9FKc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HKlOdHL6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="03yazhy7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fUV0g/K+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lFxm9FKc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 48B2E3DFF;
	Thu,  6 Aug 2026 15:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786028832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dr/NPmeGrimZDn7XCnESDkCGUTBx020Wc3GcO4vo2Rs=;
	b=HKlOdHL6BTl38GWOOr9AxG30rkIliBYa5eBRc04wlsKPUUvgfL2C9t0gW7CPHiTuBSV+7P
	bQmRhx8nrMS9xuUmZUrKdrOAttju7E00+8JzdfG4ORiMTR1D8OrfGhLyGYwoSnHT5hCHNH
	6gYHtTwi3GtXbgL6nY2oqh7bmN7uIAg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786028832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dr/NPmeGrimZDn7XCnESDkCGUTBx020Wc3GcO4vo2Rs=;
	b=03yazhy7Z6pfznf5OzCu3yB+XszmFlsC0OBKbUMPhjuQi5dQFedYsawDXukWPG+BwlPIbq
	ZcKbO3zi48fc6lDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fUV0g/K+";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lFxm9FKc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786028828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dr/NPmeGrimZDn7XCnESDkCGUTBx020Wc3GcO4vo2Rs=;
	b=fUV0g/K+UkzH4c2BSnskb0XS6gnJ+jCWolgFFXeEbdK95kFW85/Is1GDkHSGGH3LQs/IFp
	OLhl5EUiug0PJ0qHLc+i7x9c73AtS0q6v2qayoxoz1yFS6BHeToc268ZGAdTVJ6yCpA6/O
	kl6BFBmAsiU0JV59kYnbTHWMjN2BOLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786028828;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dr/NPmeGrimZDn7XCnESDkCGUTBx020Wc3GcO4vo2Rs=;
	b=lFxm9FKc5pfsJwHdBVs2t0Vg/Qj6uAnM/H+ftwalu/0zZBg9hr94ARH7XMh32Uc02Gpq10
	y4FQ2Ie7VrgXLkAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 417C6779B6;
	Thu,  6 Aug 2026 15:07:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E0f3DxyjdGrTfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 06 Aug 2026 15:07:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D2347A13B1; Thu, 06 Aug 2026 17:07:03 +0200 (CEST)
Date: Thu, 6 Aug 2026 17:07:03 +0200
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	linux-ext4@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH] ext4: Avoid entering writeback paths during fastcommit
 replay
Message-ID: <opjjhpe7p3mt2xr7aj2dpyfvwpzjs3s76j4xhgg53rdbomc5zb@hvzpcnnro5f5>
References: <20260804104112.93202-2-jack@suse.cz>
 <anSeKuPHikw2UxRt@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anSeKuPHikw2UxRt@mit.edu>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 48B2E3DFF
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Thu 06-08-26 10:48:47, Theodore Tso wrote:
> On Tue, Aug 04, 2026 at 12:41:13PM -0500, Jan Kara wrote:
> > Fastcommit replay effectively happens in nojournal mode. This results in
> > ext4_mark_iloc_dirty() setting I_METADATA_WRITEBACK flag and as a result
> > we end up entering filesystem writeback functions. However during
> > fastcommit replay s_writepages_rwsem isn't initialized yet and hence we
> > crash.
> > 
> > Fix the problem by avoiding setting I_METADATA_WRITEBACK during
> > fastcommit replay. Journal replay flushes the whole block device after
> > replay anyway so all metadata is properly persisted and replay is faster
> 
> It looks like this patch is only applicable if the patch series "fs:
> Fix missed inode write during fsync" is applied, and in fact appears
> to fix a problem introduced in "[PATCH v5 17/20] ext4: Fix data
> integrity writeout issues in nojournal mode"?

Right, yes, it's meant for Christian to pick this patch up to his tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

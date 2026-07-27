Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2095C3F8229
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785147692; cv=none; b=LlBIvJyIZipuHF9pmduEefxca4oWWVGbnAfUIrPngGIo6crLfvEVFCnAajrbekAkr7TtQ+4KdAyCjb3zOFsipkQqBJkXWpCp7rCK2ueCs0RaF83sGChiJXW7SjJpFEb80lcZDR+xy421gumZDvsEoYHIrtGRsxl228YN6T5YGo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785147692; c=relaxed/simple;
	bh=bBp7i8xP7OvikDAToIsUuOG8cX6RijFyVUnqlateJys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hnv5ZiRlqI115OjZsBeiTtJKmqbrHWgoSaeElN04m21yn5xcg7LMtmXQaSeIUdEOkcPqGknYZ14BEcIkaUHcXSF5RqaDNdSqAio70bYf8un7W0uykmBdaCYvdDDyK9gQStCZFnUdZicz9JLablCYPjFJmcKuCVTYCeqFMDqnGPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yKK/Lnhe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0IQN/3Yy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zs3r1Z5Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CT+eNBmw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yKK/Lnhe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0IQN/3Yy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zs3r1Z5Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CT+eNBmw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EFC797D93E;
	Mon, 27 Jul 2026 10:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785147685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fN2GkKFOxahiB6syrKkve9WsyO0+/0IDPTMAboFn3gs=;
	b=yKK/Lnhek+58pQ7wb2pgwKn1l2aJbCdzliGb5wgK0X+qLth2fKKYtPhMJU7rCgd1fc4b9+
	J2oN6LwCoHjg9+TthC/B7jcru9JrEeo6+u9oSa7gVdbhaYuX8dSVVxXAkfC3EcDW3BGkvb
	Oq8NODg/1C8jgWz4pxrHPqxoh3BaCyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785147685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fN2GkKFOxahiB6syrKkve9WsyO0+/0IDPTMAboFn3gs=;
	b=0IQN/3YylqxJhzfCjtHCX9C3s6H/NG1cnIvjOqDDPicFgh+DRvQf0nmgFK+ds9B4Ng7bFm
	A9TaK0r6/EWKj5Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785147680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fN2GkKFOxahiB6syrKkve9WsyO0+/0IDPTMAboFn3gs=;
	b=zs3r1Z5Y4sscikTjE8Noo9kKDdLz1BEkOKEzQXQYNSANe7MSjkieOhS699cRUUjALE5XU3
	Gg9tTNGONfdRhfqRALf/khSmthP3U4TxojUQILaf7ehJyb6bNeVVvkybup1Xr/Zi6y7AGr
	uGPKJmw58M712cNvFZjFZnziV1L2mtM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785147680;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fN2GkKFOxahiB6syrKkve9WsyO0+/0IDPTMAboFn3gs=;
	b=CT+eNBmw2vceQQqYxdKz2BT33ka0GbyM71uK1xgrJ1bi4AeR0JH7RGkNW5oB4lJHIzkUE5
	5Mj7qEkTUi/uaUBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7718779B9;
	Mon, 27 Jul 2026 10:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jex4OCAxZ2r6TgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 10:21:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 83195A0BA1; Mon, 27 Jul 2026 12:21:20 +0200 (CEST)
Date: Mon, 27 Jul 2026 12:21:20 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH v4 0/21] fs: Fix missed inode write during fsync
Message-ID: <pvgt7vemge5pwcs4bvlzg32fz3tzdnctni7zsai6uchtmtyx3y@sv7zv4ipg4ci>
References: <20260716145359.28639-1-jack@suse.cz>
 <20260724-einmieten-beatmen-glossar-63c4b3962e07@brauner>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724-einmieten-beatmen-glossar-63c4b3962e07@brauner>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,gmail.com,mit.edu,mail.parknet.co.jp];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Fri 24-07-26 11:52:31, Christian Brauner wrote:
> On Thu, 16 Jul 2026 16:55:22 +0200, Jan Kara wrote:
> > fs: Fix missed inode write during fsync
> > 
> > Hello,
> > 
> > here is v4 of the patch series which fixes the possibly missing inode write
> > during fsync(2) for filesystems using generic metadata bh tracking. This
> > revision contains mostly small fixes and improvements since v3, neither
> > Sashiko nor Christian found fundamental issues with this approach.
> > 
> > [...]
> 
> I think there's some outstanding sashiko reviews for this one. Feel free
> to just send follow-up fixes if the changes are small enough! Thanks,
> Jan!

Thanks! Yes, there were still three bugs Sashiko rightfully pointed out. I
already did some fixups before I went for vacation last week. Testing has
finished while I was on vacation so I'll post a new revision of the series
today (sorry, I didn't keep the fixes as separate patches and bfs
compilation failure would be annoying in git history anyway).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D16148380B
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 10:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160273; cv=none; b=Rx+PNHorsYL1/Q+yvdvmTGr5WmLqQlJs5NaT3z+PRuYgiRQsWLJx09ALPxSIClEDgmPrne1/Mqn48sCYe0LFTtwahPJyYA7kZJ2hYj7wZo1gBHgzNQf5Zrz70W9ZTibulq09e+sQi0ma7L8Lv/JDozfSegW5sZ+noQRPU0C1JTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160273; c=relaxed/simple;
	bh=6xPYkyIKm1n+pIKVwdP5BjtOHpdMJISHGOAcnKOgYIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCqA1wRAmIeLGUOy3hp7sZeWjBM+XJdZe+FR+PfldPyzNjxPNy8kxjGfrer70TjxXl6ucdA9Dl5HozX+JQpfhJueXW+jvkq4PSflAPv1VAIO/euZ8HOXVk5aosFJVPT33AOODDGJ5fLDxLPihtKUlCZnvDPpwrF/a7oaHNnrLrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Vv/gNbg8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZqqesWH9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iyr+VPsd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FVPLKAud; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Vv/gNbg8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZqqesWH9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iyr+VPsd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FVPLKAud"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ADFCA21B8C;
	Wed, 23 Sep 2026 10:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790160255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/bC/bqO9WykPptf4YQ6uosjFCCZq8jPc2lRQLDv1N6A=;
	b=Vv/gNbg8JOMjjReG8us2XUmt0/4TuAad90vG9Y4BRaKSUbwINrcZSR2m9ldFh2eQU9SPUO
	FHY+mUgLgPaXWvhesRrMZEqB85gNlDkIdVBGRhM6N4EQVvwGxAZTnw0TY+qpQc637nfaDz
	/lBFcJ1oIUglc8L8jm169ZeTlK8xp3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790160255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/bC/bqO9WykPptf4YQ6uosjFCCZq8jPc2lRQLDv1N6A=;
	b=ZqqesWH9dF8pH8YJC9RWo94EpNuxECNm0yPV7nKfGa4cdQF9GuJzJwUDG6/a9eCFUZ1gaO
	I685ndaaiSSj4HCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790160251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/bC/bqO9WykPptf4YQ6uosjFCCZq8jPc2lRQLDv1N6A=;
	b=iyr+VPsd2hRkOe2he+NbqnB5qb1E3gmvpp0n0ZiVLGTnqD6kkxgGlOfL3K8cdC3+XNP1KO
	M1WsnFvxflfLKrKa0MUu09JTIxALptwZepm9vqiroCh3b9+EALjCA4/kfDNuiPpl2Fspy8
	tR5qPZv7VlVgr7r8Ab8CU7NDJuf8L30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790160251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/bC/bqO9WykPptf4YQ6uosjFCCZq8jPc2lRQLDv1N6A=;
	b=FVPLKAud6Piui4QXRO/TGN5jxxSZuHkoiJ48nA9/7vzSlUhsIVmXUqpIoUV5i/5wapjtIr
	UDCoXJYHEBkrJaDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84B0413432;
	Wed, 23 Sep 2026 10:44:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eN9GGHuts2rUawAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 23 Sep 2026 10:44:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 11450A13D4; Wed, 23 Sep 2026 12:44:11 +0200 (CEST)
Date: Wed, 23 Sep 2026 12:44:11 +0200
From: Jan Kara <jack@suse.cz>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Message-ID: <5vxi5l66uorp6o4ctrw2ggg7bj2earkj43sbnnbhv3u2jmaazs@pzhoyizpfqfp>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923101749.3505886-1-matthias.goergens@gmail.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,ozlabs.org:url,suse.cz:email,suse.com:email]
X-Spam-Flag: NO

On Wed 23-09-26 18:17:49, Matthias Goergens wrote:
> The ext4 T: entry names the repository without a branch, so tools that
> default to the repository's HEAD select master, which still points at a
> merge from October 2020 (96485e446260).  Development happens on dev,
> which is also the branch linux-next merges.  Name it.
> 
> The Sashiko review bot, for one, falls back to HEAD this way and has
> been reviewing ext4 patches against that tree.  Its review of an EA
> inode refcount fix reported a Critical double decrement and an
> undefined function after applying the patch to that stale baseline;
> neither holds on dev.
> 
> Link: https://lore.kernel.org/all/20260916072420.316321F000FF@smtp.kernel.org/
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>

Good point. Feel free to add:

Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 806bd2d80d153..8ed6ae20c2523 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9791,7 +9791,7 @@ L:	linux-ext4@vger.kernel.org
>  S:	Maintained
>  W:	http://ext4.wiki.kernel.org
>  Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
>  F:	Documentation/filesystems/ext4/
>  F:	fs/ext4/
>  F:	include/trace/events/ext4.h
> 
> base-commit: 9091c97be34083587a75db174aab51551d8e8543
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

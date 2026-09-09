Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFCB4766B7;
	Wed,  9 Sep 2026 09:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788947209; cv=none; b=u2vrM5D/FBsOPymTFKlr1HuH5+p7f+XOIwbbWfSDBJDln0AMucQ6L6nk7e/9sXmgwmoopr/H83GgmHWMzSTlSCNC/n37ncdZNYibhYQqKft4AM1aXCBvAEuXgJzUZKEEcr9B3APIfBpcS3k8SpzdotMY53UaAT15h0TkOP1FvgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788947209; c=relaxed/simple;
	bh=mJovflON4q9TCpM6ZQzExrmapiA6Dx3iIby56hc5sjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ut6xIBQNeNiOSY3cpERbk//Ta2HLDzYgRUovErqiIM3ATqgemc9yFnjJfu8jLJ4mH7DB8Gv9Zu6yYAVPhE/8yTAre03ZvSOsOy+Hl77Lkgojl0I0Gafh03YFwwlmKUFltHU2n3Dfbx7Qj+ZMTgvqMNlxJeulmTDuqGw7spEOGwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=clQYoghz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HzOeEs70; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rgr8rTkp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zMSDJGRn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="clQYoghz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HzOeEs70";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rgr8rTkp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zMSDJGRn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB42821B48;
	Wed,  9 Sep 2026 09:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788947202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ET8n7cENHr0UHT7IN2RMsfgNqJ4fiwg5SvVAcH7Rh2s=;
	b=clQYoghzbU3jwwvSUUZ4Fp6MEjUDN1ss5m3HLX6+ZQaodsd4p69uoDeIW0sVx1Xqjpma0h
	TDXBrkMFof7irKIbhznpQNPHyoTpVpRsucQetZl5MiuVLbjbTzweqWLCcHkD5/xhiN1Poa
	9l3AUTGnR8BhJHBDCISGfU1GaazzDWo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788947202;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ET8n7cENHr0UHT7IN2RMsfgNqJ4fiwg5SvVAcH7Rh2s=;
	b=HzOeEs70kHC/CdWJtrPIyf0B1CcyTkYtt+GsIltRkC4AEKVjEfZVNIzefeSDpAj2y2AGA8
	DF/o69WmynvAc/AQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Rgr8rTkp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zMSDJGRn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788947197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ET8n7cENHr0UHT7IN2RMsfgNqJ4fiwg5SvVAcH7Rh2s=;
	b=Rgr8rTkp674DvF1CYsr8WdWNXKLwfKOsJCp4FeLFbwyFtpwwmqNTTXeIcVVsvAgfUOQHd3
	T+I/kY2TNSiXPlq7OD2+k/q7XNbCpmsfUU9jteermIMYI/AsVSq5L4zOScStdMZZpGsq1I
	ce+UKgS4aWlRmswm3fUqN4CfYghe3nU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788947197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ET8n7cENHr0UHT7IN2RMsfgNqJ4fiwg5SvVAcH7Rh2s=;
	b=zMSDJGRnez5WKRm247LuMMvBMkku642ek9XG/7QKC3ERUDdKcvgFxVr8KOFkXRlGQFhqSL
	nWQ3JW5bxeB/vFAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9B271352C;
	Wed,  9 Sep 2026 09:46:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mS5SLf0qoWqlAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 09 Sep 2026 09:46:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 48C26A1341; Wed, 09 Sep 2026 11:46:33 +0200 (CEST)
Date: Wed, 9 Sep 2026 11:46:33 +0200
From: Jan Kara <jack@suse.cz>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marco Elver <elver@google.com>, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	Timothy Day <timday@thelustrecollective.com>, linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] once_lite: Simplify condition handling and fix context
 analysis
Message-ID: <wdik2jphoenf2qaixyrmy2adx5vcf42fzzcictossm73lqweoc@l3vwrnzxvsg5>
References: <20260903101843.3462767-1-elver@google.com>
 <20260907221334.GA1619741@ax162>
 <CANpmjNNuiX-rQFvn0GK1SxAbcxEUH7rKh69GPq+7u2tg63qbmQ@mail.gmail.com>
 <4ohly4m6ffr4jnpqncucwkajjorfzdi4x3perczoszs5cb7ljx@mrf7no3uuzua>
 <20260909002005.GA3661577@ax162>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909002005.GA3661577@ax162>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: DB42821B48
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
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
	MIME_TRACE(0.00)[0:+];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Tue 08-09-26 17:20:05, Nathan Chancellor wrote:
> On Tue, Sep 08, 2026 at 12:15:13PM +0200, Jan Kara wrote:
> > On Tue 08-09-26 00:17:34, Marco Elver wrote:
> > > Thanks! I think this is one of those orphaned files - which tree can
> > > this go through? Can it go through your tree, unless Jan already
> > > picked it up with the other fix?
> > 
> > If Nathan can take it through his tree, that would be great, otherwise I
> > can take it through mine. Just let me know.
> 
> I applied this to my clang-fixes tree and created an immutable tag for
> you to pull from, as you should have it in your tree since you are
> enabling context analysis there. If nobody else needs it and I do not
> have any other material for 7.4 in that tree, I won't send a pull
> request if the ext2 tree is merged with this included.
> 
> The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:
> 
>   Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)
> 
> are available in the Git repository at:
> 
>   git@gitolite.kernel.org:pub/scm/linux/kernel/git/nathan/linux.git tags/clang-fixes-once_lite-for-7.4
> 
> for you to fetch changes up to 0bb666d5f5a2339a5692afb312c2161df9620503:
> 
>   once_lite: Simplify condition handling and fix context analysis (2026-09-08 16:54:02 -0700)
> 
> ----------------------------------------------------------------
> Immutable branch for once_lite.h context analysis fix
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

OK, thanks. I've pulled this branch into my tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795549948;
	b=B70YMy0idvv5lslrUmXISE8YCe5sz4cYXsZu7z/0ZxEgVvZDy23EQ/WzwaOiWk3HW7UX
	 QzC0UkkTTm2XhaTioYyEv0AnOHCkBeKTeP3dGUIP3jTBSPf3Yj5dve3mdRtMatVgQDn81
	 fGhbB6vKB88CtiSfUuLfAKEGcsszRsVdsvKC4s0uzYjsfxGO/07Djwd9PVs6in+x3X05O
	 Lad2EZVGBGJTlcREtjS0uFxeQnB9Tj1Qa4iIsOujxueqogbyFXRLDkbKJzzQS8zGtBSDk
	 Zj2NTpSimt5m2vePLn5t9VT0msIJkSYy2S7d8o1V6E3kWU+w1o14s4ichiAdTSMzJzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795549948;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:In-Reply-To:
	 Organization:References:Date:Message-ID:MIME-Version:Content-Type:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=yS7O3rY1oGDr4IdzWC9LN89ek2gLw2iYbqf8+mjmRCg=;
	b=P5EMeYu1dO44EPXip3RAZgnlMJNuVdzzIcJoxQ8htHxAd4GA9v3PJ9ZOf2tEW2pZ4FbF
	 CclWqLufvNiqOn2Um9CLK6hWMzzQPXLSqtC7Kq4KFyuFnA0vobkUoV5kC7QrII9lyBPLg
	 cVaYwGkGF4YCjcO+iAfXio2cTyOJvgDdKsX/wUSGEUHg/5VoMBwsJJ/8rUPuAp8Pr1DAr
	 bZkotngoV+dzy8Y1k8rBM9B/NS5Brfl11ket+5kBipl8U8f673PrNAaXPnXfDVFEB79Ia
	 nSzGqAk4BepvkiJGXWGWcdbmHYs0VSIQ5nQ4OSTHFZMqoK3BlS9F8VrUJiH64yXmm/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ABSW4SHs;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eZhk8UbS;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=aqZ1v6OZ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="qv1aY4/M";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE3D606A31E;
	Tue, 24 Nov 2026 19:52:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AE3D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ABSW4SHs;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eZhk8UbS;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=aqZ1v6OZ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qv1aY4/M
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 669D01F74A;
	Tue, 24 Nov 2026 19:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795549945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yS7O3rY1oGDr4IdzWC9LN89ek2gLw2iYbqf8+mjmRCg=;
	b=ABSW4SHs1GfyhLVQ5cmQVHhbhYepMI1Px5Cu45+4wvB/xYKaHt/daGvGmP+LK/Q29aUD3d
	cpDaM7OzoXTzZIqdamxfZ/w+7qnK+0fXgOL9827YuAI0c7AsU3jPXmcPlwrsrH4IROvLBq
	PST3uD4/wREGzB7p1WjsuGckN3Ehce8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795549945;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yS7O3rY1oGDr4IdzWC9LN89ek2gLw2iYbqf8+mjmRCg=;
	b=eZhk8UbSU4nTa1ZVZOsfnPOLNd5gGACp1YNIWXPCyoNYdMRNwReGeS2p/rk+ZdOuojfYJT
	EGf6rEudpU1kp2AQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aqZ1v6OZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="qv1aY4/M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795549944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yS7O3rY1oGDr4IdzWC9LN89ek2gLw2iYbqf8+mjmRCg=;
	b=aqZ1v6OZZhD0L6t/OtkrvtdoUw+6bndbfupVFnsWrhQxlaJIYGmc0h/9wshnOsWoEEY20j
	Q3gurqN9ZGyW+mwh6g8TXyGnDltsqn5vJ6kIiTLOzsfAO3j9BTn3H+Yx9AYZR8GO6u8gbo
	UrW24EouDg4SAOqvg23eoRAMsXGT8kA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795549944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yS7O3rY1oGDr4IdzWC9LN89ek2gLw2iYbqf8+mjmRCg=;
	b=qv1aY4/MYDiSFNBtI2kb9tahjtzyX0nEc93C13sUw/l8vQ2ivFVv06bCgYiMvSemkFFAAx
	dly2ZcRh11Lm+cDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE0DA1339F;
	Tue, 24 Nov 2026 19:52:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oniJIffqBWsLeQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 24 Nov 2026 19:52:23 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Sarthak Kukreti via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Sarthak Kukreti <sarthakkukreti@google.com>,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Eric
 Biggers <ebiggers@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Dmitry Torokhov <dtor@google.com>
Subject: Re: [f2fs-dev] [PATCH v2 3/3] f2fs: reject casefolded names that
 fold to ".", "..", or empty
In-Reply-To: <20261119214944.1480596-4-sarthakkukreti@google.com>
Organization: SUSE
References: <20261119214944.1480596-1-sarthakkukreti@google.com>
 <20261119214944.1480596-4-sarthakkukreti@google.com>
Date: Tue, 24 Nov 2026 14:52:18 -0500
Message-ID: <87ik1mc8i5.fsf@cartola>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 669D01F74A

Sarthak Kukreti via Linux-f2fs-devel
<linux-f2fs-devel@lists.sourceforge.net> writes:

> From: Dmitry Torokhov <dtor@google.com>
>
> Filenames consisting only of ignorable Unicode characters fold to empty
> strings, and names with leading dots and ignorable characters can fold
> to "." or "..". Allowing such names in casefolded directories can corrupt
> directory structure or cause confusion with special entries.
>
> Reject any non-dot names that fold to empty, ".", or ".." during
> casefolded name setup, while still allowing invalid UTF-8 sequences to
> be handled as opaque byte sequences when strict mode is not enabled.
>
> Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
> Signed-off-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>

I don't have any comments on this one.  Fell free to add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


-- 
Gabriel Krisman Bertazi

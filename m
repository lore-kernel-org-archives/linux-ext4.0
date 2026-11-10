Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794312791;
	b=kDkLFORylLECzNJGCItw9j9zwzJbDLm4DZvhfUgwQ3L3dGGt2j2CiAC0dlNIB7nR2/uw
	 Gh+Xa06dFBt7DcDvJ74jHvkAAXMgLrDWmcTGiQwoFkFrW3T8wVHf3w71nP5dBYsiaxres
	 ZkJPhzLySCVcVBNkUIkmGqyzWmWYo8I4eehu9IoCddaMG3MwQoXJVsDKKN4jSgqHB/L7l
	 U9sm/++/y8hNFsjwzcFOjYSPPfTiHcCepWqkqAGBQ29NHlchnLPbtdrSE91ie0KrEvoj5
	 ba+D/3rDFgR1dLzuSrLNCkMOs4QMWtELKChGM0TfuCCfhnd6RexJyNNyYVS6qn7zHGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794312791;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=WUT2O0SW8TKi+EbcZowhvh+wQIZVSFCDotTV9qKsnQU=;
	b=WYGncM+8KglterQlLNIGCTwfEpFJxYrp49UnSuwmHmVlOPw1OTD7nsedv2L/M7zbCRuk
	 khib1dtVo6jdCtI2YicQajE7VJvQqiRpa7tHjib4UpxDCUqb8XsdXjpdYIOED08XVoQ3d
	 lnBbDjkWG0VbeRCDytglPWAiwZhp2xIXdrdyM7Qa5XzjJq7E8bti9qbKfzeMD3RK2exeF
	 epig34lInaZeuhaJqLBI8pgwmTIuQOnVfFzZRokeXLY5t4/kqhV+6PNPbzQuVZWEzHYIq
	 rSoojH8dOapSHlqPTOgUcdnFw8txUKe+xjpM+ZlyLs2fxojZMsnGNHqA/3EYtN4FxDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=o8NGFdwy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=a9H93C0w;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qo+8yXEs;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YXNjNYrm;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C29606A31C;
	Tue, 10 Nov 2026 12:13:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78C29606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=o8NGFdwy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=a9H93C0w;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qo+8yXEs;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YXNjNYrm
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5B88921F01;
	Tue, 10 Nov 2026 12:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794312788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WUT2O0SW8TKi+EbcZowhvh+wQIZVSFCDotTV9qKsnQU=;
	b=o8NGFdwyIOuncfNndtOEjuROboQRE2JcBb3nVaSr5GUt7bCru8l4xxVFHrRchVYhMp2Qzi
	N9TTM+kebK/z73RZs2/vY2GVe//j8aEA4CPsw6IWYMNiTx9ueBLOwzqf1irRHUgsFVlsLI
	5QqMpoV1RcsSnJ88MCNkr9Gv2J7+cP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794312788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WUT2O0SW8TKi+EbcZowhvh+wQIZVSFCDotTV9qKsnQU=;
	b=a9H93C0waV1nj9dBJoVMtBkoHroU2Yw88g6hWtWYIkpbk8pn8CuX1KQQOhJ9SR1Na+y8hz
	gcOl8bH0WiyuVRAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794312787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WUT2O0SW8TKi+EbcZowhvh+wQIZVSFCDotTV9qKsnQU=;
	b=qo+8yXEst4416WTvyO7Ox8vs15Ov2oKlYanbPC3xwLUdzt+STEGPCRSaBVwyelwuGGkjVn
	6dNDD/x6om3gS+9fSrCUI0EvQmaDhPufchDaGBWJ0aJYzsQPVpcFuxc2leo9WT0mGyHvXh
	zUbzPOALMrghku3wJAcqChrZiL+n2sw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794312787;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WUT2O0SW8TKi+EbcZowhvh+wQIZVSFCDotTV9qKsnQU=;
	b=YXNjNYrmrcNmxw8NSwb/yMKsgZIvBQQZuNbVi+71FS3Y6dETimwZyjZJFtOUypR0+oVVng
	OsJ+4wcv2f9yBaCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F98E13479;
	Tue, 10 Nov 2026 12:13:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6rfmAFMK82qeFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:13:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A8837224B9; Tue, 10 Nov 2026 13:13:06 +0100 (CET)
Date: Tue, 10 Nov 2026 13:13:06 +0100
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?SsOpcsOpbXk=?= Jean <jeremy.jean@oss.cyber.gouv.fr>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix OOB write in fast-commit replay
Message-ID: <hmrm64sqocegpeoys256faue5zxpj56v5djptsnx35mujob7b7@waziougupt6k>
References: <20261108204345.1423203-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <idqh5j5m3rhjsdu77h7dchk5vxj47fcsls7tcdhu4wdf75cthu@sxwipa7u2hyl>
 <038be9b9541cbcc43ed35cf7950b9361@oss.cyber.gouv.fr>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <038be9b9541cbcc43ed35cf7950b9361@oss.cyber.gouv.fr>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 09-11-26 21:47:51, Jérémy Jean wrote:
> On 2026-11-09 14:19, Jan Kara wrote:
> > On Sun 08-11-26 20:43:46, Jérémy Jean wrote:
> > > Fast-commit recovery checks record bounds and lengths during scan.
> > > Replay reads the records again without these checks. A corrupt
> > > filesystem
> > > can make an earlier replay operation overwrite a later record. Its new
> > 
> > This fact looks like the real problem. I think we should validate the
> > replay does not corrupt the journal. How does this happen? Otherwise we
> > have to fully redo the validation of each record done in
> > ext4_fc_replay_scan().
> 
> The replay can corrupt the journal because a corrupted image can make
> metadata blocks used during replay overlap with fast-commit blocks. I
> agree that making sure that replay does not corrupt the journal would
> be a stronger fix, but I'm not sure I see a simple way to fix this
> properly. Rechecking bounds as I proposed fixes a memory issue but it
> indeed does not address the root cause.

OK, I suspected that. So it would mean making sure jbd2 does not corrupt
the journal under itself. In ext4 we have "system blocks" infrastructure
for things like that - see ext4_setup_system_zone(). In jbd2 I guess we
could create something similar just for the time of replay - during the
scan pass we'd build a list of blocks belonging to the journal (just a
simple rb-tree with extents should be enough, under normal circumstances
there shouldn't be more than one or two extents there). During the replay
pass we'd verify the target locations of metadata blocks are not in the
journal. This would actually cover a larger class of journal replay attacks
than this particular one...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

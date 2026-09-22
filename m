Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE194F4D13;
	Tue, 22 Sep 2026 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071945; cv=none; b=KyiaaT9ATumqZ4Mrba8XPctyjul0TvvOpJTO7ZhuHRjKjjClV7kgjuGAv9WnBWHVW8lf+dg37cMMOaOG3DqVYBv10r4uzQEyEOe86Eoy7xUAoGzVkriduV8XHYttNgwBNZzO1/DY1rmqKrPt7AycL7YCVG64dMfbxJCSBkZqf0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071945; c=relaxed/simple;
	bh=bTCKT3I0YOxmOjbGJfUZYE6q1iBMjbtWrtxyyk8rJT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAzkBpNpyl5ypq/AamY/nnVDcorkx948RrxLYNe6iMo1rtVR9drw7By/PXmakEpqg5EYqC4/nJTB5TJqVKD+Y8yKBlDIxNSjd2TcbLRDmjmnXZTQky1k8Vilzt8ylijS0FHaSTIPjLfBNX9q0XNAfA/8/3fdQhQDA+ztBTw+PhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yB7ccf6K; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ey+Kp//i; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PAR907Yn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WC40t3yh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yB7ccf6K";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ey+Kp//i";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PAR907Yn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WC40t3yh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1F8E51FA78;
	Tue, 22 Sep 2026 10:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790071937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0+bhU7AzU8BA4/XU1mCfWuUmVqNRDI/2RZv5h4MV0tE=;
	b=yB7ccf6Kbd91ebV3g4focxybDdLq8t9aXsYcXPKnUvTQ7k6PQC91rFzC60nSN853WRd/x8
	0W6pxYdz0CtM7wN7E78Kq5A7tc8xvnALvplUs2qCQnbJ1AtF1cTX4YFgwoIRtBEOZNEMPO
	daCV8E7ZVhVGNrMLy35HD/KZC2NinQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790071937;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0+bhU7AzU8BA4/XU1mCfWuUmVqNRDI/2RZv5h4MV0tE=;
	b=ey+Kp//iEu6T89eXfZ96T6/YpWv6bfuCvxChBBg8gu1XrF88TaAgUhNAb+smiem8f1E3Cf
	EDM8XPg3vqq2v7Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PAR907Yn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WC40t3yh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790071933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0+bhU7AzU8BA4/XU1mCfWuUmVqNRDI/2RZv5h4MV0tE=;
	b=PAR907YnTl8gie22jsc8vApmzdNN6u8xZkhZPTgYpLhui0cOOiINmi68FG2ohljF0ORsNV
	/M7nrfOwtKvc+IX2kbkgQonpMIQ15JmLVouGsn5BBWyDvwqBgvEXVxDsNsrQzpkSgHvXoZ
	z3DdK+8TcIeORwPZYw078VHr5AVjRj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790071933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0+bhU7AzU8BA4/XU1mCfWuUmVqNRDI/2RZv5h4MV0tE=;
	b=WC40t3yha4og6CW63dPYWR8oQ9hBs2g/AkJbcrc45IRc7fweTVPG+oTsdVKGhBBnUWnRHX
	wQtSfaefeLy4+1Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7CA3139EE;
	Tue, 22 Sep 2026 10:12:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kwl/L3xUsmq9FgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Sep 2026 10:12:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 770A6A13D4; Tue, 22 Sep 2026 12:12:04 +0200 (CEST)
Date: Tue, 22 Sep 2026 12:12:04 +0200
From: Jan Kara <jack@suse.cz>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Christian Brauner <brauner@kernel.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Srikanth Aithal <Srikanth.Aithal@amd.com>, 
	Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>, 
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
Message-ID: <vul22mzglx7gnnnslcnydkoiemwdyx572mfe6uylyjqaz7wpcs@nl7m4xyoklpa>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
 <apiMiLlwujmqyYLP@user>
 <c3be2678-72e6-4122-94de-ae95e980578b@linux.alibaba.com>
 <20260904-unkraut-preis-pendel-a57f694a54c5@brauner>
 <12e93e0d-0fb8-4ac8-9be2-3d9b5f7c6d4e@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12e93e0d-0fb8-4ac8-9be2-3d9b5f7c6d4e@leemhuis.info>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1F8E51FA78
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,linux.alibaba.com,gmail.com,vger.kernel.org,lists.linux.dev,amd.com,fairphone.com,suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,syzkaller.appspot.com:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Fri 18-09-26 08:53:38, Thorsten Leemhuis wrote:
> On 9/4/26 12:35, Christian Brauner wrote:
> > On Thu, Sep 03, 2026 at 09:42:27AM +0800, Joseph Qi wrote:
> >> On 9/3/26 4:52 AM, Yalagada Pavan Kumar wrote:
> >>> On Wed, Sep 02, 2026 at 09:33:57AM +0800, Joseph Qi wrote:
> >>>> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> >>>> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> >>>> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> >>>> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> >>>> directly") made them point b_data at the kmalloced frozen data rather
> >>>> than a folio.  Submitting such a buffer during journal commit oopses:
> >>>>
> >>>>   BUG: kernel NULL pointer dereference, address: 0000000000000000
> >>> [...]
> >>> I was working on a fix for this syzbot report [1] and didn't realize that you were
> >>> already working on it. I noticed your patch on the mailing list, so i won't
> >>> send a duplicate patch.
> >>>  
> >>>> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> >>>
> >>> Could you please add the Reported-by: and Closes: tags from the syzbot report
> >>> to your patch? This will help syzbot associate the patch with the reported
> >>> issue and track the fix.
> >>>
> >>> [1]: https://syzkaller.appspot.com/bug?extid=41453ea05ab61c075f1f
> >>>
> >> Could you please address the above when apply the patch? Or should I
> >> resend the patch with them?
> > 
> > I'll do it. Thanks!
> Christian, just wondering, did this fix maybe fall through the cracks?
> This got on my radar because there were a few other reports about this
> regression since then -- and I can't see this or some other fix like
> this in -next.
> 
> At the same time it feels a lot like I'm missing something -- or like
> some deeper problem with all of this turned up meanwhile, which required
> more changes that people are still working on. If it's something like
> that and everything is on track, feel free to just ignore this message.

The problem is fixed. The bug never got outside of linux-next so Christian
just fixed the original commit in his tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9AD514743
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2026 11:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790680710; cv=none; b=BeEwBwaJdtdR5pXZ1yGAnQkJmJP84oGmWoCZp4fWvTnefT87RlEFY5gCXVAljDElRz5eopE/4onJATFKbyOIUWAYOb1KLZJVMaO86h1Glxsoe1AGdDSQnifKiD4xE89y9G+ad9TXzVmG8nYchflNU+bYJV06Mb1rPLKZ725ZPmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790680710; c=relaxed/simple;
	bh=iySmgqq4FqPd9G82urILN5lWP5gmUtgoJnrG7lr0rO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnhZbznRUvl5YFMS+6NNEaurq7rIK7VQw1g34oYKNRWhgFcIx/mdlGfC3Xm3k87S4VqU7ClKHEnrqnAbZaF9iOfw0bgTj5KPFuT8QmcipGMyiaWhfXeYkm+E8jkjnlkyv85nvkQAXptDB/+w/sNpc9XnsFVso3KGEp4UGHb6VfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uQmEv7eL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4qt5ma/p; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XequeGdw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8uNOQ68B; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uQmEv7eL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4qt5ma/p";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XequeGdw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8uNOQ68B"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D555B21CE0;
	Tue, 29 Sep 2026 11:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790680703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Zj6EK1kZRtd/QX7s8cqCOJvgr5lWKH/M09payvKFoM=;
	b=uQmEv7eLfg/DZY32PtcJqaZANX8eHFtNe/5V55WJ5j6HO09Q37DDs5JOXWseQLDSobHxja
	FONAowiOFGK9i28uTQE5UkaMQZUeEKd/wJAnKHdY17fZjywNQBlwLBTN4ppxrQumnEfnUr
	6Zoxb8bSabsuz2BCO0LWb1DylIDff4o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790680703;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Zj6EK1kZRtd/QX7s8cqCOJvgr5lWKH/M09payvKFoM=;
	b=4qt5ma/piat85oiPZKxDv+Wj3+mQNcz1GXUKaiWjBU+5Em9vU/BlQV6QGFx/MU41j4LMV5
	1LuSMiV9MpxKB7BA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XequeGdw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8uNOQ68B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790680698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Zj6EK1kZRtd/QX7s8cqCOJvgr5lWKH/M09payvKFoM=;
	b=XequeGdwFzHY3h2dUu4snxOvpYupmQrD9mG5N/hmarjYhYA20kM0cqM+CeyKMm0/xIkWs8
	Z7ozeoA7pclowSSuORIuK5MSyTSZtISM2Hb0KT4oEa7wR1VWmGCB+nAM/hnbuC2HnZ2Ov9
	8Z30nQoz9eM5vIZ6rpI/bk1/PwJG8uc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790680698;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Zj6EK1kZRtd/QX7s8cqCOJvgr5lWKH/M09payvKFoM=;
	b=8uNOQ68BxaRaZFZdM6Ja8T7+Tl3wqvCvl9pagctNn4q0KZ/TPAFNiv1u0xi6mRXNgIAiyL
	NmTahlarqLZwGgAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A00C136F7;
	Tue, 29 Sep 2026 11:18:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IgOGGXqeu2o4DAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 29 Sep 2026 11:18:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 188C1A132A; Tue, 29 Sep 2026 13:18:18 +0200 (CEST)
Date: Tue, 29 Sep 2026 13:18:18 +0200
From: Jan Kara <jack@suse.cz>
To: Alberto Garcia <berto@igalia.com>
Cc: Eric Biggers <ebiggers@kernel.org>, 
	Baokun Li <libaokun@linux.alibaba.com>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Message-ID: <4eha2a3cgcfnkhjcxziycbm4rzz5e2xkyjhwah4sokn2brz4vz@heqnevhi4yiy>
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
 <arPIrtWTXUTwqxFC@igalia.com>
 <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>
 <20260923180119.GA1506901@google.com>
 <arU-kvN-75AEmNQw@igalia.com>
 <20260924180438.GB1978@sol>
 <arZVoP0GGSNXYBLC@igalia.com>
 <20260925190751.GB2060@quark>
 <armU51iuvA9d7zvR@igalia.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <armU51iuvA9d7zvR@igalia.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D555B21CE0
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,linux.alibaba.com,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Mon 28-09-26 00:12:55, Alberto Garcia wrote:
> On Fri, Sep 25, 2026 at 12:07:51PM -0700, Eric Biggers wrote:
> > On a filesystem without the encrypt flag, ext4 rejects creating new
> > encrypted directories, but it doesn't reject accessing existing
> > encrypted directories.
> > 
> > It *should* reject accessing existing encrypted directories. [...]
> > The only caveat is that, technically, if an existing encrypted
> > directory is using the old policy version (which before v5.4 was the
> > only option), it can be unlocked and accessed without executing any
> > of the encryption ioctls.  So in theory someone could be depending
> > on that on a filesystem without the encrypt flag.  I think it's
> > unlikely at this point, though.
> 
> One problem that I see is that e2fsck does not seem to detect such
> filesystems. Wouldn't it make sense to fix it there first? (I suppose
> by setting the encrypt feature if an encrypted inode is found)

Yes, that sounds like a worthwhile thing to do to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

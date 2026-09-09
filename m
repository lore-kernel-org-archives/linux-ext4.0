Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC9054DAE0
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 12:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788956902; cv=none; b=XGZZjwYX6jqmVt0zxEctWpsD2eOVMsTcu+T2aMpf+xWFVrNvV/8rTt23V8PsyAJmWaF8yE+i8RjPRTeNYo4DWfTkDIFO4j19XUYozUvj7puS0tWN/iM7xx19pzqAwdPqp+EgvItW68/QdHH8VtHgqhx+rS4d0ITIu4xR2fZb0hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788956902; c=relaxed/simple;
	bh=60pdTpsqkKg1YHIm6cgc5vAONkkRWzhN8yBYKbZ98pU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PPK89tAb0wuV6iFc+oFWUtXQdm01QnUw8pS9R7/dayWkw/arghFKN5QgYbsyUhf73Z6R8fJkj9FtYxGNE6ScwnCmcITpJNvrvwR2euIlK/6H6pKVF96OpyuoHuGbLdnaRFO6OD1zIplKHBXlEGNP0DCoCppU15XtdzSDCJojm48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0cKxjq7f; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FcSQlASU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=h77ZKx/T; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=f1lAk/ta; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0cKxjq7f";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FcSQlASU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h77ZKx/T";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="f1lAk/ta"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 590A91FA54;
	Wed,  9 Sep 2026 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788956895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gF62I1aP35Ezeel3OpRYNZjsS+Sr+pE2ylU9F228aLI=;
	b=0cKxjq7fl87Mlj7754Sj/xxXHZcAl/Lnk+5HL8R4UJTsEhGMVw5u3Uu8OJCZllZ8YAhbRs
	kOkKMXps9RPhWRVaInD0js6Gf+WEcrOhArzV9eFjVovf2IUHls4EGzfgsv7wyVwtGWcO/p
	NM/tl5LtecaqCeRFwGm6OB0LUDjzNII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788956895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gF62I1aP35Ezeel3OpRYNZjsS+Sr+pE2ylU9F228aLI=;
	b=FcSQlASU1fwCWcsi1Nwp2TpkGMQabBiYegHYKVzoo8f/FF0g52a/AWvc+pclnKmTRGhcKL
	ZdXL7XfvCn+oDhAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788956891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gF62I1aP35Ezeel3OpRYNZjsS+Sr+pE2ylU9F228aLI=;
	b=h77ZKx/TOuCN0jylVJKid29qzb0agsDXO1E8YD5AH9eCB8BkARNVNrsIrUoQKBeYWm/hrI
	zc0LYp5bi+ulUbb9tqU6F5/kTd+6rJVulm+x9sKIf7Yi822lkiRMN8EiAe+idJGLtyh6D3
	AGaaSgkgHO4E2vjxv3tG7gOIqZGbl7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788956891;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gF62I1aP35Ezeel3OpRYNZjsS+Sr+pE2ylU9F228aLI=;
	b=f1lAk/tajDPTSmcvrfPlnZk9Lb4ku4rzvf3dcZcoNV5jJZK1LT2Mpj17D02E706NmUOdLl
	U61uSMcS1KaeqmAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A0741388B;
	Wed,  9 Sep 2026 12:28:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tV0mDttQoWorOAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 09 Sep 2026 12:28:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BCA0CA1341; Wed, 09 Sep 2026 14:28:10 +0200 (CEST)
Date: Wed, 9 Sep 2026 14:28:10 +0200
From: Jan Kara <jack@suse.cz>
To: shuo chen <1289151713@qq.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4:Fix the initial value of not_found in
 ext4_destroy_inline_data_nolock
Message-ID: <t6wtkwggbtqrgbzezrqg3m25oahdtb7nq4tcps3xgmbnxzq2sk@qsujtfjqpwsg>
References: <tencent_CD1AF9C3A7875C42F2187B57D74A1C5EE609@qq.com>
 <r7cnmruhhypvxk32ilopf47mbx4qd6dcdsbari6zwovaerp7gz@a27v6irfx6hl>
 <tencent_853282AC6E9460BD1035B287B70CD5852C0A@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_853282AC6E9460BD1035B287B70CD5852C0A@qq.com>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[qq.com];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Wed 09-09-26 19:30:24, shuo chen wrote:
> On Wed, Sep 09, 2026 at 12:37:50PM +0200, Jan Kara wrote:
> > On Wed 09-09-26 09:12:35, shuo chen wrote:
> > > If a file has EXT4_INODE_INLINE_DATA set but lacks the
> > > EXT4_STATE_XATTR flag,
> > 
> > But how can this happen? Inline data is stored in xattrs so it shouldn't be
> > possible...
> Thank you for your guidance.
> when finding xattr, there is no space left. Can this happen?
> int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
> 			  struct ext4_xattr_ibody_find *is)
> {
> ......
> 	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
> 		return 0;
> ......
> }
> If this can happen, it makes sense to fix the initial value.

Let me repeat in more detail because you still don't seem to follow.
EXT4_STATE_XATTR means inode has some extended attributes.
EXT4_INODE_INLINE_DATA means inode has inline data. Inline data is a
special type of an extended attribute. Hence it should be impossible that
EXT4_INODE_INLINE_DATA is set while EXT4_STATE_XATTR is not set. If you can
find a code path where this happens, do tell. Otherwise I'm not spending
more time on this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795005742;
	b=Wtg6xpjdYA4Yv9yec+jN3rdOPB0rbzEiDYVf7r18QIlgLBHSvANlbr/Y8fzuIGNQY0OF
	 jAKRMRzJ3/hU7xxgpuAntRMsFFoh4AoqNfiE7C1I6qQizPDmQ2CFemZTKJfYUCux5yTSt
	 x/vHr0sUiEGoiScFAGn5tTojHxodndg5Qfr/pOTkiV6Q7fbPvn80wnhqxuzFGwcu5M5L8
	 1cQPDLv7LYIi3b9t6yQmkzcB/m6CgDELUjekB+A56Co6lEqAnH01g56Lq+DW2gwHrnO7v
	 QYuFdUMMb1UjzFHeT9S80yz81AuPOzZOzm/G6SjY9Nx2Wcpes0Mx1hMxZo31aEe+26Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005742;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=Zxr2lXP/CQxcFyWePtNcp3//xZZmywzEeiRPGK/G+Zk=;
	b=2ioX/wLriqP2Cni86Fh8EZTxHvWstfZnyQEiZOHvoTyWoKK6etk7KUpHE+2+R1AdE0a6
	 IUcEX9Mr3LSkAByhjR6PLOn10vZU1TSMLnkwx1+P0PJkY5/QFm5qZYaubBaKPV3xKoKVH
	 q791+i2wRroYm9DwcU2yGPqzY+YDmSB5m2z2vbJXOpn0IAiAPWu1rH+UQVNLBQgeZLHQ9
	 zlpoKJ8DcrPks+1Oca+fs1kIgJ5frJkGpdMHFWv0NSJIS8Cqhgszm84+7tz4bLC/U6XbJ
	 g2iyzycxk5EdOJLDQKTj3YZpb3bWskQfpzPsy/VMQVR9W2wMYZzjgUJapmabWn8Z3AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=gKKvctMK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fs4EkGCO;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="JsWww/C/";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+kpswuRN;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86EF60A261C;
	Wed, 18 Nov 2026 12:42:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E86EF60A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=gKKvctMK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fs4EkGCO;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JsWww/C/;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+kpswuRN
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D54372237A;
	Wed, 18 Nov 2026 12:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795005740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zxr2lXP/CQxcFyWePtNcp3//xZZmywzEeiRPGK/G+Zk=;
	b=gKKvctMK6mEzUt/tgWDg6IeSBshXImrkFSjKOEE3uPu44kH33HRnHUW8rilIrCB1zrW+Wd
	JSwXt/IMuScdKYaPnpFFSh7T/X+PmGyipbpzxzhhSab+eEJrSqK/eWqgRh+T9ZVqEMnhrt
	cyQmMvQe3YRe8sP5s3uJqiFlGnXKUko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795005740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zxr2lXP/CQxcFyWePtNcp3//xZZmywzEeiRPGK/G+Zk=;
	b=fs4EkGCO5gReP1kRv9xzVB58cwcbZxoDYB7FEACvJO8hRVRZLYZJpGsRU/LlcVdy+MnOBB
	loqiJehdrJiiwaAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795005739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zxr2lXP/CQxcFyWePtNcp3//xZZmywzEeiRPGK/G+Zk=;
	b=JsWww/C/hV64W+IlpznLL826hSFmFuT/xnAcz3EU0b+YXigcqWvp+dFKu6zPKAtJZarxvC
	NA5ym4Cj+/1nKTthGZ7I/CRpqhf3oAzh9ejc+g6yvP/K1UFHAFbHSl2XcjmJxV2cGM/jxO
	TUC8ZMnXAUIQg65blCja2JUwFSRo/7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795005739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zxr2lXP/CQxcFyWePtNcp3//xZZmywzEeiRPGK/G+Zk=;
	b=+kpswuRNhYjKe9Bxv5ZhFEJ0SEZF3c2Kl0yGxy7YvIgF6eGrGT0F5KJ7nbXJOUvIlqQwgx
	HHoj8aZDKjVqDADQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD602134E9;
	Wed, 18 Nov 2026 12:42:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wu0wIiud/WpjTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 12:42:19 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 4253925042; Wed, 18 Nov 2026 13:42:19 +0100 (CET)
Date: Wed, 18 Nov 2026 13:42:19 +0100
From: Jan Kara <jack@suse.cz>
To: Haoli Zhang <26031212468@stu.xidian.edu.cn>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+3fbf2337de43f5581aec@syzkaller.appspotmail.com, Jinning Zhang <25031212117@stu.xidian.edu.cn>, 
	Bin Yu <byu@xidian.edu.cn>
Subject: Re: [PATCH] ext4: validate in-inode xattrs before listing
Message-ID: <l7j46abepbwlpvsnpjhuws4wb4c2g7d4x6b5pjgoegkafisgc7@fkg673q7kt4p>
References: <20261117090147.3950327-1-26031212468@stu.xidian.edu.cn>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117090147.3950327-1-26031212468@stu.xidian.edu.cn>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[3fbf2337de43f5581aec];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,syzkaller.appspotmail.com,stu.xidian.edu.cn,xidian.edu.cn];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30

On Tue 17-11-26 17:01:47, Haoli Zhang wrote:
> ext4_iget() validates in-inode xattrs when it reads an inode. However,
> ext4_xattr_ibody_list() fetches the inode-table data again with
> ext4_get_inode_loc() and passes the entries to ext4_xattr_list_entries()
> without validating this read. If the re-read data contains a malformed
> xattr entry, the listing loop can advance beyond the valid in-inode xattr
> area and read invalid memory.
> 
> Validate the in-inode xattrs from this read with xattr_check_inode()
> before listing them. If validation fails, skip the listing and return the
> error after releasing the inode-table buffer.
> 
> Reported-by: syzbot+3fbf2337de43f5581aec@syzkaller.appspotmail.com
> Closes: https://syzbot.org/bug?extid=3fbf2337de43f5581aec
> Co-developed-by: Jinning Zhang <25031212117@stu.xidian.edu.cn>
> Signed-off-by: Jinning Zhang <25031212117@stu.xidian.edu.cn>
> Co-developed-by: Bin Yu <byu@xidian.edu.cn>
> Signed-off-by: Bin Yu <byu@xidian.edu.cn>
> Signed-off-by: Haoli Zhang <26031212468@stu.xidian.edu.cn>

So it is an interesting observation that although in-inode xattrs were
verified during iget(), the bh backing the inode can be evicted from memory
after iget() and reread from disk (with possibly new content if someone is
corrupting underlying storage). The problem isn't really very serious but
it would be kind of nice to fix. However there are many places that use
in-inode xattr space without verifying it, not just ext4_listxattr(), and
verifying in all of them will get expensive and likely cause performance
regression and in practice, the bh is very rarely reread from the disk.

I've been thinking for a while about possible fixes but either they get
complex, cost quite some memory, or cost runtime performance so for now I'm
inclined to declare such type of malicious media not really worth fixing.

								Honza

> ---
>  fs/ext4/xattr.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -790,9 +790,11 @@
>  		return error;
>  	raw_inode = ext4_raw_inode(&iloc);
>  	header = IHDR(inode, raw_inode);
> -	error = ext4_xattr_list_entries(dentry, IFIRST(header),
> -					buffer, buffer_size);
> +	error = xattr_check_inode(inode, header, ITAIL(inode, raw_inode));
> +	if (!error)
> +		error = ext4_xattr_list_entries(dentry, IFIRST(header),
> +						buffer, buffer_size);
>  
>  	brelse(iloc.bh);
>  	return error;
>  }
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0AF42122F;
	Tue, 22 Sep 2026 11:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790078303; cv=none; b=lDfbp6Ms3JrLEHVJofko9e++aJlvT8CQqY1/8wR5tJXguXPoEdNISJD13KmAI9ep9g/GyV7gg1rDU4jlKZxkL+TB+Hb/r2ddNhkObpTfYwA1enZ8/H4uByZoN7NjGNROGeGulII5Kvsfk13QmCgUmZhCdJSFZ1xK0KhPKbOEIT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790078303; c=relaxed/simple;
	bh=GDo5LJBS7xr75sAXB31mb8fbAN0e3qyr1eJ+dEUudBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xoa8z3OHYy2RHGEuiqFK66KLJnCRszpOPlAhZdmXbmo6zUj5JulsdukALw+/ZpdKOql4dhh2+c93qZ175ieiL9GxjfZQesOJdeXwGmnKoW5OApz657JED8IXiEne7add0TvDcTTkd0cHqwsdrc0p/O79g+hOGN9gGVLw5thcvkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gazFT6eY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zWCSQ9yM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cMOiS9+R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MFkt+T3/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gazFT6eY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zWCSQ9yM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cMOiS9+R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MFkt+T3/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 582751F8BB;
	Tue, 22 Sep 2026 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790078294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY8zp3Um8ldVBJiScx9k+ZqUxftcrdn4zEKGLR24oO0=;
	b=gazFT6eY13Mktjea8t6HM5a4SvQjeV6lOHma/4K/R/ZFwIfhz3ZAyuWYyvaPknMeUScZF+
	lqB8wQCGUpzS4VOyHBI1ecpj+JHlop0iE/fIFeHyUv3klpb7CzJkInh85gGVXA++Mh6Js5
	iljlt/xU5V+Ef92ZJUkD4V6V7gvKPgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790078294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY8zp3Um8ldVBJiScx9k+ZqUxftcrdn4zEKGLR24oO0=;
	b=zWCSQ9yMb8y6mLbUr2/cBizsUF9mPWCnPDfllS7SrVmnBJGK7kbATORkpLIyrCUXjjBteY
	pfVp7DcchsmednCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cMOiS9+R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="MFkt+T3/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790078290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY8zp3Um8ldVBJiScx9k+ZqUxftcrdn4zEKGLR24oO0=;
	b=cMOiS9+RwzmVOKWc9qNCrjflKetvpYcuFhb4CqsQVskyr7iLKgcyvHtm+tzQw4//fWa8V8
	77bKGmjhPP7IovphrATm9qvlnSK1kFjfW73ctVoOKKua/i8CkJHzH4PFZys/QlPrx4imo9
	xpL7eStPjOyiXh9+Z3Wzm/jmglStc5k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790078290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YY8zp3Um8ldVBJiScx9k+ZqUxftcrdn4zEKGLR24oO0=;
	b=MFkt+T3/1Y8X21Exqc3tyExQ0YsfZs299hCHyCrdSI9ATPNpgIA6tWx+8bYUh850iu85FM
	BoNh4WaxKrcOMGAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B396132D3;
	Tue, 22 Sep 2026 11:58:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OwJ4AlJtsmqODwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Sep 2026 11:58:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ACEEEA13D4; Tue, 22 Sep 2026 13:58:09 +0200 (CEST)
Date: Tue, 22 Sep 2026 13:58:09 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hughd@google.com, 
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz, ziy@nvidia.com, 
	bfoster@redhat.com, joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 4/4] mm/truncate: clarify return value of
 truncate_inode_partial_folio()
Message-ID: <5pthbyxtn7q6xi4fmkofvksmcjzfnujcw2g4fxmxjzfin5pbgf@zui3vcimb4cv>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-5-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922110703.468389-5-yi.zhang@huaweicloud.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 582751F8BB
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[27];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kvack.org,vger.kernel.org,linux-foundation.org,kernel.org,infradead.org,google.com,suse.com,linux.alibaba.com,suse.cz,nvidia.com,redhat.com,gmail.com,huawei.com,fnnas.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	R_RATELIMIT(0.00)[to_ip_from(RL77qb5igscudnz1iomstzbaxb)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,huawei.com:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Tue 22-09-26 19:07:03, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> With the earlier rework the callers no longer rely on the return value
> of truncate_inode_partial_folio() to decide whether to adjust the
> truncation range. The pstart/pend out-parameters carry that information
> instead. The callers now only use the return value as a flag indicating
> whether the loop should be reset to pick up newly split sub-folios on
> the shmem path.
> 
> Return true if at least one split succeeded, and false otherwise.
> This clarifies the existing confusing return value semantics.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just as I'm checking the only use of the return value of
truncate_inode_partial_folio() in shmem_undo_range(), the code there looks
fishy. It does:

        } else if (truncate_inode_partial_folio(folio, lstart, lend)) {
                /*
                 * If we split a page, reset the loop so
                 * that we pick up the new sub pages.
                 * Otherwise the THP was entirely
                 * dropped or the target range was
                 * zeroed, so just continue the loop as
                 * is.
                 */
                if (!folio_test_large(folio)) {
                        folio_unlock(folio);
                        index = start;
                        break;
                }
        }

However if folio was say order-2 (4 pages), lstart is inside the 3rd page,
then the split done by truncate_inode_partial_folio() can result in order-1
folio, and two order-0 folios. Hence the !folio_test_large(folio) check
fails and we won't pickup the new smaller folios so that we can free the
4th one... So I think we need to unconditionally reset the loop if
truncate_inode_partial_folio() returned true.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

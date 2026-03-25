Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE16E3CE48C
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 19:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774465311; cv=none; b=JnS1xbu0mozwZ2kMEogyK6wW/QD+xgHrfVMtSNMkPJCPpGorqrETkPhXBJGC8FbsQf/iHeYHrnr+AHbRgPE+kPCoz1BGJy6lY+wz+shPs9r2MOP3T3l8MJcYobIj8r5F2ZfyC+5lnpYcwAG/2L6PMnye8C2NYTWAtmv035Iriwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774465311; c=relaxed/simple;
	bh=3nJ0jfYwZJIm247GGH8x3z4DRlRNhGDwap3P0GMwEyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Raf/YPycnJXpk3dsPxdIy2v2NQ0YeYZrjSD2PgQxBMCF/WGCWsD73d/WUp+sW9ugwKBvToFrW3VlronlkwIS+VtWPa39aunubrl5wRnNru9f+JLzEPnkqVGs8EO/igyl4Uq9noMPlKAqJ9040HoJIyMx8DutM1xv0Zey6pL1QZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZqfbS5nR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jaay/3zL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZqfbS5nR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jaay/3zL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZqfbS5nR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jaay/3zL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZqfbS5nR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jaay/3zL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D19024D255;
	Wed, 25 Mar 2026 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774465307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9vPzHvujrmlL6/Ao060FToJBZOtkxBhOjJhl9zBg20=;
	b=ZqfbS5nRqIQN7ASSl0tgAsD9CEkLOQnUb+PvE0wNdq7++pSuVvlHaBk/4UeTmCnWh19tK0
	n8rv1ktVgAAw84Ui2Z68XWP06mU5rM5jKROPenQ7i3uvlRNdC5SmobEqu0rVnZQhiAD4yX
	3l1P3LNgAvruQzq7zRPOer5Zqovau/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774465307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9vPzHvujrmlL6/Ao060FToJBZOtkxBhOjJhl9zBg20=;
	b=Jaay/3zLY0xMJOls20zL1o8DHuoGtyADynyPTsvFa6whl3AX7CVlkqhmwD27FiV38Fwn37
	ALx0zRt9HkZiExAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774465307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9vPzHvujrmlL6/Ao060FToJBZOtkxBhOjJhl9zBg20=;
	b=ZqfbS5nRqIQN7ASSl0tgAsD9CEkLOQnUb+PvE0wNdq7++pSuVvlHaBk/4UeTmCnWh19tK0
	n8rv1ktVgAAw84Ui2Z68XWP06mU5rM5jKROPenQ7i3uvlRNdC5SmobEqu0rVnZQhiAD4yX
	3l1P3LNgAvruQzq7zRPOer5Zqovau/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774465307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9vPzHvujrmlL6/Ao060FToJBZOtkxBhOjJhl9zBg20=;
	b=Jaay/3zLY0xMJOls20zL1o8DHuoGtyADynyPTsvFa6whl3AX7CVlkqhmwD27FiV38Fwn37
	ALx0zRt9HkZiExAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4AAC44559;
	Wed, 25 Mar 2026 19:01:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ogYUMBsxxGnNYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Mar 2026 19:01:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8655FA085A; Wed, 25 Mar 2026 20:01:39 +0100 (CET)
Date: Wed, 25 Mar 2026 20:01:39 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <dqvxks5tdwgcumkucwmrz7ides6li4cjeyglghdidhljeq3sax@6kukcgubwx6d>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
 <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
 <acKO3NRw852FdGUO@infradead.org>
 <rsftk7gdlamfryksv63vhmewdi6etvvfyi6as5m2zs75ctvzkq@fnoiwumyfdsv>
 <acKzrqjnKFNK0xmh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acKzrqjnKFNK0xmh@infradead.org>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO

On Tue 24-03-26 08:54:22, Christoph Hellwig wrote:
> On Tue, Mar 24, 2026 at 02:36:53PM +0100, Jan Kara wrote:
> > Leaving the two implementations separate certainly works for me as well
> > (that's why I've put that patch to the end because I've expected some
> > discussions around it :)). Just the amount of common trivial calls you need
> > to do (fdatawrite(), sync_inode_metadata(),
> > file_check_and_advance_wb_err(), blkdev_issue_flush()) looked high enough
> > to me to be worth merging the implementations. But I don't feel strongly
> > either way.
> 
> I don't really feel either way, and I really should not micro-manage
> the series either.  So go for what you think works best.  The important
> part is to have the fsync changes early and to avoid hardcoding
> buffer_head knowledge into libfs.c.

After trying with the callback and not liking it too much in the end I've
just decided to stay with two separate implementations.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

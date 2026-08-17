Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9173EDE4D;
	Mon, 17 Aug 2026 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786982781; cv=none; b=MQBH7/jo4a6FuNVCtiblGNymwcIhL0v7Ucw0BcotcrM9NovkZP6EeNVkjq20RcN6bQWuIzGKvv/9eqouKRMl10PeorbO7iawH4cPRoD2XUyqrmBfLgj7ARf1JFjixXNxb6NnbQfR1/7/MCn8VEc/xwEuU65It1QmZ8XZJgOr+OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786982781; c=relaxed/simple;
	bh=47AAx90Y9DFp4Kta1KXb6pcXj+fSI1lJo1UIbg3QN00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNgzFtRdf1xqA43ONJoFJnLNp8QMktxCwq2cJUx9dYbm2aZzOOv0o7fWuag9jzMpws+sgbJfj9MC6smAxRor3NG6UaSuA80qmmcVJAdP+05JdaSxpqFr1Tybf9QqqRLTl278qVtvjDhZJ3ARSFNoLFo4c3Py83RiX0h+hM0Ngdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pfIwpZ/l; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oYqCsY0f; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LS+hq8ai; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2wcUIzNg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pfIwpZ/l";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oYqCsY0f";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LS+hq8ai";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2wcUIzNg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 501023E07;
	Mon, 17 Aug 2026 16:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786982752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IdHfgSBKSquB8V6IowtQrG36ItNZXmsNtihCQ+cIFVM=;
	b=pfIwpZ/lOzNN25aQjyyb+4sNKfyLyXpVR5tuvjjXevDVv46HYdYayaxzeDeApjfGSMQAgt
	Eq9ol6/EqdRIpIOrMACEqz6TLGBC1ZA+DDMQS++ECCokw8Z8A5P5CLZ0wkuyxuqcRZVimz
	xGkyfCBM+7u+wLmNpqd68865EPQzmk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786982752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IdHfgSBKSquB8V6IowtQrG36ItNZXmsNtihCQ+cIFVM=;
	b=oYqCsY0fxrAQiZUQq940MOBvgSs5DyCZd1VXyqW4yWiZZ4fJ3D+eLguuCqRbtQH3Ucss44
	XYpiTe0xDwcEqkDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786982748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IdHfgSBKSquB8V6IowtQrG36ItNZXmsNtihCQ+cIFVM=;
	b=LS+hq8aiqOz2ssG/ZFeEtA2SZtr4s9xjuSxY9yCR6lVLhJReTeYp2dc8/RNg4HdGYgVnru
	i44Ld1OikzrAkiryXqUsmwO0asEvzHNnSoz9dL+/FT1CgLCX2L98+jFhMJv0x7sVLBeytj
	L5n/a0MvQLJ7aNVMFortSL/8H3XwUAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786982748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IdHfgSBKSquB8V6IowtQrG36ItNZXmsNtihCQ+cIFVM=;
	b=2wcUIzNgD9L3dFK0weGMjnSC1XpUHjAmfl/IsDvYTRWcwCZU2LLWsahkCKZG2Fq2VPbEgV
	lDf+XCqTxMocjZBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47E357954D;
	Mon, 17 Aug 2026 16:05:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bCOLEVwxg2r1YwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Aug 2026 16:05:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E7DA5A13B5; Mon, 17 Aug 2026 18:05:47 +0200 (CEST)
Date: Mon, 17 Aug 2026 18:05:47 +0200
From: Jan Kara <jack@suse.cz>
To: Askar Safin <safinaskar@gmail.com>
Cc: jack@suse.cz, aivazian.tigran@gmail.com, brauner@kernel.org, 
	hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	tytso@mit.edu
Subject: Re: [PATCH v5 0/20] fs: Fix missed inode write during fsync
Message-ID: <jckkvo72sng2r33ryty4yuduky6vl2plvsqim3fyqflp4vepwy@shqhgmis5pjr>
References: <20260727101509.21667-1-jack@suse.cz>
 <20260809153619.1888764-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809153619.1888764-1-safinaskar@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,gmail.com,kernel.org,mail.parknet.co.jp,vger.kernel.org,mit.edu];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Sun 09-08-26 18:36:19, Askar Safin wrote:
> Jan Kara <jack@suse.cz>:
> > The series strives to make sure sync_inode_metadata() ->
> > writeback_single_inode() will end up to properly persisting not only the inode
> > but also all metadata associated with the inode.  This is beneficial for
> > several reasons:
> 
> It is well known that if one just created a file and wants to properly
> persist it, they should not only call fsync on it, but also on its
> parent directory.

Yes.

> Is it true that after your patchset this will not be needed anymore?

No. This patch set only makes sure the inode itself and metadata such as
indirect blocks etc. properly make it to the disk on fsync(2) and similar
events which wasn't the case before for some filesystems.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

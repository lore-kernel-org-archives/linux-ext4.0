Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C433EFD2D
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2026 11:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784545359; cv=none; b=iQDgzLxWrvJZmQqyoyWJB3SsEm5/a0lgdcGabn4ePBez0Bl7tNtXSnQRgBpX1sp0XsYBhWIIoExfa7XhybCWBXji93L6iRsGZT6X40X5gUp1ZpnblSoz1KD79QtPLa3w2zlZG6w+JvK5saFNG53YAkrgaI4JljAYeDP/4aK2PK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784545359; c=relaxed/simple;
	bh=KZtKkBdxdhhxVAYZ/+jsniC0UjdRvcSsYyORgs33LnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YE8Lsw1XHz0/TxfxBsaKoLg9O2kq8XBcnK1/fFbb17G+i9ollivM7oyiSkStcY9Uf3NfpjA6AS1w9o+FAuv4MMjzAVK3o8ek2qY8my6nyn1G7T9JytGXQ6MXr4E52HOhqNqL5X8vKXp6T7zPi0XUsA/ROG5CaFxzzdmde6TpmpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a7qlSHkB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mdiCEdAB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SYPCh4W/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Vd6mEVVO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a7qlSHkB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mdiCEdAB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SYPCh4W/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Vd6mEVVO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ED28E79EF6;
	Mon, 20 Jul 2026 11:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784545356;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QNvKujcEHJaP+CioAP0IMjfRWn5fi/vRa+eOghQmfk=;
	b=a7qlSHkBZSGAhww/XKsyTjzhnNPL0dmZCt8geb7JXcTWaL5DH/AqIjPqYqU5jBQ7DeaqHK
	G1eQWwkRJGSiGvC7KixQvhkSddx5aMjJNylVBQ+4nKep0HsCVhnI1Y63RIFNBSKBg25vH0
	GI8tq6Jc9UDoKqPSHfKh0x6vuErS77I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784545356;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QNvKujcEHJaP+CioAP0IMjfRWn5fi/vRa+eOghQmfk=;
	b=mdiCEdABkidr3CU4n+sx7C9aiItHMfZE5xcZL3RtuffiZ18qVqO6peBEh9OvC8m9L9hqkK
	swnHQ0VVjVv0pbDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784545354;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QNvKujcEHJaP+CioAP0IMjfRWn5fi/vRa+eOghQmfk=;
	b=SYPCh4W/VpU+ZdjNU8cHR9FCfFVxGssnHP6eZ6Nm2GhncK6aa2rElmHy4jvkF9FVL23nPG
	VjWFQhy9NBNCFUdxqqA3zwkdcEiqmsDxmW6uSuh5pzMZ5NQFk69GZ1aaRDuYAKOZltndJn
	cEs6Ysr53PB8XwQPeC2EBUSS5NIO9Tc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784545354;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2QNvKujcEHJaP+CioAP0IMjfRWn5fi/vRa+eOghQmfk=;
	b=Vd6mEVVOi+NEoFqqHHCJJVlts/tYAiD1noX9A0RGcec9sCUr8nFy12rKuBNkRLiZcGG0Ey
	QWh5zWS1hl+3wNAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CAC10779AA;
	Mon, 20 Jul 2026 11:02:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HrzGMEoAXmqhAQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 20 Jul 2026 11:02:34 +0000
Date: Mon, 20 Jul 2026 13:02:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v11 03/20] fsverity: pass digest size and hash of the
 all-zeroes block to ->write
Message-ID: <20260720110233.GD10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260710085256.3464201-1-aalbersh@kernel.org>
 <20260710085256.3464201-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710085256.3464201-4-aalbersh@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.977];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.com:email,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Fri, Jul 10, 2026 at 10:52:31AM +0200, Andrey Albershteyn wrote:
> Let filesystem iterate over hashes in the block and check if these are
> hashes of zeroed data blocks. XFS will use this to decide if it want to
> store tree block full of these hashes.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> ---

For the API update in

>  fs/btrfs/verity.c        | 6 +++++-

Acked-by: David Sterba <dsterba@suse.com>

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1328C19D07E
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 19:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785265652; cv=none; b=Cqqe4uNAzdKLAwELgjnOk8N3aRxYPr3sfVAnfAhQFFWTF5o9o8JpUALXorJDQwfxO07B0i4b426cMzPiVRanjxdmNfVvhuucWdghQmMWm5dLdqET7p4Gr6O8ytkIbMwqMMeZllknO+WR5qaT20mu68i+TOZc/DSBWX1ClCHhRh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785265652; c=relaxed/simple;
	bh=rZNQ5+WtnZElMn8XGTOE22PyzRXgToAAQyHEQL3TpHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rq1ENsbu7xxy3Tq5k80AcG9UCp7WuTb85enqjHkDqh4B31mGYDxeZ2uuFR1yUij5lUjLvx8Vy/BOwEbvcc415DwfuTtXcQxIg91/SIVgdOSaTXRLx2X7hEb5mux1HIewmXzriZsEu73BUldjYI8bu6dotyUY6VRyE1uoPiSDppQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zFRkiFc+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mvLNBWKq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HIQCj3ZQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rDQYPrS9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zFRkiFc+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mvLNBWKq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HIQCj3ZQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rDQYPrS9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 90B833E00;
	Tue, 28 Jul 2026 19:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785265643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X7c9D+94r07zu2WgoQz3Oc/B0WNYxXmmFS5oXNEe5gM=;
	b=zFRkiFc+3rJQQhdK3wv5P8V/4Sd1UEm8aX4VHX1cta6VKCUFI8HPf2BqJNcNqNwd0+sMxS
	bhKsfN8VWXLbZMy9aGXAQtQ+H2g23la7OF9dz/68JN8r0KM0oGr93GPuBbF7g/GaLkp1M9
	5jyAXrQo/dSgCaYPjMMHfaXvaxXpGfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785265643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X7c9D+94r07zu2WgoQz3Oc/B0WNYxXmmFS5oXNEe5gM=;
	b=mvLNBWKqTvrqbCiluscb2ZgVv8UGybonMmzQe32GIRNnLI3aRxjmajdKPRbA6vLsqzA5Oo
	cCxZz7y+NBsFC5AQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785265639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X7c9D+94r07zu2WgoQz3Oc/B0WNYxXmmFS5oXNEe5gM=;
	b=HIQCj3ZQaBUCrbYU6cszD0M78PcsYphBzHF0B5tmJuin6IATFTc22t2o1o88TE92Bjb1Yv
	fP0aXqR0dYlC4rVPMCFfYdBef4apWPfP++orOE34tfZLtwHQuUWB6mAUlWABMtzoguMDtj
	OdUhDwlF9wj8hscDRi2ObBYFJMM0e14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785265639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X7c9D+94r07zu2WgoQz3Oc/B0WNYxXmmFS5oXNEe5gM=;
	b=rDQYPrS9Ngdfsour1S5xBP8ncLhZGWwWH8y3e2EgOjNk6glPBD+nI10iqRZlEPYs4sWJW0
	yn0JYCy3INDn9TBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82DF5779B3;
	Tue, 28 Jul 2026 19:07:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gTF8H+f9aGqvIAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Jul 2026 19:07:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 209A9A10B6; Tue, 28 Jul 2026 21:07:19 +0200 (CEST)
Date: Tue, 28 Jul 2026 21:07:19 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH v5 0/20] fs: Fix missed inode write during fsync
Message-ID: <caghofkfjzzzekirepthhytjm3hnnxxqm26gbh3vqlyepk6fpf@7im24ygj3ej6>
References: <20260727101509.21667-1-jack@suse.cz>
 <20260727-wallung-umzingeln-fuhren-749ee08538cf@brauner>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-wallung-umzingeln-fuhren-749ee08538cf@brauner>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,gmail.com,mit.edu,mail.parknet.co.jp];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Mon 27-07-26 17:51:56, Christian Brauner wrote:
> On Mon, 27 Jul 2026 12:49:18 +0200, Jan Kara wrote:
> > fs: Fix missed inode write during fsync
> > 
> > Hello,
> > 
> > here is v5 of the patch series which fixes the possibly missing inode write
> > during fsync(2) for filesystems using generic metadata bh tracking. This
> > revision contains mostly small fixes and improvements since v3, neither
> > Sashiko nor Christian found fundamental issues with this approach.
> > 
> > [...]
> 
> I've put three patches on top of vfs-7.3.sync that fix Sashiko reported
> bugs. @Jan, please take a look. If that looks fine to you I can fold
> them down.

Thanks! I went through all the Sashiko comments and the (now 4) patches you
have on top are the only issues I have found valid among Sashiko reviews as
well. The fixes look good, thanks for writing them! Feel free to fold them
or leave them at the end of the series whatever is more convenient for you.

								Honza

> 
> ---
> 
> Applied to the vfs-7.3.sync branch of the vfs/vfs.git tree.
> Patches in the vfs-7.3.sync branch should appear in linux-next soon.
> 
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
> 
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
> 
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs-7.3.sync
> 
> [01/20] affs: Drop support for metadata bh tracking
>         https://git.kernel.org/vfs/vfs/c/b637f52f2f26
> [02/20] fs: Fix possible UAF in mark_buffer_write_io_error()
>         https://git.kernel.org/vfs/vfs/c/b0bca4e95b03
> [03/20] fs: Fix missed inode writeback when racing with __writeback_single_inode
>         https://git.kernel.org/vfs/vfs/c/5a499dad2c79
> [04/20] ext4: Allocate mapping_metadata_bhs struct on demand
>         https://git.kernel.org/vfs/vfs/c/daca0f43a934
> [05/20] fs: Provide way for filesystem to wait for metadata writeback
>         https://git.kernel.org/vfs/vfs/c/c474bc56b6d1
> [06/20] ext2: Fix lost inode updates for IS_SYNC inodes
>         https://git.kernel.org/vfs/vfs/c/356984d1a5c3
> [07/20] ext2: Drop __ext2_write_inode()
>         https://git.kernel.org/vfs/vfs/c/4efd6a43a92f
> [08/20] ext2: Avoid unnecessary inode buffer writeback for sync(2)
>         https://git.kernel.org/vfs/vfs/c/74d4faaa76b8
> [09/20] ext2: Fix data integrity writeout issues
>         https://git.kernel.org/vfs/vfs/c/917e583992e5
> [10/20] udf: Fix data integrity writeout issues
>         https://git.kernel.org/vfs/vfs/c/1ec98214ccf0
> [11/20] udf: Use sync_inode_metadata() to writeout IS_SYNC inode
>         https://git.kernel.org/vfs/vfs/c/061d83911da5
> [12/20] udf: Drop udf_sync_inode()
>         https://git.kernel.org/vfs/vfs/c/c87c0098cf61
> [13/20] udf: Use sync_inode_metadata() in udf_evict_inode()
>         https://git.kernel.org/vfs/vfs/c/e0e30479c756
> [14/20] udf: Fold udf_update_inode() into udf_write_inode()
>         https://git.kernel.org/vfs/vfs/c/5b2e45c33565
> [15/20] bfs: Fix data integrity writeout issues
>         https://git.kernel.org/vfs/vfs/c/0cee81a3fd9f
> [16/20] minix: Fix data integrity writeout issues
>         https://git.kernel.org/vfs/vfs/c/84af7c3b3462
> [17/20] ext4: Fix data integrity writeout issues in nojournal mode
>         https://git.kernel.org/vfs/vfs/c/c26339e1df33
> [18/20] fat: Fix missed inode writeback during fsync(2)
>         https://git.kernel.org/vfs/vfs/c/525da4f40a7c
> [19/20] fat: Replace fat_sync_inode() with sync_inode_metadata()
>         https://git.kernel.org/vfs/vfs/c/e668e0668181
> [20/20] vfs: Remove mmb_fsync()
>         https://git.kernel.org/vfs/vfs/c/dc78399717c4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D82A315785
	for <linux-ext4@vger.kernel.org>; Wed,  3 Jun 2026 13:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780494119; cv=none; b=Na8E4iwZQKKForDLCyl7JXEKygUalSgE7z9F3aAdho+5yYYIHJLOLrnYXAu9+XsG59oqOBiEVD4mJ16ld73j5Mh6f8NZMvwTNFXIm1ToC9OC/6vYYfU8G+QrR7MYknbjlURHLGDq72sVu6A6US7WTp2BES0B0HLnfGZ4r+ZBUcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780494119; c=relaxed/simple;
	bh=TIovWOzztPXz//n5jR16uz3sHaYtHYwL7xq7etY9iKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a3DswIq05Gjym7Z0TiNJyEmdasYF+lp+XulvazqtIPdOpRFwvHG+QKkFwJsGPRWgbnNUygrniNbMPANjagL2r9L1TkAW933nEUd7ZuoAFlOSDd3WFMwjQjfG8y1iH8LOw5iQWNKh+8s2wFJcCk28ZjERsMF+9dkRcxDruXHLpJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=lIQyG3gZ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="lIQyG3gZ"
Received: from macsyma.thunk.org ([104.135.218.91])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 653DfjeW021765
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 3 Jun 2026 09:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780494108; bh=ISe3vSQ7x+rSaAji0WYQTn2PUhL/EfMn/sIwN9sEa/U=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=lIQyG3gZ7HUaMx/TzNAnN0+X2qP1tRaxMExhreH7KhCfG6u779gls56jNrHPFkk//
	 pTzr3RhNeoxE8cHWw7JuUisXHFvLrZKURm/yHQZYOR9MYKcO0L+wJstz3wSm293rGf
	 xniVESai/r+A3pfj87CeSDgR7KoZgYtHBwIbbxypENJIvEy9gc1gDg119tPW/dWZ69
	 dKqpWeEB7jVL/Yr+vPfZyTkE6tQIU99g1ks0/ibmeDn0xsEzSW600pIU7CTfox8nFm
	 L4ciQr9z73uvQT6BhSKWYVXjeI4mokQMVXIBUGSXhsCFrwEiBL7Mwt7zi8zBM178MY
	 +QyvRx5XqKgyA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A98D335D692; Wed,  3 Jun 2026 09:41:45 -0400 (EDT)
Date: Wed, 3 Jun 2026 09:41:45 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        aivazian.tigran@gmail.com, linux-ext4@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH v2 09/10] ext4: Use mmb infrastructure for inode buffer
 writeout
Message-ID: <xty6yt6f6nmclyz4sroxi2l27zvgqtuztr2crawdhyv7kdkmtb@pjscafixv2pc>
References: <20260525085035.12891-1-jack@suse.cz>
 <20260525085821.769119-19-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525085821.769119-19-jack@suse.cz>

On Mon, May 25, 2026 at 10:58:15AM +0200, Jan Kara wrote:
> Use mmb inode buffer writeout infrastructure to reliably write out
> inode's inode table block on fsync(2) in nojournal mode (from
> ext4_sync_parent() and ext4_fsync_nojournal()). This significantly
> simplifies the code as we don't have to explicitely handle inode buffer
> writeback in ext4_write_inode() and thus we can also remove
> sync_inode_metadata() calls from ext4_sync_parent() and
> ext4_write_inode() call from ext4_fsync_nojournal().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Theodore Ts'o <tytso@mit.edu>

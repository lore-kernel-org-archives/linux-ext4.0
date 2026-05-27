Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2DB3E6386;
	Wed, 27 May 2026 11:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779882875; cv=none; b=TWi8oKxtLx8SHeA1jcNSd1qFWJSbxHcSRRRhNk7dJadiEUQcSsaJzDSl680kIWWjAFEQPWJng5zO+ePKR2VTVUZkxJ4gyGCdGAF8W4EeU18NWq6cc0Oz0AGhYh6mkiZWI5DYgpWWRZViP1v8o7nSbBb2/XiuPjj0fQcfX8Bqhuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779882875; c=relaxed/simple;
	bh=Nl0EYgk5/10RYVtACiA4b9l0U6rJwQ9vSzs3AzvYcuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=arUIAVaJhmaHSoON91M/O9lcjh3PjYl+HtsF98Ne2lCJ9FxjErCL5iJ8axOfFTOmxOm3DRnWzOe5NQ9xLZG8SjZET/nvTOAEfqgrD1sAUS7qFB9jI5GLPPhO83Omw4MsDDF6ulJLJp/gW15CWS19AM6BRkLdYPV9FDIBm5er/1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnPBwV5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnPBwV5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EED1F000E9;
	Wed, 27 May 2026 11:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779882873;
	bh=ALlnSlvl47j3SgF33C5oc5PJByTXH/SdGyN7p0a61yM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lnPBwV5I3kgCbtjfzRT6ATYuRRCjcunb78BufJNUBTnxXnQX3Cx5qwkKlCyTxMV/5
	 ahWcmLrpHiSD5mCLP8zoqch3i1FBbry45LOPhi6TwB9nZasjUGfjflqkculUEDHYKe
	 DJGO8shtoZdUaBcxVk+0fS8cpCINWdp+QPtbYiO5RTN1e/Za8swPsmrP4IOoN1kNiI
	 IIZyIjyE1cDa4QPkSsS0RPTyi9fEKBEqed0mTGGbuRbwvUiQV8TZy4m5UBdjiDIHdG
	 OONUzpduFIgBV4OstCphSeo8ohGcKA9yN55NgLBC5jXOskZfzJ16laSljtFa5aU3iG
	 U8Riu5zXOH89g==
Date: Wed, 27 May 2026 13:54:29 +0200
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/8] super: retire sget(), convert iterators to RCU
Message-ID: <20260527-ekstase-auskennen-zyklen-5c256ef34df1@brauner>
References: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260526-work-sget-v1-0-263f7025cedd@kernel.org>

On Tue, May 26, 2026 at 05:09:02PM +0200, Christian Brauner wrote:
> * retire sget(): CIFS plus the two ext4 KUnit tests (extents-test,
> 
> * Walk @super_blocks and @type->fs_supers under RCU, pinned by

Can't work as I originally envisioned.

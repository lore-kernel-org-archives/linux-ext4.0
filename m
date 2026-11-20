Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192978;
	b=yock/gjf6gOvP7fa2AiSjWN9Cd1qforx+lJWwHj6rQP5GzpAOSYYtcdWpD784kZSQqRO
	 fD+DcZ0Wcdq1WPgMHRG2fNo1PkTOeSKIw6u18y7CodumYuWVvmP6uM1MFJOdAfvyiolFw
	 f6513Y3A8Rk2oP/NPtFNJ17GNCZcKBP4tpQIF0yzXtQUfgCkUg8WjCySQUvqVnvXwG30+
	 9slYrhn33xHznzb2JFr5Yk6sMEND2mIvGgi/f3n6sdXAzEwQX6bnbkiqEu8EdwwW5M/Uv
	 BaO/vuaWVYiysO4FwpS9xlpmsch4ILw3h8GH06fxb61RAOeGaaA4e3jI6XgYOnJS5Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192978;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZOol1tUip28IJ9V/fmUhkTzp6PkYAKu/YPqu/uCkA7k=;
	b=npUll5zKqjr98L2GMOd43XJi4ID9E7MAN1t5ath8WyoEc9hwJg+CHd6aYlg5yWmCNGK4
	 w8j2EHBbidxmiLFtnj2Vuc9NampCgHLhckD7ZKnfgQWEp57/H4zd42aXzAoIoiBQ9xKjc
	 pMuy73CnWcTBFBQM9JW8j20pzsuOa9lK1/n/Qt09tjZJbxqzRNtpp/J4oDqrU7BMcB2rf
	 CnLUFpC3HVxyHjQ2JnVOuslJeRtzPFBat3f4JUd5uCc5hinI5cDtrWoWyWQ+ESIEwQiEf
	 4FAUnCcPavfEoW5H0oAznI7Gv5C0OiaFwgBd2NAESxy3yTdO+Lnf+pqpGWlx7JSmqgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=StnGnXdw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC72A606A613;
	Fri, 20 Nov 2026 16:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=StnGnXdw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6FA1F000C4;
	Fri, 20 Nov 2026 16:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795192978;
	bh=ZOol1tUip28IJ9V/fmUhkTzp6PkYAKu/YPqu/uCkA7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=StnGnXdwkQvwHADr6xINhbVMaAmHG9EHSHSAAuZgJvslgz3dsqmoA7a9u+M8RgeYO
	 6l/1LPYhhIGaT0aNwsWn6aK4EEdctlSzVKcq+kDqx/A6yeEUfkbuOaneyxXcQKISgU
	 fHwMIBYqYuT35LU7O58X7uN0Tv8kkv8Qrkvldw3JewiN7NwttgtYDRb1mBKNpzmqZf
	 uBmldC3CXYcVXIECrLPvAqVk85vdNLFdb/AHaEr6oAD9mkFoz2b6A1U45PijUruS2f
	 F0MgBhOlVcd1aAnZYx/2UhpHIrXdRgWLM0zT/HCgH4fZ7sZB2WMPkHwgouF5HRhZqc
	 e6t4Leq6dsUlA==
Date: Fri, 20 Nov 2026 17:42:52 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: fsverity <fsverity@lists.linux.dev>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, dsterba@suse.com, Eric Biggers <ebiggers@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu, chao@kernel.org, jaegeuk@kernel.org, 
	viro@zeniv.linux.org.uk, dsterba@suse.cz
Subject: Re: [PATCH v3 4/7] iomap: use fsverity_is_building() to check for
 fsverity IO
Message-ID: <awB0oPTthwNrm8eT@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-5-aalbersh@kernel.org>
 <sashiko-outbox-225558@kernel.org>
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
In-Reply-To: <sashiko-outbox-225558@kernel.org>

On 2026-11-20 16:21:51, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] iomap: inode-wide fsverity_is_building() check in
>   iomap_writeback_handle_eof()
> - [Low] iomap: missing Fixes trailer for broken fsverity check in
>   writeback
> --
> 
> commit f52ac6dc651e2b12c5452600fd41f0db8111577f
> Author: Andrey Albershteyn <aalbersh@kernel.org>
> 
> > iomap: use fsverity_is_building() to check for fsverity IO
> >
> > Recently, inode gained new I_VERITY_BUILDING flag. This flag indicates
> > that inode is undergoing fsverity metadata construction. Previously, it
> > was indicated by stale iomap flag on the IO, now we can check the inode
> > instead. As fsverity inodes are read-only, the only write IO happening
> > during I_VERITY_BUILDING is fsverity metadata.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> 
> [Severity: Low]
> This fixes the check that read an uninitialized or stale wpc->iomap
> before wpc->ops->writeback_range() mapped the folio.  Should it carry:
> 
>   Fixes: 63e242afa466 ("iomap: introduce IOMAP_F_FSVERITY and teach writeback to handle fsverity")

This is not really a fix for that commit, I don't think Fixes: is
necessary here.

> 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index d6e2f1ded5ca6..4fb4136908ec5 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -1930,7 +1930,7 @@ static bool iomap_writeback_handle_eof(struct folio *folio,
> >  	struct inode *inode = wpc->inode;
> >  	u64 isize = i_size_read(inode);
> >  
> > -	if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
> > +	if (fsverity_is_building(inode)) {
> >  		WARN_ON_ONCE(folio_pos(folio) < isize);
> >  		return true;
> >  	}
> 
> [Severity: Medium]
> Can writeback of a dirty data folio while I_VERITY_BUILDING is set hit
> this WARN_ON_ONCE() and skip post-EOF tail zeroing?
> 
> enable_verity() sets I_VERITY_BUILDING without flushing pre-existing
> dirty data folios in inode->i_mapping, and filesystems write back both
> dirty data and verity metadata folios while I_VERITY_BUILDING is still
> set (either during background writeback or in ->end_enable_verity()).
> Because fsverity_is_building(inode) is an inode-wide flag checked before
> comparing the folio offset against isize, any dirty regular data folio
> written back during verity construction triggers WARN_ON_ONCE(folio_pos(folio) < isize),
> and a dirty data folio straddling isize returns early without running
> folio_zero_segment() or clamping *end_pos to isize.
> 
> Should the fsverity_is_building(inode) exemption apply only when the
> folio lies entirely at or beyond isize?

I think this warning is better to be fired for data folios in
writeback while fsverity is being enabled. The only user of this, so
far, would be XFS. XFS will flush data folios before starting to
write fsverity metadata. Ext4 doesn't flush data folios before
starting the build, but I think it make sense to have data on disk
before starting merkle tree build.

-- 
- Andrey

Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D143431E6
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 02:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790128927; cv=none; b=MqlGaOvw8Gie3LHSnEGvVeN0hp6ia/MAiV8DMmpb8+4Cp8KLf97CSwZRVLpBNWLU6YGRnvORv7E1pfHUyOjTzpYwmaPZDlgIutWW2UJvrgEMOWWu9EP8zDi+kWpbCaW6EIvkMyEtJer2RBwdSOFFNtIopeQz5RfpR3luTash0wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790128927; c=relaxed/simple;
	bh=Gvr2sk34nyPj7tWKULFWAbQNfvwxogxejf2EIQ4gyCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GoSsY5LVl3wyzo2fCCZeNeOUNCWNay+/QgVrAgjZEs9zjSP02OPe8176I+dVaGJRk+4nY2CO1A3MxBelp7tT75Tz4MMUkNYao6aKIr5YFLfxpm6z5JoaQyw9xnlYo7QNqnf4ZSxNaTswGlJRc+UjDCspJNt+VSRgsUFILxG11Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Y1DcOrtL; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Y1DcOrtL"
Received: from macsyma.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 68N21vu2020918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 22:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1790128919; bh=U/o67BbsS43+XKzm4tzMv2za314L0FMCTOsMHatkv+E=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Y1DcOrtLW4xcXd7GSrzbnCve/rwEVRp+e3HHG8MQ24Pe64fHrBrY/fdu3aIsJSXta
	 IFELgLp1Bt1JjRqMwENiWMcBz3X1l+RiRgNpDV/giVLzXiocXY3fqMGMy1mzCBXk4I
	 RYDFX8HvrxnZ1VWNi7GnnrxfSLWC63ghL+ckZwUvho1lO5Zub6CATVQ5DDSUqwD4kv
	 TlpKXYf38hgUqW3MpQhl8fHe0wLVoQBnCpv3ubteHAnBqmP4e1U0m2rBF5FBSqRoIr
	 ctaCBRSrKRB73bouAFIeVekINP3/mObAlXwRvZ/a/4vu/aJt1kWJ72BmmZw97bnMB5
	 d3yYpRmyHkgiQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 611CF1CA9928; Tue, 22 Sep 2026 22:00:57 -0400 (EDT)
Date: Tue, 22 Sep 2026 22:00:57 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 3/4] fuse2fs: improve block and inode caching
Message-ID: <arMoQq1vyhPnHyiZ@mit.edu>
References: <178919524496.1033422.16170817413025710050.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178919524496.1033422.16170817413025710050.stg-ugh@frogsfrogsfrogs>

On Fri, Sep 11, 2026 at 11:42:15PM -0500, Darrick J. Wong wrote:
> 
> This series ports the libext2fs inode cache to the new cache.c hashtable
> code that was added for fuse4fs unlinked file support and improves on
> the UNIX I/O manager's block cache by adding a new I/O manager that does
> its own caching.  Now we no longer have statically sized buffer caching
> for the two fuse servers.

The problem is that cache.c is in lib/support, and my long-standing
rule is that the interface of lib/support is not guaranteed to be
stable, and hence libsupport.a is *not* built as a shared library.
For this reason, we can't allow libext2fs to link against
libsupport.a.  If we do, then the interfaces in libsupport.a will leak
into the libext2fs namespace.  This means that applications that link
against libext2fs might accidentally use it.

If we ever change a function in libsupport, and it's also in
libext2fs, then a binary which links against the newer version of the
function in libsupport.a, but then the binary happens to use
libext2fs.so.2 with the older version of that function.... well,
hilarity can ensue.  (Especially with Linux's ELF shared library,
things are OK with AIX shared library and how it handles shared
library linking, but that's another story.)

So there are a couple of ways we can handle this.

1) We could #include cache.c with some kind of #define hack to make
   all of the functions marked to be static.

2). We could move cache.c to lib/ext2fs and rename all of the
functions to something like _libext2fs_cache_xxx (to avoid namespace
collisions), or if we think we are happy publishing it as a public,
stable interface that is used by fuse4fs, we could use
libext2fs_cache_xxx.

What do you think?

						- Ted

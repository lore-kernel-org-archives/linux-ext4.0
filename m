Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85153A71BE
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 05:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790140274; cv=none; b=u8jS0Etdr/g6en7BiR48sqWgaKeAxlXJ0MSmcRVzXT5B8oIovCVfT/iCNEQ34qFZf2aSLrfNaAjbEsjb+spf89RlRlNakqe30mIOiFC+Q8IgQNo8jWgXPmCAfDaXXO4WHwpg5/0J+VgCvQiTD5it1IY8AirvYTEmVl5h3Le9Mm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790140274; c=relaxed/simple;
	bh=Kth5Lzqev8G4y6YQ9jKn9h3ruXv/gqQvBYnhS8ziQPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnvGWUIHQKsRRjXngeYms6E6ChgyNFADcE3QI9SrP5+Icf+iFfUWPr+gqr9ZVPse54baB01hmvqULSE72ti3JJLqaYLZFH9+f/eaVMk1JdBxLcVAMlOg9kmR5D1F+sNBxUof9WPs8/v9kGsgrUdxUItCvegpYAI2Z/6hwyl5Avo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgEsTS1j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgEsTS1j"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E4F11F000FF;
	Wed, 23 Sep 2026 05:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790140273;
	bh=OucXoyX9H7s5vterYhONF4+EAQLiZfkMSuMvuMSphps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FgEsTS1j4Kxoi0tSzqXdS1k5bcZYuIjQRcX26geZML8vOZd9cEF3Kxk7QMnxw0CXo
	 zBSIesuZezxHCd9z9ifLARx/W7nO+vzRZ3R0bv5i3wzjiyTUTTTclhVghudAqg+Hqf
	 pzcjtHevls79i+OAnFU7j5+ANJO6zxs76EXr0SP85N5P0jbpKYpr0SJbPNbHn/DGPD
	 jne3MSn7ZNTVYBtcgzlkjLHLtzpumvi4+kYplH/AX9lHTbzP+1jDmSMmUU26pFcz8W
	 ZZghc11FTEX+AjUuicNFjDRa2xgKfUvI3B+HkLfeNAsHjPfLd/tpvf09BqqNG8pSaA
	 lxWeewhvrfRzg==
Date: Tue, 22 Sep 2026 22:11:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 3/4] fuse2fs: improve block and inode caching
Message-ID: <20260923051112.GA6283@frogsfrogsfrogs>
References: <178919524496.1033422.16170817413025710050.stg-ugh@frogsfrogsfrogs>
 <arMoQq1vyhPnHyiZ@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arMoQq1vyhPnHyiZ@mit.edu>

On Tue, Sep 22, 2026 at 10:00:57PM -0400, Theodore Tso wrote:
> On Fri, Sep 11, 2026 at 11:42:15PM -0500, Darrick J. Wong wrote:
> > 
> > This series ports the libext2fs inode cache to the new cache.c hashtable
> > code that was added for fuse4fs unlinked file support and improves on
> > the UNIX I/O manager's block cache by adding a new I/O manager that does
> > its own caching.  Now we no longer have statically sized buffer caching
> > for the two fuse servers.
> 
> The problem is that cache.c is in lib/support, and my long-standing
> rule is that the interface of lib/support is not guaranteed to be
> stable, and hence libsupport.a is *not* built as a shared library.
> For this reason, we can't allow libext2fs to link against
> libsupport.a.  If we do, then the interfaces in libsupport.a will leak
> into the libext2fs namespace.  This means that applications that link
> against libext2fs might accidentally use it.

Ah, right, I forgot that non-static functions can leak out that way.

> If we ever change a function in libsupport, and it's also in
> libext2fs, then a binary which links against the newer version of the
> function in libsupport.a, but then the binary happens to use
> libext2fs.so.2 with the older version of that function.... well,
> hilarity can ensue.  (Especially with Linux's ELF shared library,
> things are OK with AIX shared library and how it handles shared
> library linking, but that's another story.)
> 
> So there are a couple of ways we can handle this.
> 
> 1) We could #include cache.c with some kind of #define hack to make
>    all of the functions marked to be static.

Eww....

> 2). We could move cache.c to lib/ext2fs and rename all of the
> functions to something like _libext2fs_cache_xxx (to avoid namespace
> collisions), or if we think we are happy publishing it as a public,
> stable interface that is used by fuse4fs, we could use
> libext2fs_cache_xxx.
> 
> What do you think?

Hmmm.  I guess it's really up to you as the maintainer.  I was trying to
avoid exporting more things in libext2fs, but we could just move it
there if you're ok with having more API surface.

The funny part would be to export it and then try to convince the
xfsprogs maintainers to make xfsprogs depend on libext2fs to reduce code
duplication <duck>

--D

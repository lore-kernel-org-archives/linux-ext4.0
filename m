Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B8020ADF8
	for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2026 02:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786589056; cv=none; b=tnP8gqi/FUZrphGa6ytvvhynUrNlCMOHHbJ8W0Dy4wa4LXA118O+KnQ4J7JVgVGoND/uFHjmRpuqEpw71rzxRwnrUBuKrL5uL9Po06fRBPUJgKHkJ4e8RTGK6BgX6zIO9l5LdratHb+xbhSsH/viBljHC7moP2MleAdFIw9CuqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786589056; c=relaxed/simple;
	bh=YCWMMlcMQICpyCCYNjli394oTSld+6lVPh5MmFumLHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sncoeoTKgmxfaSGSPwTFGjgbjgRdgUpZSQMdAhU1qma1RUI3x6n3AX+Opkyerq8F4+KmnKG8u6m7x/Z0fe3hz7wjPMb6C3yGxSF8iRZ5f5kFiSz7J5hmA8RBs7e7MrjFQE1bbWHKQsWqjehfhaPXMpg2Uzsl7vLG/LDUSofJ6js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=LJRr02sO; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="LJRr02sO"
Received: from macsyma.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67D2i2Q7018469
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Aug 2026 22:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786589046; bh=ZvUeyu23fXAtsk0F2VCZ6Q60hFbloYUCma7F1GPFOyU=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=LJRr02sOdJr9rgslpx2XoGBl6K7QNUgriqvryu3nvFCUHbPLW/Qx7pzKeikl6s80o
	 s2kaVSZ66ns5eTCrcHCF2xY4xkhIupPI5Kf7uUuPQ8lMBsQB329y8Y8HBo5obA1XjQ
	 OPbCg/K/fxCsYQN42PWbHTH2ilFPDDaCTP9Pz0/+QU9dW8iHoEW/7c+PNfDt/CwfBP
	 /KIk5tEon4G+lvexRzPmUaeX0cJ31LyCvvhTvl4MuQLel7BigTSZaQP0p9UL6ZbDPy
	 dykZBkejqLgc7RX9P1Yj18hsmPSFfoVf65EUSU0nvtsN+iGFNApXvw0kVLefscL81U
	 WVkFqTP2uDxfA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 35C48EB26E0; Wed, 12 Aug 2026 22:43:02 -0400 (EDT)
Date: Wed, 12 Aug 2026 22:43:02 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: eaujames@ddn.com
Cc: linux-ext4@vger.kernel.org, adilger@thelustrecollective.com,
        dongyangli@ddn.com
Subject: Re: [PATCH 2/4] libext2fs: add quota to libext2fs
Message-ID: <anyHu4U8pf5iMW96@mit.edu>
References: <ahl_GhW8EhYTEun7@eaujamesFR0130>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahl_GhW8EhYTEun7@eaujamesFR0130>

On Fri, May 29, 2026 at 01:57:14PM -0500, eaujames@ddn.com wrote:
> add quota related interface to libext2fs and install the
> relevant headers.

The reason why the quota functions are in the libsupport library as
opposed to the libext2fs directory is that the quota functions weren't
ready to be moved into libext2fs.  The libext2fs library is published
as a shared library, so the function ABI's must be stable.  This
requirement does not exist for libsupport.a (which is only statically
linked, so function stability is not a requirement).  The functions in
libsupport also in some cases try to write to the standard out, which
is not allowed for libext2fs.

As a result of this, the quota and ea_inode feature is not directly
supported by libext2fs, and hence, not by programs like fuse2fs.

So to address the problem you are trying to solve in this patch series
--- which is to allow e2fsck to correctly handle processing processing
an orphaned file which has an extended attribute value stored in an
inode and quota tracking enabled --- we have two choices

* Clean up the quota handling functions so we can move safely move
  them from lib/support to lib/ext2fs.  This is the long-term plan /
  goal, since it would also allow us to add support for ea_inode and
  quota into programs like fuse2fs.

* Don't add the functionality to lib/ext2fs, but just arrange to have
  release_orphan_inode() in e2fsck/super.c call the functions in
  lib/support as necessary.  (This is how we handle quota support in
  e2fsck today.  We just didn't deal with the combination of ea_inode
  | quota correctly.)

						- Ted

Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C7F383C64
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 11:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340545; cv=none; b=BCE14wc04B2J4YuzC1qfIv/UR/hokwyWsy6+3awP/WK3SAMAAr9jO+xmTH1w0puwZvD+w2udk2cs5bgjha9TYdpxe5MxlW6gjqcvFv4Ga7u4q3dz17t/yZcvAV/4EYzVMLJmpLkTf+urPQc5SVxmOCbMKKMk4HMDne60sByMcGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340545; c=relaxed/simple;
	bh=JnAje/X9C8YfhGOCIz1/VlVMqdAl8bBSAceIJfqsCBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nO8LLiBhN9XGvWpwUysWyFf/WyhvckpEc5R4pHLTs44tYdNiLPbvLwsRtKwdVCzfzs27BYrbFxHjlRYlsTUn6WhhMSFgSvNfK2dXCA7yxWLkn4bKimqWBdV/fBkqFWNThSirRvgru5JsVeVsK548mdmhn5x6um99qqlrh1p3u+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Hr+sVbO7; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Hr+sVbO7"
Received: from macsyma.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63GBtZCQ002971
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 07:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776340537; bh=9jMqHZPxzURZPW1OByiLgBIV+rz7GoO0YmLISCkb15I=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Hr+sVbO7ieFg8cNLwX4SD7vcElY552KLGd5QfwmsL0BdGCgHFEV1Vlx90BmlZbcn6
	 Jo4UMK3pbplvQntGfyVVXodErtriYLb+AG3MKK8thCHW/icvbC9Vy91eOnFaSGYfXb
	 XICo4JLNJKj/2Vn4HSOaDbsSdMVU1E6ppguxpsLqqHFz1lZtADexWTDzhbej6kYAb5
	 LlNz1N7GXhjalVHHT0XkfG6xeI6mO2u6g/QATmw3A00XW+ukbctbBKWG0MNEQfxe9A
	 sKEd2ZuZVIYEz8VGKdqXT4i/ehflhhRVauZ+KMDpJAkjuCYZGXBMr1H6PZOhtWIC48
	 Jkuh0huoYLFQQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 582396375041; Thu, 16 Apr 2026 07:54:35 -0400 (EDT)
Date: Thu, 16 Apr 2026 07:54:35 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger@dilger.ca>, Milos Nikic <nikic.milos@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: enforce power-of-two default revoke hash size at
 compile time
Message-ID: <20260416115435.GA52577@macsyma-wired.lan>
References: <20260413212724.127035-1-nikic.milos@gmail.com>
 <cjtirtqozud4keiu2fqi6sj3o4moimloti7celc4y44eejsn2y@i2tz72chmm34>
 <C27553C0-0A8E-4BCF-8C6F-1D62A69841C1@dilger.ca>
 <gq6n6m75h47lcr2hvmtlun7revnyf3bx3aanndglbh6djmrjcp@jmxhl7kf7bwu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gq6n6m75h47lcr2hvmtlun7revnyf3bx3aanndglbh6djmrjcp@jmxhl7kf7bwu>

On Thu, Apr 16, 2026 at 12:16:05PM +0200, Jan Kara wrote:
> 
> Yes, I know. But there is already a runtime assertion in
> jbd2_journal_init_revoke() making sure the passed value is a power of two
> which is verifying also other callers that aren't using
> JOURNAL_REVOKE_DEFAULT_HASH value. I don't see a value in the *additional*
> BUILD_BUG_ON when we already have that runtime check.

... and if a developer doesn't run regression tests before bothering
the list with a patch... that's not a developer we want to cater to.

Milos, my recommended to workflow is to use kvm-xfstests[1], and just do:

% install-kconfig
% kbuild
% kvm-xfstests smoke

[1] https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md

For a successful run, "kvm-xfstests smoke" will run take 15-20
minutes.  In the case of screwing up the default power-of-two default
revoke hash size, "kvm-xfstests smoke" will report a failure in less
than a minute.

						- Ted

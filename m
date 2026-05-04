Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E74A3E3D89;
	Mon,  4 May 2026 17:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777916597; cv=none; b=udkdIWBPezaJ10ye+XWCXMq4tR9ai1YwQIwtQWKAsKZxThOV0rM5jKvOhHs1DOjF+SX9ostdDtEhkBDAaaF+lQjkHdsrBfLd0wMprp0ra16jnTjlMp7LI/q65Rcc08fuT5IrBLPWZIJw6X5dcEKl34iJKoYBT1MApcbHkiDF9YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777916597; c=relaxed/simple;
	bh=QAMGO3XMXQYWp0JGzxDSNDarEFMXe4IoJPUIi2nAO08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxbG1l9AeA5OoH2/PmVXlDzxn2IXW/u56pol++w3SxWxdSOEmMZ5AC3zcLfiy8RLs/lJmMWtPIJj63Yg3tHVUmPhZ6KTtYrs4REBKtEUwrNpQUOGp6uV1+MHPXn9rw1H94FccyJRxND73QgVVByks+vme8qem9YAYL47u1s9dgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZUnQsR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZUnQsR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA07C2BCB8;
	Mon,  4 May 2026 17:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777916597;
	bh=QAMGO3XMXQYWp0JGzxDSNDarEFMXe4IoJPUIi2nAO08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YZUnQsR2wFTV7Xw0aTbLW2kepVcEl9h7yZ/y1jmJr7tayQaGNaKyPepo6grhN9OUm
	 2+r+QgITFFATBHsCo6poakgzWZWhG3AeuRN3SF2uz25eQYN7RGfbxyMuebOxTb4wWA
	 OOHCMe7XpowGD10eF7d4n0XU7MnpXLXIY02vkgVqO2DpzydpMrN+mGk8jWnbyGT3/B
	 yhpRnz4o1UV5mlpBdFSgKNy0TwIQ32SX68jMdymOdghr2YOyyY5GWS3nuQ7zsdlOEK
	 w+ibkmImKfup6JLor2gsnE7erbYwMr1N60aeWxux1lgVUVGCDbZmsVXbEAq1jPCeU9
	 eH6qtMRScPCXA==
Date: Mon, 4 May 2026 10:43:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bernd Schubert <bernd@bsbernd.com>
Cc: fuse-devel@lists.linux.dev, joannelkoong@gmail.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	miklos@szeredi.hu, neal@gompa.dev
Subject: Re: [GIT PULL v5.1] libfuse: run fuse servers as a contained service
Message-ID: <20260504174316.GZ7739@frogsfrogsfrogs>
References: <177758364789.1315233.15610945404741826500.stg-ugh@frogsfrogsfrogs>
 <9c920b17-81a8-4c1e-921e-4c08cc290cb5@bsbernd.com>
 <20260430224911.GN7765@frogsfrogsfrogs>
 <2f2ba053-53a7-43e5-969a-32d185e9c7b7@bsbernd.com>
 <1d2c00d0-255f-44cd-9757-d7418373cdcd@bsbernd.com>
 <20260502190543.GG3778109@frogsfrogsfrogs>
 <757367d0-3a8b-4de8-aa86-f74f316b3445@bsbernd.com>
 <14222a33-62a3-4c8f-b86f-7c5ee47c9db7@bsbernd.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14222a33-62a3-4c8f-b86f-7c5ee47c9db7@bsbernd.com>

On Mon, May 04, 2026 at 05:41:38PM +0200, Bernd Schubert wrote:
> 
> 
> On 5/2/26 21:51, Bernd Schubert wrote:
> > 
> >> Oh, that's concerning.  Could you figure out exactly what it's
> >> complaining about and send that to me, please?
> > 
> Hi Darrick,
> 
> just pushed a new branch version that should avoid all chekpatch
> warnings (squash of yours and fix of one I had introduced).

Ok, thanks.  I'll have a look, thanks.

> Please find attached all the CodeChecker warnings.

<nod> I'll try to eliminate as many of these as possible.  I think the
complaints about "can be declared as pointer to const struct" are easily
amended.

The ones involving char **argv might be a little trickier though.
Anyway, I'll try to have something ready to send out before morning in
Europe, assuming that either you're at LSFMM or at least in a similar
timezone.

Also thanks for sending the tarball, it's useful (a) to know which
cppcheck complaints you want fixed, and (b) to compare against the
version on my system (Debian 13).

--D

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793311113;
	b=rbyJ33IqSo/5kpAXk2ytuAr1oBHjiIliGWPylTaGD/OJLi2Z3TpCbjQfWBmrxSZy3cBN
	 5fwmQWhMplBW5U1K5LHJsHBSuiaj5ZrVcbW1gDrVP4QkJPs5tc4bQCa4Cn+eayd/nq62j
	 0bJu5UCsPKfwMt5RmiXB2fYWOuTxysBs4p0NMyKGT9vhu5rdmO/gRLbc+QUk7VDM7Ixy2
	 oDeFdn3RdKCiEWopyvuIJGyu0y2/7fSvn+C1xcsmbE0wrFXJVsY1O6wu3olWpgkmkM6NY
	 PI7ih75Jppsz4C6Q2qheoxUl8OcmQESpp874riGtl57JTTsG2+AkOr8zXUZM9RcznhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793311113;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=U0Vdp4AlMQoid5KFTkbCosmjcciIZ2qtRXsvKhAKL9Q=;
	b=raXGL6X1XMiLtieOgUMXh1G+ke9YPktz1oMzLIrQ2UAPgdruSaZNonaCzpdoN4JjYLMX
	 T7fNTa18StjhPoGOey7mWpmDhaGJERLvIv0Rsnz4IsERETyoylHmCmob3KQrEtE2AyjwF
	 +QxkHha431UKCfm+8pCsAyn1lI+k405twEWpG1bptW2YC/KhHGwRweBFcTLXS//A8OmQ9
	 UuZ6YVM0SOkKyxIUGMkL8rjEUvCZXY50TwMXTUOQkV6lumkheNUE69KkKe+jFdH6q6tfj
	 kAv9SIq4c+YpWxrUdQ+DA+jPiXIfD/u81+QcTU4o3IqeeJ+yczUbTAqMJfvqcuIMk6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FaaSlv2v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC550606A31A;
	Thu, 29 Oct 2026 21:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FaaSlv2v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1E21F01816;
	Thu, 29 Oct 2026 21:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793311112;
	bh=U0Vdp4AlMQoid5KFTkbCosmjcciIZ2qtRXsvKhAKL9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FaaSlv2vOsEuL89kfK7kCINwHmGiDACZOtMoi7biSm5VbKOYs1XBMOuyT3hyBQufd
	 4pNW2XdOxFommGhHDHqinO9UG/m9q9Iz1fjYG2MbazNrcBi0t9atwYACtHPIwUK1E0
	 C4Hv/h5OM6Hq7R/kepTxtPZ2l+4QkXCs+kw4YhhZ57tZd5b3Y96fRdGsT4GV4vAD2D
	 HEMivv6jXGLsXBSevXSDhPIZTZsWD+4hrfTR3Q4CLO+PXn2OSjH7F/lckDN9oaLe8j
	 UTbwzaHRT9P8CYV/M7iKaL+JW5L1ChNiRcIHc453PYdwL1SSseWUNoQz7Fu6/GdAzR
	 PchtOWjgYoDsw==
Date: Thu, 29 Oct 2026 21:58:30 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, stable-commits@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Subject: Re: Patch "ext4: switch to using the crc32c library" has been added
 to the 6.12-stable tree
Message-ID: <20261029215830.GA1254086@google.com>
References: <20261016171849.GA122880@google.com>
 <2026-10-16-1-daily-reply-0016-ext4-crc32c-drop-6-12-6-6@kernel.org>
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
In-Reply-To: <2026-10-16-1-daily-reply-0016-ext4-crc32c-drop-6-12-6-6@kernel.org>

On Fri, Oct 16, 2026 at 11:00:21PM -0400, Sasha Levin wrote:
> > Nack.  Missing prerequisite commits and didn't Cc the mailing list.
> 
> Dropped, thanks.

Thanks.  Note that the commit message itself described the prerequisite,
and it intentionally did *not* have 'Cc stable'.  Also this was patch 16
of a 19-patch series
(https://lore.kernel.org/all/20241202010844.144356-17-ebiggers@kernel.org/),
which is discoverable from the commit itself via the lore link.

A similar example was
https://lore.kernel.org/all/20260616145143.326415700@linuxfoundation.org/.
That had the same characteristics: commit message itself described the
prerequisite, it intentionally did *not* have 'Cc stable', and it was
patch 18 of a 30-patch series.  (That one was actually applied to stable
anyway, despite two people pointing out the missing prerequisites.)

And these don't go to their subsystem mailing list, so there's limited
opportunity for people to catch these incorrect backports.

Can you help me understand how these incorrect backports get queued up
in the first place?  At least from the outside, it looks like there's
some automated process that pulls in commits needed for another to apply
cleanly, without anyone really looking at them.  (Or if LLMs are making
that decision now, then they're seemingly not being asked to evaluate
whether there are other prerequisites.)

Is there a way to opt out of this until the process can be improved?

- Eric

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210865;
	b=ZMXNRbXtRNSdYE87hz401e8Tj/Gb37d2tvuDYhG79MB5Lqb7I65vr3UHOF/T6sjSKkKP
	 cTjOdBsELZpL6uYoPW5ZaIhQN+xIyyIFEXr8kEpjYsZ/W7ivSl1zhQVAm9uoSfUx072z1
	 ujV7xmMn4iHM6FkEaw6HzqShzkROdU6C9gOlEw+B7kUAYk1R0H2xqRhRlir/EuAmqdJPV
	 Ybo7wJYcvCHGDqkbUEBJemd3DPkOncTvRizjfsZ49ukU08NEdsLPTLSfhdgTjfwM1MAGv
	 EtSIh73buaPs4iRT19JYQccta811mGsOUXqkiqcnvY0Oazd6RKmGlUdFp0PHVmwRAIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210865;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1QymhgOg/76tJKj+piGg4eRtQ0QyG1Y+W8oL9ZVUd0s=;
	b=xFB8fiX3y9YcJWvna/tk4RyIBrI82fMAp3Yl/B6eG1ddbnecfhVJgjRayTtyvaAdElsz
	 CdXgiVUbhXWF+hDhbdnilOylTVCf8FWFdZkjnITSL+AijSL06Eg6K0U1UfrRYm0zCe9Qd
	 /F1xeuAG4AY77aM9qPJXfVrnf08BkuH3LJz9tvT6H4sYSJGF47qlZW8TaD0dk9oYlwonk
	 OFh/xZYBBi3xYwNvg0iqh94w6Q4iQWkhERiwXESWY3cwzcUawMVitENIaBQJfM4WvXNk4
	 QN/dipqFIBrstcoe8uTNn3RjNhyPxoGP6fvv2V8r/zZ2+85Ri/h+eM6zJvq7JNjBTPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2MBID+h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E8A606A31A;
	Wed, 28 Oct 2026 18:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B2MBID+h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B63C1F01825;
	Wed, 28 Oct 2026 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793210864;
	bh=1QymhgOg/76tJKj+piGg4eRtQ0QyG1Y+W8oL9ZVUd0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B2MBID+h5JXphOHFX4EjjP5TGNlc2R/fSyqoRU9W9KNvjSp7JIstOtAxppz9j49wa
	 +TwFNSs79rS5qKmO08xnqr9p89KK2NeIsdRKgEwMlIMV+hgIyvNTMq6sNSmeW9fmvO
	 4ik8PWQP3XaGr9QMwBbtSyAvm6rSs8Ui+CA+mDhxKm9BE5UfN1WI+Q6yQT0/f7EQtL
	 WdEK/w6psIVF6nkrFHO7ro26OVvH46YVNgaW2dHjsyPJxWg3UCs7+20rwE48zGS2ue
	 tmagc6CXl1YtkosYW44oqYa1MT8oxzt6iV+0/VFEpDWJa0BA5pOa7BT8uJtsGIgd7w
	 ftDck6ngIk+Tw==
Date: Wed, 28 Oct 2026 11:07:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: fsverity@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH] fsverity: Set S_VERITY only after rollback is no longer
 possible
Message-ID: <20261028180742.GD1876@quark>
References: <20261025204807.122875-1-ebiggers@kernel.org>
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
In-Reply-To: <20261025204807.122875-1-ebiggers@kernel.org>

On Sun, Oct 25, 2026 at 01:48:07PM -0700, Eric Biggers wrote:
> However, ext4 and btrfs can roll back verity after they set S_VERITY,
> causing a use-after-free.
> 
> Fix that by making ext4 and btrfs set S_VERITY only after rollback is no
> longer possible.  On failure, don't roll back S_VERITY, but do roll back
> the filesystem-specific verity flag.

Applied to https://git.kernel.org/pub/scm/fs/fsverity/linux.git/log/?h=for-current

Acks from the ext4 and btrfs maintainers would be appreciated.

- Eric

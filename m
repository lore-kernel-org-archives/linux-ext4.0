Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210818;
	b=zpm83IPEsRvE5TUf+70EYIyOZX+//I9geJdsGQo7TbVIg/WEvllzECiOjSTjD7M74Qif
	 /sXojq7LisF19BStv+7lwNVC7WbDpUBKxuQs9BgPglj4KAKYaoHuLpnvqOpMhpDAwF4/i
	 ZcIMBSNVZTCfslNoUFF7BdqpzkY2wnQdIGjw//Nn4kVbJrFFuF0bSEommxuIuvcVlumlv
	 //51a5SKDa/Pn/+Cju8zLPILxGGvE9VYoMjxbOW1ILl7HH5O7CdSiObXf9L+WjJNh7hlH
	 mLDsjmJQlvq5O6z4v1GuIw8IG/tzzD5kkoii2EOQGe39XBTJ11Delg2UWunyD6Fp0uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210818;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=z4L3nEOGF+qxkGkMn6bRtZnF7sFx5d4JUIfh1IpPOZI=;
	b=xQfKNNmDU8lhpUrsDD+SxLC+QtiO4WnrcdrYD9YRmcdIRNbR35yTngXkfM3sJFOaRhGm
	 /dvQH3NMknuxmM4KD78fC4iMC/riJn/T4HhPnL1EMV5UTBRxrojqMSIfkTOOeEaqeh4nD
	 N8qUZRvN3EG0GZRTrVqtrpi5T7kfE62yLnbs+zNL2CqZ1g65RZUhXyb2Li+pqpW6PPiAf
	 gvAYBxcrlCl7mmCzHcp2tVFExpSABgVape2SGeUmFb+Ltt+0fHhLstIoPSbWuiB+zRG0t
	 ntDnhAD7IA5PBo/82KvEHEcj+NmbrfUsrUbNSp9xqLuir76ddRzsRaQfzmZnJwHuOpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OePYN9Rv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08698606A321;
	Wed, 28 Oct 2026 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OePYN9Rv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85D81F031E0;
	Wed, 28 Oct 2026 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793210817;
	bh=z4L3nEOGF+qxkGkMn6bRtZnF7sFx5d4JUIfh1IpPOZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OePYN9Rvv0YAMMAc1zL6t3lYVnztxSYIpNBqx56kavAWJbVUADgpDMfnuj7Ql2/Zp
	 sd4IeBtthoNuyT506ZpiEYyshzMT5RowzeHrx9sM6zl0jSvxoaIYOfGV/PyFqy0hjR
	 eU1anzCHz8pIriKfUIlbaErBp/yuPQOaiQE/wvZXiGMDdNV3MjqbXbzGtV6pX3W7Ve
	 aw1T8v5sEeJBgSogs2giVIvWJve+/Vtj8vLHBAdHl+GfanNvMFeJZ3KWRXsySilAV7
	 8oN8nFomVKlfx4pvxFj5EF0p/ZA7CPgXnl2S8PJBlONmzuWcEe+TjdMlGL5DisTDd1
	 J0TQuKqDRhD8Q==
Date: Wed, 28 Oct 2026 11:06:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: fsverity@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fsverity: Be more careful with return value of
 ->get_verity_descriptor()
Message-ID: <20261028180656.GC1876@quark>
References: <20261025203831.120095-1-ebiggers@kernel.org>
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
In-Reply-To: <20261025203831.120095-1-ebiggers@kernel.org>

On Sun, Oct 25, 2026 at 01:38:31PM -0700, Eric Biggers wrote:
> If fsverity_operations::get_verity_descriptor() returns that the verity
> descriptor has 0 size, then a zero-size buffer is allocated to hold it,
> and it's called again with bufsize=0.
> 
> But bufsize=0 is a special case that says to return the actual size.  If
> in the meantime the filesystem has decided that the size is some
> actually valid size, it will return that size, and then
> validate_fsverity_descriptor() will read from ZERO_SIZE_PTR and crash.
> 
> Of course, for the filesystem to misbehave in that strange way, it
> generally would require direct writes to the block device.
> 
> Regardless, fsverity_get_descriptor() might as well guard against it.
> Make it do so.  Specifically, validate that the first call to
> ->get_verity_descriptor() returns at least the minimum descriptor size,
> and validate that the second call returns the same size as the first.
> 
> Fixes: fd2d1acfcadf ("fs-verity: add the hook for file ->open()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Applied to https://git.kernel.org/pub/scm/fs/fsverity/linux.git/log/?h=for-current

- Eric

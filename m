Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794244312;
	b=1FYE8gJB+8d8V+qMxZzoduF8QeKo52BIm3DJ7f6RBdcCqnyuIy71L1GlZoeb4GwNiLF3
	 Yf+D50m1lUu64SjShDIssMSmPvf6B3T+o1YjeNKtHVHbriSF7GefhblYl9+YcCiBeP4LZ
	 OoQexR7dsmdS/Ofi1+EZiAXjdx74jCA+hPUF58ywIviTksZnw4Ibb/9nQPYwMvCwYrtEb
	 joVa8zSpcqjiHcCusQmbe+HWVs+TcajfO7QcdCliM3WMJDCmOxR5MGKURM9YX8Hmgqo0q
	 xRg+uQxPwaktAqkNK5ozI0qomUQequgu7hGhBl4WCQYN1h89q+NIon5eAOmSQhU5sPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794244312;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Gd8ao2vcySwNPYZ9JWeVv+0pNcg0TDblj6I0GzkVrvs=;
	b=04NBcBKheEI3Aku2Ihj25s/RelRJOs7jfjH/q97QMQpgeSMxUd5FCVUV2F0WasoEYb6X
	 znr356lo507umJV0bma8bmNlVrD3KTBQWkEqSXnsa11f9deT7o4s61dJd2kSQw9J9caaS
	 lUTIpiEAfMO9x0hAPqAEdfogUTl7Cy5cSmlLVYor3weDnWzKwFKUQKG/MLhEXQMfFCiEE
	 BZP3Lz7bCtV6lci2Vf3hf2dkZQ9aM1dqtD8vWOz7uxr27A7Jw1qT2J+B9ayC3Q1ZW1n97
	 jcvS28xWj3q6LW3dU/hrol7OfetcIflBTKaBn21FllbA24J3rnM2m4j05eAtb2Ced6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EzFEcAzV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A65606A326
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 17:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EzFEcAzV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8101F0089F;
	Mon,  9 Nov 2026 17:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794244312;
	bh=Gd8ao2vcySwNPYZ9JWeVv+0pNcg0TDblj6I0GzkVrvs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EzFEcAzV7/PlzwXx+/dz2uRJaYq+WB6mlK8ffJ3kUAXM+DBRSHJ1n/Rzb+HYhZ9f8
	 wWyzy5Ypa4ZizYgarvRHfNmNFZ+b/a7kiQu2xmD1WjKaGxXRaxMQOFEO8viT4Pzhob
	 p8sFChOUTx9gQSLD0/KXgKOfQ6GSHKAeN6Ey+vugFktT+nZUX6nhaJRetVjTFMTIZ1
	 8DMDN/D1gqKSmz2do3SJCuoK4qbLVFtDCMZtLRo7fwMRNocU8XUGE+/imNUR8SiA9h
	 Gztc7us3Gxhz2+6qUnwYc6Kg4Qce/B+gKpxYpVhTWIKIcJKWMbW5NHIXlekwTXmgmv
	 wdfsVMyhBjFzQ==
Message-ID: <sashiko-outbox-205281@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 04/14] ext4: don't read the inode block in
 ext4_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-4-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-4-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 17:11:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Without a journal ext4_sync_inode_metadata() looks the inode table
> block up with __ext4_get_inode_loc_noinmem() which reads it from disk,
> with readahead of the inode table on top, if it isn't cached. But a
> block that isn't cached is neither dirty nor under writeback, so there's
> nothing to write or to wait for.
>=20
> That read is also something we can't afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> ext4_get_inode_loc_noio() instead and treat -EAGAIN as nothing to do.
>=20
> Note that ext4_get_inode_loc_noio() also returns -EAGAIN for a block
> that isn't uptodate. Such a block is being read or failed to be read
> and can't be dirty either. A block whose write failed still counts as
> uptodate for ext4_buffer_uptodate() so the write error still gets
> reported.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D4


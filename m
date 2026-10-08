Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE7010F0
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 01:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791423174; cv=none; b=aYKEQ6siwoPVr8AsGYY3V8/mx9xIETYGdoj3fj5WaS7QlQNXYGjVBj2dX8+i21nq4gzRzqbc46tg1umDY8X5+Brx09XdrHFSZMrTNGnXg37jkJYcBYj92RKNIK+Uh8d5Sr0A+4vQWSAQ7kLTnfk1xV615ADalNsKVVyD7c5O0q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791423174; c=relaxed/simple;
	bh=9EP4lZxFabBRp65/2V2ELIHGwtaY/8KfOo/kNiuDdzY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Kd8dtz3vCjXpMfPPGmG/EXEmHAfKdcX55Zzr/4qmbVTlX8pKq6gBDDNSCqpteHPPfUPhlzvPk663dvtq/9qnXf07oIGylAIB5cu2StQjsHfL5jueE7L80KtqO1fg5KmT9b5vl2qztSrL4ZGassOe/pEATvzcnNg9cG/lmqz391g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMva5DVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMva5DVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80191F000FF;
	Thu,  8 Oct 2026 01:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791423173;
	bh=9EP4lZxFabBRp65/2V2ELIHGwtaY/8KfOo/kNiuDdzY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UMva5DVmvsHinQUZnzTT6FRlVTmvWR68E2H6/UdMcAy/HXY4BQIszp4uP6Mecc47d
	 YNmVUxAPvPPzeIv5xYhZMDDZrOM5EZe4OxFt5HC+m73QGLZo84Li8UOHnZ2xqVXM4p
	 MY32ssYuFxNEpOVuFGYLHKK9sqZIaJ4gALpKbBxpnTJU7lOkAdLrmhsQzhFc51zAzm
	 12r+OXSFGQvNptR0Y5JyxIK3VQjlVGNbtgd4ySfc64tpXZNUCId3PRBomoQcwcdMHv
	 iYEpBQvq7iSUvKw4Wx2Z+udQyRC03smljy3OJh6c+4xE/59msCrH4SWGH2o+7BkZY8
	 l0gKZtFbpD4bw==
Message-ID: <sashiko-outbox-163489@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] ext4: don't cache unzeroed blocks as written
 after a failed zeroout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261008-ext4-fc-zeroout-v2-1-55cab1e24fa3@samsung.com>
References: <20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com>
 <20261008-ext4-fc-zeroout-v2-1-55cab1e24fa3@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 01:32:52 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Daejun Park <daejun7.park@samsung.com>
>=20
> ext4_ext_convert_to_initialized() may zero out the blocks before and
> after the range being written and convert them to written together with
> it, instead of splitting them off the unwritten extent. If
> ext4_ext_zeroout() fails for one side, it falls back to splitting the
> extent, so the blocks on that side stay unwritten in the extent tree.
> But zero_ex1 or zero_ex2 keeps its length, and ext4_zeroout_es() still
> inserts those blocks into the extent status tree as written.
>=20
> Until that entry goes away, a read of those blocks returns whatever was
> on the disk before the extent was allocated. A write to them is mapped
> from the cache and goes in place without converting the extent, so its
> data would read back as zeroes once the entry is dropped. To reproduce
> on 4 KiB blocks with -o nodelalloc: fallocate 32 KiB, map the last seven
> blocks of that extent to dm-error, write the first block, restore the
> mapping and read the second block. It returns the old disk contents
> instead of zeroes.
>=20
> Clear the length of an extent that could not be zeroed out, so that
> ext4_zeroout_es() skips it, as the comment at the out label intends.
>=20
> Fixes: 308c57ccf431 ("ext4: if zeroout fails fall back to splitting the e=
xtent node")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-ext4-fc-ze=
roout-v2-0-55cab1e24fa3@samsung.com?part=3D1


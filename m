Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94B537F316
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991250; cv=none; b=SxE779fp7+U1R5AGpTKyxGp2QdJeqDbhvJAZ830LoynLsiDXKeVHpEGk/w7spG5NDwGL/3IwwmF7YUIDxhyIumw7+5mU5A6URhOr3OFY7Uk+1o12MBZls2UxUdbB4YWN+kz82ZHTDl4rWpYk/1wQ+4zS1ry9Tc243PbappePZec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991250; c=relaxed/simple;
	bh=lZjSz2uWI/zca8F6UqJC/48h2Wd/ux8nZBq6NIlN3NA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N8T8LGewenQVX1WbGdImlFN86rba8zMy3dU0jCQXz6NmCPHq8FGxCYF6DxCChp6ayCwg6kCi+w3Nicsi+5zjbqWvWdadYD6kbsKE+lvY62ZmqEuTKg7iWINslCDq1j/lAbXmr8sOZfGTbFdwXsEZJ6Peqi2Z8js+xz66mlSZIl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BycnnpHS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BycnnpHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F32F1F00893;
	Sat,  3 Oct 2026 01:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991248;
	bh=lZjSz2uWI/zca8F6UqJC/48h2Wd/ux8nZBq6NIlN3NA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BycnnpHSEqOgtdK8pjsmatEh7c0VFojfg+O43WwDE4nAhgey8uF/zz1Z2g7q+YiK+
	 PiNlVzm6RgluTFg/RRXbBZkLjKlAqoUi3jRd9uOvq2/5JDXiClTTmm+pX1BsWMyWAy
	 lHmhBmEdavIoALmKsIQ6boca0G1EGlhy9tlZ/cQ6CxNRmhGuYI9xvkqzgwOCMIILsr
	 r8nuJCMGP18gDuU5bfdn6gqrK1nZD3M22mxKiImHPE/TRL/gBrZ5Nk520iMQ0m4Ml8
	 LROmn2CBtBmAZkjnAuU0372b7C7TUt0cXqHGz7qL6SBpx15GMOXUcEn78jt/1uF6u/
	 dqOiSNQcZMrmg==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 04/21] fsverity: hoist pagecache_read
 from f2fs/ext4 to fsverity
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: dsterba@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261002223705.2175542-5-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-5-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:08 +0000
Message-Id: <20261003013408.8F32F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> This is the same function to read from pageache. XFS will also need
> this, so move this to core fsverity.
>=20
> Note that f2fs and ext4 functions diverged a bit, as ext4 operated over
> folios and f2fs operated over pages. The common one will operate over
> folios.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D4


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E523D3B42F4
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730702; cv=none; b=Zatq0/DX7b2m4s9WDW9+iGTo+U6N7SvhapuoDrtdLFf/T8wXBVeFyAk+vSafzXq8i6SyMpIa8TQ1ln1kGXrJlv285gOn0TK9eoC1Nkr5LF+27KLSpkfx7rHGZJnHbUKo9C9HGwStTNpLP3MlE8rKTqknAz05MFH8oFGvIjnSZkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730702; c=relaxed/simple;
	bh=NY2H3wKZAoLW67iQcBXLNEjKczrUxZh7nLFHSKr3SIQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DH2QLvAhDKDwX9Psk1VX1Z24CRlEDVotUSxojvlCHigIB13tnuUqjD58JkLiknJce7xiJ2F71vzU+PYq5y44KqQVQrYdDDrrHjWWFQNGUGafS0AAC4n5/0AETapkUARpAiXvh0mxNdNHEu2OJ6/YqVJ6qtCLcoIYXdVnGrbZ3ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kwqmzwFu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kwqmzwFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4721F1F000FF;
	Fri, 18 Sep 2026 11:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730700;
	bh=NY2H3wKZAoLW67iQcBXLNEjKczrUxZh7nLFHSKr3SIQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kwqmzwFuEerrnZ1X8sqV8DlSGFm+0fw0eZt66XtEWU2NYOKUQv2Nr7m6ukpaRtYBm
	 1RiGIBw6S0ud91RozlygzZCyF6FPDSL/41W+ZxgGsAqcqozrkaYOvhwvZg+/M7UglC
	 miScNjN2wITJxqDgjTohqZ8nrO1kfmpKXt+GAKaW+XMug3f+mjIYGy6irAUBzNzGWs
	 QRsjRjn240rFg57hxy4s3GRgwcKgk+z2pbFjC9GJDVX5aLjkxKIh8soyoNursIuOH/
	 FaGe4YuwCTlh1zbhl5IslC77bYW3uooGIz/aZcO/nRuAhHjemXzpQJeClhux2wYqA2
	 PgLCHph7kaJ7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 03/21] fsverity: pass digest size and hash of the
 all-zeroes block to ->write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: dsterba@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260918111539.1003439-4-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-4-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:24:59 +0000
Message-Id: <20260918112500.4721F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Let filesystem iterate over hashes in the block and check if these are
> hashes of zeroed data blocks. XFS will use this to decide if it want to
> store tree block full of these hashes.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D3


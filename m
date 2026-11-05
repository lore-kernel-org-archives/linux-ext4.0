Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883137;
	b=Lwx4rRw1kNWOPH8XeeTtA99iRyEg/HulI8Ef7TO+Wv1fbBsgcCKWzVUIqKkliePPcuR9
	 tOO8gwRviQQSizOxyIl6LuzoSpPFXqM++fTK6S4Nf8zXzN7JHil1sEQpzeKDfIMJctxIL
	 0Njof791YumoPWl3iuc3yRR1Jgut+ogWrRzkaCOLCSffumFOeyEbfzN3q84qFLXXEWXYL
	 dbuB0cvqtR3TK/wEWToNEPARpmelg1K/8tdOcx1L/7pUSRFgPbVKgXecc9bYKUY7l1KcG
	 rVOagjmMg0g/RF8Ush8ZtSJ1LfNaeqqRgKO4jKbi3iVSi37cIbdVCvea6j+vnVUCmGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883137;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=T8oGuOvO8xfSLKfwj6ZAK8dQA9Elzxnee+tXMrNfWOM=;
	b=zDLjkW1lPtVKhsCE7+7QIHuAv97XDaA6BOjKWp3MVbjyCTZwpfwZGkbr++5G/m8xVfum
	 c+GyH+l4maXuiD3Er6Jlwk/j6OuGiwEiI2blgAJuI8SVAqA8tRDf6Ngvw9W3cnF3Z8utr
	 Xt4jyqDJQK07V+F2ehr6oqERhglzM5kPKzDDx3lhbVkt6H7P2FA8BZSyWiuUIqUgstYR3
	 LHOyv6KneKb6c7VYbz0opGJgKo+bjCkxRwtNdPYtt575a/5vhrQqYdtuah6IbrXJQx1tE
	 xsXAhqvVZCqkY3oNHHjspVfPFwldOQ+gKnhBF9aEBcfR0N/mmAIKSEX+ERZWpez9yJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8WKhJT6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20C1606A32F
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8WKhJT6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442E11F00919;
	Thu,  5 Nov 2026 12:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883136;
	bh=T8oGuOvO8xfSLKfwj6ZAK8dQA9Elzxnee+tXMrNfWOM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y8WKhJT6W+4MkVLg/TYiF7y7JxlVal89fruVWbjwkydIVdwSpR+x5g8/i113CLTel
	 gRH26C9cPW9VZ4Bd0dxWd8zQJtxKH7DYJhAQ3/rlX+YxmrTwFQOnekx1aGZT+875XB
	 DcnKfd4DzYuXGSKx7bnepJbftBiNdAInZErz/XRIOg7N8g9vtauwPmN0xnzH8lgjFG
	 JDkmwsFumIzwqLoYNZd5MzSNA+P+UtGcC29BQ8pXtjU49leb85V57qvWk5BN1f+YCD
	 +PYiWYzQ5Tgeuxv6VgNp53lWfZbqaB8fjFDizGnXojaHprYvqJ/Biv2I9ZLYVQ/Xn/
	 nI3eTCeio6ztg==
Message-ID: <sashiko-outbox-199073@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 01/13] ext2: add ext2_inode_block() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-1-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-1-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:52:15 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move the lookup of the inode table block that holds an inode out of
> ext2_get_inode() into a helper. ext2_sync_inode_metadata() is going to
> use it to find the block without reading it from disk.
>=20
> No functional changes.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D1


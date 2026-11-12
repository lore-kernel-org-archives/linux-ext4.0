Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457651;
	b=FwDDqa7nJAu8LQjcjne1+UDAKJITqVUFGAS/GRgnaKAnbGy0O6mO3hj8wyBeilQRkPLJ
	 nsv74wazkZ+DdhM2uR9c47yhdVGKmLQg5IjJIiNzz+Xzuk/eBpSsY4Pumi/X8rdvbwQhL
	 6sSwTwK4Y5PqGJWnF5iXt0fDnqMHmax25812D9K9QSDUvLxZdygKJAuM7NPj/pW1lU5n/
	 bie5ty3HuVJgNwf+rMXbToEY1fHLkmX09TWaiDJ6WbQfoUqaoWbUXCUsZZ8QFDlyK0A+U
	 FRgjpTJsyR08cWDUkMOXgseh5jaA9iaSx5PH+92vGMQU/5PfP2Dtmjf3aT7Wgc8AlDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457651;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ws/rbKIuYvQmXo7Py84nzFxCyjTQj0NUGeody1q8gJw=;
	b=wbrqeBOjnVtEJF3aN8QXJA+cU8QYBKhKurlvBczgJofU6/cLZaHoLzivenDBxSdM0fJ8
	 velUxchnOMJFgqpzpxOIaQ/y7i336EqEd41Y6fnK/FyGHhZNRJgEbNWqOGWXt9AsJfBFC
	 Tn//3A10wiPkmt0tfckNyKfcONwuibyqxImrZG55bvQaRkZh8qjYjbf8p2Hn1fqSyZZ08
	 Bv0OzSN7FJuhSoPNfDiX+o0u1UTRxmqlOgEP9ff0KWuLthnkS/SJ7bgc9BWaHROOgkVc4
	 e443+A46d6gjSXC0S1/3oVU2R6anpHeO5SnVdWuGm+o/ZkVcQtmeKWBwn4zzTjbrJKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTBC5TEf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC63606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTBC5TEf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F061F00A05;
	Thu, 12 Nov 2026 04:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457650;
	bh=Ws/rbKIuYvQmXo7Py84nzFxCyjTQj0NUGeody1q8gJw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=fTBC5TEfWXyeg0dQm+tEiZzybE7ahRj4tLyuxN/UGvU3viBx2x4/I69aE1kkDLqJJ
	 VgepXwhylv7LE4wM6epcfb3UfEmFnZioFIxVinubg+5DYAL1JargidiNnfGB7R0YXT
	 5PtAWXpmWSMjvCYmyJogKRULcL3y+1MPJdah21gLlvQeQ0y31JSMU6ghfdl6Oi94GR
	 q1eo1HgnPzg9fcD4bYDLQWa4NmQqQqhfZjlyzjrZ/HlWv3BAoknpjJHppN/92vi+FU
	 R11J6+BRIYyQ7IEznoxmsZl6/OqbRmH0POD62RJydRsNZ+gf9XZpGjNELy6eDICveQ
	 NpTIdBRm7LHsw==
Message-ID: <sashiko-outbox-210336@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/27] ext4: add KUnit tests for fs/ext4/super.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-18-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-18-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:27:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] ext4: duplicate test symbol exports in super.c and mballoc.c
  break modpost
--

commit bd8448103700f2d8698fe8da1a5ea9c5b818c8f5
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/super.c

This commit adds a KUnit test suite (ext4_super_test) for superblock
validation, geometry checks, metadata checksums, mount options, overhead
and statfs accounting, and error recording in fs/ext4/super.c, along with
test helper wrappers and symbol exports.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 88bd28cedd999..838dabda35c5d 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c

[ ... ]

> @@ -379,6 +381,7 @@ __u32 ext4_free_group_clusters(struct super_block *sb,
>  		(EXT4_DESC_SIZE(sb) >=3D EXT4_MIN_DESC_SIZE_64BIT ?
>  		 (__u32)le16_to_cpu(bg->bg_free_blocks_count_hi) << 16 : 0);
>  }
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_group_clusters);
> =20
>  __u32 ext4_free_inodes_count(struct super_block *sb,
>  			      struct ext4_group_desc *bg)
> @@ -441,6 +444,7 @@ void ext4_free_group_clusters_set(struct super_block =
*sb,
>  	if (EXT4_DESC_SIZE(sb) >=3D EXT4_MIN_DESC_SIZE_64BIT)
>  		bg->bg_free_blocks_count_hi =3D cpu_to_le16(count >> 16);
>  }
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_group_clusters_set);
> =20
>  void ext4_free_inodes_set(struct super_block *sb,
>  			  struct ext4_group_desc *bg, __u32 count)

[Severity: High]
Does exporting ext4_free_group_clusters and ext4_free_group_clusters_set
here duplicate the existing exports in fs/ext4/mballoc.c?

fs/ext4/mballoc.c:
    ...
    EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_group_clusters);
    EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_free_group_clusters_set);
    ...

Because super.o and mballoc.o are linked into the same module or vmlinux,
builds with CONFIG_MODULES=3Dy and CONFIG_EXT4_KUNIT_TESTS enabled fail in
modpost with "symbol ... exported twice".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D17

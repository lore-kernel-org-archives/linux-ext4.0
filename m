Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794909083;
	b=YBkd7g+dup2GV67c5C/W2KP+y94dvYKmuZ+2noSwZFYg7shbzhL7/DN+HHqEyfPl6e2t
	 W1J7Ovcl/zjVTuA7zxmjkMaJXfaGWX4XiEa4X+cAk3otYgeHdrfhvC/ksbqZqY1filImB
	 hf4kIOWc4oimjD02gRl4AARLOu47n5+1F8zSo1OPfgZg+rtJ+Z8SLVrh5hCN2Yvh35aHV
	 23fM0yVpOvS5a7eC212nb0Qw8RMRU0dYgnNo2yQg2D5c/wN8qRtaEnEsNW4ZYAXSkIWFN
	 n5k8sqnaJQsZ9LIHUSI1ezddp10nogNmlZroWNax1uvy3Wdgf3cYZAEGlvp9YLSHWig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794909083;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bSiEa6c5RbiJISAh9MazCmsYgQZGJRi1v4E7Avxq3w8=;
	b=swQl4pZ4l1Hpz59fL8DZB9ptqQaeyexm8Lwe2SYldZ0FmaRtdL8TGDk46PQe+Jb8kggm
	 wfKJqKnIFlPYNnRALzaVMIpQ7nkauCfzKIT37PvZL8YlTUn+4PgNXOEqqjNWNM1M8Rt7W
	 gV/U6ZKCkZ40OjlRf0gdoYW5C/PlAXbXxUlXlfwVtPMk/F61V6azXZem4Iyrq9z1smDun
	 AckRTHqivCIyLsgO2sajnViCpRDYhj7PdBJGCxg2j9/Q816WeiNfC6Pdg+AYQfFR7tebq
	 +GATJ1zcR2tCS2PIc1CGNYq042o+bXNk4jCOmuBsjnLwoZ69qRVlQ4dvK2VLVp16KSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HaMbWk30;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0DF606A333
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 09:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HaMbWk30
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D77E1F000C5;
	Tue, 17 Nov 2026 09:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909083;
	bh=bSiEa6c5RbiJISAh9MazCmsYgQZGJRi1v4E7Avxq3w8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HaMbWk30/U8Sw1bGnlBntmgnDr1IwLXwIxExItCxdKPGfE+CRo+Usf/FWTiE4BbZh
	 7ECDZa8j9BeabhUqkib577l59o9B0oDTVbIYmnhRA/TRIV5x8XxHf7kRSwoajuIwa3
	 Ujyc905ybNZywFtGLTkBah+IXkE77OkkXiPpYXmEYlfdxlKc0Z1I7GbeoXgAdqGdFq
	 Ud3fhDhgR6TaS2tBa0g2Bs9HT+P7D/u3VfKU6ahTiBLS+o6QwtyVTC9kKFH/o7DITQ
	 hyzbIeRT2UYuPXhgbz5zLibVd9zmqTco4PC6YfAPGkNDQPpH5caSogYxLLZxlMDlBJ
	 bM9SJj1ApPd7w==
Message-ID: <sashiko-outbox-218536@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] jfs: refuse inodes with a negative size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261116-work-fs-sb_rdonly-fixes-v1-3-95a25ce917ad@kernel.org>
References: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
 <20261116-work-fs-sb_rdonly-fixes-v1-3-95a25ce917ad@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 09:51:22 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> copy_from_dinode() takes di_size as is and a crafted image can store a
> size that is negative as a loff_t. For a symlink that passes the signed
> i_size >=3D IDATASIZE test in jfs_iget(), so it's treated as a fast
> symlink and i_link[i_size] =3D '\0' writes out of bounds. Refuse a
> negative size when reading the inode like a corrupt dtroot.
>=20
> Fixes: d69e83d99cf8 ("jfs: ensure symlinks are NUL-terminated")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-work-fs-sb=
_rdonly-fixes-v1-0-95a25ce917ad@kernel.org?part=3D3


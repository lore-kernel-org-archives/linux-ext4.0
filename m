Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793328207;
	b=uvnEXkOz3p8kkwrlu9n+Cwm8sfYaZMf/1rZ78T0sAlj+YcLr9eekYNdMj6YFrND1PJv+
	 ecbTFUC8810TmPH3uijNeAs9JyQAsJrg0FDVJ3HCh4mZK0dvyBu3F7tubO3211WSywiX4
	 wxiUzsy1TN7zQz2P37BtltHT+Ewj1sTMsR5RuS0iZumNB92+v+wc4InypvzjAWtZuOAGQ
	 fOrSq+TG6TV+4PlwHuX4FqodR3+sMA9y6FuFOvMxZuZgUyofOyk0z5srwI/FF2FOah9xr
	 ipT8HE5IJgdevGzyK0T5lHmmFeZWdPvI9eafA4xiPRf8S2KEIVG4mtol/gmSq7SG0Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793328207;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dfFvLwxGVfuKBMMpIppG5h3zvFaom+3v8wAotvcU2uI=;
	b=VdYNw6rO2kSNo3ycMuyRsWEtyG4MXfkyeHSFeR//0NXxl7R/bLREsVdI2sWdL07Mwe64
	 dqnZ/v9O0VCcJu1lGtftWTAIwzQSdYNZ/U8Zkfy732tWezsO3iOhrQjEGpDIU7qoF9UE6
	 Iw2SwwoWxCSFO3ezwpcqqGR5C9GH54/+aNVjOy0FYOvuwQ35w/D+uV7a3tuGylSa2BFdK
	 zcb+Fh93d2yKbH99dCcObUvZ8FnkdWjyl9CiwyBPQRWRQtS5pqvV5ZsT+lMXEPU+VYlVZ
	 isyy7uLmx9rcZ9vmw0EZV2MLhy5c4PzXVFM7omar3cdmkQmn4kQMMvSepl2xtUMKNHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dyiHjc4E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94843606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 02:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dyiHjc4E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59481F000C1;
	Fri, 30 Oct 2026 02:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793328207;
	bh=dfFvLwxGVfuKBMMpIppG5h3zvFaom+3v8wAotvcU2uI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dyiHjc4E7jsu1eiwQlOHZM2yTwoLIiyl3wYEYRxN358aABVY45HGvyG40xczpgaQ+
	 n7Tg71GhTuj/OQdhy5HNCumG4Iz8vL7Alz41GlhA3DUSX4vCUTe0Sc+deMyNVA4lf2
	 CEqIPDeLF4ZBRAXDxLdgvKRCH8Ppwlg3cX08OY1EI+f+70FhU7QoF46lPU5KtIeXBN
	 2GoQB5wXA/McYVh/udoex6T9ZBZi4Rb4O9vegz0Nu3MlS0wiyIVdMhTfUP71QGGCbT
	 Cl9E4xZUS7tvDpmp6i8R0tV/VzdTZUmKK7GBlt8pGDhzRjYhJHsIameOaE0+qx485d
	 tdn9AcNuh9WxQ==
Message-ID: <sashiko-outbox-190180@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] ext4: add inode to orphan list before extent
 conversion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261030021338.1768292-4-yi.zhang@huaweicloud.com>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
 <20261030021338.1768292-4-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 02:43:26 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> ext4_alloc_file_blocks() zeroes the blocks it has just allocated and
> converts their unwritten extents in a handle started with
> ext4_chunk_trans_blocks(), which reserves credits for a single extent.
> The range is allocated with ext4_map_blocks() first and converted
> afterwards, and only the unwritten extent conversion which runs on I/O
> completion can modify the extent tree of that range in between, since
> this path holds i_rwsem. If such a conversion converts part of the
> range first, it splits the extent, and converting the whole range then
> needs more credits than the handle has reserved.
>=20
> Before commit 10660a0ca7ed ("ext4: rework handle credit accounting for
> unwritten extent conversion"), this race condition led to insufficient
> credits, which made the conversion fail with -ENOSPC in the middle of
> the range. After it, ext4_convert_unwritten_extents() can extend or
> restart the transaction. Restarting commits everything modified so
> far, so the extents converted by the first iterations reach the disk
> before this function adds the inode to the orphan list. A crash in
> between leaves written extents beyond i_disksize on disk with the
> inode not on the orphan list, which fsck complains about.
>=20
> Add the inode to the orphan list before the conversion instead and keep
> it there until i_disksize has caught up. A restart then commits the
> orphan entry together with the extents converted so far, and the entry
> is only removed by the transaction which raises i_disksize and i_size.
>=20
> Fixes: 10660a0ca7ed ("ext4: rework handle credit accounting for unwritten=
 extent conversion")
> Fixes: f7237a775c8f ("ext4: protect WRITE_ZEROES written extents with orp=
han list")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030021338.1768=
292-1-yi.zhang@huaweicloud.com?part=3D3


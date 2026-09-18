Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C51332861E
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 03:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789700822; cv=none; b=sLGmItzK8mmYyj+x2YBwpT56tHLTdAC/fYaZunEoL4KFzh9RWoqeR8fTKoY3mRvbXaHCVHTNkdcyNgLH52Vhdgn8CoUq3UhqQPht3PSwFd2uMX0deloFpr8a7+CmPyKPyNs+wl8bwoLxmSjyVwblrgk6JTGzDn03yFPlBvYa8E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789700822; c=relaxed/simple;
	bh=mbenqiTKtDk2vnEg1+Hzwp0QYG6l2RUGUu6yMMuxa00=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eiX9cK5Z6b98mCsaTgyurL3Byuzjjj4Bu0qJE1ZwQ54tXevFWIopy9hOMZ95naPdcXrj6VdfwFAiQDX2K6K/wXboJOV1wWWqMo3Xt1yzwGr4aGcdsB+qBA0s1Kqxtspugfvdon7XumGGuCQCKNfUeOuCQMkDveBPT6X5TYlj5jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEaMS62v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEaMS62v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DB31F000FF;
	Fri, 18 Sep 2026 03:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789700819;
	bh=3xrJBrLCjQnU/wy3cazo4rP7szkSVdb0VYunFgSNcWQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SEaMS62veTAUYSHxcqOY7kBXIFihXPLeWekz2svY+qZPqQzAa0hQ/5mWpLstLELc9
	 j36oUTiVcbHpouKioR6w5BiV3e/IEL/K9OHcqfydhEHtaqQKxBDBqYU5y+9axzXKFN
	 tXcmDKrfa8QH7igmYchBrsW9m7Ew8CUMZFnYUm21ry4D5Bdmg4VGbD7RSsgICH9qwk
	 bG1wQjVZ7l+Q56bk3SX9i82SbfWR4LdEuTqN896lVQ5bi1zyxk8wB3tg8pNzX42Br+
	 fozlujuRMUruadqU+cokT0fv+02TiLOIv6Z31lxlwgqaJM2bNRMvuZFHtSA99mUMIz
	 hXZoq6zLtDagg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix race between inline dir conversion and folio
 read
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sandeep Dhavale" <dhavale@google.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260918025416.604297-1-dhavale@google.com>
References: <20260918025416.604297-1-dhavale@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 03:06:58 +0000
Message-Id: <20260918030659.29DB31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Commit 90f097b1403f ("ext4: refactor the inline directory conversion and
> new directory codepaths") moved directory block initialization in
> ext4_convert_inline_data_nolock() into ext4_init_dirblock(), unlocking
> data_bh before setting BH_Uptodate.
>=20
> When block size is smaller than PAGE_SIZE, multiple buffer heads share a
> single block device folio. If a concurrent read on that folio runs via
> block_read_full_folio() while data_bh is unlocked and not uptodate, it
> locks data_bh and submits a disk read for the uninitialized block.
>=20
> Because ext4_init_dirblock() initializes bh->b_data without holding the
> buffer lock, the disk read races with and overwrites the initialized
> directory entries and checksum tail, corrupting the directory block:
>=20
>   EXT4-fs warning: ext4_dirblock_csum_verify:375: inode #...:
>     No space for directory leaf checksum. Please run e2fsck -D.
>   EXT4-fs error: __ext4_find_entry:1626: inode #...:
>     checksumming directory block 0
>=20
> To fix this, mark data_bh uptodate before unlocking it in
> ext4_convert_inline_data_nolock(), just like the regular file path
> does. Additionally, hold lock_buffer(bh) in ext4_init_dirblock() while
> populating the directory entries and checksum tail so any buffer
> modifications are properly serialized.
>=20
> Fixes: 90f097b1403f ("ext4: refactor the inline directory conversion and =
new directory codepaths")
> Cc: stable@vger.kernel.org
> Assisted-by: Antigravity:gemini-3.8-flash
> Signed-off-by: Sandeep Dhavale <dhavale@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918025416.6042=
97-1-dhavale@google.com?part=3D1


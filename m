Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1758E2DEA7B
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 00:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334183; cv=none; b=PAjWKhvXuDbDNp2cpN693GBpSrNvU/psuMT0nhsA536rwgx0TrjIBVcrr6i297D80Yz+i4SOkUnjYRwjHC931HFdNILywk6xUIl6WSlE7j5PtJtoi2DDI2hbZ2rv5Bq3iT4qznaglLTltmYsAF2b5Pig33Ikqr1b74t09KSOfCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334183; c=relaxed/simple;
	bh=Uus22tdTDsQx5ccJNv1LRveR35esFe69BDRjPCrv1qY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QjL7s4ZuXbb6xu52MHGVW5gQseG23aJwhrTSIysfUen9KTkj4jgJ8ZrbTYmvpIujB23PgzEOOwN7KpoE5b+rwa8btImA6fklB2pkLyET1uiDeGb/LxyEWrrFHHsQvMCwLSVQ+fDalwtthHOejStrSKZAVKWXh+vxbo4m4Qxi+Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4mkdf2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4mkdf2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9391F0089C;
	Wed,  7 Oct 2026 00:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791334182;
	bh=Uus22tdTDsQx5ccJNv1LRveR35esFe69BDRjPCrv1qY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J4mkdf2z6onTkySQpf1iSuDrsyWvKjS6tSQiQ833GsCGcusQ9qzWNQOmElCDtMNZs
	 AplO3mcNtN9E6RJGWrz/lLGySx8R4xN05def6BdfOVT7vr80uT7wa2qk+lDBM6lToG
	 CfUIJLzxQm5Uy/1lygSAoQNRTkaHMMFywpthiwoGnljDWaBxzRwfFuedfk1BDrevaw
	 gYsfies53gnlCbeOjcFHSGuLuGTO78rGUPOhlatzx0L3/C+BkIoPO1eiplM0TphYMv
	 D3cHS5OMaignAzwl/HrBB1/Bgn+7oaXC/tabyDoA2gInLRDu9dRAEF2YQ0cwU+RwFL
	 zzJqqp3ipU4Wg==
Message-ID: <sashiko-outbox-162553@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] jbd2: don't start a fast commit while the journal is
 marked empty
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261007-jbd2-fc-after-flush-v1-1-548bd91cd959@samsung.com>
References: <20261007-jbd2-fc-after-flush-v1-1-548bd91cd959@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 00:49:41 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Daejun Park <daejun7.park@samsung.com>
>=20
> jbd2_journal_flush() checkpoints everything, and
> jbd2_mark_journal_empty() then writes the journal superblock with
> s_start =3D=3D 0 and the fast commit feature cleared. It sets JBD2_FLUSHED
> so that the next commit writes the log tail and the feature back, but
> only jbd2_journal_commit_transaction() looks at that flag. A fast commit
> started before the next full commit writes its blocks while the
> superblock on disk still says the log is empty: jbd2_journal_recover()
> returns at once and the fast commit is never replayed.
>=20
> On ext4 with -O fast_commit this happens after ext4_freeze(), and after
> a remount to read-only, which flushes the journal in
> ext4_mark_recovery_complete(), once the file system is read-write again.
> EXT4_IOC_CHECKPOINT and online resize flush it as well. An fsync that a
> [ ... ]
> as it does for the existing check.
>=20
> Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-jbd2-fc-af=
ter-flush-v1-1-548bd91cd959@samsung.com?part=3D1


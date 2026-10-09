Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D364CB8BD
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791545124; cv=none; b=iMZo0Qaq0nYQ2Pe5r9K+Xn8lTJOCkzvI/rAMY/GdRXOTBsXeuStWkICeWQt+72gjrwgTPerZ42gWDjg5AsawINPQV605iHzNIe59ddPAv7XACAqmyL2lCO2u/YnJn9FLogyzwI69zcpyjeITR+GIL/16j0fnDPtqoATq+OA66fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791545124; c=relaxed/simple;
	bh=DHEXb5T137tWdodbm4FiEgqPkRKwDH0P7gf8LoejD3s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=S2BkW8Gok2JOlcH6oP4nFuXX/xsxCpW8cZsP2RA3pfsacJZb6VdLaFU8Pnko+/ipgcIMumKdGONA8vS1RtADDH8+n3SC8i3gV/+nrMlFP1hEdDH34+NvoFUzHQf5rXFhInMfmW2Ec3ggM28kuqTXokUK7bQK9eMUoZ7ON7HbUHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDxK9mOz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDxK9mOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358981F0089D;
	Fri,  9 Oct 2026 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791545114;
	bh=DHEXb5T137tWdodbm4FiEgqPkRKwDH0P7gf8LoejD3s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EDxK9mOzaDmYf5tyLatsZWaThWuYRg1Tqw57IZbBbRiMtTbn4fHnm3LNSz9ZsSDMr
	 7rgQdh/zyy2OYnQls4DcmG5LY1pchk8p1qbIHj4ZDUq37EmSXnuqTQZVVBcule+Na8
	 5PdvHEZrB8SXxnOAYEiCXb6GYBgljjjzSrPcQlKtMq8sXGlAlwA3zm9p2Wpvy8f5jb
	 NuQYRkl739bz6sx23nMRYEtWl/PDQSCWGd1oDdVfTa7dFzjnKoKl+yUf3KEqTqiEfL
	 MPqMWPaNiK4mPT97WirFiQIy+rlUiA7KHOi58mjzY+F4mZqdY5lqsLaF9ontjg8nWO
	 H+yRl50nhzt5Q==
Message-ID: <sashiko-outbox-165367@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 25/31] ext4: submit and wait for disksize-grow I/O in
 fallocate paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-26-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-26-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:25:13 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Collapse range and insert range update i_disksize directly under
> i_data_sem. If the operation runs while the zeroed EOF block is still
> awaiting writeback, i_disksize could advance past the zeroed boundary
> before the zeroed data is persisted, exposing stale data on crash.
>=20
> Deferring i_disksize updates like fallocate and zero_range is not an
> option here because the shift would move written extents beyond the
> current i_disksize. So flush and wait for the pending zeroed EOF block
> before these operations advance i_disksize. Since these operations
> already perform writeback, the extra flush does not add significant
> overhead.
>=20
> In addition, for ext4_update_disksize_before_punch(), if the punch
> discards the pending block, the zeroed data will never be written back
> before advancing i_disksize, so it is also necessary to sync the
> pending EOF range there.
>=20
> Finally, for the SYNC variants of zero_range and fallocate, this also
> guarantees the i_disksize update is persisted on the synchronous
> return.
>=20
> Note that EXT4_STATE_DISKSIZE_GROW_PENDING is not set for now, and it
> will be set after everything is done.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D25


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A49246762
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801363; cv=none; b=cSFxYtYT+pFvuyYSDXAUts91bNzcR5SDmQ06s8N0zaGma+1cLUoBiBcDNX/aRnh+urtywpxn6uHq5gM5d6cEcviCJ+iI0wtCkCQPOvEjiqI4RvOVzcplEzrwF26EexKX5388ewYY9IwcZiKx9OkIIAVfCxNEPA1D604F38uuSbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801363; c=relaxed/simple;
	bh=s0N8yYQ5eN0/qZTbOpPheyHr5Jfd0mTNfvpDCApfArA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=lyK7Jh1HSMviCNucrf/rBo40inPDqBZQt6KcAsiZP5xZADMrUc9smAsPsKtR5jnC1SuiOe3JPXflq/tXwsT3JAEAqQ5K9RCD428HHa31HZ2FQ6xmny2ZwvQYSTpP1/JDciPF+koOgZaH4vQC5A5zXNgu/nN/7lMe2RdwOups2u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D7QA///G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D7QA///G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883A21F0089B;
	Mon, 12 Oct 2026 10:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801362;
	bh=s0N8yYQ5eN0/qZTbOpPheyHr5Jfd0mTNfvpDCApfArA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D7QA///GJkekp+SgvIYgysbdYiCeqkfL9psB+T5OtLBj1TOf9Vx+2XrZkbhVa+zjn
	 kuGJ4DW8Xtr7bU6gmhzMpvkHZ+cnxGm4Cw7moIPe2I6rbHt3GBcBtM+caFvFKbuQmT
	 b+2SdDqZZS6minDV3O7HgoCGMXT95RDxeN9vJn6OMnOidqQ9l7rNMcw2HloDn97m/K
	 zq3sxJei+kNCRZUmfrRYRakV2VJmtq+LVj6F4XDaQxJDp5RUhxp5M/6JfD+fFFzX8g
	 jlvMQ4M46hWe4Q6citEYd1gcC17maItbGmLe7PWSD4hePDdipymgTMYUcMNei6XH6r
	 bTnLQ8iV1/mLg==
Message-ID: <sashiko-outbox-167968@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 10/28] hfsplus: don't set SB_RDONLY when creating
 the attributes tree
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph
 Qi" <joseph.qi@linux.alibaba.com>, tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-10-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-10-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:36:02 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> hfs_btree_open() sets SB_RDONLY when the map record of a b-tree doesn't
> mark the header node as used. That's fine while mounting where the
> mounter holds sb->s_umount. But hfsplus_create_attributes_file() calls
> it too when the first extended attribute gets set on a filesystem that
> doesn't have an attributes file yet. That runs on the live filesystem
> without s_umount and a filesystem must not change SB_RDONLY behind the
> VFS' back.
>=20
> hfsplus_create_attributes_file() opens a tree it has just created
> itself, with the header node marked as used. So there's nothing to
> check there. Only do the check while the filesystem is being mounted.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D10


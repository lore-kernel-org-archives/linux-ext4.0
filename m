Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0CE437469
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2026 11:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787225872; cv=none; b=FEpxfqEwH2tAbHaObNGANx2FXF0+xQ2C0t+wo+dkDeL8UWLHQPVB4KSG+Nv09aqQVJ7Vl3hYzdfY1xCRQjMjbEYhkSTZbkNTR1pKWjC2mNWSZO22Om5E65SFyWrm4fQh0iRAntS8XQD6c41TEprvxDAZeGv5isUbjSNmNTkmhqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787225872; c=relaxed/simple;
	bh=s9SYgDF4ElLBJ29p23oxSqcCDREhHWeI04FxIqtK9o0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WRIeBdiFw5VntS7I4qPzw/BVaKG2mup/zX/NmxRL8sEK3e5Waw0aaONpw6B4qzACLaMyziEW36UPX147mwrrEyFYmf678xb7Tl8P2aWefvMXQ4hoaRL0VSWKlNuVP9uCS8j4PdueeNhVxN5HpsfKx0xUDLAFXVHX08TB/6S8D8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZQWgcU9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZQWgcU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FC31F000E9;
	Thu, 20 Aug 2026 11:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787225871;
	bh=s9SYgDF4ElLBJ29p23oxSqcCDREhHWeI04FxIqtK9o0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eZQWgcU9Hk3+XzPpZSEk9OYkDG6TQ1FEduvy1Hc+Z94sg0sc5YGzluItr1SG9SxcG
	 TwJuX1HPvTOFz8TehyWulHzzIfJ2cTcWGrLcTIf1457W/AUTzeF+NY2CAcgl62VSK7
	 ED/HTZxlr2ckbrs4uTSHvkC/wFV4150VASHYkG8LsOWiXj/NtF+KT1JJJzS6CDhjhV
	 +EdFU4PxS8i7RkaW9hFlEvNgEMzmhKNQbivPzcNX/p5nyUNbqSKFVi9/DDX7NUAPy4
	 4jderNq2/sxnT4a1Q3SSUJD6eAMupgNm7EykhFl65X93C9w8uWVGNMiz+qCDiCYN/a
	 x2Pe2Zfg6yeBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND] ext4: Avoid entering writeback paths during
 fastcommit replay
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Kara" <jack@suse.cz>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260820112532.757055-2-jack@suse.cz>
References: <20260820112532.757055-2-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 20 Aug 2026 11:37:50 +0000
Message-Id: <20260820113750.C9FC31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Fastcommit replay effectively happens in nojournal mode. This results in
> ext4_mark_iloc_dirty() setting I_METADATA_WRITEBACK flag and as a result
> we end up entering filesystem writeback functions. However during
> fastcommit replay s_writepages_rwsem isn't initialized yet and hence we
> crash.
>=20
> Fix the problem by avoiding setting I_METADATA_WRITEBACK during
> fastcommit replay. Journal replay flushes the whole block device after
> replay anyway so all metadata is properly persisted and replay is faster
> this way as a bonus.
>=20
> Fixes: c26339e1df33 ("ext4: Fix data integrity writeout issues in nojourn=
al mode")
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260820112532.7570=
55-2-jack@suse.cz?part=3D1


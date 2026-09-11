Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEB23EC81A
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2026 03:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789098254; cv=none; b=ENW1uBZepBvKfCksCMjaeXjJWHESfzGmTmNBdKXp4r21NINU3KQ6L97iwxcLGBSOm3gc62zii00bjNVUxl9yruWv4hiehTVTcRS8SpQZCXzAWkkzTP8RysyUAVKbZb6uB7JEBqRl5e20g1xZIChy6V5EOOllQYMf9mgGQ2VYwkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789098254; c=relaxed/simple;
	bh=SOY+1unyUA8L22v0uf7tigaq8RC71eMqwyGvzPjJY2A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lX4OWRcFrZYNAO1JYM5AicGsC2UIF4XTx+7iMDJTGCXxmIV8Ed6iYKK6E1WhG5hoNgtJdSHuvEFjz3RCMJWMahF6foSSKvpaylYeYDIPsO7iZzoUw171wXVuPh3POzlTJ6TrdHor7mvO/hVX6vInpIymbEsaEXfZ0m8xUM7aS5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9EYHcqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9EYHcqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B66B1F000FF;
	Fri, 11 Sep 2026 03:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789098252;
	bh=CuB2mBk6OxD9zE48Vd39vg5aZ7O+W77uc73JQGVom4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n9EYHcqucke6cHaYjGO3dAOKsXGwq1foGayP0n7mlN0W6/jpnCXUIFhjOyNg9XVjn
	 2ooHx4Lb09Hx0558Xd/xrC7T1hnLErTuhcC7gvZs1/E0YJGvNFocDdU7aOWZeFGQio
	 9XF4ShcuB0vI8e0XoTn8R9j/mbLl/+pXWBHWe1yJnTkEYMgBEfUoDAfmXszb+zZBtY
	 +QbDKrfBO1v49pusbFgYlyIYoKdsrzDUZEBsN5vNVmT63bEeBZIEQU0FToST9cDSAa
	 OB0E8Km+THX0MoQsd7Q1+HJuHix0h4YkpDwx2JLR5qY20M8nuHVspPNQXuFC1sIwmf
	 bKCYojP3zUckQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: move orphan tracking away from journal state
Reply-To: sashiko-reviews@lists.linux.dev
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <67ae57ef2ee3ac27ab844c22594351c83142d86f.1789097450.git.jonaszhou@zhaoxin.com>
References: <575wyoks3ldokhrg6v43rxwsegaecod4bgrpbii6jeczy7czbi@a3yq26u52orp>
 <67ae57ef2ee3ac27ab844c22594351c83142d86f.1789097450.git.jonaszhou@zhaoxin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 03:44:12 +0000
Message-Id: <20260911034412.7B66B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Moving `s_orphan_lock` introduces new false sharing with the hig=
hly-contended `s_es_lock`.
--

commit 269f37a627203c8f7267166bbe89e9f2dfb71db7
Author: Jonas Zhou <jonaszhou@zhaoxin.com>

ext4: move orphan tracking away from journal state

Move s_orphan_lock, s_orphan and s_orphan_info together below
s_journal_triggers to separate orphan-list writes from journal
and flag readers.

Link: https://lore.kernel.org/all/575wyoks3ldokhrg6v43rxwsegaecod4bgrpbii6j=
eczy7czbi@a3yq26u52orp/

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be613..1669109149731 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h

[ ... ]

> @@ -1786,6 +1782,12 @@ struct ext4_sb_info {
>  	/* Journal triggers for checksum computation */
>  	struct ext4_journal_trigger s_journal_triggers[EXT4_JOURNAL_TRIGGER_COU=
NT];
> =20
> +	/* Orphan inode tracking */
> +	struct mutex s_orphan_lock;	/* Protects on disk list changes */

[Severity: Medium]
Does moving s_orphan_lock here introduce false sharing with s_es_lock?

On 64-bit architectures, s_es_lock (4 bytes), pointer alignment padding
(4 bytes), s_journal_triggers (24 bytes for a single 1-element array), and
s_orphan_lock (32 bytes) perfectly sum to 64 bytes. This places s_orphan_lo=
ck
exactly in the same 64-byte cacheline as s_es_lock.

This can cause cacheline bouncing during concurrent operations modifying ex=
tent
status trees and orphan lists, such as parallel unlinks.

> +	struct list_head s_orphan;	/* List of orphaned inodes in on disk
> +					   list */
> +	struct ext4_orphan_info s_orphan_info;
> +
>  	/* Ratelimit ext4 messages. */
>  	struct ratelimit_state s_err_ratelimit_state;
>  	struct ratelimit_state s_warning_ratelimit_state;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/67ae57ef2ee3ac27ab8=
44c22594351c83142d86f.1789097450.git.jonaszhou@zhaoxin.com?part=3D1

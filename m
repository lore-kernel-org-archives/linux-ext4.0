Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F814E36F4
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730872; cv=none; b=nQ1F5mFJA0JGhVBILBdwE9HQBZmCcHeFiovMy34NpMSI5zjblbvpunDK9ZWxhug4tUPRZMZSHLd2l2KkvkA2ceCLZhC1QBT7mb7A2Hp6krukSDDlzTvy1wIJzWL/AnPzvnAmYsrtpGJOn3DGj6oNtYOy8OpsbjbKXkrZq243fPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730872; c=relaxed/simple;
	bh=mtm4osIbVs54Czt57C9cWvIgXeMnWXXS/hfhMst8XQw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uB03iqY6/TxpzkmyUez7TSlS3+N217dcYXVlIP91XYea63RkAXjWNoXBw2CPysCEMrORahWExyzY3ZAGSXjh5QH3F6vbdQW4obuwNBpJLHrKtUJIILqqrUHf89Q52g489U4I5TS4eMn6jmcljAYQzgulzaoMtLtU1K8xuSigrEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTKVryLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTKVryLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBC01F000FF;
	Fri, 18 Sep 2026 11:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730870;
	bh=mtm4osIbVs54Czt57C9cWvIgXeMnWXXS/hfhMst8XQw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RTKVryLJKN5xzM7AwnVLIEOmjqrs8i0fl/Bk894yYb6bYD0fJgrvTguVE9En9yeWa
	 hU7WgCE89Z9KjeufHnKaeYcZzWGwj6HVak2gmOVzq24xmWmAc3sL3YVaznGRCdLXYM
	 HiUWArt+1VujlDgdEmN4xUDb5Pm7r3GVGkgvCX2bH3APma7XnSy4a8qubGMtS9Rqnn
	 gA1+aIjB09p6K5sWpkhx6B4Z7CznRei4+gQufD+rubcaUepweg+tkuZN8hGTbhueM8
	 zNeULmVmUCEpnmK/EyoqZkurRXDXqvqpdMdtfeJlymSUvRpbtWXRU6CmJTPnYWw7eN
	 /dxTIBgRhoPZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 08/21] xfs: don't allow to enable DAX on fs-verity
 sealed inode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20260918111539.1003439-9-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-9-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:27:49 +0000
Message-Id: <20260918112750.5EBC01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
> inodes which already have fs-verity enabled. The opposite is checked
> when fs-verity is enabled, it won't be enabled if DAX is.
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D8


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C340311946
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 07:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235842; cv=none; b=f3FZ2i2amXZO5XSKP7wE53Bx5+FpRQDhByLwXXj4LndK9PhUNodxspqMacmg//RRrHqGr3IzJrTmANd1emFGn5kUo8W9DUbxFVce3ZfIxAOEhA2UcWGO9eiidOG64DZd9/ZYXdKj2OcEEgZ1JHImxSV1iV8QjRmtPLBCAXWCleI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235842; c=relaxed/simple;
	bh=7sO4geK/eHZ6KUYtWuM3NR+11ftrV8o5r65NYqinIuc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Mmj4uq3l8B5BMlkAeW3ixfV+MpTuJU7Scsu5YoTevEeHYZ8HaQgULoUr69pDnyqzM4y1dEKHZQ7TNpqBA/W6qoGL4lwaaucEkpLW3k++4gBeS3SY2rY9rvNhpWE7A1vEKQHtAJjlnAgNcNrJNsrNaRzDXYTlt65dAUyCRvMtmYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAKw9pgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAKw9pgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C46D1F000FF;
	Thu, 24 Sep 2026 07:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790235840;
	bh=1BFMSdrhgDQWlt1z+xk1qi9vaRFJkzmAeMx9OtqIyAs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gAKw9pgJUVxsKiTvGjA7Rf8uwy0aeAmBl162zNMBkxkeMppbxDubsCO2BOLFxsRXC
	 23Xcg0iBeYx+gjsJp5QuWLM6WKlyPmEnN69GWPRf0cY6iaWDu1hvQPTM61xmJayZea
	 FqdhE2/0oX0HhgYm5uFzrjd3SU2RI72/szUnkjuR8cB66UaMjfImzuid89FbSQxnA2
	 SKvrrlFbiE7vz2/ngIiLoAxUpzUVD6I7YIZ/H1Gpta9H2/zRn8pjHurq46MVALbxpc
	 bpu098On4tAGMdXi3FRPfjkAX7K7GxC0Ol424LtJ1cvbgNwamCmr4HKPkh72efe6+8
	 KOT+A4p5/aNCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: Fix sparse warning in extents kunit test when
 EXT4_KUNIT_TESTS=m
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260924073929.2594339-1-ojaswin@linux.ibm.com>
References: <20260924073929.2594339-1-ojaswin@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 07:44:00 +0000
Message-Id: <20260924074400.7C46D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When kunit tests are compiled as modules, the extents kunit test emits
> a sparse warning:
>=20
> >> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
>    declared. Should it be static?
>=20
> Fix this by declaring it as static.
>=20
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversi=
on")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609221900.Pgwrcp41-lkp@i=
ntel.com/
> Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924073929.2594=
339-1-ojaswin@linux.ibm.com?part=3D1


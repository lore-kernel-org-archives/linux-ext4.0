Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598D253A3BB
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 11:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790076236; cv=none; b=oSFkCwKr2+2TLfckWMNe8K8qaTMHMOnUWHSpix4oTj5f8xx1nKaaIsPqjmB1EZ02Jd5XGe21jrq0oI8ZClzSrtweN6v5yiangTlGLXdzu9cFajH2zuoWIyUBvmUoMjY84NcETmrNPMPw/TTxi9g5FBaSV9tdf81oNdROCz2kukc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790076236; c=relaxed/simple;
	bh=77933v84byz2wlKch3YIvHjplvDiRwaV7nMrXyA7htU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Jn6P+M5vT3xfRVZpxxb2npeOOY7s7y3LAtae72vv0YmSS+ENDAp0J8KBL2wEg9WJLTo3F/vNOCs//wwOocHgmm5RgSj35eGA7PfRqOc3g10zWJYmQIUDay+mTuFPPXHkNXM9DZir8F3QWmAht8Jsg333yURDHYGQx92g7cDoxvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwpSnosG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwpSnosG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD6A1F000FF;
	Tue, 22 Sep 2026 11:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790076228;
	bh=77933v84byz2wlKch3YIvHjplvDiRwaV7nMrXyA7htU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dwpSnosGnlvkQUvpfUfSdP/XdAZpHzRhJBxzSsqB5FMuLIkz9sX4HayxoPVUQb3sJ
	 yoqCnodef7xzRvT9lcIhpeyHv3R00bq9Qj6m30ojz5nPJPoKlBjR70q0XkNW6zYBxU
	 QdcL6uC+OORCEEZ0h9CxPBYJARSPNpOQv1VK/+aUNOEJpLIu0WKx8DHWu0G8yxzCE6
	 GoyLDU7nHUp9dJYW/0rJYdZs25isRZBrAt+DyQZzCs8IQbYmsF0V4fkyyB5CZALBIf
	 fn7El0stbX4nrgMQb3GBmaqklAV9+Kkj5LsgxIT/ujyRapywtL/aT5XQI2PRBDLWra
	 zFy6PA+h7WTjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/4] mm/truncate: fix data loss when splitting
 straddling large folios fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260922110703.468389-4-yi.zhang@huaweicloud.com>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-4-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 11:23:47 +0000
Message-Id: <20260922112348.1AD6A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
>=20
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
> [ ... ]
>=20
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922110703.4683=
89-1-yi.zhang@huaweicloud.com?part=3D3


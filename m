Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F0042A80
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2026 04:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788063713; cv=none; b=az/YnZDsH2ywfvGC1DrSgTmQICzT3xrxDGa+45G/4Puo2+ZuKRzuaQ/gzT1ty5n4z/o69sS0hUGCyQMXgvqRH15pnk1WrZZH18tVPTclRJF8q/5Mf8b/G5lQ122PON6DJhP8ZWzvLbACN5ZDUglS3Hi/s1rYR0kDyvr6zWngYFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788063713; c=relaxed/simple;
	bh=SZUo0DUyH+hz2mCwZ61kacTcNwxdUn6/B7nNaEOpW2M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UIjnbDrzjZ7BLcH07t+GGt7+QCita7Zh/1t2bvHZfJqJzzW5pOP73VxpKdM8Qmhv1q1gk77QBAVEaPkkEOITLvLRfzgRKxThGv+m+q6/UDiKovj5UI1vkkXaVslSn6duWR4bT49ldh4HnsM5OEK4Xvgc7fFbleqk6DcYkVv/LXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIa78UFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIa78UFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890DF1F000E9;
	Sun, 30 Aug 2026 04:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788063711;
	bh=DM272UDCTp9eJ9keIxy8WtgTEohoXCC4UpqUsGFYeqo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QIa78UFQKXkg+daup2+YpI4ww6CLAhVbPN0LD7tYSrqaB5KMnhN5UTLT6fViRCRJ7
	 B5boRZS1ozx5/A1MkzUFVHbobzO+sBmHzXuCLlGXAud9Y6ETw7hHoO6AVfwF5byN+x
	 lnAokcgCU69+2XEMdmCRH4q1amPzXfLPOkxL1zadjPP/9ZhZ2dZxuYKqZsCys4EUzM
	 7Jy29riRPUhO9EZ+6y8Md6BvN0k8lDLVrZY2gaVKqqxOg1OiF3a8yL6reqEHzuOSW5
	 MdWdpr2GVngkdo0X9pEwU3QomhjbCoUbLaW4TzAFkYlAlb4n83FSgP2lisRxM3NCrr
	 2LIO+JY/yLdqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/9] mm: Improve memalloc_nofs_save() documentation
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: linux-ext4@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, tytso@mit.edu
In-Reply-To: <20260830041901.2668-2-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-2-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 04:21:51 +0000
Message-Id: <20260830042151.890DF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Talk about why someone should call this function instead of
> what this function does.  This makes the long comment in mm/readahead.c
> obsolete; replace it with a comment about which case we're protecting
> against.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830041901.2668=
-1-willy@infradead.org?part=3D1


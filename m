Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA2721767D
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2026 04:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788063869; cv=none; b=ZnzUG897BA8pab06AFZWPURYsk4wxsdQCy5tg6HcyLxh5/c/JzRJr00kSfdTKGbsCP2YbdgMcUg2elL4JVe54xLKialRnNksST7JnviojcGIYZ9UplQiSuoQWPw/7E/9IJapJJFizF8W5OKSQ80T93F25S76N75Si1hHr/RIX7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788063869; c=relaxed/simple;
	bh=+iT1CJOMXE8WmBgfdf7Jz55secF0Wz1jyZfC7DIPP+w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P8sQ6xmvMPSBMPihzAJgmDzSRXzAYgCoptbp3XhlYKD1or2r/n6CEymxD5p1SVRSTS5puRo3Wf5kni0WUC+ii0rlzXtyy4CVUGNRiz+6b0KrFL5VQaaXJ9AhRXwElxRv8Hvi9fvIDcViGafvNZUrpo2eNXCw9bzcyNAwIbF4wmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxqL8LH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxqL8LH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82721F000E9;
	Sun, 30 Aug 2026 04:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788063868;
	bh=+iT1CJOMXE8WmBgfdf7Jz55secF0Wz1jyZfC7DIPP+w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RxqL8LH+krEP2ZIlm8OIBQl5d53bH2RWM+pvRYOidZOz02eAhhlC9Fy0T5AUY5Etg
	 /DfeokvYVHFhl6bl0/ZHFr60YKLoC7EQBDXzZcZlXlF8eVa2HprOduqw0XwxWzB1bF
	 DZmh/L5aHiVLJUdcIRyRqFa0KxcixFo/pVOa8c/NF5KJfH01griwOBcCrQr9ds7DEj
	 SpbiWJCJ7Bwm/wCefWgVgU/CaBw5YIFI5q1GjzoRcqwd6ao9523YnNWA7LbHqOcPYP
	 zfzFQTw51yoX97sV73bKQRDBJoY0ENBIK6z5XchohSt+2I7aGFoTaEZnUfRuoQTVFg
	 /RhEcpEv763Cw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/9] erofs: Remove redundant FGP_NOFS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, linux-ext4@vger.kernel.org, tytso@mit.edu, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20260830041901.2668-4-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-4-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 04:24:27 +0000
Message-Id: <20260830042427.B82721F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830041901.2668=
-1-willy@infradead.org?part=3D3


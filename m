Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAB9369D7C
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 07:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335639; cv=none; b=u/TeOhMwPFvbTUvUmGNJVWeEnolU5rGdwPDheLdailM3LOAA5YezPZ87JViifqJBneDkvFueKkOkqRnHmQ0DBIvR66lATttCHfZnkWBbYy/0gAAZX4n4PUXbQsOste8YHEJFE9kqAzaiilxOXibeqCk2vOyrwIJPZtS5GCzzBUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335639; c=relaxed/simple;
	bh=pkfAnh0EZY0z4RW9LQJK8NUPKO010WT7NVcVeoGNeUk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xi83EUqyCZqDrxvohEpNrE4GdFiw3shWdgPt1Cpkth0ZzN1q1465CNWadinICrZJYwtMJbKfDiW1yLcX+/0XraQXr7viarxXzOj4DVotQZWKt6055Vkawjd3KRw65W4vwgtNqLxCxMh0pZL3y+3xYOKxL0tclN10nlEHehAWeug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5p7wGxQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5p7wGxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591081F000E9;
	Wed,  2 Sep 2026 07:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788335637;
	bh=pkfAnh0EZY0z4RW9LQJK8NUPKO010WT7NVcVeoGNeUk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K5p7wGxQCGQn1Bo8ow5hjrPXchp1fgFf7v7dKQPTqNI05A5I9XKP9y3oPGkVAP675
	 vjI8rH6FeKlEsaPwyYT8taJCHMFSJ0iDGmkekOIsOLAqWsTyP61IprVtdMazebZk+f
	 UN5AUC9ClPnnFqtKTRHVaJ69oYsSwdMVqos83CDp5QAJRFWs8fUlf0hgep5l32UYxr
	 IZy/YfTnnJtvcLIcoCKGPDGnizSIBwf5JjPijN7RSGzHrXmK4BQFgXZpho4HNX4N8l
	 Y3OFWiXdGa4jU6djbK8egQbjbqJh+Qe2YPZjpvoOE0BD7C+RuwReZONGj8vv86sXOa
	 OS34TinMI2H0Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/8] fs: Use acquire/release for fdtable resize
 synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260902074805.398540-5-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-5-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 07:53:56 +0000
Message-Id: <20260902075357.591081F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb()/smp_rmb() barrier pair with
> smp_store_release()/smp_load_acquire() on `files->resize_in_progress`.
> The flag is the publish point for fdtable expansion: writers clear it
> via release after rcu_assign_pointer(), readers check it via acquire
> before rcu_dereference_sched(). Observing it clear guarantees the new
> fdt pointer is visible.
>=20
> This expresses the pattern more clearly and allows cheaper one-way
> barriers on weakly-ordered architectures (e.g. arm64 STLR/LDAR vs
> DMB ISHST/ISHLD).
>=20
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902074805.3985=
40-1-ruanjinjie@huawei.com?part=3D4


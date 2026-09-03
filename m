Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4AA4AF174
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442748; cv=none; b=byeKjNjD9lpy5M/CXUW+sYW4IlEBMX/BC0FnB7+V6FP7PLqgZccU/LxwSvjefQUQ+AywuySdSybLbzopI8og610WICC0m3Y+agyEotSg+ummYv/Q/kbsBVEA1nP7AyA8NmQNuBS7qulfmgjHrUhTZ1sQlo+72q/2NjKPBaWAyGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442748; c=relaxed/simple;
	bh=5rluBUucoJpCYEQT+H+eVyDssyYwK3LTx2J+8a62HQQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OlliJ+0rfwAE35RJLXMlntrAJ1CfnBRX8rpI16SPxlZGOs8VD4PkPUg0BtONy5nNV1WbmNPoyqg38CL4vFArW7pUDhhQAjP2gcjA6WcuuFIMjltesf9l9ksiaR5miKKRB0ZIajW2aLEx8VwPDANimgB4cYOZbfas25ibRqZ2Rvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oagclufz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oagclufz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3981C1F00A3D;
	Thu,  3 Sep 2026 13:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442734;
	bh=5rluBUucoJpCYEQT+H+eVyDssyYwK3LTx2J+8a62HQQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oagclufzlRVthvsFJQeI2cOp+sF1Rx4M0FuJyV30QtomxOVgzSeYNZAmIAB/+080e
	 uc8oWCAGw5TRqhR2yIyEZhVmzTZVryTF9Z2U0wwa0U+2ZAPebIT7jSnT4lESwZKSGd
	 tCCKgCHdGjBjnwhe88oohF9Qbxnpyql0jrceoNsUSbQbxKi0v6QGaj+jttPvupx6Cw
	 1Gt2y2mEXOBXqN+KC6jlKhr2+YvWwrO/8EFv67H/CL9OUkJY8J5AlHLEidNQGm7u4d
	 kx1JDOtfFTuiTYaL78lsqfHOwzXtF7OojWWlOUvnODQcSmoqx5MuYM27B32OT9/7XE
	 Uzzl4pkmJ2nwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 24/31] ext4: defer i_disksize update while
 DISKSIZE_GROW_PENDING is set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-25-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-25-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:38:53 +0000
Message-Id: <20260903133854.3981C1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Operations like append allocate, zero range, and truncate update
> i_disksize directly. If the new i_disksize exceeds the original value
> while the zeroed EOF block is still awaiting writeback, metadata may be
> persisted before the zeroed data, exposing stale data on crash.
>=20
> Defer i_disksize updates while EXT4_STATE_DISKSIZE_GROW_PENDING is set;
> the ioend worker for the pending block will advance i_disksize to i_size
> once the zeroed data is written back. The tradeoff is that i_disksize
> may lag i_size transiently, but this is observable only to callers that
> read i_disksize directly.
>=20
> Introduce __ext4_set_i_disksize() to centralize the bit check for
> callers already holding i_data_sem (ext4_ext_truncate and
> ext4_set_inode_size), and refactor ext4_update_inode_size() to take
> i_data_sem itself and check the bit atomically with i_size_write(), so
> the ioend worker observes the latest i_size under the same lock.
>=20
> Note that in the O_SYNC mode of ext4_do_fallocate() or
> ext4_zero_range(), we need to flush out pending blocks that can update
> i_disksize synchronously. This will be handled later, and
> EXT4_STATE_DISKSIZE_GROW_PENDING will also be set after everything is
> done.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D24


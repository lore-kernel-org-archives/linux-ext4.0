Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7D33A963D
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703161; cv=none; b=k4CuedsmXmY08jue28qxNJz6/fnX0KyjhArRta+3EQdHw4lm4DW22I8MAPe+cerBDI4bdFaVc9AoSDpDsV9D0y93MIgKkvt3cxAGp3M5ak3+aYoNPwCESXnE6osOkiAOxY2NMu2apI4XV6xJiyhChSI3/paoo15T2vtttiT14x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703161; c=relaxed/simple;
	bh=7C24C1jqjz87vCXRVkh1g+l2uEKer/mH5iAt+P8s9GE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ISmZrLGZZPm3IOezkeK4GlBu3tkN0N2oiZ4ks1zH28KXkkJNjuIZ8u1b/9WHA/V2IJZSsRE/xeN+fxXNP3TtuyWq3ENvJXxIQle8zF09+5vVXZFO7nL4lQBhjgiBvDqzyLDNXrFvMnoHodrfV2BE84RBH14TPoMh3Sfc5jEFUpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXvjLLeB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXvjLLeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85101F00A3A;
	Fri, 14 Aug 2026 10:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703146;
	bh=WklkWhoAa0K75dygoqBYUFSR13OEGTFYORS+qJ3nifo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NXvjLLeBifHZ3VsWloeZyPJV7usbNyNviP3suHnwD1oMzZpWrOLb/EZMVk24Uluix
	 sR8//ShLvKlNbK53r/i/vqFE31qxM+FDRHWoks6b9f59P7qcnpdY/42iQVpIcNiMth
	 ij/6YsIFpNGSWU0ia6kvjcjljsVhQ0BkqsWBkRWoEpcVVkVcswqcQvNruS4gjqkwQG
	 3WkHyHh03TZvz0SJeGTmF07mA8AVmYj6xdB5ISlv3ZF1Kr3VBXQhy55docuzmtjJ4U
	 FlFgMkvY9OoD1Otr4ao3qWa46muC3ZVWkYImV/sbMX8d1FQ3K34ByWopl/s85wOm3O
	 ji2uNQE2yNKSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 24/32] ext4: advance i_disksize to i_size upon
 disksize-grow I/O completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-25-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-25-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:25:45 +0000
Message-Id: <20260814102545.E85101F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The EXT4_STATE_DISKSIZE_GROW_PENDING state bit is never set anywhe=
re in the codebase, rendering the entire disksize-grow logic and safety mec=
hanism inert.
--

--- Patch [24]: [PATCH -next v5 24/32] ext4: advance i_disksize to i_size u=
pon disksize-grow I/O completion ---
commit d834c25602b493451d52cc75b3ae8fd40461bce9
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: advance i_disksize to i_size upon disksize-grow I/O completion

This commit updates the iomap writeback path to advance i_disksize to i_size
upon completion of a disksize-grow I/O. It introduces an is_disksize_grow f=
lag
to ext4_iomap_wb_update_disksize() to trigger this update safely.

> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 955ff88045db6..4f1176b9332f2 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
[ ... ]
> @@ -589,9 +589,36 @@ static int ext4_iomap_wb_update_disksize(handle_t *h=
andle, struct inode *inode,
>  	 * i_data_sem.
>  	 */
>  	down_write(&ei->i_data_sem);
> -	new_disksize =3D min(new_disksize, i_size_read(inode));
> +	i_size =3D i_size_read(inode);
> +
> +	/*
> +	 * EXT4_STATE_DISKSIZE_GROW_PENDING is cleared when the pending
> +	 * I/O completes. However, another thread may have re-set the bit
> +	 * between that point and here, meaning i_disksize has already
> +	 * been advanced and a new EOF zeroing has been initiated. In that
> +	 * case, do not advance i_disksize to i_size; leave it to the
> +	 * next pending grow ioend.
> +	 */
> +	if (is_disksize_grow &&
> +	    ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING))
> +		is_disksize_grow =3D false;

[Severity: High]
Is EXT4_STATE_DISKSIZE_GROW_PENDING actually set anywhere in the codebase?

It appears this state bit is never set, such as during EOF zeroing in
ext4_block_zero_eof() where there is a TODO comment about tracking the
ordered range.

If the bit is never set, ext4_test_inode_state() will always return false
and this safety check will be bypassed during concurrent fallocate and
truncate operations.

[ ... ]
> @@ -607,6 +634,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioen=
d *ioend)
>  	loff_t pos =3D ioend->io_offset;
>  	size_t size =3D ioend->io_size;
>  	loff_t end =3D pos + size;
> +	unsigned long io_mode =3D (unsigned long)ioend->io_private;
> +	bool is_disksize_grow =3D (io_mode =3D=3D EXT4_IOMAP_IOEND_DISKSIZE_GRO=
W_IO);

[Severity: High]
Is EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO ever assigned to ioend->io_private?

Because the EXT4_STATE_DISKSIZE_GROW_PENDING bit is never set, it seems
ext4_iomap_get_disksize_pending_range() will always return 0, meaning this
io_mode flag is never assigned.

Does this render the entire disksize-grow logic inert?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D24

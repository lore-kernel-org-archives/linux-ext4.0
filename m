Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C0E5013A4
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 21:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631946; cv=none; b=QOtHZqvgWaWf88HC9UKfFY3ZqucYeEl1q7kfKzBOslCkLzOrZXAOPXoOedJ6CSMc7NlAKYhJVJ4bbxIANHs/vhky6BTEPzw3iYrJ4+0G8yHM8PEIdF7L+/4jLb9uZxYhX6PfIB9kSslSacFC+hfQdd+rW7x3wtMJ8eDvGLzs0Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631946; c=relaxed/simple;
	bh=0+YekPL/lpcBzowdgbwfyyMcw7o6Qp68cyk5tJ493So=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M+C5JQYWRlSHRzOWiyj5VUmsvo5SCf6QMuhmKWaAp0tvRP9VJrv8xgSia6CXjb0x1i+zKzmJee8YH/RnCVETsVCO26YNSDLXpIkVPkImXcHfjjBDFRgcZz6DuLKIoKIRFsfiWfalyRFRiH3hI8/fvGazTCh/ZhYGtWPonqO54OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxEoVVwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxEoVVwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFDC1F000FF;
	Mon, 28 Sep 2026 21:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790631942;
	bh=LQ2xzC2MkN9zrs34FZJr4k8zU0q3o6eN71WoAS7yHiQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nxEoVVwQk0ti4wvc1J55Or/VyVXSzgtn4rGPeMbg7adqyrkV9emS10cCkmhCeLZCa
	 TUR3FzMSrU4sBjRj7qm9zW3WMoz1DlBQLYKabqlu4zrrDqEEznb8Cc1QKxaSfCpLoC
	 kwbGFPRMIFzTI0VcPf1bD+dVTUMy6Tfbv0NYnkx1UyTiBuQuD0BNnQ7GLbOFtmSKMN
	 N3PrqXyaBoeX6WGL1ynZ6adezdaZnaMOCfH+FQ1TgBLTuYTp837HbTgMKGm5thACgO
	 yfhuqtobuLXL0Q7DVeDnAAfioUh8uk2FNg8gipGlBG+eTW7izeDHRtnFdtqJDx0kAV
	 EVE3xURz4zeJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] ext4: Expose the filesystem encoding through sysfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gabriel Krisman Bertazi" <krisman@suse.de>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260928213155.2612039-3-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-3-krisman@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 21:45:41 +0000
Message-Id: <20260928214542.2DFDC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: NULL pointer deref in encoding_show() via dynamic casefold
--

commit c325498f77eea14582e06218baa713f49fde001a
Author: Gabriel Krisman Bertazi <krisman@suse.de>

ext4: Expose the filesystem encoding through sysfs

This commit introduces new sysfs attributes in ext4 to display the active
filesystem encoding and encoding flags. This provides users with a direct
interface to check casefold support without relying on dmesg parsing.

> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index 923b375e017fa..bc1c59d67eed8 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
[ ... ]
> @@ -161,6 +163,25 @@ static ssize_t err_report_sec_store(struct ext4_sb_i=
nfo *sbi,
>  	return count;
>  }
> =20
> +static ssize_t encoding_show(struct ext4_sb_info *sbi, char *buf)
> +{
> +#if IS_ENABLED(CONFIG_UNICODE)
> +	struct super_block *sb =3D sbi->s_sb;
> +
> +	if (ext4_has_feature_casefold(sb))
> +		return sysfs_emit(buf, "UTF-8 (%d.%d.%d)\n",
> +				  unicode_major(sb->s_encoding->version),
> +				  unicode_minor(sb->s_encoding->version),
> +				  unicode_rev(sb->s_encoding->version));

[Severity: High]
Does this introduce a regression where reading the sysfs attribute causes a
NULL pointer dereference if casefold is enabled dynamically?

If a privileged user dynamically enables EXT4_FEATURE_INCOMPAT_CASEFOLD on
an online filesystem via the EXT4_IOC_SET_TUNE_SB_PARAM ioctl, it updates
the in-memory on-disk superblock representation but does not load the
unicode map into the VFS superblock:

fs/ext4/ioctl.c:ext4_ioctl_set_tune_sb() {
    ...
    if ((params.set_feature_incompat_mask &
         EXT4_FEATURE_INCOMPAT_CASEFOLD)) {
        enabling_casefold =3D 1;
    ...
}

In this state, ext4_has_feature_casefold(sb) evaluates to true, but
sb->s_encoding remains NULL. If the sysfs attribute is read,
encoding_show() will unconditionally dereference sb->s_encoding->version,
resulting in a system crash.

> +#endif
> +	return sysfs_emit(buf, "(none)\n");
> +}
> +
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928213155.2612=
039-1-krisman@suse.de?part=3D2

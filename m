Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC0E3E765A
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801903; cv=none; b=sZQp4zAuCoo2PRp8C16LNaH/IMwhvpAASQBcgIozlAyfhyyqUMn9Mxjbrl6OydX71tao8V9kN2wljaWvFQZEx0D8/J95PpJztKWnDEy2SH66JapiShsoPoD4QvXB1P2zWx3FxALYAUtivyLYCdvA/8ObprSGtJ9Jcsjqz/6JrNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801903; c=relaxed/simple;
	bh=NrvBjZCrVktikmScU31w7K/+35/ngupauC/phPgtvbc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UeROoLlMZvH/w94apaJa9Ik8jXpvkZuy4xTt/ovYjwk/YsReRlJswDJiVJxwqB376DPzTe+grOBXSJ4tdz2WiBnOnPeAaENI+Zda8CLu7VD/17TjKuXayrweMmqlnefK2oM1SIpKAK/TtlegaH3km+Ak0lRa48joCxpfVnzuhYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WxcBfBM+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WxcBfBM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61231F0089B;
	Mon, 12 Oct 2026 10:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801902;
	bh=IWatrvur3fNn6I+B+2/h+1MPjB3vk6pOU5amApuNidA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WxcBfBM+ZP7fZod5TIuWWaG0ncrJf2eswyvM6rzAAtvksdgdZY1dE/kXwFWHHeg45
	 L5uwF2l14beP4xJzRT+jHYBOrfrHEQfUtUgvkqS4U4xjc8HYDbkqcIJqSp4FxtItw3
	 cGy9iWQ5D6Mha5rY1COqfuxcA6Cp50XYeBpjUbQymnk374HT9rYbI3L8olLdO/fBe0
	 1t19FZtOeFH/zneIXlJyrXYmrtgs6AOGdKDZYem0D6ssjUNO/VzKUTmtVO986OYtkf
	 IznasOoqVCJrsA7z2SWujrGVpKpPGOSqbHLyQttWtIsVW8b81Bml7YL5S0V5FUV81f
	 M4oGf4mHenwfg==
Message-ID: <sashiko-outbox-167982@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 15/28] ocfs2: keep options that can't change on
 remount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: dsterba@suse.cz, tytso@mit.edu, "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-15-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-15-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:45:01 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ocfs2: TOCTOU lost-update on mount options during concurrent rem=
ounts
--

commit 113bf3bcf65b6ea75a7b673818520d321b5bd39c
Author: Christian Brauner <brauner@kernel.org>

ocfs2: keep options that can't change on remount

This commit fixes ocfs2 remount to inherit current mount options so that
unspecified options are not dropped or reset. It copies the current
options into the fs_context during reconfigure initialization.

> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index c62e389d4dd65..26041371a6667 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1213,6 +1213,20 @@ static int ocfs2_init_fs_context(struct fs_context=
 *fc)
>  	mopt->resv_level =3D OCFS2_DEFAULT_RESV_LEVEL;
>  	mopt->dir_resv_level =3D -1;
> =20
> +	/*
> +	 * Start out with the current options so that a remount only changes
> +	 * what it specifies. Emergency remount (sysrq u) passes no options at
> +	 * all, and the heartbeat and data mode can't change.
> +	 */
> +	if (fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE) {
> +		struct ocfs2_super *osb =3D OCFS2_SB(fc->root->d_sb);
> +
> +		mopt->mount_opt =3D osb->s_mount_opt;
> +		mopt->atime_quantum =3D osb->s_atime_quantum;
> +		mopt->slot =3D osb->preferred_slot;

[Severity: Medium]
Can this lead to a TOCTOU lost-update on the mount options when multiple
remounts occur concurrently?

If two threads execute sys_mount() with MS_REMOUNT simultaneously, both can
invoke do_remount() and locklessly read the active osb->s_mount_opt into
mopt->mount_opt in ocfs2_init_fs_context() before either acquires the
s_umount lock.

Both threads will parse their distinct mount options into their separate
mopt instances. They then sequentially acquire s_umount and apply their
changes in ocfs2_reconfigure():

fs/ocfs2/super.c:ocfs2_reconfigure() {
    ...
	if (!ret) {
		/* Only save off the new mount options in case of a successful
		 * remount. */
		osb->s_mount_opt =3D parsed_options->mount_opt;
		osb->s_atime_quantum =3D parsed_options->atime_quantum;
		osb->preferred_slot =3D parsed_options->slot;
    ...
}

Will the second thread unconditionally overwrite osb->s_mount_opt with its
parsed state and completely erase the first thread's updates?

Could this be avoided by using a mask to apply only explicitly specified
delta changes under s_umount instead of snapshotting and rewriting the
entire state?

> +		mopt->user_stack =3D ocfs2_userspace_stack(osb);
> +	}
> +
>  	fc->fs_private =3D mopt;
>  	fc->ops =3D &ocfs2_context_ops;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D15

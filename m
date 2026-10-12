Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B4A3AD531
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802359; cv=none; b=jc10mPRrDkbc16q7tEbxEQHhEbQ2Bat69CcFLQek+66uyS9bFaUd/Ywc/W/tGyJYz5LQU/TD4NnoFc+qp9aGd3/5ldDu0p2uiaSSTzfYCSN1TAJp4ZUrQA+vvl8HAu3SmkGVKRBvyp4UEFBqk0YL+K9jzCa2Q8sRVFCS3YfoScQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802359; c=relaxed/simple;
	bh=JtslYwdRI///bhwxdL70ghcKm6AokddrfPUhJi6Ngd4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ObuEdljtA328i+HU29E3OVIaV+B4vYrVbCxVlhPKes3X/aMNMWPhfHG2XQUGg2Qibs1fwEy2jr3vUL1610NmKY9EFr+XgZUdNpzieDfAigzfGsZRoVIC+xfEhWBere6xpfGWPcyeJWYM1QuJ+hk5tcrTDP+5TI4YA76Xs8LJCx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlb5YIxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlb5YIxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27B01F0089B;
	Mon, 12 Oct 2026 10:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802358;
	bh=aY4+qE5wOexxWmRRemMmNnTcs4nn3PoSOIxOtwMarjg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nlb5YIxJ+prwz3tlEbAqbAbQ9No/yjX43mA0f+Fn+DdWMLnVaMsosSBJe1nMXGTVK
	 H0p3P18hN/DaTuUO88HXlMjxTaVEOwEvCEvMTkE4hIOQJ9gXrtbX22+OMab3vQBFZQ
	 nhGCEY/QJuehXrQMS27iYmuwqGVs1cQHs9b1f4R+qu+vMsg3CA6gIeeRgOMqK+5rwS
	 3s88qD2TBvdwEEV8pPA2Q5c3Mcr82FhRXX0qSKVgoYHthM4dXNGV7UjTL91HRA3Bog
	 DqN8e2lJ+YGFva2FQ2OvUbp37doWj+ubqg0gfYahBSJsdYGUtkL0SJ2OAa5a7kz57b
	 dBcdBhR0DVfEg==
Message-ID: <sashiko-outbox-167991@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 22/28] efivarfs: stop using SB_RDONLY for read-only
 efivar ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Joel
 Becker" <jlbec@evilplan.org>, tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-22-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-22-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:52:37 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] efi: NULL pointer derefs in efivar_lock() and efivar_set_variable_=
locked()
--

commit 8baf8c78bb84688313f856459551571bca3c4964
Author: Christian Brauner <brauner@kernel.org>

efivarfs: stop using SB_RDONLY for read-only efivar ops

This commit introduces a private flag EFIVARFS_OPS_RDONLY to track whether
efivar operations are read-only, replacing the use of SB_RDONLY. It aims to
resolve freeze and thaw deadlocks caused by concurrent modifications to the
superblock flags.

> diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
> index cb1b6d0c34545..a074145fa57e1 100644
> --- a/fs/efivarfs/file.c
> +++ b/fs/efivarfs/file.c
> @@ -23,6 +23,9 @@ static ssize_t efivarfs_file_write(struct file *file,
>  	ssize_t bytes;
>  	bool set =3D false;
> =20
> +	if (efivarfs_ops_rdonly(inode->i_sb))
> +		return -EROFS;
> +

[Severity: High]
Does this lockless validation allow a race condition that leads to a NULL
pointer dereference?

If a user-space process initiates a write, it evaluates this check outside =
of
efivars_lock. Concurrently, if a module like tee_stmm_efi is removed or
fails probing, efivars_unregister() may set __efivars to NULL.

When the racing write thread subsequently attempts to acquire the lock via
efivar_lock(), it does the following:

drivers/firmware/efi/vars.c:efivar_lock() {
    if (down_interruptible(&efivars_lock))
        return -EINTR;
    if (!__efivars->ops) {
        up(&efivars_lock);
        return -ENODEV;
    }
...

Evaluating !__efivars->ops will unconditionally dereference __efivars,
crashing if it is NULL.

Alternatively, if a generic_ops struct lacking a set_variable callback is
registered immediately after, efivar_set_variable_locked() executes:

drivers/firmware/efi/vars.c:efivar_set_variable_locked() {
...
    setvar =3D __efivars->ops->set_variable_nonblocking;
    if (!setvar || !nonblocking)
         setvar =3D __efivars->ops->set_variable;

    return setvar(name, vendor, attr, data_size, data);
}

This attempts to call a NULL setvar pointer without validation, which also
leads to a crash.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D22

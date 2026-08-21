Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D46F39A7EA
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2026 10:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787307609; cv=none; b=IdIHfJNu6+7fASS/dkxcYRpZhqHi1SRLcaxYj8sK0B1msVGJDL3Un2fKtRIdHl3bLHWLukxemkRPTSggHWKZbymPil+opws1aCTdJ1mMUGprDbaRgYdQ+hS7MVi+NrDhIkpfG5Ea3lv/xbsTJ1ISDlJGJhWGhoxr66jN+jTEGLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787307609; c=relaxed/simple;
	bh=5xY0PcNvC3MokMwym9wuv0vXcAS/hCSK3G8qxuTzUQw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mJLl9RsiTtIpD74axoiKLLYMvlpc7Fks1V9AZWoZPU0735eM+wU5GAWifL8Udpe5vmduSXdjRCgIYBl0y5sOwfaz+fl4MBbBw8BXcyQ922+KFDDJDBjZ2+O5nLnNDMzmQSAsw9kGNI7NIkmAssXRUXwIzUXeNtkjHNg36YLn6/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+PXDxnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+PXDxnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957471F000E9;
	Fri, 21 Aug 2026 10:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787307597;
	bh=39gxWFQc+2XMK3IrOgUlYZcrT7tqlDSK7pKGEEAT9pg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B+PXDxnUu0X8k+t6zTbBhFuvO2tEn+UOvBNV051O0qX4JHbqivFQ537VpyXiTPrI6
	 NixveZM1M0RSBW/y2WoyIK5n06Id4A5CDJdKmMHG9r+glGqfg0E5Hc/0e2cp4HlsfW
	 XXpfiHeFWN18j5HQtrc0kMkQvOJFiEtttKOKaGx5bgVw0xaGPUpICjXdnc0RvTUSSY
	 miDu1EPE45M0uI+BtOQDACzETvCL6cSaSkpfTXH33IQ1KFcIhVe+7JJ8yGA64FKtra
	 TfxmY2sWZ4M8aSw1cc3eyd3pBCNCABlqB7YYKV4OAaGVmGKor1boeIae2NYlH2Ejd5
	 5RqSfUopcegoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: validate extent root during fast commit replay
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260821100559.3612643-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260821100559.3612643-2-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 10:19:57 +0000
Message-Id: <20260821101957.957471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Incomplete fix allows type confusion and out-of-bounds access =
for indirect-mapped inodes during fast commit replay.

Pre-existing issues:
- [High] Pre-existing error pointer dereference leads to a guaranteed kerne=
l panic, exposed by the new validation check.
--

--- Patch [1]: [PATCH] ext4: validate extent root during fast commit replay=
 ---
commit 03dbc5f9111ce7346c9dc6815dd71904c9c82a55
Author: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

ext4: validate extent root during fast commit replay

This commit adds extent-tree validation for extent-formatted inode roots in
ext4_find_extent() during fast commit replay. It prevents out-of-bounds
memory writes caused by unvalidated extent roots with invalid entry counts.
This addresses an issue where ext4_iget() skips normal validation during
replay.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 559100f3e23cd..50484f7c3f25e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -850,6 +850,13 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t bl=
ock,
>  		ret =3D -EFSCORRUPTED;
>  		goto err;
>  	}
> +	/* ext4_iget() skips extent validation during fast commit replay. */
> +	if (unlikely((EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY) &&
> +		     ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {

[Severity: Critical]
Could scoping the validation to extent-mapped inodes allow indirect-mapped
inodes to bypass the check?

During fast commit replay, ext4_fc_replay_add_range() unconditionally calls
ext4_find_extent() without ensuring the inode is actually extent-mapped:

fs/ext4/fast_commit.c:ext4_fc_replay_add_range() {
	...
		if (ret =3D=3D 0) {
			/* Range is not mapped */
			path =3D ext4_find_extent(inode, cur, NULL, 0);
	...
}

If an attacker crafts an ext4 image with a fast commit log containing
EXT4_FC_TAG_ADD_RANGE for an inode lacking the EXT4_INODE_EXTENTS flag,
this would bypass the new check and could parse unvalidated indirect block
pointers as an extent header, potentially leading to out-of-bounds access
on EXT4_I(inode)->i_data.

> +		ret =3D ext4_ext_check(inode, eh, depth, 0);
> +		if (ret)
> +			goto err;
> +	}
> =20
>  	if (path) {
>  		ext4_ext_drop_refs(path);

[Severity: High]
This is a pre-existing issue, but does ext4_find_extent() returning
ERR_PTR(-EFSCORRUPTED) lead to a panic in callers that check !path?

For example, in ext4_fc_replay_add_range():

fs/ext4/fast_commit.c:ext4_fc_replay_add_range() {
	...
			/* Range is not mapped */
			path =3D ext4_find_extent(inode, cur, NULL, 0);
			if (!path)
				continue;
	...
			ret =3D ext4_ext_insert_extent(
				NULL, inode, &path, &newex, 0);
	...
}

And similarly in ext4_ext_replay_update_ex():

fs/ext4/extents.c:ext4_ext_replay_update_ex() {
	...
	path =3D ext4_find_extent(inode, start, NULL, 0);
	if (!path)
		return -EINVAL;
	ex =3D path[path->p_depth].p_ext;
	...
}

Since an ERR_PTR is not NULL, the !path check evaluates to false, causing
the path error pointer to be dereferenced when passed to
ext4_ext_insert_extent() or when accessing path[path->p_depth].p_ext.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821100559.3612=
643-2-Jeremy.Jean@oss.cyber.gouv.fr?part=3D1

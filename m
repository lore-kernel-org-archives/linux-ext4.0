Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3B633BBCF
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2026 10:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787565703; cv=none; b=EJPbahYQW220s+CMcvqPhAk8j9z4EpNuch8iDsSy4CJzZOUxkr2amusffRTcBsey7AHvSBMJCMtE23aLnrfb2pp0+GY+W2UcirSzYHwL1JlWm6ptXzGxD6DRMjFdbSAbu89NZ5iOYxaWe1AOsGeaLbMHsJKbumHiKvxzk+jEP7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787565703; c=relaxed/simple;
	bh=1Ww6f99ovnnaaaMlRSoZWofDYR8h/NE9j2ZDD/CF5DU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m8AyBIgTJGR7I5xoXiRKw1/MxLAYHuE30pP9IruL6PwUcGAeVRH6ftKXIy7J4cq0kcFhLf5XmINihLQKyTT25io4EWu3V3pyD6s65BUmaa24PSq8pXEAyuRbpF5PNzHp2hEoJvy+ZYret+7g2CSUncSmbabRlIdd7/aWCWbyQxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVgbPYow; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVgbPYow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E351F000E9;
	Mon, 24 Aug 2026 10:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787565701;
	bh=Sk9xc+sbYUCVPCpKkVtDKfhwHxvXJhwv+REc7TbUPLc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KVgbPYow4Du0ySzXohOkWiKM5yxucGKVzAEng7vSf8t+ixbOuvw5qlSrtnIWce8ry
	 zADmDHE5HV9kDCtGzr9O0d3bLkmX1KFPwqt4nGO45Ujv1e2kRSEN+t7RcZ9LrhdB1F
	 vtPDcsyNogpNSnYs4nmWqPOaPT7yUyb3V0mC2ZeZxn1OTFBp7O2DbehBQGaW/LXsTJ
	 j8w6qPv5L4pArnV3ODbOe9KeJJ9gdF2szYKmvj/BwOG0fupDmhBPdPSyQ4UG9/GZLs
	 hMNZOdgr+HMgdy11FmDLlpbxOCw4A1QBYbP/x230/n3BOUNn1WRvMngdijENPUOM4W
	 kzSn6HsNthzHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: skip extra isize expansion while unmounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hemanth Selam" <hemanth.selam@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260824094512.2436628-1-hemanth.selam@gmail.com>
References: <20260824094512.2436628-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 24 Aug 2026 10:01:41 +0000
Message-Id: <20260824100141.86E351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete fix for a TOCTOU race condition that can lead to a NULL=
 pointer dereference during unmount.
--

--- Patch [1]: [PATCH] ext4: skip extra isize expansion while unmounting ---
commit b6a44628f998028bf5040431bbd5fcff301de3c8
Author: Hemanth Selam <hemanth.selam@gmail.com>

ext4: skip extra isize expansion while unmounting
   =20
This patch attempts to fix a warning in ext4_xattr_inode_create reached
during unmount. It declines to expand the extra isize when s_root is
cleared during the dcache shrink but before SB_ACTIVE is cleared.

Closes: https://syzkaller.appspot.com/bug?extid=3D4b03894b6ec5753ddf24

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bd4b778df9eb2..6e523a5c8230e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6598,8 +6598,14 @@ static int ext4_try_to_expand_extra_isize(struct i=
node *inode,
[ ... ]
> +	 * Skip it while unmounting as well.  shrink_dcache_for_umount()
> +	 * clears s_root before generic_shutdown_super() clears SB_ACTIVE, and
> +	 * the last iput() of a lazytime inode in that window redirties it and
> +	 * lands here.  Moving xattrs out to a block then needs a new EA inode,
> +	 * which ext4_xattr_inode_create() refuses without s_root.
>  	 */
> -	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE)))
> +	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE) || !inode->i_sb->s_roo=
t))
>  		return -EBUSY;
> =20
>  	/*

[Severity: High]
This isn't a bug introduced by this patch, but does checking s_root here
without synchronization leave a race open during unmount?

Background workqueues like rsv_conversion_wq and s_ea_inode_work can
process inodes concurrently with unmount. They are not flushed until
sync_filesystem() and ext4_put_super(), which run after
shrink_dcache_for_umount() clears s_root.

If a background thread sees a non-NULL s_root here, could the unmount
thread concurrently clear s_root right after? The background thread would
then proceed into ext4_xattr_inode_create():

fs/ext4/xattr.c:ext4_xattr_inode_create() {
    ...
    ea_inode =3D ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
                              S_IFREG | 0600, NULL, inode->i_ino + 1, owner,
                              EXT4_EA_INODE_FL);
    ...
}

If s_root is cleared by the unmount thread just before this dereference,
could this result in a NULL pointer dereference on s_root->d_inode? Or if
s_root is cleared right before the warning check inside
ext4_xattr_inode_create(), wouldn't we still hit the original warning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260824094512.2436=
628-1-hemanth.selam@gmail.com?part=3D1

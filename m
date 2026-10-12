Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491063A9635
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 11:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791803103; cv=none; b=BdrIzksayIqpV4Y0poKMCF5q7HqvQ/7Ue/5S1W6PEAnqupGkX5OcVwvIHxPX14/rSO+cP+bfiqVzLjq7w//dvSYkpnUIR8NyJORlpoliHvqnjqrqd6L5HvCv3TUaiMuOSTjQjkb9AgEvAcavZNn24C37ASH28WHl9hRsYMCfcws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791803103; c=relaxed/simple;
	bh=IuHjotWLFoEv/owwi/ZdsTQ7+hxbd8/jYpBo0k8P7x4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Z7z058b346huZvo6xXRRdwZP1kuquxfMGCB4HmA491YXvjSY3Tf+BFdMVD5HVhlaaNFNqfTJr5O/fDeYFFvLwuHy/AoiB6jRh908HeoLRLoM23jw3j7Vj6Sm6woxZmd5B2Hw3fQWVKqU5e1xDQqFLYDgneWgTmPSMMViEWjw96Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ckx9rEeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ckx9rEeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB861F0089B;
	Mon, 12 Oct 2026 11:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791803101;
	bh=uWthotPLuDYrrBFrHiKjlD1vtZQRinyOI+J9Ca2T+7o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ckx9rEeRgWb9PHNhZ8yuu17VOORkMCbCg0rUy9G/4CFfgpQ9CuXLTy+CIXKZLzgiT
	 xiHZ9khHu97Q05FtKWrFwrGXLIvlZm8kG2KcecyuNPHRCewTiVX9H7dLeY23cKZC86
	 X2FWJjyqGWGKewyT3gJ7fubilrFMkQLvArF77hVPNOv5Jzd9GMcn2p+UmzL0xko7Wc
	 qM4IWMyvPiG/pAzEeu336N8GJhI6dwhB5yleU6bZUjzZVD2wE6OZLGPi4deP6jw1IU
	 mRMBhYmH9MacenkfQZtfQShOWSm26lGr1MG8zw/DenKcb869IuOMNWLRzblxfbdzv1
	 /kMf/u33opcmw==
Message-ID: <sashiko-outbox-168003@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 19/28] btrfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Mark Fasheh" <mark@fasheh.com>, tytso@mit.edu, linux-ext4@vger.kernel.org, "Joel
 Becker" <jlbec@evilplan.org>, dsterba@suse.cz
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-19-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-19-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 11:05:01 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] btrfs: inconsistent SIGBUS in page_mkwrite during emergency RO s=
tate
--

commit 37c3f7ad9f2e4471edb125849f5c833765177985
Author: Christian Brauner <brauner@kernel.org>

btrfs: don't set SB_RDONLY after filesystem errors

This commit changes btrfs error handling to stop setting SB_RDONLY without
holding s_umount. Instead, it relies on BTRFS_FS_STATE_RO and a new
BTRFS_FS_STATE_EMERGENCY_RO flag to block modifications, keeping the VFS
layer under the impression that the filesystem is read-write.

> diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
> index 9aee0e0d7e85f..99cdd5f5a1111 100644
> --- a/fs/btrfs/messages.c
> +++ b/fs/btrfs/messages.c
> @@ -171,8 +172,16 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *f=
s_info, const char *function
> =20
>  	btrfs_discard_stop(fs_info);
> =20
> -	/* Handle error by forcing the filesystem readonly. */
> -	btrfs_set_sb_rdonly(sb);
> +	/*
> +	 * Handle error by forcing the filesystem readonly. We don't set
> +	 * SB_RDONLY because that requires sb->s_umount, and changing it under
> +	 * freeze_super() and thaw_super() leaves the freeze protection
> +	 * unbalanced. The fs_error recorded above stops new transactions and
> +	 * BTRFS_FS_STATE_RO makes btrfs refuse modifications, see
> +	 * btrfs_fs_rdonly().
> +	 */
> +	set_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
> +	set_bit(BTRFS_FS_STATE_EMERGENCY_RO, &fs_info->fs_state);

[Severity: Medium]
The commit message states: "And stores through shared mappings set up before
the error get SIGBUS because btrfs_update_time() refuses now."

Does removing btrfs_set_sb_rdonly() here lead to inconsistent fault behavior
for existing memory-mapped files?

Looking at btrfs_page_mkwrite() in fs/btrfs/file.c, it calls:

        ret =3D file_update_time(vmf->vma->vm_file);
        if (ret < 0)
                goto out;

Without SB_RDONLY set on the VFS superblock, mnt_want_write_file() no longer
fails immediately with -EROFS. If the inode's timestamps are already current
(for example, if they were modified very recently), file_update_time() retu=
rns
0 and bypasses the filesystem's ->update_time hook entirely.

Could a store silently succeed in dirtying the memory page under these
conditions (with data later lost during background writeback), instead of
getting a SIGBUS as described in the commit message?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D19

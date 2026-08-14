Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B17333F5BC
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 05:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786684422; cv=none; b=pPcn6XfrhcT47NrX5Fh7BR6qVcsmXfdpBHIosc4sxKTwBhyILyTeO9u6jC7+bNyJ1P7KnrM519jAgsBCfnLUdABpMjPMoXfDnCd9Scf8083ww9ZaWpAgelN2hIbLrRW0bw4fdI2Ij1V1G1dOzH3BL3cVOGGLjkAAW7KN+ncdFkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786684422; c=relaxed/simple;
	bh=lfyYjWvLD4nTQ0sDKhHRqWcOcdL/Pz+uI/e3+oerMXs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OGqBJwEUWG/kHuBT5us2IKiO14tbxmdmOnkGXbE8aSeqPc/07bR+NWAGk9T+SUIS8I93CzfxUMzTVkWGUHDX3cGfD4mYSOGMp7XalPJVDaW39aYf3vdQ/qFhieh4z7T69RIzx1BuWGj3KGnjLX2eU+4iWKutLbkzVvRuek13RLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REXzq2Hz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REXzq2Hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF3C1F000E9;
	Fri, 14 Aug 2026 05:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786684421;
	bh=KLgADcU4K/J9xkPczYwnuyweVqsTl/PBz1ghLbIssw8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=REXzq2HzFXtP32+TbEyZNlSUdeSQDPKdF4R3mxm/XRfLB0qRcpDbBNuLdEtWsED4W
	 brGH9wILBb36fHpd3gPmgy1xiWJGo2NtFw/MK210Ws9iJxD/GbQD19ARfPFYUs8Klb
	 o4lzlehwzeVB2J8pN6ChI4xSLbUev0TDrcdH8oPWMQwY+xEipQFzRqWo3UZtlGy4rp
	 epr1rtLpKrLk7ZtI/qOUlz/6rRIC2Qrz+GqOBm/pZDTtxEABz0Mav638FXeRETttbX
	 R9gQm3LoEUJdDCa50gOuERJS6yFPv+6PLNNEX70BZXRSzLxPHF1NG/xFYsWvAKigHf
	 o5qSypXhIj9JQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: reject delalloc to nodelalloc before applying
 remount options
Reply-To: sashiko-reviews@lists.linux.dev
To: guzebing <guzebing1612@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814034855.1573759-1-guzebing1612@gmail.com>
References: <20260814034855.1573759-1-guzebing1612@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 05:13:37 +0000
Message-Id: <20260814051341.4AF3C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch incompletely fixes the TOCTOU vulnerability and resource=
 leaks. Post-apply validations in `__ext4_remount()` still expose transient=
 invalid states during failure paths, and the error path restores options l=
ocklessly.
--

--- Patch [1]: [PATCH] ext4: reject delalloc to nodelalloc before applying =
remount options ---
commit 3e2a754f5c730db5d2d9a5a35cc756e9e8b67276
Author: guzebing <guzebing1612@gmail.com>

ext4: reject delalloc to nodelalloc before applying remount options

This patch rejects switching from delalloc to nodelalloc during remount
prior to applying options. This prevents a race window where concurrent
truncates observe nodelalloc and leak reserved data blocks.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index bca0dc87d0b7c..ec21ed1cb6ded 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
[ ... ]
> @@ -6688,13 +6696,6 @@ static int __ext4_remount(struct fs_context *fc, s=
truct super_block *sb)
>  		goto restore_opts;
>  	}
> =20
> -	if ((old_opts.s_mount_opt & EXT4_MOUNT_DELALLOC) &&
> -	    !test_opt(sb, DELALLOC)) {
> -		ext4_msg(sb, KERN_ERR, "can't disable delalloc during remount");
> -		err =3D -EINVAL;
> -		goto restore_opts;
> -	}
> -
>  	sb->s_flags =3D (sb->s_flags & ~SB_POSIXACL) |
>  		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);

[Severity: High]
This is a pre-existing issue, but does this approach leave other mount
options vulnerable to similar transient states and lockless rollbacks?

While this patch successfully addresses the delalloc to nodelalloc
transition by moving the check to ext4_check_opt_consistency(), other
validations in __ext4_remount() are still performed after
ext4_apply_options() has been called.

For example, if a user mounts with nodelalloc and then remounts with
-o delalloc,nombcache, the nombcache check in __ext4_remount() fails
after delalloc has already been applied:

__ext4_remount() {
        ...
        if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT4_MOUNT_NO_MBCAC=
HE) {
                ext4_msg(sb, KERN_ERR, "can't enable nombcache during remou=
nt");
                err =3D -EINVAL;
                goto restore_opts;
        }
        ...
}

This creates a window where delalloc is transiently true, allowing
concurrent tasks to create an inode with delayed allocation and reserve
data blocks, which could leak when delalloc is rolled back to false.

Furthermore, the rollback at the restore_opts label:

restore_opts:
        sbi->s_mount_opt =3D old_opts.s_mount_opt;
        sbi->s_mount_opt2 =3D old_opts.s_mount_opt2;

restores the mount options without acquiring the s_writepages_rwsem.
Could rolling back options like DIOREAD_NOLOCK or DELALLOC locklessly
cause data races with concurrent writepages operations, potentially
triggering the WARN_ON in ext4_add_complete_io()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814034855.1573=
759-1-guzebing1612@gmail.com?part=3D1

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4174963BA
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544842; cv=none; b=ttcgTGOaX492RalWZtkFsfMMShsLuDjsAeJYKNBVgrRjmt3uV/fZo9l9ig1/YCj2E6Se5WRVrkDleBC7aYIXxC3XnM0xYMG5pzFS5yjho9op9HJVvp3DFLBTdxhbGxSZBIEM+rSPtt4n8g6I/38xOjoEBrfu8VS3GxacePyCuVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544842; c=relaxed/simple;
	bh=HwkaABU1g6aM81MNCBPuQpxUALdS5e5zXIafjB2/XdI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QVK/tSEpq7YAiCDTTjbNlmuvhzHqJIXAOu2orWY+uOX0FTstB9FF/bjMCnvOzQfOdnoyogXhfcYapNqgiZ/xQxhlBOZ6HLYFAnoeNXqxbrCCllon0hUwRHRhKt+T3DXFoDXPFqT3KiYBeddrN1aflGtbe5wU8ZIdMtnerMzSMaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2rEIF6Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2rEIF6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915E91F00893;
	Fri,  9 Oct 2026 11:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544832;
	bh=0bTattFDdh75HF+h0XbtSQv10PVmC+MuL22XLV6hkbc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e2rEIF6YjjQfusFIYS9hLIbe53377ShZO5iFLhIgMBJhBeb1liEWgUnF8b4f9awBD
	 kPiE2/zRKJFA1GhQ3a6RTCEgrRoBwhzNDdv13ROQzHpyojMr4QXbqlsk+yxTcKS2/+
	 Qb/N0Od1RHyceXSe7EGyuVRegJWbST3O2QOM+8x03y9Lr5FAdkxYGQKMZifsKWeL6C
	 5wCuaygx3x7aEpXRezHaHk66+ffO6cGch6Atg5X8/2NybX421EEMpp+zS5UEutIla/
	 HAeFfRdn0HCtmZuvLBAU3i8l+gR7PXvpIkO3oC3yy1RSOtpmeHNMdbcfpnStLbtyZH
	 KynELOGxshKuQ==
Message-ID: <sashiko-outbox-165354@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 14/31] ext4: rework handle credit accounting for
 unwritten extent conversion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-15-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-15-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:20:32 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: atomicity violation in fallocate extent conversion
--

commit 352cf8eb3125c707efc06205d4a61cc670cd67bf
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: rework handle credit accounting for unwritten extent conversion

This commit updates the unwritten extent conversion process to handle long
merged ioends. It introduces a check using ext4_journal_ensure_credits to
extend or restart the transaction if credits run low during the loop.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 76038b6c36552..83d040e36b682 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
[ ... ]
> @@ -5137,27 +5137,36 @@ int ext4_convert_unwritten_extents(handle_t *hand=
le, struct inode *inode,
[ ... ]
>  	while (max_blocks) {
> -		if (credits) {
> -			handle =3D ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> -						    credits);
> -			if (IS_ERR(handle)) {
> -				ret =3D PTR_ERR(handle);
> -				break;
> -			}
> -		}
> +		/*
> +		 * The caller cannot know how many extents the range covers,
> +		 * so make sure the transaction can take one more extent,
> +		 * extending or restarting it once it is full.  The reserved
> +		 * handle of the buffer_head writeback path is safe as it has
> +		 * enough credits for the conversion, so it is not restarted
> +		 * here.
> +		 */
> +		ret =3D ext4_journal_ensure_credits(handle, credits, 0);
> +		if (ret < 0)
> +			break;

[Severity: High]
Does restarting the caller's transaction here break atomicity requirements
for fallocate?

ext4_alloc_file_blocks relies on the atomicity of converting unwritten
extents to written and adding the inode to the orphan list. This prevents
e2fsck from flagging initialized extents beyond i_disksize as corruption on
crash.

If the transaction restarts during this conversion loop, the first batch of
converted extents is committed to the journal before the loop finishes and
ext4_orphan_add is called in the parent function:

fs/ext4/extents.c:ext4_alloc_file_blocks() {
    ...
    ret =3D ext4_convert_unwritten_extents(handle, inode, ...);
    ...
    if (new_size && converted) {
        ret2 =3D ext4_orphan_add(handle, inode);
    ...
}

If a crash occurs after the transaction restarts but before ext4_orphan_add
completes, will it leave the disk with initialized extents beyond i_disksize
and no orphan list entry, triggering filesystem corruption warnings and
silent truncations in e2fsck?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D14

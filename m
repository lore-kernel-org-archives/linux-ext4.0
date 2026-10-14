Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E7E1A6839
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 02:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791945768; cv=none; b=BNq5YqoTVTMHAo8fnL31mkJc/e/nkgdXGELTrSrNxXbqTY/JtyF+wjrHonKfY/H3ali1Yn1+wkPJu9/muTpuHAoflm/5O1SNVfSoS0gqHHcuACKLnPSPDPSxW7l3s4Wpvhp5P4LinWDlxQ8NTib0qhlvyRV42zuQ+57JG8vmHp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791945768; c=relaxed/simple;
	bh=KaWKQszewjsTZFHvwo0M+Qf1cq7hoaQRXBula+m+TT8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=uKb7qLxoN0MQUVCelJ/b/6+H50VMnY42pyouFmcwDTlg0kGrTXa1pdC0vBNqhm1pcsFfNnjO+aOHyuzxrKbtgASluF7Hcm3E4Ho63BwACcbncTPLsQ9QddkVedTGhj4eOdcj186iYhSfDpyalVE7KlJKg9obx0AxWAv+hwZxlwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2NIdzob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2NIdzob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CD31F000FF;
	Wed, 14 Oct 2026 02:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791945766;
	bh=PEQrB5zLZ0PYCgNt/yFd0ocO9DuAgr0TpLEqVNSRZ7M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C2NIdzobBD+pfcuA+AqwsydgrR5grS72KBvLGfTbSEC2iEPE22ub9zTDYShIEh8zi
	 IbxfK2EF3gKOhSVMiT0mMh4eygnStZ7E0L4PMDRjvlGQITUzwvEUhTyMtghq0ltzvQ
	 N8RG092K8hVKpJwO1KF3hNwJjTiZRMXeKWEYN/QsNnc6zCn59L0oex9RUQNgrVeVNN
	 UemIVd4YKxjdeEglC8O1jUYnQ+d3PHTXrsTBsd9C6cBw3k9gN4iUvqoszVImQhbvze
	 GIZf9Y73W+TcvFgdVqJOE3HE2csnqa6RX4mv4kLsHqlsVPiGywD/UwPZAIFm/QOwd9
	 CEvxsu4VGjqDQ==
Message-ID: <sashiko-outbox-170745@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix extent status cache clearing when truncating
 inline data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261014021714.2382353-1-yi.zhang@huaweicloud.com>
References: <20261014021714.2382353-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 02:42:46 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: integer truncation of i_size in ext4_inline_data_truncate()
--

commit dadd6832c867f600a26266f1d17a57f7cfd12f24
Author: Zhang Yi <yi.zhang@huawei.com>
Subject: ext4: fix extent status cache clearing when truncating inline data

This commit restricts the extent status cache clear range during inline data
truncation. Instead of dropping the whole extent status tree, it clears only
the blocks that are actually truncated away to prevent inconsistencies with
dirty, mapped, and delayed buffers.

Link: https://lore.kernel.org/linux-ext4/20261009103033.2920530-9-yi.zhang@=
huaweicloud.com/
Link: https://lore.kernel.org/linux-ext4/6ac92a4c.70ed5d86.2ac85.0072.GAE@g=
oogle.com/

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482b..b630e56815bb5 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
[ ... ]
> @@ -1905,8 +1905,12 @@ int ext4_inline_data_truncate(struct inode *inode,=
 int *has_inline)
>  		 * the extent status cache must be cleared to avoid leaving
>  		 * behind stale delayed allocated extent entries
>  		 */
> -		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> -			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> +		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
> +			ext4_lblk_t lblk =3D EXT4_B_TO_LBLK(inode, i_size);
> +
> +			ext4_es_remove_extent(inode, lblk,
> +					      EXT_MAX_BLOCKS - lblk);
> +		}

[Severity: High]
Does this calculation inadvertently drop valid delayed allocation extents on
32-bit architectures for files larger than 4GB?

Looking at ext4_inline_data_truncate(), the local variable i_size is
declared as a size_t:

fs/ext4/inline.c:ext4_inline_data_truncate() {
        size_t i_size;
        ...
        i_size =3D inode->i_size;
        EXT4_I(inode)->i_disksize =3D i_size;
        ...
}

On 32-bit architectures, size_t is 32-bit, while inode->i_size is a 64-bit
loff_t.

If a file with inline data is extended beyond 4GB via a delayed allocation
write, inode->i_size successfully updates to >4GB. A subsequent failed write
past EOF (e.g., from ENOSPC) triggers ext4_truncate_failed_write(), which
calls ext4_inline_data_truncate().

Because i_size is a 32-bit size_t, the 64-bit inode->i_size wraps around
(e.g., 4GB + 10 truncates to 10). When this patch uses the truncated i_size
to calculate lblk, lblk incorrectly evaluates to a block near 0. This
results in dropping valid delayed allocation extents across the entire >4GB
file.

Additionally, the preexisting code assigns this truncated 32-bit i_size to
the 64-bit EXT4_I(inode)->i_disksize, corrupting the on-disk size. Should
i_size be changed to loff_t to prevent both the incorrect extent removal
introduced here, and the disk size corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014021714.2382=
353-1-yi.zhang@huaweicloud.com?part=3D1

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229690;
	b=TUKG0Hx4zzk9FOyUw7Gg72GX7GEwu8eW4hjRmYPCTRQV4+QPMptIxeJSr1P+kve13ipy
	 KLGJ6Kqsufg3Y00aHp6b2fkbw6+95rmrMz9W2sVkLuZLfbq93IPa3z5k1LmoiU2b5IVc5
	 KA0nop8uug4spYEiRYGwwgwto8JWr3SFpWquu/OlNmRmR3aMNvFUyKeDMQeHXIWLRghtA
	 m11WYxk0xjTcUkCDAOC8QqkxbZmnM+i3f9d3m8epbSjuNqqnUUScT3h8H1sJOOwjr+dhG
	 xOm/y6ZmC/Ay3smSeD56V2NY01vgxOZtBfva2MQnunpMulunkdGsneY/FEI3e7YSSiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229690;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=zAwiO5k3OPBsYbF4B77nSbIf14d/o8yXU5UEbi4oX84=;
	b=32i4k1hAYBJiIaiO5gsjfiehO4GLp9OARojuhCSobGAWbqcWz4kkPpQwLjEbx/6LNDQP
	 ZzW0qVv9aCU2p1UwPw+YFVb0UzjM8CaPJjS9vj8DdiIjjEsrFg3kKolC9wWkF2/olyWOb
	 oBtbbcmVpRiQMvwT8S1J+YKgR6LTARq7YXd4C+H2rPue8SeEG20EjlqNh4b718krCcLkv
	 ox1qou15/5Zo3LkemRN44lBa+zprApMRKMb8a2K+cEzz2tf7hOpAtnpcMVdbRhuR34apR
	 otx8Ak1fhmpo3kShPEXk3EFm7RuXtfQ2eLXFXzBWAK9ZZ1VMrYmpmeIymvgspHzMGSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=U+ReDomn;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OtHQ+k7Q;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IaiHbX0J;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vZ420DqW;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93730606A31C;
	Mon,  9 Nov 2026 13:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93730606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=U+ReDomn;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OtHQ+k7Q;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IaiHbX0J;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vZ420DqW
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6035321FA6;
	Mon,  9 Nov 2026 13:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794229687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zAwiO5k3OPBsYbF4B77nSbIf14d/o8yXU5UEbi4oX84=;
	b=U+ReDomnDFv8aAmF1o1ZYRi8oRPvfWehA1KbI/CdZHIFdwo7Duf343roa6sRdo8wHMbZYt
	uEo7JXae+JufecKGmhfQXfkTzTZhzXA31JWegn0dICtVGIOIgMbQu4y/tkIo/VOeriJFAg
	OOsY8EPSZRBJryScAFG2CZpzySY7RWY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794229687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zAwiO5k3OPBsYbF4B77nSbIf14d/o8yXU5UEbi4oX84=;
	b=OtHQ+k7QBV8ZSLjDJQR9E3zvK2ukAPdCsHeqKkkOlQjQGDFzXkc+qjb86l1S9U3re5MBwN
	rA9N/T0wgrfpipBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794229686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zAwiO5k3OPBsYbF4B77nSbIf14d/o8yXU5UEbi4oX84=;
	b=IaiHbX0JZ4ni1iy/evfx3GZMYt8U97nlARFUPFK639PvgLHF894q3axwmdtT78vaf/K2iA
	nJh0Ucos0Q4VIP26KA40IYo5otto+6AS38o3bkO5muyGsxEyvNJcHK/uKzcEFc1xBYVo0r
	cdWT9uPwsQEKoO21i+pGUk2X/4P2bYg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794229686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zAwiO5k3OPBsYbF4B77nSbIf14d/o8yXU5UEbi4oX84=;
	b=vZ420DqWsvhLj+HzBbi8A/s9qYu7stWr00jS9+kikIgpDlpe7eN8Z9FxKwoEAPs3bDMTOp
	XxHy882ZjZ9/S7Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 163F313302;
	Mon,  9 Nov 2026 13:08:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e0QQN7XF8WqFFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Nov 2026 13:08:06 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 931E922013; Mon, 09 Nov 2026 14:08:05 +0100 (CET)
Date: Mon, 9 Nov 2026 14:08:05 +0100
From: Jan Kara <jack@suse.cz>
To: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: test reserved GID block allocation
Message-ID: <wicb5d6bpnqo2vhodhocekneqflqsw5fh45polocrejjcvxtpu@7qtxcbjkvldn>
References: <20261012112109.3363168-1-sahaj123.sc@gmail.com>
 <20261107193050.330685-1-sahaj123.sc@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107193050.330685-1-sahaj123.sc@gmail.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Sun 08-11-26 01:00:50, Sahaj Chaudhari wrote:
> Create a small ext4 filesystem with a nonzero reserved block pool and a
> reserved GID stored in the superblock. Fill ordinary free space as an
> unprivileged user outside that group, verify that another allocation is
> denied, then verify that the same user can allocate a block with the
> reserved group as its primary and only supplementary group.
> 
> This exercises loading s_resgid from the superblock rather than overriding
> it with a resgid mount option, and detects the regression fixed by:
> 
> commit c87abbab6147 ("ext4: fix incorrect function call when initializing s_resgid")
> 
> Use su and xfs_io for the credential changes and allocations instead of
> adding a dedicated C helper. Exclude mount options that override the
> reserved IDs and skip configurations without the required users, groups
> or fallocate support.
> 
> Link: https://lore.kernel.org/r/20261008065651.3517824-1-sahaj123.sc@gmail.com
> Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>

Thanks! The patch looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes since v1:
> - Replace the C helper and its build registration with su and xfs_io,
>   following Jan's and Zorro's suggestions.
> - Set both primary and supplementary groups explicitly, and compare
>   ordinary and reserved-GID allocations using the same unprivileged UID.
> - Exclude resuid/resgid mount overrides; leave _user_do unchanged.
> 
> Review:
> https://lore.kernel.org/all/j2dthue3fzup753jrndn6kh44qfvihx2bylmiwcoxubnrxpgdk@zx6shyx3hbb6/
> https://lore.kernel.org/all/aurRSqrRkEfyp6M7@zlang-mailbox/
> 
> Testing:
> - Exact ./check ext4/309 in x86-64 QEMU: ordinary allocation is denied
>   after filling free space; reserved-GID allocation succeeds on the fixed
>   kernel. The pre-c87abbab6147 kernel fails at the reserved-GID allocation
>   as expected. Both TEST_DEV and SCRATCH_DEV pass e2fsck -fn afterward.
> - Exact ./check ext4/309 passes natively on an AM642 ARM64 board running
>   6.12.57-ti-gd00ea986335d; both loop-backed filesystems pass e2fsck -fn.
> - Validation is limited to ext4/309, not the full xfstests suite.
> 
>  tests/ext4/309     | 63 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/309.out |  2 ++
>  2 files changed, 65 insertions(+)
>  create mode 100755 tests/ext4/309
>  create mode 100644 tests/ext4/309.out
> 
> diff --git a/tests/ext4/309 b/tests/ext4/309
> new file mode 100755
> index 00000000..3bd12009
> --- /dev/null
> +++ b/tests/ext4/309
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Sahaj Chaudhari.  All Rights Reserved.
> +#
> +# FS QA Test No. 309
> +#
> +# Verify that the ext4 reserved GID can allocate blocks after ordinary
> +# free space is exhausted.
> +#
> +. ./common/preamble
> +_begin_fstest auto enospc quick
> +
> +_exclude_fs ext2
> +_exclude_fs ext3
> +_exclude_scratch_mount_option "resuid=" "resgid="
> +
> +_fixed_by_kernel_commit c87abbab6147 \
> +	"ext4: fix incorrect function call when initializing s_resgid"
> +
> +_require_scratch
> +_require_command "$TUNE2FS_PROG" tune2fs
> +_require_xfs_io_command "falloc"
> +_require_user
> +_require_group
> +RES_GROUP=$qa_group
> +_require_group root
> +FILL_GROUP=root
> +
> +echo "Silence is golden"
> +
> +RESGID=$(_cat_group | awk -F: -v group="$RES_GROUP" \
> +	'$1 == group { print $3 }')
> +FILLGID=$(_cat_group | awk -F: -v group="$FILL_GROUP" \
> +	'$1 == group { print $3 }')
> +[ "$RESGID" != "$FILLGID" ] || _notrun "reserved and fill groups are identical"
> +[ "$(id -u "$qa_user")" -ne 0 ] || _notrun "test user is root"
> +TEST_FILE="$SCRATCH_MNT/ext4_resgid.fill"
> +
> +MKFS_OPTIONS="-m 10 -N 1024 -O ^has_journal $MKFS_OPTIONS" \
> +	_scratch_mkfs_sized $((16 * 1024 * 1024)) 4096 >>"$seqres".full 2>&1
> +"$TUNE2FS_PROG" -u 0 -g "$RESGID" "$SCRATCH_DEV" >>"$seqres".full 2>&1
> +_scratch_mount
> +
> +touch "$TEST_FILE"
> +chmod 0666 "$TEST_FILE"
> +
> +su -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" "$qa_user" -c \
> +	"$XFS_IO_PROG -f -c 'pwrite 0 16M' '$TEST_FILE'" \
> +	>>"$seqres".full 2>&1
> +
> +if su -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" "$qa_user" -c \
> +	"$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" \
> +	>>"$seqres".full 2>&1; then
> +	_fail "ordinary user allocated from the reserved pool"
> +fi
> +
> +su -s /bin/bash -g "$RES_GROUP" -G "$RES_GROUP" "$qa_user" -c \
> +	"$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" \
> +	>>"$seqres".full 2>&1 || _fail "reserved GID failed to allocate a block"
> +
> +_scratch_unmount
> +status=0
> +exit
> diff --git a/tests/ext4/309.out b/tests/ext4/309.out
> new file mode 100644
> index 00000000..56330d65
> --- /dev/null
> +++ b/tests/ext4/309.out
> @@ -0,0 +1,2 @@
> +QA output created by 309
> +Silence is golden
> -- 
> 2.43.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

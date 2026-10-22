Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639068;
	b=ZJy6TIAugzEoRBxtLCRoNbSsv26NG9MgwSFEZvix8z8RCp8EfaKRzRk1QyJwjU0nRnMH
	 z0frbTatZ2LdxIjMqLzC1d8wQ7cAqgoUfRw7ZTD0ciJ9q0XurocXE/Id7N7uZrN0mna3V
	 jG0SV7G0Lfw4DEdHZ5raHHcnvIorWtiB9bTywBeulnmdoLnpW2zDpAn2YQQM5obwgCxxR
	 aES1JJhd3BwEej+wOMTLHC9MkNCKSv5h5XXPHYfjWfkJLSeRP8MaCkuZu1hoJYaRTqapq
	 nTvCRbKnvj7u6/fOCQBth8Ti+MQb58Nt0JLTIxK4ElzPh85PzDYDJv4wfWcGpwY3IzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639068;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C3u2J5p7ZJQre7MK7LAkW3PLotnEu5GXQR/XZ9ATPRQ=;
	b=enZUTN7rTaVOh+LC41k2AFXn1+JAd6J1u6Rh/gVwGJDN0RZ09g4LwFlvmm9YwxPiS7hG
	 9UFc/L/SAXobTJ8Nnu9EMjZgBUYTNNi8OpCVOiKYyN6b+837N38kAUlJn8/O3sOm05WKW
	 DRiZ/rVFiWUfrsOCDNinMyRn4rQILfisu0zYR+m0BR2uc+HvhO63EUO1puWG7UDk+l/xo
	 Gttyf43yFQXOUzlkRE6TT6Y7XxjTP3W4QcbRNtgVTWeWGWnnF4xIZGBB8mYm50jiuYUOM
	 iZirtXGGxBebDcHTbmelF9qCNzab4bZnNrjSS3m2qm1WFCQ0hm9+trFj00C3LoffR1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnjVWvri;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9253060A382A;
	Thu, 22 Oct 2026 03:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnjVWvri
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668DE1F000C5;
	Thu, 22 Oct 2026 03:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639068;
	bh=C3u2J5p7ZJQre7MK7LAkW3PLotnEu5GXQR/XZ9ATPRQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hnjVWvripGRsPB+ksR+ULBkGLxiFAbn/HmfgrLZCz3LOm+zZmDfVzvvR6iSzv07BS
	 tHbP21FBWsDuBm/1UQFcDwXZ5JoaAj0Wmug0CNmQdce6jcn3LjK3r7PmZ6yasPB5h3
	 II0Rj10+zVZRNn5DnE8WBWmwC626Mt88RpYUZBTTlN0vqezeJ91r7XoiB5KVd3FRnK
	 clB74NqGVWrM6jpMEx3opOEg+U9pYMv2XMvkTd2/9xmRDI+z7OQDhsDtEOoi1peMrv
	 a4YWCCELi1kkzEZauHnz5iODj5siL0GsC8BzqUn5omrRvFy2r+csDxIt04cQILLqS+
	 880/EgWI+kMGg==
Message-ID: <sashiko-outbox-180923@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 22/41] arch: wire up the *_r uid and gid system
 calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <014ca715d4d35199cda084420f0c7b8163d64cab.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <014ca715d4d35199cda084420f0c7b8163d64cab.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] audit: missing chown_r family syscalls in audit_change_attr.h
- [Low] arch: commit message states wrong syscall number ranges for *_r sys=
calls
--

commit de1d2caf3a9cdd09efea2705dc6569ed00a466b1
Author: Jan Koester <jan.koester@tuxist.de>

arch: wire up the *_r uid and gid system calls

This commit wires up the 20 extended uid and gid system calls (getuid_r
through fchownat_r) in the generic syscall header and across architecture
syscall tables.

>     arch: wire up the *_r uid and gid system calls
>    =20
>     Assign 472-491 on all architectures (582-601 on alpha) to getuid_r,
>     geteuid_r, getgid_r, getegid_r, setuid_r, setgid_r, setreuid_r,
>     setregid_r, setresuid_r, getresuid_r, setresgid_r, getresgid_r,
>     setfsuid_r, setfsgid_r, getgroups_r, setgroups_r, chown_r, lchown_r,
>     fchown_r and fchownat_r.
>    =20
>     __kernel_uid_r_t has the same layout on all ABIs, so the compat ABIs
>     use the native entry points.
>    =20
>     Assisted-by: Claude:claude-opus-5-5
>    =20
>     Signed-off-by: Jan Koester <jan.koester@tuxist.de>

[Severity: Low]
Should the syscall number ranges in the commit message be 473-492 (and
583-602 on alpha) instead of 472-491 (and 582-601 on alpha)?

Syscall 472 is already assigned to fchroot in
include/uapi/asm-generic/unistd.h (and 582 in
arch/alpha/kernel/syscalls/syscall.tbl):

arch/alpha/kernel/syscalls/syscall.tbl:
    582	common	fchroot				sys_fchroot
    583	common	getuid_r		sys_getuid_r
    ...
    602	common	fchownat_r		sys_fchownat_r

[ ... ]

> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic=
/unistd.h
> index 5b7e77a7c736e..8475635005025 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -867,8 +867,49 @@ __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yiel=
d)
>  #define __NR_fchroot 472
>  __SYSCALL(__NR_fchroot, sys_fchroot)
> =20
> +#define __NR_getuid_r 473
> +__SYSCALL(__NR_getuid_r, sys_getuid_r)

[ ... ]

> +#define __NR_chown_r 489
> +__SYSCALL(__NR_chown_r, sys_chown_r)
> +#define __NR_lchown_r 490
> +__SYSCALL(__NR_lchown_r, sys_lchown_r)
> +#define __NR_fchown_r 491
> +__SYSCALL(__NR_fchown_r, sys_fchown_r)
> +#define __NR_fchownat_r 492
> +__SYSCALL(__NR_fchownat_r, sys_fchownat_r)

[Severity: Medium]
When wiring up chown_r, lchown_r, fchown_r, and fchownat_r, should these
new syscall numbers also be added to include/asm-generic/audit_change_attr.=
h?

Currently include/asm-generic/audit_change_attr.h lists the existing
ownership-changing syscalls to populate chattr_class[] in lib/audit.c and
compat_chattr_class[] in lib/compat_audit.c:

include/asm-generic/audit_change_attr.h:
    #ifdef __NR_chown
    __NR_chown,
    __NR_lchown,
    #endif
    #ifdef __NR_fchown
    __NR_fchown,
    #endif
    ...
    #ifdef __NR_fchownat
    __NR_fchownat,
    __NR_fchmodat,
    #endif

When an audit watch or directory rule monitors attribute changes,
audit_to_entry_common() in kernel/auditfilter.c expands those classes into
entry->rule.mask[], and __audit_filter_op() -> audit_match_perm() in
kernel/auditsc.c checks whether the syscall number belongs to the attribute
change class:

kernel/auditsc.c:audit_match_perm() {
    ...
	switch (audit_classify_syscall(ctx->arch, n)) {
	case AUDITSC_NATIVE:
		...
		if ((mask & AUDIT_PERM_ATTR) &&
		     audit_match_class(AUDIT_CLASS_CHATTR, n))
			return 1;
		return 0;
	case AUDITSC_COMPAT: /* 32bit on biarch */
		...
		if ((mask & AUDIT_PERM_ATTR) &&
		     audit_match_class(AUDIT_CLASS_CHATTR_32, n))
			return 1;
		return 0;
    ...
}

Without the *_r ownership syscalls in
include/asm-generic/audit_change_attr.h, ownership changes made via
sys_chown_r(), sys_lchown_r(), sys_fchown_r(), or sys_fchownat_r() will not
match attribute-change audit watch rules.

[ ... ]

>
>  #undef __NR_syscalls
> -#define __NR_syscalls 473
> +#define __NR_syscalls 493

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D22

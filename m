Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792531683;
	b=XAHu8fmXDcc0MnmxJ2McngDL1PQTUHZ3PqJLlmSViwq66LmaV+DRvIN2TiTvl4DTwLzT
	 cXmjDlCR3lTjntin9XZFkuvE13r75Xvxh0y8ZQc5X2cAqzM17ja4rYkp7lsaHICsesmV0
	 N6/grUag9/HDrAVtKhGlAOHcqwMR+8RoJtfiIrW36AhhjaLOGOQ2cfre6a2P5eMKPcBBf
	 +cUxQQtiUAh06ZrTltEAYcgMAUNP8e4mh7tszep0onBVkpev5UCsiA/Rc4EksekIYWgYs
	 S/iow0UQiFefmKSqvNgjLQj2Zti21xWWyNjf+ekw+ZQZgbjHeuEZW69tke+q8Wvtibw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792531683;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=O4srvN/pBk5eVTiZDRmWvIGYI9o+QEmQ8rEEasrkFqQ=;
	b=tTHBo0BPvBrDp8NmW28cGafEXuldddjH+01tx+orgEW3ClauxljA/i0Z4IZiD7e1LWFJ
	 QWMTgwO0kI4KyMy18+qV5bm68/e2oUfwd70AtiTKqiimZaByPjZNrmgXGK5We5w4gQedX
	 SB9Itu70O8ap7bVZaa4j8HHYoMA8Vm5cjEcEDMF/g5qvLTmrx+cP2hk74nWvhD6XnWqWW
	 KnKxdHgrFWsxcpDQyMTqkmPUlScetFuRL06uCmTMRuZ/dnrjYi3GCc57azuiQP4epG8Yk
	 bk/TAAumIyQS2TTxG/wm/0krPsvkH31lgD8goJz36hPYeHXaFoqT9OckAOEIppyTeTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cc4Ei3P6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B8D606A319
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 21:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91B8D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cc4Ei3P6
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b1ab2ad719so5416033a12.3
        for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 14:28:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792531681; cv=none;
        d=google.com; s=arc-20260327;
        b=VBBtxMhltab1c6bBk5hxzCFsCRxv23JHnDCQWJc7u7x4stbXeQ2ydoAG5gyV/zncW3
         JDkNHSUiRY7R7V49Fp3dH+Mftj31rH88TxjYRW6icRi3n4LZx+e5bm2PulC3oUMDFhtf
         OcnI8QFwmXlCKkzQAgFm/aUAZisREF99RYJ+qvZg0E9IaCziryRtcNdxnayaqaE6iJQq
         pgkXLktPzupdVBshNqWsO5xkz2G/aMtgW3tezUUjHo96Nd2oaGeINzwypIgKKXv7IP0f
         sP0Bb1wwcwuC6tPDJHs0jl0wHgBnmx3o/S1/uab65zaHu4zMEaIyimun5pY79T0fs5of
         zCwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O4srvN/pBk5eVTiZDRmWvIGYI9o+QEmQ8rEEasrkFqQ=;
        fh=NW1Z2rqzbPvKECw9AlogOsOyd9oPydwdvt1+PBK7t4o=;
        b=LTLitPNSHV+tdjyz3YhL5gvFyKIdfD7DEx2rS0ohoi7b8Qy7uEOms/Q5kQPOugySnw
         wcPK5vQyikf+ancLUlVv3M51AaJ2yjmJFF7N6OEcD7HhDmx1+7nWu+1bxY8riBl4bkxD
         gHScbMab47Ad4xSftGlyyoWVClDgoQvR/LmxFxR/U3+e0vRwMpLKGiG929PUv+OUsvWY
         fL24LlJ8Ov9K7jpeNkVBQkOi0RKl1AQFs2GRWxp0OCBvmpJk0B/K7ixGN+xDPr8Ay3r7
         jH9auq6GztdjgrIoCVjG7wVjM4wqFTmVBcq/j3kTZ4FDN/AQZZxLRfqvHBzi+kDWWIQS
         6Khw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792531681; x=1793136481; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O4srvN/pBk5eVTiZDRmWvIGYI9o+QEmQ8rEEasrkFqQ=;
        b=cc4Ei3P6HzngZNuiymktrEDw8AujBjDnaMFaXmgzNr+GTiyXeVt264YvZkd3CYd97b
         euP9G0gdn+uTT84htILcL7FMez5JUVFCiFiD9zR2gi0I3Ao/AGSt1CbUAUVJLZOxPT9n
         Clz9sldd7IeZMwDgamoUaAiwA5CoihWWl/7BVA142fJeMLL39fsIUJnccGqS3MTopNA9
         BEsHKMTZMIGPdHD7KjPEnxiCee8KCDllj0xuI7rfZOeuzJ4CEgebEV+oT7LgIOZbAI8M
         n+a4jvG392hNF07KR2ItVWZGFPWTTR1gmbUL1cbQxoKyx6y/AEI4fHG6DhWzLRztgg8K
         JXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792531681; x=1793136481;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O4srvN/pBk5eVTiZDRmWvIGYI9o+QEmQ8rEEasrkFqQ=;
        b=QmqH+wKuRHeGVDQHHbw5W2B8mrRHAx9TgUk5dXtPxsOfMqst5Yp6gAFS3o1MqiPmOu
         30IcoZHu1KtNOWVnDqHfAwNoN6patCOitLQbF8BWTIJn6USLtiHd81Hrpiaup4Ihfn1M
         lEYrIEb7I9tmfc40zBUkii1A6aCekT+iAbuAMHslMZTYxivgKyg9OGO8xxSsMSckUufK
         aUK4tVAMKS0pY9lTSRuKfCXiqq++eFiha+iFlhI2UKRoP+h7Q/gssUaSdRk9USn/AhfZ
         SJM+I9R18XYfoVxnAmXoB6I5GM1JVGfPplb5O3g9tCI3jZg9T5tbu+bYkEgkCW07F/NW
         MJRg==
X-Forwarded-Encrypted: i=1; AKwUvBxhTHiGcGgideLpR9z9YTTy3kh6UiXjuNzmJKBi+58mxR8UfK+O/LABpeS/MXUrcHtCbGJmMMmGjgJb@vger.kernel.org
X-Gm-Message-State: AFq9FYIC35QnNuxtGdEq26f9yaopX9P9V9faoi9cPLU8uD+xJqZjbiUP
	zqQTCNaR9WrKn+QRYD2xBUa67rGeM0ZBUkUWqt6cxSuAmqKofbwOZKyjRdwS3JTFEMESSlJdA1/
	M4MSvUpR4QtkGkXMX6zjMuTU6kpzbmKw=
X-Gm-Gg: AYBFou3Uv9qHwI0zZR4NRwtcI1ecvDg9Q/3sYeFQTd2R4ysS+8GJZRHhUU1vOgOjGdi
	MvkWxnA3fUiJg8mkLIQQ7zDIKKqgOeC2K9/GqFdGWbhM56GR0xk8qo7+ZrxL0rfKmk5K/h1+W6T
	uJozYZ8LLADlXAZDSUYrQ9NE9FTqcN3BwSqihf89kE0KkkwK0rU9k5ybiaOs2alBSRSYRpmHzI/
	L84YxAQjOVeJip0txZ4R8HeFsxpUgZZ7xV7eVV6L3TSeip+bcNcRm730XtmECtBQcu04HVdagZD
	hGCAVENkokQTnys0NogK18HQZ8tJ8gm6m/DmE74z+p1G9YbP6T/j
X-Received: by 2002:a05:6402:1f03:b0:6b3:84c7:efbc with SMTP id
 4fb4d7f45d1cf-6b3a81d6c67mr7787609a12.43.1792531680694; Tue, 20 Oct 2026
 14:28:00 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>
 <atbfAjLsKxhkqW-q@mit.edu>
In-Reply-To: <atbfAjLsKxhkqW-q@mit.edu>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 20 Oct 2026 23:27:50 +0200
X-Gm-Features: AclHuK9PVHbkB9QEa2qrctoA2a3SO9z_q9FaIo9kMIlvASMOLwNA_ijQgQ0d71c
Message-ID: <CAOQ4uxh9+pa9v+bY1gS5zCGzHcF-9rgSr5tVCVP07LS7Dt_aag@mail.gmail.com>
Subject: Re: overlayfs: unprivileged writes can use ext4's reserved blocks
 with the default resuid
To: Theodore Tso <tytso@mit.edu>
Cc: Claudio Fernando Pinto <claudiofernandopinto@gmail.com>, linux-unionfs@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 6:55=E2=80=AFAM Theodore Tso <tytso@mit.edu> wrote:
>
> On Mon, Oct 19, 2026 at 06:03:17AM -0500, Claudio Fernando Pinto wrote:
> > Hello,
> >
> > ovl_fill_super() lowers CAP_SYS_RESOURCE in the creator credentials wit=
h
> > the comment "Never override disk quota limits or use reserved space"
> > (fs/overlayfs/super.c:1511 in v7.3-rc7). On an ext4 upper with the
> > default reserve owner, the second half does not hold:
> > ext4_has_free_clusters() grants the reserve when the allocating task's
> > fsuid equals s_resuid, 0 by default, before it looks at the capability
> > (fs/ext4/balloc.c:654-657). Writes through overlayfs run with the
> > mounter's credentials (ovl_write_iter() sets .cred =3D ovl_creds(sb) an=
d
> > backing_file_write_iter() applies it), so with a root mounter the fsuid
> > that reaches ext4 is 0, and an unprivileged writer can spend the blocks
> > reserved for root.
>
> I'm not sure why overlayfs is trying to override disk quota limits.
> What's the background behind this?
>
>         /* Never override disk quota limits or use reserved space */
>         cap_lower(creator_cred->cap_effective, CAP_SYS_RESOURCE);
>
> More the point, why do we have creator_cred in the first place?  We're
> not lowering CAP_FOWNER or CAP_DAC_OVERRIDE and fsuid is 0.  So if
> we're allowing some file system operations with the mounter's creds,
> why is CAP_SYS_RESOURCE special?

To put it briefly,
Because vfs enforces CAP_FOWNER and CAP_DAC_OVERRIDE at the vfs
layer on overlayfs inodes.

vfs does not enforce CAP_SYS_RESOURCE. only filesystems do.

> Also note that if fsuid is 0, then
> regardless of CAP_SYS_RESOURCE, any writes will be charged against
> user 0's quota, and user 0 doesn't have any limits (often it doesn't)
> there won't be any disk quota limits anyway.

Yeh, that's just not perfect code, but dropping CAP_SYS_RESOURCE
doesn't really hurt for overlayfs and it obviously helps when creating file=
s
with the user's uid, which is what overlayfs does.

Thanks,
Amir.

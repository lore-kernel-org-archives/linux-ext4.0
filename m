Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792446923;
	b=jH2ONXLjcrP7O7liea2hpiN6XNj0MFOS77zGs3r1S/rpKJUF01wlUVGbO5PREQvG+Aci
	 sfouYrU9kpSbbqDRArUgCqiyxgrebj4pyS2ZwTy2yH1Lgllqi3dah07fW/SSJC/6hPjyW
	 8LTIX0mjqExELBlTvryDbSBJjF6qG3CY4JrYBDdDapOgNjqnO5jKtB4hL1XJwqYB1M1cB
	 BbHUJxN8yobngVLg3P2rkTfT+LsEg9acPJ8dH6fLAsNV4az6W/Ocp5oXjoIugNGjjsJ4F
	 st0Lzxln6iUFgwpmoeHC1PbDZ328rSIMTmWiAbDGNWYv2VizetlwNGjU1Yth546layA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792446923;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=T8Iq4pdPlGHJEwvjJiX0aDJUqpeYVl+t+UzpRIrJcyY=;
	b=oR5EaZN74BMcYwEjXA43oHlbkPJUfr+BsN9f+vuqIRULjNHLSPNPC0lPdM7v+i5IKJzG
	 SiZiqJAEQf4Rq0NrClJypTAN31PrDiJihgEAMFnT6BsyhxoHP7+rsq0EmDr9jmnLKjURn
	 eZnCl/kau4TE1aN+tpw9zdgxZZFzTTI6F5dlhrd34oamtuxPgb0oJWoiMfKqS6hLt92BI
	 u5jcos7BTYBUChXRl88lGHkYjBZLaHAPF+WMfHe26wbT5Dn+B6n+WCf++I15OikWdHAcJ
	 B23Tr4/jGX651M0JVKk41hZC7Bhk8IFqTvKYE04nlyK1VF4/6FJUCCUEGHLBgmNYE9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YIjlvJfH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B4C606A31A
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 21:55:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75B4C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YIjlvJfH
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso4074139a12.3
        for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 14:55:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792446922; cv=none;
        d=google.com; s=arc-20260327;
        b=gL4MsilC+KqXQc3L3e7WmLiBayZ2OXNyY3S6+5Wu2Fixw/uohP22u9D3bQc9KpELbB
         WIOuRyj72wfp4ZuUt3UAns/GDlFKD/wFQ+7jf5yJFxvxfc3kVZURfHnAbnYCMX50giUc
         RCGnyCqv7Ljqhycplk0P2OlSjYdfCxoLJOLIBiFwsAQ9aPld/PwQSQe0vURL1zGFefR/
         01KMeTA2sRRzf+5CCu0pa8LEEz+1M6RVUdbgIR8XnGSMU5pIVSlJCtDGEJN4Z9TOOOFW
         mIqry3QIyPBzYxr+C8ioxHAlJoXFUaiRH3UIskBv6RAP1PcMmHBh/w495I490o//RCGS
         3T6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T8Iq4pdPlGHJEwvjJiX0aDJUqpeYVl+t+UzpRIrJcyY=;
        fh=YciwkcPkUkr9PV4dUjrBRo9Y2l8uVrry/G+yGO08xPg=;
        b=NereAaQRMlgr++aW0T5wnMYKEDg/uXtFKqb/r249s4G5QjJrFrdCQfKM6mAeWLWrxb
         K1770xGxGPeQxA4CaK8+7BqVjJfML2t+2Q6qCyVSkfbleTuDcKAq0bPwbu3240CXbCve
         gG7ikeL+FtpFqI30tk562O5dqdw693EDK41sX+dytcKPexnchzvciDYRtOA23Mzf2Rtu
         V7lM6rZVJDHCEvTnwS7TApl/h4uO1UKP9r6lay3LiR1iocJgZptGO/VdrIEJkoTAJsy1
         Tpb+klCLu6g/OqNvGN2MXy//3fKRGlBm9dyuhElb1uX91yMORn5clpapA7893RTHv4DH
         09Mg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792446922; x=1793051722; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T8Iq4pdPlGHJEwvjJiX0aDJUqpeYVl+t+UzpRIrJcyY=;
        b=YIjlvJfHZJwzkDyVmDSHEGAGGTMlDR73ZU13Cwy94sKyiVLB9MKtyGRhLVh4c6afSs
         pyX2JFu3rjoA/5fRLWrzZm/RA15uUw8PpgNkgmXxpjHfeqih/2zKcbgp1QiI0iglnHS1
         DeetUffXBMirCyrXz1ltNwGrxQZaInAgU81ac0FPiNtzdJ13bx6xJ3cKXmvVUqTWfVku
         ViCsmIb4npJY8gLEyn94IIBoZqJvXwPi9ut0+NC2k6ty9BWt1t8Nqu79uhQj7heOZ/aF
         teSxFtDqptinuBf+x5GlOWU7+UGF7q0OIemPd47oBCnSmIWb8j4DLI/V68ux/xzxnqqb
         VwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792446922; x=1793051722;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T8Iq4pdPlGHJEwvjJiX0aDJUqpeYVl+t+UzpRIrJcyY=;
        b=Y1xMIG85lpVM2MxK17Y3cyzhMfFHjFpjiVlgHQRJAB2vo+azDYgy8+7kdlmC9ZaWvK
         jrCU6SNNiyGSvWi6aTSupjheJtD8URXEVSxTFmh5jIV1oWBCQnJXrM8aS4msmDchRLVu
         qhNzwaa2Jiy22GB9af6CSI5LsZJz6gGGqJTMdZZo8Enhi9Id6OLiAtfudPUOCNVCQZ6w
         kbtP+ah8teVhoF16KtPbSzK6ACi9KszSHNIoNXL+BoIB3Q4Wau42JliHoVsWnQQPsUs9
         weWyyt2lrz3pTXkVGV1cOS3L41g6AbpVqd+S7JqoXFqisKqAlDzqKed2t+h8+ilL8Mgt
         gDfw==
X-Forwarded-Encrypted: i=1; AKwUvBwNTU/agV81RrCTWigLZnTafLcLgnzLSXmVYINviLrXSUVZxmTZuGuvaqMrfD4gHUPGwL+VGFwuTuUO@vger.kernel.org
X-Gm-Message-State: AFq9FYLChzcX4iG5jDoQiP+YHbTk27TPLwJopg3GbI0seHNDb3VBRbEc
	CLRqpv/MBUSR/2Myz++oLzmq0dNLWhb+qlU0d3+LgLZ78OniSHwnqETUdsdeWzg+9D1vkWPUPsd
	+hiu7laS/dbr8nBC4lWpZBJuV04Lj5Ec=
X-Gm-Gg: AYBFou2MFGTUyt1XOLQmCM9H5cazlSkGYfAey7yUoXk/PbPZO5tjMHwscrX5hIM+hqN
	o3i/mPIXeQ9wm8Q62zwZOkAPYBGYwIq6V66ThjsPvEKxPSS5JXpEFFFWWEFw3W2/4fHoznmJtQA
	o2Sfwwod8QKsyvZIsH3DjH/3UVMt/sPfEn1rel17Rof1uqaTXCWMqImTlKSug7oi4lhwTRa4Lcb
	AU7dGnr7oFoTLPJHDRYyBd3tT2BfG1y3vSKMyRrT2YrhI9QkQaVNE4FvunM88Xz9gLdhYtiFyEc
	YG07V0WeScgkSSK1LoAz5Kt9kINpkTu7BNSUg9kX6vln7QP3i/cht3MjvKv0jtvtDA==
X-Received: by 2002:a05:6402:21d2:b0:6b3:c0a8:721a with SMTP id
 4fb4d7f45d1cf-6b3c0a876a7mr3271800a12.32.1792446921583; Mon, 19 Oct 2026
 14:55:21 -0700 (PDT)
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
In-Reply-To: <CACs2WyyyGBxznvnJRDYWziAbzz8QROr41CF9Wtu9fOj7jX1fDw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 19 Oct 2026 23:55:09 +0200
X-Gm-Features: AclHuK-vu5bxZTtJjQZs-cG_GwqGQ0GiQt0sHWbR5qBAbzeswFscmOXiOptU_M0
Message-ID: <CAOQ4uxh0g1MtgCO7Q2f4yJP5vq5rLEiiXHbVfeCxwXB5ff4-VQ@mail.gmail.com>
Subject: Re: overlayfs: unprivileged writes can use ext4's reserved blocks
 with the default resuid
To: Claudio Fernando Pinto <claudiofernandopinto@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 12:03=E2=80=AFPM Claudio Fernando Pinto
<claudiofernandopinto@gmail.com> wrote:
>
> Hello,
>
> ovl_fill_super() lowers CAP_SYS_RESOURCE in the creator credentials with
> the comment "Never override disk quota limits or use reserved space"
> (fs/overlayfs/super.c:1511 in v7.3-rc7). On an ext4 upper with the
> default reserve owner, the second half does not hold:
> ext4_has_free_clusters() grants the reserve when the allocating task's
> fsuid equals s_resuid, 0 by default, before it looks at the capability
> (fs/ext4/balloc.c:654-657). Writes through overlayfs run with the
> mounter's credentials (ovl_write_iter() sets .cred =3D ovl_creds(sb) and
> backing_file_write_iter() applies it), so with a root mounter the fsuid
> that reaches ext4 is 0, and an unprivileged writer can spend the blocks
> reserved for root.
>
> Reproducer, a 64 MiB ext4 image with the default 5% reserve (1146
> blocks), the same user ("nobody") filling it once directly and once
> through an overlay mounted by root:
>
>   direct:  reserve=3D1146 free_after=3D1146  (reserve kept)
>   overlay: reserve=3D1146 free_after=3D327   (819 reserved blocks used)
>
> v7.3-rc7 (24a19b953e2a), arm64 under QEMU, writer uid 65534; the same
> on 7.0.14 in Docker Desktop's VM (1148 and 331). Script below.
>
> I ran into this in an out-of-tree stacked filesystem I work on, which
> copied the overlayfs approach and had the same gap. There I now run
> data writes, fallocate, clone and copy_file_range with a copy of the
> mounter credentials that carries the writer's fsuid, fsgid and groups
> (built the way ovl_create_or_link() builds creation credentials, and
> cached per file while the same identity writes), so ext4 decides the
> reserve as it would for a direct write. I do not know whether that is
> the direction you would want here, given the per-write cost and copy-up
> also allocating with the mounter credentials, or whether this case is
> already known and accepted as one of the behaviours that cannot be
> implemented with full fidelity.

Practically it is one of those cases

> Is it worth a patch,

Which patch? How would you suggest solving it?

> or should the
> comment just say that resuid/resgid still apply?
>

I don't object to a patch clarifying the comment,
but don't overdo it.

I would just drop mention of resuid, but tbh I don't think it matters
so much.

Thanks,
Amir.

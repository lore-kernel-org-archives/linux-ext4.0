Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792485571;
	b=FUunImtsps5MWLyZ1wYBMBDoZqOK09b2Nmh7AooFnCGlCSdbbizN4+ome9O2zrB5v49U
	 NV06ex2ib9/7+JkX7P03thSYIAzBx/XEMohSEmM/Hm3jbpykrql82w0t1WrtBcLAJOZQq
	 kpbi0ooq5uZsS9QOTY7jr751mkCc9RFwO8td03Iqyof8kJelKXGGjndVugKpfSq3DarWJ
	 SfZ8ipB7YZFQvJcepgqegT8XDm+scrktUVfLS9JYvFUSBSRBQJOZbPEfS3ns3BaPsey7J
	 QnjP3QB3bt8J9T8hUpYKgPt2RjLzwUnQkuPlfkHFtjbgL44+YCW5XQW20Eci15wxPbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792485571;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=RfLpTPAhPd28vtmcJfKwJOyT8j61Fqz5N+ThO6odozE=;
	b=o6QDcqggMvyHugQ74/tF3jJf9UmkVUTQ6um9JIOTKOqyCsm50jphBUWe2HFuS1qPo40T
	 v9wU3IqqELOUwzly9nFjAL2ep6dZmy7KNaKh67Wfo5hwFdZs/Lij3/YljKv+zTVrH8akz
	 CbkiWielfGIuFqttiRTM0H53/oe1ZMH9PxGBU7dKnZgD5SJtfswj1tVR+aYe3haONeW+e
	 HleDXzgFrhJ2GXiFj4gCQvwJWOCTLpBOqlmSnhoFYq9hCrwXRpuJ0kH4NKaeEYOCPmZ/Z
	 fihHPms82hp+Y33RxQ4JykRWXSB18W3J4Mes8WPaXhXSY4KMzYX3XBSUgOVX6DNhulg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VY2vuGJT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA70606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 08:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AA70606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VY2vuGJT
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c263415982eso365683766b.0
        for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 01:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792485569; cv=none;
        d=google.com; s=arc-20260327;
        b=asZZzGW/9QB7k2e8PG1DIyRWTUOY5EbkKXAQLT9LVu5wttuJSkNS9/l/TbI+Fitz6A
         IyK6eNDljRCuftccEquFdGmF22QxZ3eG83nJ1Jd6NuJsbhhGzWKo118/fa3faxrrh8Jy
         PTWeaH0lr7oGRLpWDrSLi16+SV67ZKoDw9dbJ7gbrJr1lxXnpxup88Y2cMXno9EtgUex
         2eqPCnTB/Z5T93alAa4O8RIxbUAUCDZw7coxti0gH1PosemQccMDhE0sMinmLjTz+zPk
         UF+Tzdti+mu0WoKju7jg8lCTxb3JxzlWbusdyJHXvje/pgT43s/yGrZmmKCLddHW98G3
         lEiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RfLpTPAhPd28vtmcJfKwJOyT8j61Fqz5N+ThO6odozE=;
        fh=/Fd9mIyQwdZRXrbsR+KCRGA610l8/dRa2TYae4ZEaTI=;
        b=kbC7AJ3Lo8jW9FNtojA+7/3gYxWStVlAnZKtQETL5HY8SZimxcUejd+XOnseCKJ9S+
         gDx7DMaZTbN6DHHIPSpzZ1M804+dfW9cSoLJE57Dn8qgGvYJgMxddcTyXUaHxVQeDd1k
         b6nd/6WVLsJ59HZ+6sYNmv6fMEduISa8PVyjR7ZKUbKhfFxqrOTJei/RKbDOtKObFirv
         RE6Ly30yeO6IAWGSPf6QMAylQ0LS7AGorkUd7+Jojiumnm3QSPHn1nNgzuat24/7bbjF
         bheUpdGLBztmxtp3WntDmZBIUt7TIUqUZ/r1qXunT8E+TWsV39PwtslrTxq8waFz05rB
         HU3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792485569; x=1793090369; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RfLpTPAhPd28vtmcJfKwJOyT8j61Fqz5N+ThO6odozE=;
        b=VY2vuGJTmoCSLOOYWdIX2nZALUdQZnUfICIhBT+/e3LFsU2QLZfLHACxDGcbiAWTeF
         KOWNusiWI0qx/eFKnL7837ZCjkzRkDZp85C58+AeGgcvnkH8dWx0amORY80DdeFB74T6
         jAOfIurcKuptsnTGx6oIChEHIPpkBGXAflVOvi4clOeTcTkv/9q/gDNO4K1PL5p60hRh
         l0SqQfCW/nFh2eIdVC3kGGZGzezjx7N70daYazFJHKg+A2xGB05EOQ+I1nOCd9pNukoX
         Ywe87ZmAxVPd+iCHzgKtkA8Dud0INZel7kegWcE6HTw0kNGIEuuO2AxkJJl6DTjq5snu
         Ip3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792485569; x=1793090369;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RfLpTPAhPd28vtmcJfKwJOyT8j61Fqz5N+ThO6odozE=;
        b=z8hgRpPAUJT4rU3hML1hqXgruzObKHOhNJxhqgGZ+1X2PEXV2R6yXgA+Mr35eM4xLy
         7Nu9siupg3B4FPDMADmTfDpxVo1wbPQejKSMch8M4/o+KP4XBt1z99Bl7AsdLB9GAAD0
         N1vq2cNCv3DH+UxchvLkfeS7pMEUBzl2Syee+lzL1Jbec3iflnx6HCwBdtX+PJe0JGVl
         n5p+4mnPsxpYVFWPCD69b8kxSJ92tk11J1fOWitGngTx6siCyrQEUZPwanUeSk9IFE67
         QdqET9AiJWMw1qvdjMptCEbo6ZdE3E6tguftzqXZZoBATB8QkYFWnCye2z0V6GfzLybp
         Yv5A==
X-Forwarded-Encrypted: i=1; AKwUvBzjMZhvwOroDcUBZ59jeJxAQKXLTz5ds24GolDLittzxwzkylJHlkIBKYs3f0WcT/iYWIiJX5KxRlt4@vger.kernel.org
X-Gm-Message-State: AFq9FYJqTa308RXmP1bx71BqUyEb9e91+4upZ/yraqHFpVe7LyQrpHiS
	hx2WkMcumYOHVaAR058iZaOSoSiOSHuz7xIkf0oKa6YAXHO4WNb9rtkl+fhMEXewTrdw2YkmceL
	2n7jQPykDc8F/v67y14fOBVStJ1wj/BIakR7E
X-Gm-Gg: AYBFou1cIoWcWnCFumz0js9eur4O3HFWUTrqNl4oazzE2nuOMymuc9o7FWIhAONQ5Qw
	XmrCMDZ8PQx2hvz+hIsz/fjdxZ0kO6ODsdt/73E2h3lLe1EBeF9cfxYY4XxVZokvQ2n1Fq4pPAo
	3f+05DX6nGo8lCseGYC9pfba0BbXUFv6j69coEza1yCbl4vi0TyqNLwz9PYm3LKonLgC5kKxnxc
	fpcqNG2/HV4AkcDaOCjrut9aqnVphsHRKdirBIiEN0GFXcZajVhxbRy405qWY/r+Lfq7XNiClDt
	8nstdcjz1Jw3G3tXNxYJ8wRQomITa9psTKjgt3nYdzFKS8zprI+KonovxM3YgvwtEaB8UzRpHfU
	32oEKLHmfc0ja2ABr1WGlR0Rr1IE1s1xIS6Gn6uGxch1QHpe7EwpOf9NxKYgV+ZaTrc0Q5ec=
X-Received: by 2002:a17:907:ea8a:b0:c40:33d:f06f with SMTP id
 a640c23a62f3a-c419f90862fmr798573666b.39.1792485568993; Tue, 20 Oct 2026
 01:39:28 -0700 (PDT)
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
From: Claudio Fernando Pinto <claudiofernandopinto@gmail.com>
Date: Tue, 20 Oct 2026 05:39:16 -0300
X-Gm-Features: AclHuK-6XOMoF2Xy6v_44hxLIRsnJt30hyvtuLK-Lk88hbxNuzPppNESROGHRHA
Message-ID: <CACs2WyxC0J4Nv4LvW9Jg6yzVLaK3hOWOaUiG4xSMFEK4_dXyRQ@mail.gmail.com>
Subject: Re: overlayfs: unprivileged writes can use ext4's reserved blocks
 with the default resuid
To: Theodore Tso <tytso@mit.edu>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

> I'm not sure why overlayfs is trying to override disk quota limits.
> What's the background behind this?

The drop came with commit 51f8f3c4e225 ("ovl: drop CAP_SYS_RESOURCE
from saved mounter's credentials", 2017): "If overlay was mounted by
root then quota set for upper layer does not work because overlay now
always use mounter's credentials for operations. Also overlay might
deplete reserved space and inodes in ext4."

> Also note that if fsuid is 0, then regardless of CAP_SYS_RESOURCE,
> any writes will be charged against user 0's quota

I think the charge goes to the inode's owner, not to the writer's
fsuid: dquot_initialize() takes the user dquot from inode->i_uid
(fs/quota/dquot.c:1450 in v7.3-rc7), and ext4 charges blocks to the
inode (dquot_reserve_block(), dquot_alloc_block()). overlayfs creates
upper files with fsuid set to the new overlay inode's uid, i.e. the
caller's (fs/overlayfs/dir.c:665-676), and copy-up keeps the lower
file's owner (ovl_set_attr()). So files written through overlayfs are
charged to their owner, and with CAP_SYS_RESOURCE lowered
ignore_hardlimit() (dquot.c:1243) no longer lets the mounter's
capability skip that owner's hard limit. That half of the comment
seems to hold; the reserve half doesn't, since ext4 grants it by
fsuid =3D=3D resuid, which is what the comment patch says:
https://patch.msgid.link/20261019-ovl-comment-v1-1-499b532b69de@studiomoob.=
com

Please correct me if I misread the quota path.

Thanks,
Claudio

Em ter., 20 de out. de 2026 =C3=A0s 00:55, Theodore Tso <tytso@mit.edu> esc=
reveu:
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
> why is CAP_SYS_RESOURCE special?  Also note that if fsuid is 0, then
> regardless of CAP_SYS_RESOURCE, any writes will be charged against
> user 0's quota, and user 0 doesn't have any limits (often it doesn't)
> there won't be any disk quota limits anyway.
>
>                                                 - Ted



--=20

-------
Claudio Fernando Pinto

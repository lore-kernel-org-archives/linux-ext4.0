Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D013DD874
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 16:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897760; cv=pass; b=auYKxSlCI9IFvZ3thT3/YaytP/ASRrjqlVjn14tnDUpkI2AbwYH6RljGxaUp1e9HK6HmHp7tY596ByOJ0NUpQszs9vtuaUWHAlwMda8n6Aca+4pmgOTIlx7of5gsex6ou+ZU4LFjcZWQshCdM0ghfGtzZ9+VwsbTMHkSGCPs1q8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897760; c=relaxed/simple;
	bh=AHt0+86vpId0YnypIvt+8kocwI6bTxlsvlDW/zwRB5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eENRfpbxWwNoJCHDfaPR+UBkCO/xhpiKas5984ZRm7WoinmynBBGMVuRe/7qTAg+VhwK/1j7HtNZfbR3JhZFgrgGEo6HqCyJZwY+SJ7opaEGfttGsc1zI4tXENPhuroR9geb/X+YLtszHQLOOgfux2/n5r8QIAaEEjIK5GaRtgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6AweTLN; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6AweTLN"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a8721851e2so13321066e87.0
        for <linux-ext4@vger.kernel.org>; Wed, 27 May 2026 09:02:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779897756; cv=none;
        d=google.com; s=arc-20240605;
        b=hlOF+muw8aHPxB5IHm+8WCsPdrIGBNf+E7MtUm5lsdmlcO4H9/piORUH2/v9cpoj46
         wP//yU0ZT6b3YMZ95rhIBgEEBU5JgQvlbxVRXuXmR6ywmKdNtUwAbv8jAQt2vXLx7xMx
         LTXL/XppuZUqQuZPvr8o5KSKDcrPhg3tYGfNB9HkNansfhOjExoKg6u2OqURBwxHm/hh
         nCbFf3FKbCX47XISSW/3t4LicT6c4FpiRs9d/65kfN9gFHskmhXtn2HTJWCAeqnODf6l
         kxVJQRjLoljf6yLlfPPVRs1wQ54ZrsQToKVOIFGO09Hmdp0zSbdJPHbty3kP/Jy8RnTQ
         lkMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        fh=B1L+ycXK2guIrwx/CDkTLP6F+xH23+IjIU7+3qtF08I=;
        b=LWDEXbtwZomJ+9hQemWDvOWugPNzB47/x7BY0P5ln2yCfmw82d5EZKSSvsmRyM1ua2
         yMQvebCK9mKXu2c0Bo5HZaWU19l6RYTX3c0tSl9IFVnLraPg46BjsPBbSTOAv1kxBDOU
         A8q8EfUdiQoxDRxvwvKdczH6p+kFLZLyOdGwg96Agfmjd2MxlilAKdnRa95hfukxfKLK
         Ti2DlVRnfVYZr/nicmx8IPyPq93fBnY6FYhw0hKLVkVmjxhwTVcCs/FwIBjZ+SzMP/Rq
         RWSp6fxVsy2wGXNwetWQHKsWvOmrACu4vvWFKST7rOcFQCPAyKfk1izuSaH4TWYELZ/f
         79kA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779897756; x=1780502556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        b=L6AweTLNHy/Z0BzaB6cRHkDYdErwcaMUEx8sJqTCu6h0qBQaMI0UE7aPhCgR72qWxR
         SZBJ7t2RaoXpz4Fldpeu3WtNvtR9fGkYodPHOCr6ktBnEdknHAi631onR1oC5MFvlZy2
         moajP1VpZItzXpnNDN9Vh/8h3PzgP5amoobLKOr4RvS6L4yacQa55e2mV8a00urNt5nn
         HTjaq768EtXo9tfUIVpinlcto7s/5nLIsy4HiNkmZN86ifJim24oHWq+N95dQY3ntf3J
         Z5ZtSXPJv5DKW3uIy9zRs41yXQqczJ0rvHLa8rUvUrd3+qC9SeiuGsQYj4VxNAhx6cpR
         KzGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897756; x=1780502556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        b=YNP1NAVvP8vAldQg6DekahJJgj+EOTsjPUGleDrqLg0qf6W1TasfrXXeoQL0RAIvON
         lB+GNwZQ3+/cbihjJTzaInskeXZCMYz598Bcr5FQ9zTdLQjLLyed9qcM5zvjzjVS01My
         nn8AAcKBtoSi69mc2zDwHwKSxwqc76GmFMqSloPcXgXGcGIThXTDmxbWWlGtI62JNHCc
         pqiQ8XOEcLI5wTiGMTVQalMJc8eU9ORtOxTZ0zwmmZjn/ttv9yJ32hzrkFlL8WQGjwax
         JxFP4JW/MOyeewc36Ilu6BEsqLQp2mT/1drZC9owG+dkrTSMe+l/RqQgNZPEC3kDZUDG
         Q2tQ==
X-Forwarded-Encrypted: i=1; AFNElJ8i7VF4OSAUxM/wym+myxkh+PZ9sLhQYzfJF+H94nsfU4/0jjaXQUQ4uCTfwqYtV/lAjrumxMJjyccY@vger.kernel.org
X-Gm-Message-State: AOJu0YwGR+A9hGCjCEt3yirG6iG1ODrjNvnyrWvy2fgegOAQGFMOiz1a
	ePnyK5m0kGAb/EVdwBTtdMQezvEdbAIhQHdM78lPtIee5e6W/TgumDJL1Z/ThJ65Np3bWY35gKF
	ZeY9qFw3aKVuk3nWkAIVwYgO7FLPJFn8=
X-Gm-Gg: Acq92OEvqrN2kD9vcH8TxIweWrCx1IqsDjgdX8zkUrafaA17QvpbTxrYtUWjJpl113Z
	3+4HuVWGd7wenTKy2hnpU5faFrkWtMiqMUtx6CBlQAP9TNdfkK/zRZxdKGXHwkgm4cQc7kZW5yj
	LdsUS+48q60OMRaPtATGO9LpeFjxyYO2fAWVNsgEp1rkuNikM6qSBWyMwUy4JsanE5egD9uLYGB
	N6Bcjd8RxSI23wLpkXyX0iPD4dPNasop6W2PcJIaF+YhP/aZIs6YekOaQXrBfjM1ip14+OibNTK
	miZPgqKT
X-Received: by 2002:a05:6512:1082:b0:5a8:96cf:c8c4 with SMTP id
 2adb3069b0e04-5aa3232a140mr8148267e87.15.1779897755653; Wed, 27 May 2026
 09:02:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org> <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
 <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
In-Reply-To: <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 28 May 2026 01:02:19 +0900
X-Gm-Features: AVHnY4KetSSI45sZ2YEgAEZTRsUQAA2DaTD5AcJyh7fDYB4FmiHhDhxOxGAj9DM
Message-ID: <CAKFNMokr_mk8xhMQ7u8RGRd1XPQSSd_uVKXR=-ui5Zjk8AhfTw@mail.gmail.com>
Subject: Re: [PATCH 04/17] nilfs2: replace get_zeroed_page() with kzalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Viacheslav Dubeyko <vdubeyko@redhat.com>, Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 2:07=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Sat, 2026-05-23 at 20:54 +0300, Mike Rapoport (Microsoft) wrote:
> > nilfs_ioctl_wrap_copy() allocates a temporary buffer with
> > get_zeroed_page().
> >
> > kzalloc() is a better API for such use and it also provides better
> > scalability and more debugging possibilities.
> >
> > Replace use of get_zeroed_page() with kzalloc().
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  fs/nilfs2/ioctl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > index e0a606643e87..b73f2c5d10f0 100644
> > --- a/fs/nilfs2/ioctl.c
> > +++ b/fs/nilfs2/ioctl.c
> > @@ -69,7 +69,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *ni=
lfs,
> >       if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
> >               return -EINVAL;
> >
> > -     buf =3D (void *)get_zeroed_page(GFP_NOFS);
> > +     buf =3D kzalloc(PAGE_SIZE, GFP_NOFS);
> >       if (unlikely(!buf))
> >               return -ENOMEM;
> >       maxmembs =3D PAGE_SIZE / argv->v_size;
> > @@ -107,7 +107,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *=
nilfs,
> >       }
> >       argv->v_nmembs =3D total;
> >
> > -     free_pages((unsigned long)buf, 0);
> > +     kfree(buf);
> >       return ret;
> >  }
> >
>
> Makes sense to me.
>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Thanks,
> Slava.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

This conversion looks reasonable and won't affect the behavior of the
ioctls that use the modified function.

Thanks,
Ryusuke Konishi

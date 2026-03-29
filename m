Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCDA37CD20
	for <linux-ext4@vger.kernel.org>; Sun, 29 Mar 2026 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774795155; cv=pass; b=mIaDp2+FN2ahzmjCkqBedoihc0KyPyIVkEjm/N+crSN2q4dvi+qaBFq9iY15FGLSUtf/4F6PReaqphzHDwm4PrynspAGQ5wS6kHeBftPmSCe27fx3Wczo8pxQtMBu56kQH+jbacLvpEeL5tOQtB5a6taU101eXmk0uAaSgt/2rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774795155; c=relaxed/simple;
	bh=F0RLW3r4qBmUZqSxgm9Kq5u7yTTvFj1HrudPzS9N78A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jRqGfry5ksy1rujS05p+1Is0FIwLeH2m2Bv4gv6Wd3bs66bK6t30BOwCnI+c0xt2BnavwC5p91kY4xzY3K3afvx7ATjuhyjB8TE/hGFa7qKJokoGh0uZPdd7H4xXygfpVMrJCxD6lW5CCY6XkD07H6m7MXc/8DGNyXfLlbwpUBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfMIHbEL; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfMIHbEL"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6501c4857b2so34744d50.3
        for <linux-ext4@vger.kernel.org>; Sun, 29 Mar 2026 07:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774795152; cv=none;
        d=google.com; s=arc-20240605;
        b=BdDE0dcKJEpK3R56miMjBY04zaAh6NUoxJKj/urACjWGuDYqk1vgHiqxABH4wZjFy2
         Xv+ElQVl7eSaE8gLD7lM+QM+q62vmUIbdtCw7SxuPQ9Be0baDSOp2bQdxENtnC6xZvfD
         rhFjnesbWdj6n5Z0LEmdYpnJcPIevvpFafpvDgvqWIOTsf2EUDUzmXbzXRcs6shskPNs
         c7wA3GMc3NmGVNMiJBNipNro1HYZ0QGDpH+bie7jQ02/VqYeU0rz2JOi92c1dWlAr3ZK
         yMIoKdDvGVnlHDze7KXUin2AXdxRfHLhh8w4prBGGAXyMh0z0BBcA/cTRxy/wlIW62CG
         J2iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qTXtZhWd9h22v09A5BSwIe6rhE47zlulHYLDLV/WAwE=;
        fh=Nq/s1opXvWOaDA9fHWd8unRWaG9WnOTPDNf0lyk6hdU=;
        b=VAysL8aIBOGEbbY9iTukxU9uJbId/55nKrQPp0R5qUfE9R5xU7o0l+E8o0q2aIFKg7
         nzit7BegkQcpCj6kck4h2VLyiBDi1F4e5HwlsCzuFe5PjMhnT5cwcG6NN+DADqldClJ/
         XyklHfBxMr9f1HHfpOwuRYdtqnFf64FAoRjZnPscDZ9ssX/0esgrkl62k0X9Nlvf2Rc2
         91sQg4CNHcilOqV2SysJW2D4yR+3ZMiG/ofJxihHOA1t3sjjNIbPlgx4R+wjOsBTHNBo
         k8JErMyX68AjFi1aIdcrw6UU/K7U7JdRTyCnN+hTtOl3vln0NJTJqqnJfkSU2JgWIfaC
         EKdA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774795152; x=1775399952; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTXtZhWd9h22v09A5BSwIe6rhE47zlulHYLDLV/WAwE=;
        b=VfMIHbELK+Iqh65z0hKp5++FRQUQc65dtBBRLDHy5922Gnxnf0/JWD7m8z16yDoJzr
         zLopxmSIXu64Gqbqvm1rxYA6Zz8q/v20u1eS3j7aqlpMLZihF/wxtgf5/1DWdc/i66+J
         x2XQ+fY0MKDytS20Fehz5LUyV/tzaxf1fUGOsSEGAqZrNJj9Wg9kzcytiC8s/tZnbZYe
         kaoDtEz6YTI8FKBrH7y3wxoB0IyAO5Fk7U+4gRbwutbKxsLLKcLnWoMWn86rhytVAyX7
         2qMipdgs7NZsslzvAKI7g7GKHuD3A95JAxtxoNtWXLJxc1A3qnNK+2aG5+/sRvd5QU1T
         H4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774795152; x=1775399952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qTXtZhWd9h22v09A5BSwIe6rhE47zlulHYLDLV/WAwE=;
        b=qU/9hKt9FFRfitzRARF1gMmtp4jFX7Dak/qUQUzvrCAn0HdOUa+tXotM4tM1x7enxd
         aC4QMNSBWhnGZHYPnwVYg6PdHyNrWd+GyviUWsDdrpN0Bc7scsmBEyO48RmqqzM8IBfQ
         /Ke5InRt+3/a1rlCjcIjA6dkYsGyS6LpUJAaleKKPtmEHsSmm7qhq8n4CTeXqvoCVP3X
         r9ArirKsvaFgVX9DUcxpQ5NsCujgZVDE1vATL8RwK0Pa9wKie61cGwTrnSjVjT3EUZeB
         lBNpwYFxYs54f+xa+5RghjiXALmBwv/bbXF5NGzpnv0TgQOFicf+uiERnhF67OgxIB70
         KH0A==
X-Forwarded-Encrypted: i=1; AJvYcCUQ1XZR6O1QEUvt6U+PjW37YkYYUop3ZplhsofsTRrAzezVEnbFR0vEKr3y9Du6hTuQLFu7mwTLDRFE@vger.kernel.org
X-Gm-Message-State: AOJu0YyxIpEminG8XkBi9hAKNUW2aD9QLbyh1daKJFe6Eo9FwoskStRE
	5I4uGUcL7n2vdjomekGx4/rZ5Rt3igkInbPpy1MRNGO6EbDXSLs2nADJRHcvnbN4Oje4dUSZ1eX
	kHq8nkgYKk4voIWWIEq1B6KU7eqf7LWM=
X-Gm-Gg: ATEYQzykcE2Zg8PmHZX2+cuQoGdjggbBY0f3dTc+jSZGAOx6UA9JJwQfdhp6IyEomV9
	lSpiB0zCdyNPHPeKfwtqg5Ddy/OWxUA8lcgsfUY8RVDE9LvJTlgUq0PxVbkSYKW8QTlVOSWpfZW
	BgLVvEXeDRVL1mM0iXOcoyDpsg6zJqz0ufRtjT8Ys8/1eHgOH9qTFonNHcWeOaGMsjv6wyKQQVs
	ILu32y1VUTuQIoKq23PO64n0NJX7nK0T900VeW2bHgEczKMFb0AZJ9mp3iKTilghywBxOwbg1by
	x/EYR+maqZPwcR3APGqmIOxK5GKrR/5m3bR73ex9PBYoPUwkEatulM/PCSxrRxomJmrqgdLFFag
	T80mY8A==
X-Received: by 2002:a05:690c:dc6:b0:79a:8e1f:2611 with SMTP id
 00721157ae682-79bde0f98b7mr91796977b3.53.1774795152443; Sun, 29 Mar 2026
 07:39:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224231429.31361-1-kartikey406@gmail.com> <20260326054718.GC4383@macsyma.local>
 <CADhLXY5E_4Hi=Uzu3LPwg_YNgcFR+UcAbfY-XzwVnmFBaJqjkA@mail.gmail.com>
 <20260327163135.GE4383@macsyma.local> <CADhLXY6QjWHiyY2MkUutzJK8utKghMTxjG9C8X7e=WDL5xKvYQ@mail.gmail.com>
 <CACT4Y+ZzbnD_puTRMx4MpcACpp5m3aMhQYvH+1LAyTKOz6otEw@mail.gmail.com> <20260329134832.GA8782@Mac>
In-Reply-To: <20260329134832.GA8782@Mac>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 29 Mar 2026 20:09:00 +0530
X-Gm-Features: AQROBzAlVm6_yz-UfGT1SWvlKMz4VQHru2SvBR5V8-ZXt8GK0lDG7cAZMFlYlPc
Message-ID: <CADhLXY6uiBk1KTBH7M5Zjfy5RU3nPqaYaOD7FsQWGTwgfdi4Gg@mail.gmail.com>
Subject: Re: SYZKALLER BUG: messing with a mounted file system via loop ioctls
 (was: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get() to)
 prevent out-of-bounds access
To: Theodore Tso <tytso@mit.edu>, Dmitry Vyukov <dvyukov@google.com>
Cc: syzkaller@googlegroups.com, adilger.kernel@dilger.ca, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 29, 2026 at 7:18=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote:
>
> On Sun, Mar 29, 2026 at 11:47:44AM +0200, Dmitry Vyukov wrote:
> > Thanks for the report.
> >
> > https://syzkaller.appspot.com/text?tag=3DReproSyz&x=3D17a43b3a580000
> >
> > Do you mean LOOP_SET_STATUS64 ioctl? It's the only ioctl in the repro:
> >
> > ioctl$LOOP_SET_STATUS64(r0, 0x4c04, ...)
>
> The loop LOOP_SET_STATUS ioctl is also problematic.
>
> > Does it mean it should also be prohibited under
> > CONFIG_BLK_DEV_WRITE_MOUNTED to avoid kernel memory corruption?
> > Or at least some changes should be prohibited? E.g. I guess changing
> > lo_offset is equivalent to writing to the mounted device.
>
> Yes, that's correct.  LOOP_SET_STATUS[64] can set lo_offset and
> lo_sizelimit which effectively mutates the loop device while it is
> mounted.
>
> The fix is something like:
>
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 0000913f7efc..c1d17e2bbd0c 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1238,6 +1238,16 @@ loop_set_status(struct loop_device *lo, const stru=
ct loop_info64 *info)
>                 err =3D -ENXIO;
>                 goto out_unlock;
>         }
> +#ifndef CONFIG_BLK_DEV_WRITE_MOUNTED)
> +       /*
> +        * bdev_writes_blocked is a static function defiend in
> +        * block/bdev.c, so this won't work as-is.
> +        */
> +       if (bdev_writes_blocked(lo->lo_device)) {
> +               err =3D -EBUSY;
> +               goto out_unlock;
> +       }
> +#endif
>
>         if (lo->lo_offset !=3D info->lo_offset ||
>             lo->lo_sizelimit !=3D info->lo_sizelimit) {
>
> Turning this into a real patch that exports bdev_writes_blocked() is
> left as an exercise to the reader.
>
>                                         - Ted



Hi Ted and Dmitry

Thanks for the sketch. I'll look into turning this into a proper
patch, exporting bdev_writes_blocked() and fixing up the
LOOP_SET_STATUS path.

Deepanshu

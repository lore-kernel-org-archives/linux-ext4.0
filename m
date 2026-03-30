Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB266372EC0
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 04:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774845901; cv=pass; b=brtwa02Ub1nMknUBCVpQNyuRQ0NzorEA4ew7jVxPpT/lvcDKEcPODgHvL2bpxg4fweD7JH5Oo3JbB7NIihAD96G5VdUkt7iq/FWrD5Ir1BXr2pd+cyMGIUAYzNswXFgmKOh+Vey4VVLHDdGkV0AWPWfEVMrZI7FYb2uvav8Wo2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774845901; c=relaxed/simple;
	bh=MBT5WcvlKNC6Tq/nMmxWsIFbYj8eCi97H/utYyXg6PE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a0AUi1c72QVDq+iHVTXGVcPJWyK7Y+qgjSTy6sLDPb6r2FP60gYKHOgTbLJmRyPLyxtwu/CkQB8HDoE6fb6aVbbF1qcgAKlJZOnOUOciI2FOxK4nO++PlS/1IAtLJ4HInF0tMIEHcHk8Jv7CD1zLzqTX3KwMaoqPusNt5tJ2XjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jCTreYOT; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jCTreYOT"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-649278a69c5so4342932d50.3
        for <linux-ext4@vger.kernel.org>; Sun, 29 Mar 2026 21:44:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774845899; cv=none;
        d=google.com; s=arc-20240605;
        b=dZ2lZrjukzg/DwDS4rUV7eZo7uP0o3f6tDU3xKSXiD219+HmqhD37Ux1lGpfcvnGTG
         rFE1DPLvm33bC7DBopxq4zVZwAQyPIzGPPEhB55Jjdw7838M2MfwWkEqVlzhgHB7oZ62
         CPcPS3XMn+l0A68+2aq9FCSTtmUvJQgr/Zre5YLox/EVHXD8274kko8ipRfWvkLJkUCX
         Pn8+rpduf9b7ZJQzfrAiaG++2+f+O+OvaKFj3Nb5C97is+MffDIKPUop6Bmd2vvKa5uP
         paD9bLJoAoPZN7xHf3udy8DZY4bsvHUch9aGxUibLfMCvsdUIxfz3O25nJnXbnkjG05d
         wjUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3c1H6WBUc+19aZXIU5jr6sU5s2Ev2Nojhs8cA4fV06I=;
        fh=z1POQXjUvjqAWEdKBdizaymzIlUiSIW5Iw8T3qj12mw=;
        b=I+QuaParLCoN2UqHyePXCHmtr8o0sW9qmwLaGlV2obPM/7dIWNBXf0oxn2VeloDtJV
         1alJ+JeEKpwL15RpTrWeilX5aYk2AfWnzTJO1Ij0e0GmPaLLhSo/Z0pwm18M5WrcROp6
         F8Z9Hpbgx6Br7kDuNdruB+fSvMeV6/4acQ3r5EoIcB5ByC9lG7Dssh/dS5e8D2IFO15L
         xMa31+/jAZ7gLfYvw6QLsVt8jMisg8xN0bUye+fu3LtSyd+OQR/EKQO0xdRuKcxHiABQ
         FUZggPEaAtFVh8bVxL+yk4btVz83pnsvDSzyhN9DvwM00KKeF4OG8KKlZCVIySI5t2rd
         coiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774845899; x=1775450699; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3c1H6WBUc+19aZXIU5jr6sU5s2Ev2Nojhs8cA4fV06I=;
        b=jCTreYOT89HRaazmUqtzv0Tg6o2UQMgyqAlHIp9JzFArErR0npE9uSvC6AYl3dj2ui
         j2AfPbt2Qr/dD7zHXpy5u3tEyo7lyJ1wixSIeuikkMvl3OGyjMJxOqNLpAk86BtcfMTH
         OpAQrvyj0THaXjyHPzb6dQH2Y3lJV2ru/3WnAJBmqORzwnpJ147zsTfYhmDJCYndM445
         IRiYCni00+BWxsX0KWlbErmHbbN1/ZjtAL2AgIelRJQGYo6ONR99FZUdrn0b+eXpZsDl
         XjBIPcWzraOeQ/TJV+8mEyr92fobqHbY9BSjBAR2yYfpLLXNlhDt8CYRN2XV2UrccJCQ
         eR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774845899; x=1775450699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3c1H6WBUc+19aZXIU5jr6sU5s2Ev2Nojhs8cA4fV06I=;
        b=TQ/5FSGtNSQuPM0O+0VVfsMmE3gsmePS4v4QKQy3cbTJHc5IljVykILu9m8kzFJIHM
         c5qZXSp/FsjZIib9Y1xG4/NUdTtrGKBktCs0PENAO7sOyNOGos9WqFjVzO790lU5zPgN
         CZaqQ5+IX6nD+64XesAXBEOz/rnGWqgQCjgkOsEqXLyI6v4+KE3Ksj+Xi2A0jUd6i4UY
         J9n0A1CgAa3TTHzwkkjMBFaTavFRIZ6sY39MobIQFkPvkS0NuJgoQZV6GYusjZrgstZa
         kGVwHiPsxECL9kkXtRFXABZ/FrIKfAE75QVNel2yimlzVgwP3iSxomU7CMHnm9IDDsr2
         8nAA==
X-Forwarded-Encrypted: i=1; AJvYcCW+0005hwFUpCxhZCT3tfpKneKh8auhshwFrvI74Iohm2QjRkfItl9Ul4AnyYoPf5HhCtQ+7CHSMb96@vger.kernel.org
X-Gm-Message-State: AOJu0YwGzt55UwlN8QzMhosHsw2gkRCbDOSdrhtk35yjXzDTcga/xBIH
	pUIzjOHhUK2inGWCMARIde877z/grSAjrIAjZ/luCYo4olrrNB3OdaCG4811itcoKtNIgvPBEB3
	ohxrCcIEt3GChNAUnPmJUjk2dm5ecpOU=
X-Gm-Gg: ATEYQzz/JfgGUD5cMyuzKqcJ2/9fKYFXFuwDjvtTmUZtZbOrXvQovFMlBB7FOVc5Y05
	h6JHWE+iT4ZM/nZXvrWhfc6p+8TKt+NUQs+qY+9O1a3kpPB6nJkdCM8KKXUBj26qHEjyB1FR2Pa
	TkL3mDuS6alS4oVBEXoQN1Cv+QUrsMFyXiA4Pt3+o4MBoqcXrqWnfsEMwbkPt8k99zuHy2iEPue
	ib/e9AL/PYlsfvLoqYaB1YvV5QX7UT5wtykZ5Z2Rl+r9QaYUi4Np1F0GpLLzqN/0r/fg4IzMhZF
	gtAk+aStfaCQLeRpLccKy+IV3p16bumOIijOmtpvPSydYymoYcEC54mV08TYgCtQg7P1fvSY
X-Received: by 2002:a05:690c:ec3:b0:799:1a03:8501 with SMTP id
 00721157ae682-79bddd2e5e8mr115360417b3.25.1774845898712; Sun, 29 Mar 2026
 21:44:58 -0700 (PDT)
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
Date: Mon, 30 Mar 2026 10:14:47 +0530
X-Gm-Features: AQROBzClKt2CILP_TIFQTbyWw_voCfDmqwUQP00f6yQtb8D6AztvMKaZNf_8CEM
Message-ID: <CADhLXY7zHTLAxYZZquz5vDAV33wCbAxCK6zWprEEfmzZxTBN8Q@mail.gmail.com>
Subject: Re: SYZKALLER BUG: messing with a mounted file system via loop ioctls
 (was: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get() to)
 prevent out-of-bounds access
To: Theodore Tso <tytso@mit.edu>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 29, 2026 at 7:18=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote:
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

I have sent the patch

Thanks

Deepanshu

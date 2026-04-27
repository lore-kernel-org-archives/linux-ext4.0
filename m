Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C877B3ECBC1
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314689; cv=pass; b=QRMIxen2hRE8JPBd++767Vw6OcIVFSS1qC5gWwPvYfnJkdKIjRIGHW45Zin/KGbudJetRBs5JXIUClM2KxE21/bmLLsMEU1jLxK2HQRyGbEisidRugOLt2bg4SuasUTLTcBDST9hHvdOQBL/x0ij5OUeMozJRcYd4PMdzUbSfUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314689; c=relaxed/simple;
	bh=y5vNoVjRrCeEb0mNeJ57C/lgX2jIu5b+hJdLehDSizI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k9xviuSVbV+WpojNF6GwW5XzXxWiq0XQvb6WsqYC8Di7jHBh7i5KRwc1QgGul22qb/qQplLWFVCy0O/aedu1JmpG8dJXJTpSDAuQFfJbPZ54esYfJUXFeUnlxC+1kBOTBwOU8mpV7x7fPuFn64Mrx3Su59NjT7y/pptnBquzHhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g9E8KppX; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g9E8KppX"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ba61a0a2d26so1369042866b.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 11:31:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777314686; cv=none;
        d=google.com; s=arc-20240605;
        b=D74bD9VyntFJ2RBDxBFr34oSYm+5wsQa1cRmyIcKvdlQCq+INRB4w7bdxtqYUQn1d1
         nhWeawIBo4NrQr4GL1F7vyRQmvVf6rwY+mMK/i7y5ZsHX9EhsME5etyMsZCxXcWSjrox
         sTbasN04J8LfXpIK6Q7NvyxzCHxXZry4l1PSiguTfcnefMvZcOoqaBv9V27Jg3MGywPm
         Yuwj6a9ms+h8k5R9XicgDUgJ9wl6xCrrhaQuv9wRuIHCgIZRBq4vX97NUNP8+CKovaWW
         TYAJUjkY4JBslLmU+lC+CNxp2c6AVDByScI7+BdEepHkjsiihq7F00MMXJ0AEto9lUbr
         eTKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tg1zuOY83oGY3EoVjUz4RsJNWaGJa5oex8FMk6zwF+I=;
        fh=3QwRHuPk2PfYbV80wljdw7PXdmAlkPwa49NSCXuNkEY=;
        b=fPQmpGW2WvUHbc3Dl3qn1xKp1YFMh8VacrVIk7mJmvaRN6EAezkWJRcpgAjfaGIaRj
         JSaLA7zVoF/PFvZKPuVnQ+XkYZdc2LgiHnJaddmiVfq3BDybRmIMLKejVN5zhIW2u0Zj
         FrfijlhH/cJpia+dmtdVYQ/FT22dHekxyjT55aQzmRey3/4C2QE0yTmNBfXwkLhMxjHM
         COLDLOHHYBB4W2HcNiFvd3NluDWU12BPo0dgCCyixdLYx2d65DxpBiMsH61xa6AIr4jM
         9EWa2zubbQTVQx1UTV7HV0o0Lzxg6ITSStLrZWwAqJZ9qNEY/ezYOQkt1nuTzBGKEjkx
         1weQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777314686; x=1777919486; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tg1zuOY83oGY3EoVjUz4RsJNWaGJa5oex8FMk6zwF+I=;
        b=g9E8KppXOGP+2YshzElHjYypJOoFSumRh8nKOHEMqlQ1thu4nV8VbkX1FUeocZEA0H
         alIgwcCm4qgTvesoEIP/Sy16rr7NJuYp8L1j4fk4BFWv1Q9w7hoA3zEf47AMnf197OV7
         mCyZu/NdkRuKXUmmB96AxJwaOFp/EtbNnd54XiEC0sIRBDzG7kXvOudD/ydXUwE0fRmL
         N+HEtvs2Pq7jpHZc11C4B7cmpg4qge9oz5WZ4zAta7U+yEG7OppkAkLBlon6sOek3rVP
         fzHfkTyWMxDB8qYXnP7FBsnpcH6s5Mggz0O8+/jZgLKQRLOQbXvyhF26Dtx+xt1w3oE5
         1qPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777314686; x=1777919486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tg1zuOY83oGY3EoVjUz4RsJNWaGJa5oex8FMk6zwF+I=;
        b=gOKIa9upxyrIDjYaJf1GBWDzki8IQjELZdSJZdyFdDxr3B6bivpSUPADU5TZ+H9U69
         2jCGDHCZx89HwhxMPFc/GwTAOPG/jVOqprku+OpdspJjeFiYQbLHplECJzN2Xt4MtVAi
         afsWB6yC9S8HBZ2E9VSCGjO7PrjJ7VfjJnruu3GhdWdLqku9B8OsSEt6rsunavLot48v
         tmYRfMrS8ptV80ZhhHEmGKFI7pp5CgqGcnzQm6hTi2WkwmDa+pX0hRkboNswNJALiAqe
         m1hL9y1qxYZMMsD5srTO4Sc3vIdIw00VCnehY9G9fWP4SS6uqaTBkkOgjeX3NyPMpY3E
         HsjA==
X-Forwarded-Encrypted: i=1; AFNElJ8Y7LCs5w0MRVmErGIgEO0Et7+JjwNVD4qyhA489qjYuMPrxCf/PxfHW3s0obGPcR30ey2d622N0DzO@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy2tGgqqzbnos2LD7b4lewyDBQ6DP8KiwP+VQpep3eZgqHT/1Q
	jUtA3Gv7Sq5eHZwZF/C9zHOMYFKo7le6J79xkgB0j9oub9NVrVF/ITKjq8AmscMwtm2gC389Sdc
	5T2nYIOSI1qyAbE63EwSbFBjwmoVc8Ts=
X-Gm-Gg: AeBDievdSZPgYDAHmkllyWtXWMYLzzfkW4aSD+kFbwD5ztD3DOX6TBx9A//AxSC5+7b
	/GAcM8j5O8ZeDx6ttw2ZB6Cu8/3UwhHAAI5D1JFOmWSbjv00ZqG4dHwZRroh7f2DZcbYf7muJMI
	xxfX6Mn82wONQIXiGHxBNaZl58gWXBTsxiX5+Ckk0sUsSkzG1SHUdiMoEPG4lB8D9LRI435EWkG
	X9MXEgzxOnm7FyYeEpU9ilbrPkjBDqKgW2kez0D92/DiXB+Oe8YVC+rl423Tnr9GjNUsYActuob
	mhv8Vp/SkR/ed1ZFqC5mm4xaACIeFJ4E3dv1W2SSeAvR/oDz2+yT
X-Received: by 2002:a17:907:6b85:b0:ba5:391e:20f0 with SMTP id
 a640c23a62f3a-bb7fd277cffmr2751366b.42.1777314685571; Mon, 27 Apr 2026
 11:31:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777281778.git.asj@kernel.org> <05ace38b54ea49f462bcd6274c4a2528192e6949.1777281778.git.asj@kernel.org>
In-Reply-To: <05ace38b54ea49f462bcd6274c4a2528192e6949.1777281778.git.asj@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 20:31:14 +0200
X-Gm-Features: AVHnY4IQzHFWkbOhQxy-O7952b296RbWBnPSd_gwXqTuhmjQtW-vYoNk5uAynBw
Message-ID: <CAOQ4uxjEcHiqzB+JrnzDExMcBuTbLaPT5qQcEDX0GO0TX7hp=g@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] fstests: add _loop_image_create_clone() helper
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs@vger.kernel.org, zlang@redhat.com, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 12:19=E2=80=AFPM Anand Jain <asj@kernel.org> wrote:
>
> Introduce _loop_image_create_clone() and _loop_image_destroy() to mkfs an
> image file and clone it to another image file, and attach a loop device t=
o
> them. And its destroy part.
>
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/common/rc b/common/rc
> index 9632b211b58f..0e7b7eb1d98f 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1503,6 +1503,50 @@ _scratch_resvblks()
>         esac
>  }
>
> +_loop_image_create_clone()
> +{
> +       local -n _ret=3D$1
> +       local pre_clone_tune_func=3D$2
> +       local img_file=3D$TEST_DIR/${seq}.img
> +       local img_file_clone=3D$TEST_DIR/${seq}_clone.img
> +       local size=3D$(_small_fs_size_mb 128) # Smallest possible
> +       local loop_devs
> +
> +       size=3D$((size * 1024 * 1024))
> +       $XFS_IO_PROG -f -c "truncate $size" $img_file
> +
> +       loop_devs=3D$(_create_loop_device $img_file)
> +       _ret=3D($loop_devs)
> +
> +       case $FSTYP in
> +       xfs)
> +               _mkfs_dev "-s size=3D4096" $img_file
> +               ;;
> +       btrfs)
> +               _mkfs_dev $img_file
> +               ;;
> +       *)
> +               _mkfs_dev $img_file

You making a wrong assumption that FSTYP can format the loop devices

You should add _require_block_device $SCRATCH_DEV
to all your tests or maybe nicer, add:

_require_loop_mountable which requires loop and block dev fs
and use this requirement instead of just _require_loop in all tests.

Thanks,
Amir.

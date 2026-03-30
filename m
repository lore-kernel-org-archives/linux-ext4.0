Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE5430E858
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 14:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774881249; cv=pass; b=b4/1ffRIzw5OboufuB1W/uwjM2DoWxu+gep9cYherbH5hbOGufMySWhKlJqUB0rOWsljErAh2JuG9TSKu13o2JtnXcVX+iH5g1eu0DM2OHMPvdisilGdlxFpYci71t56lCSZq5p47Kbx86jpHQHJDIFNcJdJzs7dkecfLpJww9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774881249; c=relaxed/simple;
	bh=I79gy/L1iUtPeR9Sx5svfxAJiYGA/IeaDqYZS24HXHI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R0NcSgSNC0s5cVqpDAScvaqqWZvPvseoqrnBVbjNpLgR7DE/DAPhlYgd3dQj+6roTKmXXIgCWKnT8qsyisfG2MFSkRwmJik/N6puaXKJBcC9X1rexHcXdCPpTKWHjuYdTPTqzwXDdyO51DKu0+/mLbdqpDrxrQXsJyH2wtPioT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2wieVhn; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2wieVhn"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6501547d7edso3020747d50.0
        for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 07:34:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774881247; cv=none;
        d=google.com; s=arc-20240605;
        b=P/yT698kmIvdpAi/156pzekpbmEa5MEkOTMd9VYHLDuCAEuBDs270Z+QdMXFTDwo94
         3CnbJjIk5N4ipnhDbG52LjL4J7oUeAib4B18SME2tCUs8e+ZSZ2CUhfEtq/f+HczVhuJ
         +kGwTspv1dw9pYzoiNJEExw8s0ZM8PwS3uhNnY3xD9NvNDf6iGb7nOC0iN1CYptl7AqQ
         Bti7SWP2UL1wp7WxdZHE6zeCjnNrtb+YnR39AKI67v8qPjaKKGzFMDvOfuG9R8fcjYb0
         GLRS3dK0HUvXiRs+Cgy5NM711QRBFYrxae/lS2iMPqiJVWbS8Xm8JAfK3FjBymOIP4vC
         P0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IIA8D0ff4y+v3OdWEO6D1Oc2rbEBX2dD2f4Uu2Jsj7Y=;
        fh=L9obaeD65GeaIdspxwcKWjIt030E+JHZjok8LBWptgQ=;
        b=iKmf8oRxwvf0JP/ki3GzdylycPqb7Xa/+kmF/VcCOUbRg1a4xjNKP9Aeqzm7DFCFTG
         yRLPEhl0cNYOq09bxXTvE9vTJXRFxOp+SB85gTgMlxJ/ptCClTw1HQsoisjChN/mjwo8
         h/XqJVwW6ihsnPvVeqa0oG+YJ/nQExLfLb4stiVMNrPGcxue8W740cr7KmNE37luQC/h
         QEazONbxPOal9yJH+/KYbJOegpbOTApfQMLeiSJeeUwm5Bs36afIVEG5Ejb9AaDHiePc
         xsSVSKTNbr/gm8zgWdKUT2wl+fUOW4k6yZ6HJUIfFFyZq+10S7ncWXrfwplanK5t0Iyz
         LR/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774881247; x=1775486047; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIA8D0ff4y+v3OdWEO6D1Oc2rbEBX2dD2f4Uu2Jsj7Y=;
        b=W2wieVhn5xWfAUuy6TNnJWCZQTGIqG2iw+if9Q7IaeK2CX2lPDFAMNyUvfY1Wt72xp
         SCMR0tYq008xOM4AOyAVHMVkHFUJfGHuNyybsplFXTpKGCz6ZbwoFxFsK6QpCnIXvPjF
         SflsMcKnH3DrOoZLDBfv+KOwSACmJXxnSTUKA4qLp4+zaism0boLIbWjjjfPqVZmJtnu
         RSGHRHw70qXvToO77oc3Hln4iFoio8VKQREALJ/e+cwnN2NqATTq2Yl1wiEILQ+nj7vd
         lNRbzZkmyZ/0xTWfuyIpO+rKj2J7u2aJaSkT/hBh6AfzGGYcfGeP/+OlcFOQoyPMSaHI
         3b6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774881247; x=1775486047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IIA8D0ff4y+v3OdWEO6D1Oc2rbEBX2dD2f4Uu2Jsj7Y=;
        b=Rok1p79Ti2XRQpesAkwDZ9yDrQiLz4FTME9IzyI464zArKMDdH+7pCWI0Wrsbu2pCL
         hBOxAPc+ka5Qq0o1Pja8EbGpzTROE6yTNujcePFwnUgfJUFToBK9kkq9d22jZX8a0vNw
         JL/3aWa5UlW79OX1ttixUBxMFu8Rtw7ru5rj7CV/8XrV3Kkcr2X4l/Z6HwJAKvKjHSNW
         ErBiig3oroOgMxK2rv5BQFG5jEV5n8YC2/oHb96ueNvuQpHT/L+9cqMKju5hLQ6uBZZI
         X7jI16/hvpMANpOlauD1pE2x29pRAll5oVCRm5t7OI+ZRyRogIBuZPc6a4MFSM3WfZnh
         /0KA==
X-Forwarded-Encrypted: i=1; AJvYcCWYZRzw1yffHZqimLIpYrfE8nHodRnxJ3362AkBrTkjOtFv63x13z2o1oS/11YsdWd95cQPdRCAqdy4@vger.kernel.org
X-Gm-Message-State: AOJu0Yx71vYefFLCqC1xngIKhOdZtpuxQ498TAdg7DNX9Ql/Ndb7cXOi
	AcgIRHABg3MpbIAfM9VS3IOgvzucDNYAeBh4PhJTJQOSp6x3IBPVIqOFZRaQr2a09K9oNOFMmtm
	CAMPujW8aZp35bwiq2CcY8LE8mA2g0TQ=
X-Gm-Gg: ATEYQzz77EXO9KLIzuepdNO1jCx9O6EHgcwyAlEK2b4eRZ8xKExTOwXZlifjPrpUzQX
	jqxtybJL313snMK8A/vMqUZhIOWbaN7pZk2TXvjdCeKOyvhrzZYgwwpn9DBXFdHs8g98jcRGcWC
	r/35fd+N1KwIGMdlF0f9O9ri1BGXuZJh2Awig8cKjH2sc5c4EpkrJeMzmILtP1h54ksI9+N6P39
	DDWqtO9x+Dbf1hNcdaaK8J6nm+mNRXPjuoZqY7ASFk2++wrHd4/qex3ZvYBuHQ12ZlQkwdhtWQi
	sQEAC6boQ1No+xXOFSOGPIc830SO6t5hbQ4KOzzJk4Pmta6Hsqtb5+3Eyx944C0BzvqwogIh
X-Received: by 2002:a05:690c:10c:b0:79c:3e94:808f with SMTP id
 00721157ae682-79c3e948553mr99440527b3.3.1774881247188; Mon, 30 Mar 2026
 07:34:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260330044334.373480-1-kartikey406@gmail.com>
 <acoQBLwdc1PqIb0m@infradead.org> <20260330133800.GC22278@macsyma.local>
In-Reply-To: <20260330133800.GC22278@macsyma.local>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 30 Mar 2026 20:03:55 +0530
X-Gm-Features: AQROBzC5DFrpcRbDJwyotZPLQ_bBOfvI5OeF6bTQGNecm3qxL0J9raOMmDCZ4Nk
Message-ID: <CADhLXY6Cu+O_jeL9xxORtLg-LU6pdBxFb29yhS=d2rTtgbA2tw@mail.gmail.com>
Subject: Re: [PATCH] loop: block loop reconfiguration of offset/sizelimit on
 mounted device
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, dvyukov@google.com, 
	adilger.kernel@dilger.ca, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2026 at 7:08=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote:
>
> The patch was missing the...
>
>   #ifndef CONFIG_BLK_DEV_WRITE_MOUNTED)
>
> ... in loop.c which was in my original sketch of a patch which I sent
> to Deepanshu.
>
> The intent was to suppress Syzkaller noise.  Inherent in my assumption
> was that changing either lo_offset or lo_sizelimit parameter was going
> to mutate the loop device when it was mounted, which was the intent of
> !CONFIG_BLK_DEV_WRITE_MOUNTED.  I also assumed that at least for now,
> the only user of !CONFIG_BLK_DEV_WRITE_MOUNTED was syzkaller, since
> there are file systems (in particular ext4) that are commonly in use
> whose userspace utilities fundamentally assume that you can write to
> the block device.  Even after we promulgate the tune2fs changes to use
> the new EXT4_IOC_SET_TUNE_SB_PARAM ioctl and we can assume that it is
> common use in deployed kernels, some grub operations still assume they
> can modify the block device where the second-stage grub bootloader is
> located.
>
> In the long term, when ext4 can start assuming that we can suppress
> writes to the block device (and we find a solution to the grub issue),
> we'll probably want to have a way to suppress write access to block
> devices on a per-super basis, without clearing the Kconfig
> CONFIG_BLK_DEV_WRITE_MOUNTED.   But that's a problem for another day...
>
> Cheers,
>
>                                                 - Ted


Hi Ted, Christoph,

Thank you both for the feedback. Based on your suggestions, I'll
submit a v2 with the following approach:

- Use #ifndef CONFIG_BLK_DEV_WRITE_MOUNTED as Ted originally
  intended, since this is meant to suppress syzkaller noise
- Check bd_writers directly instead of exporting
  bdev_writes_blocked(), addressing Christoph's concern
- No changes to block/bdev.c or include/linux/blkdev.h, keeping
  the patch minimal and limited to drivers/block/loop.c

The check would be:

#ifndef CONFIG_BLK_DEV_WRITE_MOUNTED
if ((lo->lo_offset !=3D info->lo_offset ||
     lo->lo_sizelimit !=3D info->lo_sizelimit) &&
    lo->lo_device->bd_writers < 0) {
err =3D -EBUSY;
goto out_unlock;
}
#endif

Regarding Christoph's point about increasing lo_sizelimit being
safe - should I narrow the check to only block shrinking and
offset changes?

Thanks,
Deepanshu

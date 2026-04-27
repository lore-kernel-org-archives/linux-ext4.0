Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C382C3DA7E5
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310171; cv=pass; b=JHRWmHG1iQ7Wu+ipcWvwnm8ocukw37hCEsN5IWvnAxff5NQWryYJCwxwQMYrOemm092B+6tNeyFfBhjTpWCvFeCwTAt9kGVrA1R/A4G7gA4YNvGRXmPsZKBIJmUIxcIzHrp3zb2Bh+4yv5lCL1euOHXcs7E8zkJrrW1Pfv0mI18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310171; c=relaxed/simple;
	bh=jxGA1aqdU5aIJg6I6FITOfxM34vHxNTeEwbnO/2hjXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qZd1yY4l9jvuvRvH+FUF2hsoeBGjE99bypvkjmfy18hKlk/uUf/cbTTDWkuN/8Q3L0oJgVuBPnNFyExm51ui5GNaq50GJUtp4KYW854u+U50MnYVf2X7bOVE7SIfBHjVz/vWzoKUPQU3ZUK/l3DXrbw+i7P2N48PSYf6SaASIJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MpuJOS8p; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MpuJOS8p"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ba699316b42so1308899866b.3
        for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 10:16:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777310167; cv=none;
        d=google.com; s=arc-20240605;
        b=eHSwKZ+GKVIsW7kYoXC8mdmZ7yT++b87RwpH5LwdbH8n21MesdBbIpM7XamT8AQqy9
         zoyBsR1ZhBMZ9L6w1pkvVBaxCgX8u4OfZ7T3qM9FLXE0Lg1J5yCpi6DW22cvZkbEWbxZ
         ZXS2yltVrEnzYO7fxSuHikQ847m5aS7Y7AfAhXn8luStTIdLDdMhR+AXLtaQDTQh3+JV
         8zlGFb0L+WwztjKz/lI1fJCu1nnW06FiymKv1To+vrjRROgihsyisFtIOwlSAfjxV6NP
         oVtGxmYSldINi4VcmpQyGvfuin5HBikcUrtAyQfqbrIrvZ42zzomkRCQBXOGRWhx0DCI
         aomQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P6ipWyGGAT6CynzNoASFRro8XE42u5BsugQYyk5ItRc=;
        fh=guy24lIysAVqNYEnEeuWudlnycDXPC6XGZudBM6PRSo=;
        b=dXLSBr8BpqI7Xo6DAgSQdRsoAGyh5+ZaY6QN2wxnRWQBoVZ04wvbS3qLPNS8ZwM/+R
         J59lLdl56rSAHibyRDfBFiLaEa+/4rDR3R5shckqOwtKO4WInhC80QWXT0Mav4Brkiuq
         nC/P0yqvrUr6aqEH7nkiD/93v4Ivn6txJ2NFdVh8t9hWmQyWuUhVqgEXbzyVZcUW+VEA
         fi1rRJ5VB27slv3avPlROoQvLLgfiVypm/uGR5J3UqG/S4lXkZqYE9M91BSfjuT4NMcr
         zRQtsvYVeh8RJWHj3rDV0XyQYgd7LYb42jZoRVaD0BiMSPrVooWOjGxO40yghGADiKtK
         UUbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777310167; x=1777914967; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6ipWyGGAT6CynzNoASFRro8XE42u5BsugQYyk5ItRc=;
        b=MpuJOS8pwEzOsvsxMz3lW7KiuzyvLgyVO7wisFNgSltReRYyrPHbP6NNKe0oaYvpu4
         L4/qiPrIo73jH5uQpbZR4oGugkQPP98VRlXpFhaW6SeQSqBIaywdcAisu+SOjgHsP6BJ
         eZdgbubwlN5RIiCaceqN3J5Xg3TtJ0r1/lq1s3TKD0ezSflwAqTNO0h3YgOXjIAsjy1a
         KxlXlb2ZfGvAREfKJXgP3Pnp2SBU2M5u/ZfYyI3LZDrqpPa9Hm4RBajS7RjHUfb/xwT0
         5vTV4LndrGlqLFCMVAkAjX/X9yUJAEElN4WQcUDfgtaO6ov2DSnDQk8ypztNzQXw4EDL
         o0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777310167; x=1777914967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P6ipWyGGAT6CynzNoASFRro8XE42u5BsugQYyk5ItRc=;
        b=Rb00+p1dsI3nVRMpQu/jdFlzLX8BwuaSD/lnx4+WiD+pFEqqfm5DzfKO1qDHfC8dFD
         a7AKTaNCF0V37ByFHB408rs16+2PFJSxGnSZHUHH1HPnjoDyZiEGIIZr9ScgIgJKsX16
         JZRvNIXMBPijW4J/oaOqDNAzhkmrDoYpZgQ23X0ZQBdXOxO/IbTCch+/QEGGUThwHTJI
         vzRAoQAAqeFwYhSnwUQ6ogmaT65dlLn2El2KBof6IzJqMU/la1+YvrTmrZSD/2rDsJXn
         XABWJugnUOtmg+Jcqr2+z2gC0RwKo1n2cLCSAviidx5eSLQ/0X2p9EoNk9NokusOGBjG
         isQQ==
X-Forwarded-Encrypted: i=1; AFNElJ+vGrupz+8P+bWGTzKQ8lP450TLS2G0guA8QLt81UcATbGSFuj5DSPCcW2ZQvXgCEMf7zfXONiQSLWl@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1QFlTMuK+yPDaXT1o1TSN/SHJbz7I28WiLyQo6pkoiu5GPgyD
	uzQBIaNpr2Sg1eTp4UsYqPnT4cIVgwP3sfEV5Zb8GF7stRLgyb1lTjJFVRY5UuBq57NGlzPPkas
	Ez5bd+jzZ+XrNmwRodEXPHTezfHpkyaA=
X-Gm-Gg: AeBDiesiQv4Efug9wIiOil+NSxqdEGua5b+9W9yvsLA4EzzV9bM9QcTZ0G2WK5vIiJ6
	+hkBhcglLf4sWBe5K1P45FjiyXmwc+BxRWgN2TwtzLdDPj9Lu/4jYXJ79v5OS8L3o4wV2lsrvDV
	JiPvOcylg+pKSPCoEYpdQRbOBoFxFM4UY16AsgwH+sZViZTYxz+9CeYCmoE4c8sfkdVZAGLLTuB
	i7y8VoXci2l8ByQYuiKSrxDqmtiEa3HvrVLFdUf0UGqwGShhvFGEP9KIJVI3DDcf8C1ERxHFeAi
	cfkVOVSRhlVA4OV4IRyh09GMEF5HCbKqQ1T8SV+yAlnXgA60paYV
X-Received: by 2002:a17:907:6e90:b0:ba8:30a6:8b02 with SMTP id
 a640c23a62f3a-ba830a68c0bmr1561283366b.41.1777310166726; Mon, 27 Apr 2026
 10:16:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777281778.git.asj@kernel.org> <d5bff7b1c8f17cffb13c8a8f28bd8ad645306e09.1777281778.git.asj@kernel.org>
In-Reply-To: <d5bff7b1c8f17cffb13c8a8f28bd8ad645306e09.1777281778.git.asj@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 19:15:55 +0200
X-Gm-Features: AVHnY4JyEbKT9mB86SxM37c-LVIlc9Tqn5Mw2-4UgKXGOHZ2QdS3GaMZk-sYwIU
Message-ID: <CAOQ4uxh+YKCZpb_FxwC+P4nbm0f5FfOy71f7+h-NR8=Xc94=BQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] fstests: add test for inotify isolation on cloned devices
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs@vger.kernel.org, zlang@redhat.com, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 12:20=E2=80=AFPM Anand Jain <asj@kernel.org> wrote:
>
> Add a new test, to verify that the kernel correctly differentiates betwee=
n
> two block devices sharing the same FSID/UUID.
>
> Signed-off-by: Anand Jain <asj@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  common/config         |  1 +
>  tests/generic/800     | 88 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/800.out |  7 ++++
>  3 files changed, 96 insertions(+)
>  create mode 100644 tests/generic/800
>  create mode 100644 tests/generic/800.out
>
> diff --git a/common/config b/common/config
> index 4fd4c2c8af11..605a57947a40 100644
> --- a/common/config
> +++ b/common/config
> @@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=3D$(type -P btrfs-map-l=
ogical)
>  export PARTED_PROG=3D"$(type -P parted)"
>  export XFS_PROPERTY_PROG=3D"$(type -P xfs_property)"
>  export FSCRYPTCTL_PROG=3D"$(type -P fscryptctl)"
> +export INOTIFYWAIT_PROG=3D"$(type -P inotifywait)"
>
>  # udev wait functions.
>  #
> diff --git a/tests/generic/800 b/tests/generic/800
> new file mode 100644
> index 000000000000..16bc1159a2e1
> --- /dev/null
> +++ b/tests/generic/800
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test 800
> +#
> +# Verify if the kernel or userspace becomes confused when two block devi=
ces
> +# share the same fid/fsid/uuid. Create inotify on both original and clon=
ed
> +# filesystem. Monitor the notification in the respective logs.
> +
> +. ./common/preamble
> +
> +_begin_fstest auto quick mount clone
> +
> +_require_test
> +_require_loop
> +_require_command "$INOTIFYWAIT_PROG" inotifywait
> +
> +_cleanup()
> +{
> +       cd /
> +       [[ -n $pid1 ]] && { kill -TERM "$pid1" 2> /dev/null; wait $pid1; =
}
> +       [[ -n $pid2 ]] && { kill -TERM "$pid2" 2> /dev/null; wait $pid2; =
}
> +       rm -r -f $tmp.*
> +       _unmount $mnt1 2>/dev/null
> +       _unmount $mnt2 2>/dev/null
> +       _loop_image_destroy "${devs[@]}" 2> /dev/null
> +}
> +
> +devs=3D()
> +_loop_image_create_clone devs
> +mkdir -p $TEST_DIR/$seq
> +mnt1=3D$TEST_DIR/$seq/mnt1
> +mnt2=3D$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $m=
nt1 || \
> +                                               _fail "Failed to mount de=
v1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $m=
nt2 || \
> +                                               _fail "Failed to mount de=
v2"
> +
> +log1=3D$tmp.inotify1
> +log2=3D$tmp.inotify2
> +
> +pid1=3D""
> +pid2=3D""
> +echo "Setup inotify watchers on both mnt1 and mnt2"
> +$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt1 > $log1 2>&1 &
> +pid1=3D$!
> +$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt2 > $log2 2>&1 &
> +pid2=3D$!
> +sleep 2
> +
> +echo "Trigger file creation on mnt1"
> +touch $mnt1/file_on_mnt1
> +sync
> +sleep 1
> +
> +echo "Trigger file creation on mnt2"
> +touch $mnt2/file_on_mnt2
> +sync
> +sleep 1
> +
> +echo "Verify inotify isolation"
> +kill $pid1 $pid2
> +wait $pid1 $pid2 2>/dev/null
> +pid1=3D""
> +pid2=3D""
> +
> +if grep -q "file_on_mnt1" $log1 && ! grep -q "file_on_mnt2" $log1; then
> +       echo "SUCCESS: mnt1 events isolated."
> +else
> +       echo "FAIL: mnt1 inotify confusion!"
> +       [ ! -s $log1 ] && echo "  - mnt1 received no events."
> +       grep -q "file_on_mnt2" $log1 && echo "  - mnt1 received event fro=
m mnt2."
> +fi
> +
> +if grep -q "file_on_mnt2" $log2 && ! grep -q "file_on_mnt1" $log2; then
> +       echo "SUCCESS: mnt2 events isolated."
> +else
> +       echo "FAIL: mnt2 inotify confusion!"
> +       [ ! -s $log2 ] && echo "  - mnt2 received no events."
> +       grep -q "file_on_mnt1" $log2 && echo "  - mnt2 received event fro=
m mnt1."
> +fi
> +
> +status=3D0
> +exit
> diff --git a/tests/generic/800.out b/tests/generic/800.out
> new file mode 100644
> index 000000000000..b10842a31210
> --- /dev/null
> +++ b/tests/generic/800.out
> @@ -0,0 +1,7 @@
> +QA output created by 800
> +Setup inotify watchers on both mnt1 and mnt2
> +Trigger file creation on mnt1
> +Trigger file creation on mnt2
> +Verify inotify isolation
> +SUCCESS: mnt1 events isolated.
> +SUCCESS: mnt2 events isolated.
> --
> 2.43.0
>

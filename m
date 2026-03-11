Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4914B257825
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 13:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773235361; cv=none; b=hxijtylItK2a8bZf/kqTRC6hCGUA85jWPxgxnEzjksFuHQl0zhY0gXKghvfXQhw0CFXdQyMuaTzxTE+F/HbtP+afrHwoyr13bxaNLeGu1lSrJETr92WZL3RjQLfVBTKx2KRupoqpq7C0D+aLJ4BOY8Esy4oXxS85uNv1WBglG0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773235361; c=relaxed/simple;
	bh=bQRlE5OR+3/41N9B/xBGXfMeOTv3hgeQ2WrY6jcTpBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=upT3m8UYb5PeP3qzisXj7X/erJ50+YfQzuszUAzsTWdNc+IsOaU4GwoUjhf1J1dS5b9YjsYTbe7A9nHMbcb82D9H24RkRUbIUdQmPgTUqD3ZNiB+su0+M4DAGt0/rsoSzeIWfSJ08uW1+h8ue405ricTDdC6ZNrvPKGX6upOCAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-56ae58f3fc6so6635932e0c.3
        for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 06:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773235359; x=1773840159;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34DR94e/1PAvLLEaib58vFA4GW0m5SGe6jvxchEhMek=;
        b=Q9o6v4lsTKzlISxUUOLJkULJUPHGIMFvg9qEJpUvBbF/DUUXmw0Ehvc9lDaGEb+qpZ
         UP9zJlE0Wg1a1PTqNPonCUxpXRrbl7StMeUsRoYzV08KXt3qG5927nXEcQsnPnz8HzKI
         o/Rp7SA8VdFzeG9AJITJA5xWuYnO8HoepRWCJ+OvywdpRF48DKLNDk8h3eTLfoGid4sh
         a2ioYLdKtbwNdKSgvykWCbEUf4ReffBUK+/tK7oSnpnmr07SmmJtwPmj+PZAaY2qsOlm
         HyQrrslQTGzlXhAZmjI/Xtc3X/QcJWdk2HuWP7iC2HVGJUdAGbf3SvYYtE/TQl3tykaj
         owIw==
X-Forwarded-Encrypted: i=1; AJvYcCVGqmNfgGxbSx72mZBOJXiFpZFfh+Sin0Tc2Jp0fhi66Pv/SQ00jJPZpvB5Ro9cfhyUoQ6KydeCa1ng@vger.kernel.org
X-Gm-Message-State: AOJu0Yz163l/r4Xaa/ko3eHJRL0MKsHuvn7NaNgMVpl5QG9fK1nYKDRS
	+DyZiSUQzGafZJoS3W+RpG7LXkRgSuAjHcHXtZ5/S8nID8fKFpiJ031IPF2Oe3cz9xk=
X-Gm-Gg: ATEYQzzl0vFeAfudH4rxn9pFkzBC5kWyHEHXc2O/OSdiaA6vFk5L54pXqJ9chDiQFnu
	4i2bAxdKvNZFan0BKnsFWS5mrS+NIWYP9dnComTmKV0mjSp2InzpYmHntAJP+fv2OPXtp/M7YOe
	DvU28c9ryTB+B6OEzQvtXTQ/8XaPexG5F7Clb5ZO3dTuydQK/rPI2/jIG3DZ3mD+b9iWDVmDgYa
	PCL8vnNg5hZNYXJO5+fmfirQPeTdJjw5hUMEVsJKsfwgTExOUgfvlnSp9kLys6/gGHbxZUk4V/4
	L3BKzCMiOx5wODKA/h6LCgczMp8hOqKtR013koFaWhwAzMXLMQP/ShHaigxv9Atiok6KfaiiOC7
	UppdHXjobzdfNT5QQl5Dze5AA3qrE1vINGB8CBMAZN/+eggXdr9kw8PSDjybjL04e452lWsGenJ
	ahjB0Vg6dKsm0GXNjpCraWJJEzWRI8n6D8P9fCsXENzf0PLPdClQGLve6EREig
X-Received: by 2002:a05:6122:f09:b0:55a:ab0d:bf74 with SMTP id 71dfb90a1353d-56b4754c994mr951242e0c.13.1773235359165;
        Wed, 11 Mar 2026 06:22:39 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56b4645d11csm902968e0c.12.2026.03.11.06.22.39
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:22:39 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5fff18d44fbso3421569137.1
        for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 06:22:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWYKcU+iP0V6xiBha3BJjP6Gaep/gDfYQegRtlgtgdd8Xvn8miv47hSTFbVZNP1rCw1q5nRpTK0NKGm@vger.kernel.org
X-Received: by 2002:a05:6122:1d05:b0:55b:7494:177b with SMTP id
 71dfb90a1353d-56b4752d806mr922396e0c.10.1773234967338; Wed, 11 Mar 2026
 06:16:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 14:15:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
X-Gm-Features: AaiRm52J84H77ROK64ZWWtJfaiCpnFeKyoSRmPbi-NC8CN6Ju1TJEFxJU9gZQQ8
Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
Subject: Re: [PATCH 36/61] arch/sh: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Mar 2026 at 12:56, Philipp Hahn <phahn-oss@avm.de> wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Change generated with coccinelle.
>
> To: Yoshinori Sato <ysato@users.sourceforge.jp>
> To: Rich Felker <dalias@libc.org>
> To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

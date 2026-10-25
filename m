Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792937943;
	b=nHd5R/N+mPQH9Ay+dLBB01HvW4VK6cICAitwgp3Xu05+IgIEvrvdAuTSxOSJ4kh9RTDc
	 qa4IkYEkeYogGw64+X8zGqin0laHYD354O/7Qk8lGK9LYpZbPbA4kNVh5ln8OtOER1OUa
	 FOpWQb28MgTD+I4vg9ASlCxABk+vIgZKJsbhvsse3Vrb14Y/tskUV2G5tQ18eTrzcdEXR
	 9CXK1SmOsw9agvzUGCPcf8XESb2KzZQbpk6WmZI7TN7e/aj/nZ6FU8vdxbcfvxCepzeSU
	 Pglhs7Q9g4ol8I2cylz+6O8cK6e7eOXA0tm91zrq+Q7yPb62pDB5q+bO9vYkNGrPA6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792937943;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=e6eB5/+HfPV8iGsvdknKspHRvaocTX1S/a3F3L9xITg=;
	b=y/OoKvVKKt6HMfRcDenu3DZRyi25VjJ8BNhRKzvbJgjqt0N8hUanvfgsi78oMD1ZFFRA
	 Rn5vgjQzveG2ZQe2+nLaMZG05fjPUfq5osVdkMwGyRonxy8BMJddbZ0tAt8p3beew8sCb
	 ost6BmPXMTXBOUHStAZXQYlydurc8/kmQcn3Do6YO4EfukzRyE+S4VEzNMgfS2GJCRuxw
	 Se03iVWpsjDqrcC12YFfi4eifvGsvUbIKzkuV3a7kfCVIYimc3uQtMEf0PpVtSfWkzlTz
	 68cks1pmF7EJRFTZWxYjdUD3YsMIaP1oBlg9NId2SY1qvakGgGuXNNU9F0trck9G1xA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="krKMF/a3";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BADD606A31B
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 14:19:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BADD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=krKMF/a3
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91c5e31bea9so3088666d6.1
        for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 07:19:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792937942; cv=none;
        d=google.com; s=arc-20260327;
        b=DRQ8vD2Q7g/hEv5LHcFVRvTLSUGt9kC8YSGBqav66xfZ21HJMNHexeHybOk0YaKm50
         oWnjvh5QRJBUucqGAreK7n0vLf/w9/zlbI8ENysCcRvX2FohG2FBgbtCxNxsSPzgsCaH
         HXKoYsIRVtix59T41VwPdKFtzW+Z7Y9dsm3Yud4+R+QCfdKwNC6H00xV3QvPpy2/cG7t
         +4Njx9axX0ubDjluA7uS7HWxtjC6KNNy3B4BjdAEii6a/2oiDvBIohFUtCef6ZcRztzV
         iTmGzCBVZATgPNNGnkjjQtT41YJehIy5Vca4oQFfjGlfCwc+YGsRv2iAJ15XU6C8J2LD
         D22A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e6eB5/+HfPV8iGsvdknKspHRvaocTX1S/a3F3L9xITg=;
        fh=EYghWZLFmTZaS1plSLep3UNKDZb/ktRnLb4KZ0xHWbs=;
        b=RwQjTN/XzhHCQcbx12DvmccMk6BPECeSlpKD7lPrMpdZUvj0ixoK9BQg3QM2jrK738
         G7b8EurgvcGUl568/ZrjBWW6AnbOQ/09e/rJvLKQ5Y3aAssjVaUm//WPmdOzFcY9C6p2
         TsdJ+tFQ5yz33Eczz0DUxkUfAl1P7z2H7hS6KM05YveFYxI2NoxiH7Urn7MZSj6aZvJL
         XkaCdwOLJBs58q2yciCfg7pppHath2GAXq1f/Hqcvmk+/cYElVkK9AuoPqAG4AhfWyeE
         q+8u/LeX+D+FXx0eF7sYtxpmRTTxMbslpocuEamv+j8jvHtPdfAp/B+K+HXX9Y+9+1AL
         3B3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792937942; x=1793542742; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e6eB5/+HfPV8iGsvdknKspHRvaocTX1S/a3F3L9xITg=;
        b=krKMF/a37dmQMGFgWjgS1lgoM6RJ0MCOZs2MWdstZSDiAD4I9yNYPYzczmFXh8SJsI
         X28FSziCwuvSXswP4y7ixvKPZ7NchH6arExeiii8VSWMplzgyw/ORvp6ABWkIf0Enupb
         yey4Zc7e1QS73OWCgkKQY9b1FSwPqpSs8rHkdyG4f2BS/0bTp+dptDnI3yMt6cykLruC
         ZgGQijwsYWasLpv/rdXpNMNr3f54Drm3vbjXd04NrfbQRgpRLvocSFadd958IoRLup5l
         p8QusmI21ASpHemoe7AeBJ7fGN0SkQaY2pkF2yAZXS4vztUb8ulLC30STQQLoNQnICz8
         7How==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792937942; x=1793542742;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=e6eB5/+HfPV8iGsvdknKspHRvaocTX1S/a3F3L9xITg=;
        b=OWO6XDoDO7zZiOA4sBNOjLsKPBKjfYipQkhH6a2mUyMZc+4qF0hY7R7TGCVPMNSlwk
         fqjgnpkyOEVOI7qV18G+UOCd6gFYU5/zM1oRiinymupGvRUUMcjxMpbE+NDKXHVkNoKz
         3AOSK+4PP/9iNhkt+TtCQoHjS2COhOuhn7w6fy+EcK24A49HikMWzLryX9rFpR5NT/WC
         5Av29AJHcJIKwx0W04mN5eeW1ki9+/PCgh1PYdPmbjYoWSrshayCS1bFdrJCgBckyWfa
         Zk11oblgHclHsmIBvQjOR9+4snfBGazjySRaux00cgIhm3+PoGDCzFhwM+LqDEPq+lVP
         RaSQ==
X-Forwarded-Encrypted: i=1; AKwUvBynzPPGOZeuR+zMJaXbkPAGUvxb9Lw0x1FkuBDNjvOmaOe9e1qXOinO73JdRkAlAX/0iinlJPY7AoCI@vger.kernel.org
X-Gm-Message-State: AFq9FYI2sk+WFS1Go1NjBVxEDszhIykLGvHDRSRhvVfUGaaqV77ADwhr
	4R5q0DooNNpK0W9XjBaNbR1BBQRwADToTbjeLntDCZRa0J2ipjeDvQg2SHiYop5I9InXdhESzOX
	nLSy8ej2nYPBB1xYRcOo4qkmWVJBYBGU=
X-Gm-Gg: AYBFou0A7jhl3fzR0n6VrfwKO6ccpkiqXM/6aFXAg7qdCgs+Wd6B38i7g5fHsCs3NhF
	5Y83OAKDHnllyVHWjMcLk3RcZAzjQrOe1U8Yk/8WSBfWUK+PJzXdfX63xVYDPgXaVT5JlWO8eQS
	WCe6GsKF/QKASX7Jcw3MGkqbU6MOS+P4lzGMYj7jZt6D2LPPEYGTlUTmN3IRDnRVEdvUSmZ/g/G
	JIL8uIA3+Zt15qPSaFd6VJgy5qbyuRgOeQAtn8z5gioH4VjZ3N1cG/vtYkuYRPCBdp5IE60D61W
	Mnee6Nq5Q3hrnYJ/8eDil00j2XbSllKnqEjhNBn9WOJWEc/xgf1MggWwDdrVazJ/tnWLzJfHn+8
	VQwVWOdHaLFCcOpPBJCt5Kvyko4X4usxgZxc3TcObTE+qx9q8S+dUEkYaT2vkjl3PfxsPWgqvKx
	lLNB+bGc5DL6t3h0j/L8Ml0Xj7OR1Wej+/gJ0RSYCrM5RP5+aoDns=
X-Received: by 2002:a05:6214:2b82:b0:91b:5d39:e140 with SMTP id
 6a1803df08f44-91c48f143efmr72761506d6.53.1792937942225; Sun, 25 Oct 2026
 07:19:02 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261014162921.450235-1-steve@sk2.org>
In-Reply-To: <20261014162921.450235-1-steve@sk2.org>
From: Daniel Pereira <danielmaraboo@gmail.com>
Date: Sun, 25 Oct 2026 11:18:50 -0300
X-Gm-Features: AclHuK9O3SRqSOfWpY-PAriDEEl8Pmx9Mwub1R5Mhg0M9i69HhGFGrrSKFIMqcE
Message-ID: <CAMAsx6ey3CMZrsMH9HfJdU9o+uGySAGvLWXAoAdfFSF3ZudoTg@mail.gmail.com>
Subject: Re: [PATCH] docs: ext4 filesystems can be converted to 64-bit
To: steve@sk2.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, corbet@lwn.net, 
	linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 14, 2026, Stephen Kitt wrote:
> Since commit fe12931 ("resize2fs: convert fs to and from 64bit mode")
> in e2fsprogs, which shipped in version 1.43, resize2fs can convert
> filesystems from 32-bit to 64-bit and back, so the mention in the
> checksum documentation that this is impossible is obsolete.

Hi Stephen,

I checked the claims against the e2fsprogs sources: commit fe12931 is
"resize2fs: convert fs to and from 64bit mode" (Darrick J. Wong), the
v1.43 RELEASE-NOTES say that resize2fs can now convert file systems
between 64-bit and 32-bit mode, and resize/main.c at v1.43 accepts -b
(enable 64bit) and -s (disable 64bit), which v1.42.13 does not have. So
the new text is accurate. This was also the only place in
Documentation/filesystems/ext4/ that mentioned the old limitation.

I built the documentation with the patch applied and it adds no new
warnings. checkpatch only complains about the unknown commit id, which
is expected since it is an e2fsprogs commit.

One optional suggestion, which does not change my review: in v1.43
resize2fs refuses to change the 64bit feature while the filesystem is
mounted ("Cannot change the 64bit feature while the filesystem is
mounted."), and enabling it also requires the extents feature. Since
the sentence replaces one that was about a limitation, it might be
worth saying that the conversion is done on an unmounted filesystem,
for example:

``resize2fs`` in ``e2fsprogs`` 1.43 or later can be used to convert
unmounted filesystems from 32-bit to 64-bit and back (using the
``-b`` and ``-s`` options).

Reviewed-by: Daniel Pereira <danielmaraboo@gmail.com>

Thanks,
Daniel

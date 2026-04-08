Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31EB388E59
	for <linux-ext4@vger.kernel.org>; Wed,  8 Apr 2026 15:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775661773; cv=none; b=tBGwZmV2TqJw7bnc1iucFppSUpGa+/gTDqPX29dDS2VEmd51Sbxu5L3tqv/XJTq4DGzG9ED/52U2TRGK0bcTZbAgN/IJqu0BupKy2HcW5ZxGX9VKMS0FBwcAs7kbJb7K0Swv7TOpuUnz6CpbVHMwgpw9Gtyh3THIz5GCn19RW5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775661773; c=relaxed/simple;
	bh=vA240ToEZpV5ABu1bLZJGQn4hXI4cp2DDe6zTQg0jQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NyAY4hjQClkFWo/13UiNNf1z1xfqjevxkENpp4WNn4st6yEoqttNk1KYwFpwBr1V0oNJH+4RPtgvWnY08ZlPaKJvdv3Pb/SXmtHkiZ6Dh/o6wLsb2H5b9aJZqMsfuwCGXj8qj4paXGB45SpCj1fVOJqzBLn7NHVV4EmnzUbdK1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hy0bblT/; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hy0bblT/"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-66bf6aa4858so11770668a12.2
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2026 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1775661770; x=1776266570; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6oB8sWft0bulZQQhndjF41bb2A55hZmeFDzZlsmEc5U=;
        b=Hy0bblT/37r4nKgkD9qBANOwCscm7hFk837xxRFrtmwudZUzw7NW/YIpdSw6Eu5+xm
         lTUlQnA0Y11vRoOQvlm7Ef48qE5OEFrSgi8kXIdFHcuNPIHC5Wtbm0t7Rz7X04YkN/2g
         ie2JZovdDJztnJGoPE/1cx/AY7yl62ZkXU5tE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775661770; x=1776266570;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6oB8sWft0bulZQQhndjF41bb2A55hZmeFDzZlsmEc5U=;
        b=R9x8KhEhbGKwSg3n53+mx19Q/AzeKWNovXufEgTdXfLEy37GlbFwlfg1C1XSYJVe17
         dyT8gghXphJANzmNXuiHSqafaUcwspcjoxzbBm6GUeBydY4LkxGB4dDMFpkY7wK1IgR3
         8oIuq1/L6Jox1BvdSpQY4CxgVfcr/ogJSV799zqjSSC6OLs6HrhGRe7XDx4yt5OwaP0i
         IEqM12oeUCWnJAfF2bRGGN0s1Q3TDJFdDu5trV8gY7bLtlhtSnzcS4C0NfMfxPYMX1Do
         2RBTR66vTE2Rx44u/8KVaF7foXIJqNs0hm8ONeK7v0F1L4yPUl9WJ4HPO43jlCB1feE3
         EyPw==
X-Forwarded-Encrypted: i=1; AJvYcCXCNVhB3RrzgBi+2oe50h1qaTLNwUcjpkpHzZQqLVqYvnOtM4i4PtGKfpZZZG4Lko9L4Pe5HY3tbJuL@vger.kernel.org
X-Gm-Message-State: AOJu0YwFfsJGVKKJEeDLpiJZXzH3pTQ8Qt21iRK5O9hnK3pitgBsOli9
	LzqRsoRQ3B1cps2MQyT6iDJ5yFz6E1kHpvrlFxJDPMM/8eZ1mL0hBLXHOzU/aS7NOtwlz1Xz8J0
	gwdLRsNU=
X-Gm-Gg: AeBDieuCmbIqMA97fxSRYskd5ToSdm9v83fWmqiBXLddbhMuSXfTvbIkiqIgeIVD9KN
	Cb227dNMzjwfHNCdaiDoqu8le1ZUVLcFmAbj/oXWJqVwIjO9FkDwhagCxa6DDWfg8q4jzPsUdJZ
	el3mIyaHJxvIMd4O0jxiSDgCUXh2FLnPpqG/z2XwMcVAeZebTwQC3rrBab3DorVoncauv1Ya60f
	IhvMixJ3P6z6UUB0HQ+leCGk4f1E8UNsBth4ihaXXJopbnUeidWWduqaZWa7HVLCEF4AaeftEU/
	yiye9muiBKA23Pcj8aT60bxysp+akd3Og5V5iiBifQUNs6/JyMg9+rjDShYTQmsXqCsVwikc6JY
	rPxKMgxTHr6U0dFIQYi85tzcy1f8QUrSYyB6dstPKSy7zgwAXzYo64XWJLdcZxJkuc7Ght8PKJA
	UZtnX0ZfH0TTCsV2kz+JrUfJk7HtBROr3Nqpmh2AMRX6Autr8a4/QvQmern00bXXuGhHTISQE6
X-Received: by 2002:a05:6402:1ec4:b0:66e:7071:5cf with SMTP id 4fb4d7f45d1cf-67004aa4f1dmr79116a12.21.1775661769828;
        Wed, 08 Apr 2026 08:22:49 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-66e034c63ebsm5024911a12.26.2026.04.08.08.22.47
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 08:22:48 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-66bf6aa4858so11770576a12.2
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2026 08:22:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVSUqhvO4qhkZhvPTZVMOQ/sHdGVOHLPpgJMqhODotDMrShK3AZiAFz5wGHwbCg4ww+qq+Fg9tIrbrR@vger.kernel.org
X-Received: by 2002:a05:6402:5305:b0:66e:aadc:2021 with SMTP id
 4fb4d7f45d1cf-670047bb29amr83427a12.17.1775661767544; Wed, 08 Apr 2026
 08:22:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <adZTGOjjJrVJOcT8@shell.armlinux.org.uk> <adZfTi3R6jtsjXx-@shell.armlinux.org.uk>
In-Reply-To: <adZfTi3R6jtsjXx-@shell.armlinux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Apr 2026 08:22:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi7+6Q5ptBNp6UGrNbgbk9jr1vsY9mJ5O3mH5RPjpBggQ@mail.gmail.com>
X-Gm-Features: AQROBzDMX29dK6Ob4UI8k1Dcez-g32vHwaiLrL1sR7wyjWf7zr7a7LiEfyJC2DA
Message-ID: <CAHk-=wi7+6Q5ptBNp6UGrNbgbk9jr1vsY9mJ5O3mH5RPjpBggQ@mail.gmail.com>
Subject: Re: BUG: net-next (7.0-rc6 based and later) fails to boot on Jetson
 Xavier NX
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	linux-ext4@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Apr 2026 at 06:59, Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> > Now building straight -rc7. If that also fails, my plan is to start
> > bisecting rc5..rc6, which will likely take most of the rest of the
> > day. So, in the mean time I'm sending this as a heads-up that rc6
> > and onwards has a problem.
>
> Plain -rc7 fails (another random oops):
>
> Now starting the bisect between 7.0-rc5 and 7.0-rc6.

Thanks. Not what I wanted to hear at this point, but a bisect should
get the culprit if this is at least sufficiently repeatable.

The exact symptoms and oops details may be random, but hopefully the
"something bad happens" is reliable enough to bisect.

              Linus
